// koti_core.sv — the Koti-1 ASIC core: RV32IMA + Zicsr + M-mode traps
// on the XIP memory interface. Merges the two proven lineages:
//   - fetch FSM + external data port + MMIO from tt-riscv's
//     rv32_core.sv (non-blocking pair fetch with skid buffer, fdrop on
//     redirect, whole-pipe freeze on data-port waits)
//   - muldiv, csr/trap, and AMO machinery from core/cpu_pipe.sv (which
//     stays behind as the FPGA/BRAM reference build)
//
// Memory map: flash 0x0000_0000+ (code+rodata, addr bit 24 = 0),
// PSRAM 0x0100_0000+ (bit 24 = 1). Core-internal MMIO carve-out at
// 0x0001_0000: +0 LED (w), +4 UART (w data / r busy), +8 GPIO in (r),
// +C QSPI_CFG (r/w). Anything else non-flash/PSRAM-shaped (CLINT at
// 0x0002_0000, PLIC, VGA regs) goes out the data port for the SoC top
// to decode and ack — the port protocol doesn't care who answers.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module koti_core #(
    parameter UART_DIV = 217
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        mtip, msip, meip,
    output logic        halted,
    output logic [7:0]  led,
    output logic        uart_txd,
    input  logic [7:0]  gpio_in,
    output logic [1:0]  qspi_cfg,   // MMIO +C; resets 0 = 1-bit SPI

    // instruction fetch port (req held until 1-cycle ack); each fetch
    // returns an instruction PAIR: if_rdata = @addr, if_rdata2 = @addr+4
    output logic        if_req,
    output logic [22:0] if_addr,
    input  logic        if_ack,
    input  logic [31:0] if_rdata,
    input  logic [31:0] if_rdata2,

    // data port (same protocol)
    output logic        d_req,
    output logic        d_we,
    output logic [22:0] d_addr,
    output logic [31:0] d_wdata,
    output logic [3:0]  d_be,
    input  logic        d_ack,
    input  logic [31:0] d_rdata
);
    // ================= F: fetch FSM =================
    logic [31:0] instr_d, pc_d;          // IF/ID
    logic        valid_d;

    logic        stall, flush_ex;        // defined in D/E below
    logic        mstall;                 // data-port wait, defined in M below
    logic        md_stall;               // muldiv wait, defined in E below
    logic        astall;                 // AMO RMW wait, defined in M below
    wire         pstall = mstall || md_stall || astall;
    logic [31:0] target_ex;

    logic        fbusy, fdrop;
    logic [31:0] fpc;                    // address of the in-flight fetch
    logic [31:0] npc;                    // next address to fetch
    logic [31:0] fbuf;                   // skid: second word of the pair
    logic        fbuf_v;

    assign if_req  = fbusy;
    assign if_addr = fpc[24:2];

    wire advance = !halted && !pstall;
    wire consume = advance && valid_d && !stall && !flush_ex;

    always_ff @(posedge clk)
        if (rst) begin
            fbusy <= 1'b0; fdrop <= 1'b0;
            fpc   <= 32'd0; npc <= 32'd0;
            fbuf  <= 32'd0; fbuf_v <= 1'b0;
            valid_d <= 1'b0; pc_d <= 32'd0; instr_d <= 32'd0;
        end else begin
            if (consume) begin
                if (fbuf_v) begin       // promote the pair's second word
                    instr_d <= fbuf;
                    pc_d    <= pc_d + 32'd4;
                    fbuf_v  <= 1'b0;    // valid_d stays 1: no bubble
                end else
                    valid_d <= 1'b0;
            end

            if (if_ack) begin
                // a fetch is only in flight while head+skid are empty, so
                // delivery never collides with consume/promote
                fbusy <= 1'b0;
                fdrop <= 1'b0;
                if (!fdrop) begin
                    instr_d <= if_rdata;
                    pc_d    <= fpc;
                    valid_d <= 1'b1;
                    fbuf    <= if_rdata2;
                    fbuf_v  <= 1'b1;
                    npc     <= fpc + 32'd8;
                end
            end else if (!fbusy && !valid_d && !fbuf_v && !halted && !flush_ex) begin
                // !flush_ex: a redirect lands this same edge and rewrites
                // npc — starting now would fetch the stale wrong-path npc
                // (see rv32_core.sv for the full war story)
                fbusy <= 1'b1;
                fpc   <= npc;
            end

            // redirect last: overrides a same-cycle delivery/promotion
            if (advance && flush_ex) begin
                valid_d <= 1'b0;
                fbuf_v  <= 1'b0;
                npc     <= target_ex;
                if (fbusy && !if_ack) fdrop <= 1'b1;
            end
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
    // EBREAK halts the core; ECALL traps (it is the SBI path); WFI and
    // unknown SYSTEM encodings are NOPs.
    wire [11:0] sys12 = instr_d[31:20];
    wire is_csr_d    = c_is_sys && instr_d[14:12] != 3'b000;
    wire is_ecall_d  = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h000;
    wire is_ebreak_d = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h001;
    wire is_mret_d   = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h302;
    wire is_sret_d   = c_is_sys && instr_d[14:12] == 3'b000 && sys12 == 12'h102;

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
    logic        ebreak_e, ecall_e, mret_e, sret_e, csr_e;
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
            if (flush_ex || stall || !valid_d) valid_e <= 1'b0;   // bubble
            else begin
                valid_e     <= valid_d;
                reg_write_e <= c_reg_write; alu_b_src_e <= c_alu_b_src;
                mem_write_e <= c_mem_write; is_branch_e <= c_is_branch;
                is_jump_e   <= c_is_jump;
                is_md_e     <= c_is_md;
                ebreak_e    <= is_ebreak_d; ecall_e     <= is_ecall_d;
                mret_e      <= is_mret_d;   csr_e       <= is_csr_d;
                sret_e      <= is_sret_d;
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

    // RV32M: md_stall freezes the pipe until the iterative unit
    // delivers; the result rides EX/MEM and forwards normally
    logic        md_busy, md_done;
    logic [31:0] md_result;
    wire md_op  = valid_e && is_md_e;
    wire md_ack = md_op && md_done && !mstall && !astall && !halted;
    assign md_stall = md_op && !md_done;
    muldiv md (.clk(clk), .rst(rst), .start(md_op), .ack(md_ack),
               .funct3(funct3_e), .a(fwd1), .b(fwd2),
               .result(md_result), .busy(md_busy), .done(md_done));

    // CSR file + trap/interrupt resolution, all at EX: older stages
    // always commit, so an EX-taken trap is precise. EX commands fire
    // only on the commit cycle (!pstall) — held across a stall they
    // would rewrite the MPIE/MIE stack. Never inject an irq onto an
    // in-flight muldiv (would orphan the unit).
    logic        csr_irq;
    logic [31:0] csr_rval, csr_trap_vec, csr_mepc, csr_sepc;

    wire irq_take  = valid_e && csr_irq && !is_md_e && !pstall && !halted;
    wire trap_take = irq_take || (valid_e && ecall_e && !pstall && !halted);
    wire mret_take = valid_e && mret_e && !pstall && !halted && !trap_take;
    wire sret_take = valid_e && sret_e && !pstall && !halted && !trap_take;

    wire csr_en  = valid_e && csr_e && !irq_take && !pstall && !halted;
    wire csr_wen = (funct3_e[1:0] == 2'b01) || (rs1_e != 5'd0);
    wire [31:0] csr_wval = funct3_e[2] ? {27'd0, rs1_e} : fwd1;

    csr csr0 (.clk(clk), .rst(rst),
              .en(csr_en), .op(funct3_e[1:0]), .wen(csr_wen),
              .addr(imm_e[11:0]), .wval(csr_wval), .rval(csr_rval),
              .trap(trap_take), .trap_ecall(!irq_take), .trap_pc(pc_e),
              .mret(mret_take), .sret(sret_take),
              .mtip(mtip), .msip(msip), .meip(meip),
              .irq(csr_irq), .trap_vec(csr_trap_vec),
              .mepc_rd(csr_mepc), .sepc_rd(csr_sepc));

    wire take_ex  = valid_e && (is_jump_e || (is_branch_e && br_taken));
    assign flush_ex  = take_ex || trap_take || mret_take || sret_take
                     || (valid_e && ebreak_e);
    assign target_ex = trap_take             ? csr_trap_vec
                     : mret_take             ? csr_mepc
                     : sret_take             ? csr_sepc
                     : (valid_e && ebreak_e) ? pc_e          // spin + drain
                     : {alu_y[31:1], 1'b0};

    // ---- EX/MEM ----
    logic [2:0]  funct3_m;
    logic [31:0] st_m;
    logic        halt_m, is_amo_m;
    logic [4:0]  amo5_m;
    always_ff @(posedge clk)
        if (rst) valid_m <= 1'b0;
        else if (!halted && !pstall) begin
            valid_m     <= valid_e && !trap_take;
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

    // core-internal MMIO carve-out at 0x0001_0000 (inside the flash
    // window: keep code+rodata below 64 KB). CLINT/PLIC/VGA registers
    // live higher (0x0002_0000+) and go out the data port; the SoC
    // top decodes and acks them.
    wire io_m = addr_m[16] && !addr_m[24] && !addr_m[17];

    // ---- A extension: LR/SC bookkeeping + AMO read-modify-write.
    // AMOs to the MMIO carve-out are meaningless and skipped.
    wire lr_m  = valid_m && is_amo_m && amo5_m == 5'b00010;
    wire sc_m  = valid_m && is_amo_m && amo5_m == 5'b00011;
    wire rmw_m = valid_m && is_amo_m && !io_m && amo5_m != 5'b00010
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

    // external transactions freeze the entire pipeline until ack; an
    // ack landing while frozen by md/astall is captured (d_seen) so
    // the dropped-req rule can't re-issue the transaction. RMW read
    // data goes to old_q instead — the write phase needs a fresh
    // transaction.
    logic        d_seen;
    logic [31:0] d_data_r;
    wire d_active = valid_m && !io_m && (mem_write_m || is_load_m)
                 && !halted && !d_seen && !(sc_m && !sc_ok);
    assign mstall = d_active && !d_ack;
    assign d_req   = d_active && !d_ack;
    assign d_we    = mem_write_m || amo_wr || (sc_m && sc_ok);
    assign d_addr  = addr_m[24:2];
    assign d_wdata = amo_wr ? amo_new : st_data;
    assign d_be    = be_m;

    always_ff @(posedge clk)
        if (rst) d_seen <= 1'b0;
        else begin
            if (d_active && d_ack && !rmw_m) begin
                d_data_r <= d_rdata;
                d_seen   <= 1'b1;
            end
            if (!halted && !pstall) d_seen <= 1'b0;   // M advanced
        end

    wire wr_ok = d_active && d_ack;
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

    // I/O sub-decode: +0 LED, +4 UART, +8 GPIO in, +C QSPI_CFG
    wire io_gpio_m = addr_m[3];
    wire io_uart_m = addr_m[2];
    always_ff @(posedge clk)
        if (rst)                                              led <= 8'd0;
        else if (mem_write_m && valid_m && io_m && !io_gpio_m
                 && !io_uart_m && !halted)                    led <= st_data[7:0];

    // QSPI_CFG resets to 0 (plain SPI) so the chip always boots
    always_ff @(posedge clk)
        if (rst)                                              qspi_cfg <= 2'b00;
        else if (mem_write_m && valid_m && io_m && io_gpio_m
                 && io_uart_m && !halted)                     qspi_cfg <= st_data[1:0];

    logic uart_busy;
    uart_tx #(.DIV(UART_DIV)) u0
        (.clk(clk), .rst(rst),
         .wr(mem_write_m && valid_m && io_m && !io_gpio_m && io_uart_m
             && !halted),
         .data(st_data[7:0]), .tx(uart_txd), .busy(uart_busy));

    // loads: external word through the byte-extension path
    wire [31:0] mem_word = d_seen ? d_data_r : d_rdata;
    wire [31:0] ld_shift = mem_word >> (8 * off_m);
    logic [31:0] ld_ext;
    always_comb
        case (funct3_m)
            3'b000:  ld_ext = {{24{ld_shift[7]}},  ld_shift[7:0]};
            3'b001:  ld_ext = {{16{ld_shift[15]}}, ld_shift[15:0]};
            3'b100:  ld_ext = {24'd0, ld_shift[7:0]};
            3'b101:  ld_ext = {16'd0, ld_shift[15:0]};
            default: ld_ext = mem_word;
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
                         ? (io_m ? (io_gpio_m ? (io_uart_m ? {30'd0, qspi_cfg}
                                                           : {24'd0, gpio_in})
                                              : {31'd0, uart_busy})
                                 : ld_ext)                 // LR rides ld_ext
                         : value_m;
        end

    // ================= W: writeback + halt =================
    always_ff @(posedge clk)
        if (rst)                       halted <= 1'b0;
        else if (valid_w && halt_w)    halted <= 1'b1;
endmodule
