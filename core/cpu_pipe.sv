// cpu_pipe.sv — RV32I 5-stage pipeline (step 4). Drop-in replacement for the
// single-cycle cpu.sv: same module name, ports, and submodules — select the
// implementation by file list at compile time.
//
// Stages:  F (imem registered fetch) | D (decode + regfile) | E (ALU, branch
//          resolve, FORWARDING) | M (dmem, MMIO) | W (regfile write)
//
// Hazard policy (chosen decisions):
//  - full forwarding: EX/MEM -> EX and MEM/WB -> EX bypass paths, plus a
//    WB -> ID bypass because the regfile write lands at the same edge a
//    younger instruction reads
//  - load-use: 1-cycle stall (data doesn't exist until MEM has run)
//  - branches: predict not-taken; taken branch/jump resolved in EX kills the
//    ONE wrong-path instruction behind it (fetch-ahead imem => 1 bubble)
//  - ECALL: flushes younger instructions, drains, sets halted at WB — so
//    every older instruction commits and nothing younger does
module cpu #(
    parameter HEXFILE  = "",
    parameter UART_DIV = 217
) (
    input  logic clk, rst,
    output logic halted,
    output logic [7:0] led,
    output logic uart_txd,
    // video store bus: MEM-stage stores to 0x20000+ (tilemap/patterns/palette)
    output logic        vid_we,
    output logic [17:0] vid_addr,
    output logic [31:0] vid_wdata,
    // video status, readable at 0x10008: bit0 = vblank, [31:16] = frame count
    input  logic [31:0] vid_status,
    // controller buttons, readable at 0x1000C (1 = pressed)
    input  logic [15:0] pad,
    // sound: 4-bit PCM for the board's resistor DAC (0x10010/14/18)
    output logic [3:0] audio,
    // SDRAM bus (0x10000000+, 32 MB): req held until ack; the whole
    // pipeline stalls while DRAM does its row dance (~7 cycles/word)
    output logic        sd_req,
    output logic        sd_we,
    output logic [22:0] sd_addr,
    output logic [31:0] sd_wdata,
    output logic [3:0]  sd_be,
    input  logic        sd_ack,
    input  logic [31:0] sd_rdata
);
    // ================= F: fetch =================
    logic [31:0] pc;                     // address to fetch this cycle
    logic [31:0] instr_d, pc_d;         // IF/ID (instr_d lives inside imem)
    logic        valid_d;

    logic        stall, flush_ex;        // defined in D/E below
    logic        mstall;                 // SDRAM wait, defined in M below
    logic [31:0] target_ex;

    wire [31:0] fetch_addr = rst               ? 32'd0
                           : flush_ex          ? target_ex
                           : (stall || mstall) ? pc_d
                           :                     pc;

    imem #(.HEXFILE(HEXFILE)) im (.clk(clk), .addr_next(fetch_addr),
                                  .rdata(instr_d));

    always_ff @(posedge clk)
        if (rst) begin
            pc <= 32'd0; pc_d <= 32'd0; valid_d <= 1'b0;
        end else if (!halted && !mstall) begin
            if (flush_ex) begin
                pc      <= target_ex + 32'd4;
                pc_d    <= target_ex;       // imem is capturing the target now
                valid_d <= 1'b1;
            end else if (!stall) begin
                pc      <= pc + 32'd4;
                pc_d    <= pc;
                valid_d <= 1'b1;
            end
            // stall: hold pc/pc_d/valid_d; imem refetches pc_d => instr_d holds
        end

    // ================= D: decode + regfile read =================
    wire [4:0] rs1_d = instr_d[19:15];
    wire [4:0] rs2_d = instr_d[24:20];
    wire [4:0] rd_d  = instr_d[11:7];

    logic       c_reg_write, c_alu_b_src, c_mem_write, c_is_branch, c_is_jump, c_halt;
    logic [2:0] c_imm_sel;
    logic [1:0] c_alu_a_src, c_wb_src;
    logic [3:0] c_alu_op;
    control ctl (.opcode(instr_d[6:0]), .funct3(instr_d[14:12]),
                 .funct7b5(instr_d[30]),
                 .reg_write(c_reg_write), .imm_sel(c_imm_sel),
                 .alu_a_src(c_alu_a_src), .alu_b_src(c_alu_b_src),
                 .alu_op(c_alu_op), .mem_write(c_mem_write), .wb_src(c_wb_src),
                 .is_branch(c_is_branch), .is_jump(c_is_jump), .halt(c_halt));

    logic [31:0] imm_d;
    immgen ig (.instr(instr_d), .sel(c_imm_sel), .imm(imm_d));

    // regfile: written in W, read in D
    logic        reg_write_w, valid_w;
    logic [4:0]  rd_w;
    logic [31:0] wb_w, rf_r1, rf_r2;
    regfile rf (.clk(clk), .we(reg_write_w && valid_w && !halted),
                .waddr(rd_w), .wdata(wb_w),
                .raddr1(rs1_d), .raddr2(rs2_d), .rdata1(rf_r1), .rdata2(rf_r2));

    // WB -> ID bypass: the write landing this edge isn't visible to the read
    wire wb_hit1 = reg_write_w && valid_w && rd_w != 5'd0 && rd_w == rs1_d;
    wire wb_hit2 = reg_write_w && valid_w && rd_w != 5'd0 && rd_w == rs2_d;
    wire [31:0] r1_d = wb_hit1 ? wb_w : rf_r1;
    wire [31:0] r2_d = wb_hit2 ? wb_w : rf_r2;

    // ---- ID/EX ----
    logic        valid_e, reg_write_e, alu_b_src_e, mem_write_e;
    logic        is_branch_e, is_jump_e, halt_e;
    logic [1:0]  alu_a_src_e, wb_src_e;
    logic [3:0]  alu_op_e;
    logic [2:0]  funct3_e;
    logic [4:0]  rs1_e, rs2_e, rd_e;
    logic [31:0] pc_e, r1_e, r2_e, imm_e;

    // load-use: instruction in EX is a load whose rd the ID instruction reads
    wire is_load_e = valid_e && wb_src_e == 2'd1;
    assign stall = valid_d && is_load_e && rd_e != 5'd0
                && (rd_e == rs1_d || rd_e == rs2_d) && !flush_ex;

    always_ff @(posedge clk)
        if (rst) valid_e <= 1'b0;
        else if (!halted && !mstall) begin
            if (flush_ex || stall) valid_e <= 1'b0;      // bubble
            else begin
                valid_e     <= valid_d;
                reg_write_e <= c_reg_write; alu_b_src_e <= c_alu_b_src;
                mem_write_e <= c_mem_write; is_branch_e <= c_is_branch;
                is_jump_e   <= c_is_jump;   halt_e      <= c_halt;
                alu_a_src_e <= c_alu_a_src; wb_src_e    <= c_wb_src;
                alu_op_e    <= c_alu_op;    funct3_e    <= instr_d[14:12];
                rs1_e <= rs1_d; rs2_e <= rs2_d; rd_e <= rd_d;
                pc_e  <= pc_d;  r1_e  <= r1_d;  r2_e <= r2_d; imm_e <= imm_d;
            end
        end

    // ================= E: forward, execute, resolve =================
    logic        valid_m, reg_write_m, mem_write_m;
    logic [1:0]  wb_src_m;
    logic [4:0]  rd_m;
    logic [31:0] value_m;

    // forwarding: newest result wins (M beats W); loads can't forward from M
    // (their data doesn't exist yet) — the load-use stall guarantees that
    // case never reaches here
    wire m_fwd1 = valid_m && reg_write_m && rd_m != 5'd0 && rd_m == rs1_e;
    wire m_fwd2 = valid_m && reg_write_m && rd_m != 5'd0 && rd_m == rs2_e;
    wire w_fwd1 = valid_w && reg_write_w && rd_w != 5'd0 && rd_w == rs1_e;
    wire w_fwd2 = valid_w && reg_write_w && rd_w != 5'd0 && rd_w == rs2_e;
    wire [31:0] fwd1 = m_fwd1 ? value_m : w_fwd1 ? wb_w : r1_e;
    wire [31:0] fwd2 = m_fwd2 ? value_m : w_fwd2 ? wb_w : r2_e;

    logic [31:0] alu_a, alu_y;
    always_comb
        case (alu_a_src_e)
            2'd1:    alu_a = pc_e;
            2'd2:    alu_a = 32'd0;
            default: alu_a = fwd1;
        endcase
    wire [31:0] alu_b = alu_b_src_e ? imm_e : fwd2;
    alu ex (.op(alu_op_e), .a(alu_a), .b(alu_b), .y(alu_y));

    logic br_taken;
    branch_cmp bc (.funct3(funct3_e), .a(fwd1), .b(fwd2), .taken(br_taken));

    wire take_ex  = valid_e && (is_jump_e || (is_branch_e && br_taken));
    assign flush_ex  = take_ex || (valid_e && halt_e);
    assign target_ex = (valid_e && halt_e) ? pc_e            // spin on the ecall
                                           : {alu_y[31:1], 1'b0};

    // ---- EX/MEM ----
    logic [2:0]  funct3_m;
    logic [31:0] st_m;
    logic        halt_m;
    always_ff @(posedge clk)
        if (rst) valid_m <= 1'b0;
        else if (!halted && !mstall) begin
            valid_m     <= valid_e;
            reg_write_m <= reg_write_e;
            mem_write_m <= mem_write_e;
            wb_src_m    <= wb_src_e;
            funct3_m    <= funct3_e;
            rd_m        <= rd_e;
            st_m        <= fwd2;                          // store data, forwarded
            halt_m      <= valid_e && halt_e;
            value_m     <= (wb_src_e == 2'd2) ? pc_e + 32'd4   // JAL/JALR link
                                              : alu_y;
        end

    // ================= M: memory + MMIO =================
    wire is_load_m = valid_m && wb_src_m == 2'd1;
    wire [31:0] addr_m   = value_m;
    wire [1:0]  off_m    = addr_m[1:0];
    wire [31:0] st_data  = st_m << (8 * off_m);
    logic [3:0] be_m;
    always_comb
        case (funct3_m[1:0])
            2'b00:   be_m = 4'b0001 << off_m;
            2'b01:   be_m = 4'b0011 << off_m;
            default: be_m = 4'b1111;
        endcase

    wire sdram_m = addr_m[28];
    wire vid_m = addr_m[17] && !sdram_m;
    wire io_m  = addr_m[16] && !vid_m && !sdram_m;

    // memory stall: SDRAM transactions freeze the entire pipeline until ack
    wire sd_active = valid_m && sdram_m && (mem_write_m || is_load_m) && !halted;
    assign mstall  = sd_active && !sd_ack;
    // drop req the moment ack arrives: otherwise req is still combinationally
    // high for the cycle before M advances, and the controller re-triggers a
    // spurious duplicate transaction whose ack corrupts a later access
    assign sd_req   = sd_active && !sd_ack;
    assign sd_we    = mem_write_m;
    assign sd_addr  = addr_m[24:2];
    assign sd_wdata = st_data;
    assign sd_be    = be_m;
    assign vid_we    = mem_write_m && valid_m && vid_m && !halted;
    assign vid_addr  = addr_m[17:0];
    assign vid_wdata = st_data;

    logic [31:0] ld_word;
    dmem dm (.clk(clk),
             .we(mem_write_m && valid_m && !io_m && !vid_m && !sdram_m && !halted),
             .be(be_m), .addr(addr_m), .wdata(st_data), .rdata(ld_word));

    // I/O sub-decode: 0x10000 LED, 0x10004 UART, 0x10010+ audio (bit 4)
    wire io_aud_m  = addr_m[4];
    wire io_uart_m = addr_m[2];
    always_ff @(posedge clk)
        if (rst)                                              led <= 8'd0;
        else if (mem_write_m && valid_m && io_m && !io_aud_m
                 && !io_uart_m && !halted)                    led <= st_data[7:0];

    logic uart_busy;
    uart_tx #(.DIV(UART_DIV)) u0
        (.clk(clk), .rst(rst),
         .wr(mem_write_m && valid_m && io_m && !io_aud_m && io_uart_m
             && !halted),
         .data(st_data[7:0]), .tx(uart_txd), .busy(uart_busy));

    audio_gen aud (.clk(clk), .rst(rst),
                   .we(mem_write_m && valid_m && io_m && io_aud_m && !halted),
                   .ch(addr_m[3:2]), .wdata(st_data), .pcm(audio));

    // loads see BRAM or SDRAM through the same byte-extension path
    wire [31:0] mem_word = sdram_m ? sd_rdata : ld_word;
    wire [31:0] ld_shift = mem_word >> (8 * off_m);
    logic [31:0] ld_ext;
    always_comb
        case (funct3_m)
            3'b000:  ld_ext = {{24{ld_shift[7]}},  ld_shift[7:0]};
            3'b001:  ld_ext = {{16{ld_shift[15]}}, ld_shift[15:0]};
            3'b100:  ld_ext = {24'd0, ld_shift[7:0]};
            3'b101:  ld_ext = {16'd0, ld_shift[15:0]};
            default: ld_ext = mem_word;              // LW: BRAM or SDRAM
        endcase

    // ---- MEM/WB ----
    logic halt_w;
    always_ff @(posedge clk)
        if (rst) begin
            valid_w <= 1'b0; halt_w <= 1'b0;
        end else if (!halted && !mstall) begin
            valid_w     <= valid_m;
            reg_write_w <= reg_write_m;
            rd_w        <= rd_m;
            halt_w      <= halt_m;
            wb_w        <= is_load_m
                         ? (io_m ? (addr_m[3] ? (addr_m[2] ? {16'd0, pad}
                                                           : vid_status)
                                              : {31'd0, uart_busy})
                                 : ld_ext)
                         : value_m;
        end

    // ================= W: writeback + halt =================
    // (regfile write port is instantiated up in D — the pipeline is a loop)
    always_ff @(posedge clk)
        if (rst)                       halted <= 1'b0;
        else if (valid_w && halt_w)    halted <= 1'b1;   // everything older
                                                          // has committed
endmodule
