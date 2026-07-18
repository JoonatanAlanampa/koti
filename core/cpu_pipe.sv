// cpu_pipe.sv — RV32IM 5-stage pipeline (step 4 + Koti-1 M extension).
// Drop-in replacement for the single-cycle cpu.sv: same module name, ports,
// and submodules — select the implementation by file list at compile time.
// (cpu.sv remains RV32I-only: it ignores is_muldiv.)
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
//  - EBREAK: flushes younger instructions, drains, sets halted at WB — so
//    every older instruction commits and nothing younger does
//  - ECALL / interrupts: precise traps taken at EX via csr.sv (mepc,
//    mcause, mstatus stack); MRET returns; WFI is a NOP
module cpu #(
    parameter HEXFILE  = "",
    parameter UART_DIV = 217
) (
    input  logic clk, rst,
    // machine-mode interrupt lines (CLINT mtip/msip, PLIC meip)
    input  logic mtip, msip, meip,
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
    logic        md_stall;               // muldiv wait, defined in E below
    logic        astall;                 // AMO RMW wait, defined in M below
    wire         pstall = mstall || md_stall || astall;  // whole-pipe freezes
    logic [31:0] target_ex;

    wire [31:0] fetch_addr = rst               ? 32'd0
                           : flush_ex          ? target_ex
                           : (stall || pstall) ? pc_d
                           :                     pc;

    imem #(.HEXFILE(HEXFILE)) im (.clk(clk), .addr_next(fetch_addr),
                                  .rdata(instr_d));

    always_ff @(posedge clk)
        if (rst) begin
            pc <= 32'd0; pc_d <= 32'd0; valid_d <= 1'b0;
        end else if (!halted && !pstall) begin
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

    logic       c_reg_write, c_alu_b_src, c_mem_write, c_is_branch, c_is_jump;
    logic       c_is_md, c_is_sys, c_is_amo;
    logic [2:0] c_imm_sel;
    logic [1:0] c_alu_a_src, c_wb_src;
    logic [3:0] c_alu_op;
    control ctl (.opcode(instr_d[6:0]), .funct3(instr_d[14:12]),
                 .funct7b5(instr_d[30]), .funct7b0(instr_d[25]),
                 .is_muldiv(c_is_md), .is_amo(c_is_amo),
                 .reg_write(c_reg_write), .imm_sel(c_imm_sel),
                 .alu_a_src(c_alu_a_src), .alu_b_src(c_alu_b_src),
                 .alu_op(c_alu_op), .mem_write(c_mem_write), .wb_src(c_wb_src),
                 .is_branch(c_is_branch), .is_jump(c_is_jump),
                 .is_system(c_is_sys));

    // SYSTEM sub-decode (needs instr[31:20], which control never sees).
    // EBREAK inherits the halt-the-core role — ECALL must trap, it is
    // the SBI call path. WFI and unknown SYSTEM encodings are NOPs.
    wire [11:0] sys12      = instr_d[31:20];
    wire is_csr_d    = c_is_sys && instr_d[14:12] != 3'b000;
    wire is_ecall_d  = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h000;
    wire is_ebreak_d = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h001;
    wire is_mret_d   = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h302;

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
    logic        is_branch_e, is_jump_e, is_md_e, is_amo_e;
    logic        ebreak_e, ecall_e, mret_e, csr_e;
    logic [4:0]  amo5_e;
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
        else if (!halted && !pstall) begin
            if (flush_ex || stall) valid_e <= 1'b0;      // bubble
            else begin
                valid_e     <= valid_d;
                reg_write_e <= c_reg_write; alu_b_src_e <= c_alu_b_src;
                mem_write_e <= c_mem_write; is_branch_e <= c_is_branch;
                is_jump_e   <= c_is_jump;
                is_md_e     <= c_is_md;
                ebreak_e    <= is_ebreak_d; ecall_e     <= is_ecall_d;
                mret_e      <= is_mret_d;   csr_e       <= is_csr_d;
                is_amo_e    <= c_is_amo;    amo5_e      <= instr_d[31:27];
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

    // RV32M: the iterative unit sits beside the ALU; md_stall freezes
    // the whole pipeline until it delivers, then the result rides the
    // normal EX/MEM path and forwards like any ALU value. `done` is
    // sticky so a concurrent mstall can't lose the completion; it
    // clears the edge EX/MEM actually latches the result.
    logic        md_busy, md_done;
    logic [31:0] md_result;
    wire md_op  = valid_e && is_md_e;
    wire md_ack = md_op && md_done && !mstall && !halted;
    assign md_stall = md_op && !md_done;
    muldiv md (.clk(clk), .rst(rst), .start(md_op), .ack(md_ack),
               .funct3(funct3_e), .a(fwd1), .b(fwd2),
               .result(md_result), .busy(md_busy), .done(md_done));

    // ---- CSR file + trap/interrupt resolution (all at EX: older
    // instructions in M/W always commit, so an EX-taken trap is
    // precise; the one wrong-path fetch dies like a mispredict) ----
    logic        csr_irq;
    logic [31:0] csr_rval, csr_irq_cause, csr_tvec, csr_epc;

    // EX commands (trap/mret/csr-write) fire only on the commit cycle:
    // held across a multi-cycle stall they would rewrite the MPIE/MIE
    // stack with already-updated values. Never inject an irq onto an
    // in-flight muldiv (would orphan the unit); the next instruction
    // is at most ~35 cycles away.
    wire irq_take  = valid_e && csr_irq && !is_md_e && !pstall && !halted;
    wire trap_take = irq_take || (valid_e && ecall_e && !pstall && !halted);
    wire mret_take = valid_e && mret_e && !pstall && !halted && !trap_take;
    wire [31:0] trap_cause = irq_take ? csr_irq_cause : 32'd11; // M-ecall

    wire csr_en  = valid_e && csr_e && !irq_take && !pstall && !halted;
    wire csr_wen = (funct3_e[1:0] == 2'b01) || (rs1_e != 5'd0);
    wire [31:0] csr_wval = funct3_e[2] ? {27'd0, rs1_e} : fwd1;

    csr csr0 (.clk(clk), .rst(rst),
              .en(csr_en), .op(funct3_e[1:0]), .wen(csr_wen),
              .addr(imm_e[11:0]), .wval(csr_wval), .rval(csr_rval),
              .trap(trap_take), .trap_pc(pc_e), .trap_cause(trap_cause),
              .mret(mret_take),
              .mtip(mtip), .msip(msip), .meip(meip),
              .irq(csr_irq), .irq_cause(csr_irq_cause),
              .tvec(csr_tvec), .epc(csr_epc));

    wire take_ex  = valid_e && (is_jump_e || (is_branch_e && br_taken));
    assign flush_ex  = take_ex || trap_take || mret_take
                     || (valid_e && ebreak_e);
    assign target_ex = trap_take            ? csr_tvec
                     : mret_take            ? csr_epc
                     : (valid_e && ebreak_e) ? pc_e         // spin, drain,
                                                            // halt at WB
                     : {alu_y[31:1], 1'b0};

    // ---- EX/MEM ----
    logic [2:0]  funct3_m;
    logic [31:0] st_m;
    logic        halt_m, is_amo_m;
    logic [4:0]  amo5_m;
    always_ff @(posedge clk)
        if (rst) valid_m <= 1'b0;
        else if (!halted && !pstall) begin
            valid_m     <= valid_e && !trap_take;   // trapped instr is
                                                    // suppressed; it
                                                    // re-executes (irq)
                                                    // or the handler
                                                    // owns it (ecall)
            reg_write_m <= reg_write_e;
            mem_write_m <= mem_write_e;
            wb_src_m    <= wb_src_e;
            funct3_m    <= funct3_e;
            rd_m        <= rd_e;
            st_m        <= fwd2;                          // store data, forwarded
            halt_m      <= valid_e && ebreak_e;
            is_amo_m    <= is_amo_e; amo5_m <= amo5_e;
            value_m     <= csr_e              ? csr_rval
                         : is_md_e            ? md_result
                         : (wb_src_e == 2'd2) ? pc_e + 32'd4   // JAL/JALR link
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

    // ---- A extension: LR/SC bookkeeping + AMO read-modify-write.
    // LR is a load that sets the reservation; SC a conditional store
    // with a success flag; AMOs a 2-phase RMW microsequence (astall)
    // that rides whatever memory the M stage talks to — BRAM today,
    // the QSPI controller after bus unification. Uniprocessor rules:
    // reservation dies on any store, any SC, any RMW, or a trap.
    wire lr_m  = valid_m && is_amo_m && amo5_m == 5'b00010;
    wire sc_m  = valid_m && is_amo_m && amo5_m == 5'b00011;
    wire rmw_m = valid_m && is_amo_m && amo5_m != 5'b00010
                                     && amo5_m != 5'b00011;

    logic        res_valid, amo_wr;      // amo_wr: RMW write-back phase
    logic [31:0] res_addr, old_q;
    wire sc_ok = res_valid && (res_addr == addr_m);

    logic [31:0] amo_new;
    always_comb
        case (amo5_m)
            5'b00000: amo_new = old_q + st_m;                    // ADD
            5'b00001: amo_new = st_m;                            // SWAP
            5'b00100: amo_new = old_q ^ st_m;                    // XOR
            5'b01000: amo_new = old_q | st_m;                    // OR
            5'b01100: amo_new = old_q & st_m;                    // AND
            5'b10000: amo_new = ($signed(old_q) < $signed(st_m))
                                ? old_q : st_m;                  // MIN
            5'b10100: amo_new = ($signed(old_q) < $signed(st_m))
                                ? st_m : old_q;                  // MAX
            5'b11000: amo_new = (old_q < st_m) ? old_q : st_m;   // MINU
            5'b11100: amo_new = (old_q < st_m) ? st_m : old_q;   // MAXU
            default:  amo_new = st_m;
        endcase

    // memory stall: SDRAM transactions freeze the entire pipeline until ack.
    // An access can also complete while md_stall keeps M frozen: remember
    // the ack (sd_seen) and hold the data, otherwise the dropped-req rule
    // below re-issues the transaction when !sd_ack comes back around.
    logic        sd_seen;
    logic [31:0] sd_data_r;
    wire sd_active = valid_m && sdram_m && (mem_write_m || is_load_m)
                  && !halted && !sd_seen && !(sc_m && !sc_ok);
    assign mstall  = sd_active && !sd_ack;

    always_ff @(posedge clk)
        if (rst) sd_seen <= 1'b0;
        else begin
            // RMW read data goes to old_q instead, and the write-back
            // phase must issue a fresh transaction — no sd_seen there
            if (sd_active && sd_ack && !rmw_m) begin
                sd_data_r <= sd_rdata;
                sd_seen   <= 1'b1;
            end
            if (!halted && !pstall) sd_seen <= 1'b0;   // M advanced
        end

    // AMO RMW sequencing: read phase completes like a load (!mstall),
    // write phase drives the store and releases the pipe on wr_ok
    wire wr_ok = !sdram_m || (sd_active && sd_ack);
    assign astall = rmw_m && !halted && !(amo_wr && wr_ok);

    always_ff @(posedge clk)
        if (rst) amo_wr <= 1'b0;
        else if (rmw_m && !halted) begin
            if (!amo_wr && !mstall) begin
                old_q  <= mem_word;
                amo_wr <= 1'b1;
            end else if (amo_wr && wr_ok)
                amo_wr <= 1'b0;
        end

    always_ff @(posedge clk)
        if (rst) res_valid <= 1'b0;
        else begin
            if (lr_m && !halted && !pstall) begin
                res_valid <= 1'b1;
                res_addr  <= addr_m;
            end
            if ((!halted && !pstall && valid_m
                 && (sc_m || mem_write_m || rmw_m)) || trap_take)
                res_valid <= 1'b0;                     // clear wins
        end
    // drop req the moment ack arrives: otherwise req is still combinationally
    // high for the cycle before M advances, and the controller re-triggers a
    // spurious duplicate transaction whose ack corrupts a later access
    assign sd_req   = sd_active && !sd_ack;
    assign sd_we    = mem_write_m || amo_wr || (sc_m && sc_ok);
    assign sd_addr  = addr_m[24:2];
    assign sd_wdata = amo_wr ? amo_new : st_data;
    assign sd_be    = be_m;
    assign vid_we    = mem_write_m && valid_m && vid_m && !halted;
    assign vid_addr  = addr_m[17:0];
    assign vid_wdata = st_data;

    logic [31:0] ld_word;
    dmem dm (.clk(clk),
             .we((mem_write_m || amo_wr || (sc_m && sc_ok))
                 && valid_m && !io_m && !vid_m && !sdram_m && !halted),
             .be(be_m), .addr(addr_m),
             .wdata(amo_wr ? amo_new : st_data), .rdata(ld_word));

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
    wire [31:0] mem_word = sdram_m ? (sd_seen ? sd_data_r : sd_rdata)
                                   : ld_word;
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
        end else if (!halted && !pstall) begin
            valid_w     <= valid_m;
            reg_write_w <= reg_write_m;
            rd_w        <= rd_m;
            halt_w      <= halt_m;
            wb_w        <= rmw_m ? old_q                   // AMO: old value
                         : sc_m  ? {31'd0, !sc_ok}         // SC: 0 = success
                         : is_load_m
                         ? (io_m ? (addr_m[3] ? (addr_m[2] ? {16'd0, pad}
                                                           : vid_status)
                                              : {31'd0, uart_busy})
                                 : ld_ext)                 // LR rides ld_ext
                         : value_m;
        end

    // ================= W: writeback + halt =================
    // (regfile write port is instantiated up in D — the pipeline is a loop)
    always_ff @(posedge clk)
        if (rst)                       halted <= 1'b0;
        else if (valid_w && halt_w)    halted <= 1'b1;   // everything older
                                                          // has committed
endmodule
