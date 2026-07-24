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
    // ================= F: fetch FSM + ITLB / i-walker =================
    logic [31:0] instr_d, pc_d;          // IF/ID
    logic        valid_d, ipf_d;         // ipf: poisoned fetch, traps at EX

    logic        stall, flush_ex;        // defined in D/E below
    logic        mstall;                 // data-port wait, defined in M below
    logic        md_stall;               // muldiv wait, defined in E below
    logic        astall;                 // AMO RMW wait, defined in M below
    logic        tlb_stall;              // DTLB walk wait, defined in E below
    wire         pstall = mstall || md_stall || astall || tlb_stall;
    logic [31:0] target_ex;
    logic        tlb_flush;              // sfence.vma / satp write (EX)
    logic        m_port_busy;            // M owns the data port (M below)

    // MMU context from csr0 (instance in EX)
    logic [31:0] csr_satp;
    logic [1:0]  csr_priv;
    logic        csr_sum, csr_mxr;
    wire mmu_i_on = csr_satp[31] && csr_priv != 2'b11;

    logic        fbusy, fdrop;
    logic [31:0] fpc;                    // VA of the in-flight fetch
    logic [31:0] fpc_pa;                 // its translation (= fpc when off)
    logic [31:0] npc;                    // next VA to fetch
    logic [31:0] fbuf;                   // skid: second word of the pair
    logic        fbuf_v;

    // ITLB: looked up on npc while idle
    wire [19:0] i_vpn = npc[31:12];
    logic        itlb_hit;
    logic [21:0] itlb_ppn;
    logic        itlb_r, itlb_w, itlb_x, itlb_u, itlb_pd, itlb_f;
    tlb #(.N(2)) itlb0 (
        .clk(clk), .rst(rst), .flush(tlb_flush),
        .vpn(i_vpn), .hit(itlb_hit), .ppn(itlb_ppn),
        .p_r(itlb_r), .p_w(itlb_w), .p_x(itlb_x), .p_u(itlb_u),
        .p_d(itlb_pd), .p_fault(itlb_f),
        .fill(iw_fill), .f_vpn(iw_vpn), .f_ppn(iw_fppn),
        .f_r(ipte[1]), .f_w(ipte[2]), .f_x(ipte[3]), .f_u(ipte[4]),
        .f_d(ipte[7]), .f_fault(iw_pte_fault));

    // execute permission at current privilege (S never runs U pages)
    wire itlb_xfault = itlb_f || !itlb_x
                    || (csr_priv == 2'b00 && !itlb_u)
                    || (csr_priv == 2'b01 &&  itlb_u);

    // i-walker: two PTE reads through the fetch port (pair's first word).
    // Fills are path-independent, so a redirect mid-walk needs no abort:
    // the walk completes against its latched vpn and simply fills.
    logic [1:0]  iw_state;               // 0 idle, 1 level-1, 2 level-0
    logic [19:0] iw_vpn;
    logic [22:0] iw_addr;

    assign if_req  = fbusy || (iw_state != 2'd0);
    assign if_addr = (iw_state != 2'd0) ? iw_addr : fpc_pa[24:2];

    wire [31:0] ipte     = if_rdata;
    wire        ipte_bad = !ipte[0] || (!ipte[1] && ipte[2]);   // !V, W&!R
    wire        ipte_leaf = ipte[1] || ipte[3];                 // R or X
    wire        iw_l1 = if_ack && iw_state == 2'd1;
    wire        iw_l0 = if_ack && iw_state == 2'd2;
    wire        iw_pte_fault = ipte_bad
                    || (iw_l1 && ipte_leaf && ipte[19:10] != 10'd0)
                    || (iw_l0 && !ipte_leaf)
                    || (ipte_leaf && !ipte[6]);                 // A = 0
    wire        iw_fill = (iw_l1 && (ipte_bad || ipte_leaf)) || iw_l0;
    wire [21:0] iw_fppn = iw_l1 ? {ipte[31:20], iw_vpn[9:0]}    // megapage
                                : ipte[31:10];

    wire advance = !halted && !pstall;
    wire consume = advance && valid_d && !stall && !flush_ex;

    always_ff @(posedge clk)
        if (rst) begin
            fbusy <= 1'b0; fdrop <= 1'b0;
            fpc   <= 32'd0; fpc_pa <= 32'd0; npc <= 32'd0;
            fbuf  <= 32'd0; fbuf_v <= 1'b0;
            valid_d <= 1'b0; pc_d <= 32'd0; instr_d <= 32'd0;
            ipf_d <= 1'b0;
            iw_state <= 2'd0; iw_vpn <= 20'd0; iw_addr <= 23'd0;
        end else begin
            if (consume) begin
                if (fbuf_v) begin       // promote the pair's second word
                    instr_d <= fbuf;
                    pc_d    <= pc_d + 32'd4;
                    fbuf_v  <= 1'b0;    // valid_d stays 1: no bubble
                end else
                    valid_d <= 1'b0;
            end

            if (iw_l1) begin
                if (ipte_bad || ipte_leaf)
                    iw_state <= 2'd0;   // filled (translation or fault)
                else begin
                    iw_addr  <= {ipte[22:10], iw_vpn[9:0]};   // level-0 PTE
                    iw_state <= 2'd2;
                end
            end else if (iw_l0)
                iw_state <= 2'd0;

            if (if_ack && iw_state == 2'd0) begin
                // a fetch is only in flight while head+skid are empty, so
                // delivery never collides with consume/promote
                fbusy <= 1'b0;
                fdrop <= 1'b0;
                if (!fdrop) begin
                    instr_d <= if_rdata;
                    pc_d    <= fpc;
                    valid_d <= 1'b1;
                    ipf_d   <= 1'b0;
                    fbuf    <= if_rdata2;
                    // a pair straddling a page boundary would carry the
                    // wrong translation for its second word: drop it
                    fbuf_v  <= !(mmu_i_on && fpc[11:2] == 10'h3FF);
                    npc     <= fpc + 32'd8;
                end
            end else if (iw_state == 2'd0 && !fbusy && !valid_d && !fbuf_v
                         && !halted && !pstall && !flush_ex) begin
                // !flush_ex: a redirect lands this same edge and rewrites
                // npc — starting now would fetch the stale wrong-path npc
                // (see rv32_core.sv for the full war story)
                // !pstall: never launch a fetch/ITLB walk while an older
                // stage is stalled — a satp write held behind a bus txn
                // could otherwise start an old-root walk that outlives the
                // flush at its commit edge (F2).
                if (!mmu_i_on) begin
                    fbusy <= 1'b1; fpc <= npc; fpc_pa <= npc;
                end else if (itlb_hit && !itlb_xfault) begin
                    fbusy  <= 1'b1; fpc <= npc;
                    fpc_pa <= {itlb_ppn[19:0], npc[11:0]};
                end else if (itlb_hit) begin
                    // execute fault: poison one NOP; EX takes the trap
                    instr_d <= 32'h0000_0013;
                    pc_d    <= npc;
                    valid_d <= 1'b1;
                    ipf_d   <= 1'b1;
                end else begin
                    iw_vpn   <= i_vpn;
                    iw_addr  <= {csr_satp[12:0], i_vpn[19:10]};
                    iw_state <= 2'd1;
                end
            end

            // redirect last: overrides a same-cycle delivery/promotion
            if (advance && flush_ex) begin
                valid_d <= 1'b0;
                ipf_d   <= 1'b0;
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
    wire is_sfence_d = c_is_sys && instr_d[14:12] == 3'b000
                     && instr_d[31:25] == 7'b0001001;   // sfence.vma

    // instruction legality (coarse but covers what kernels probe:
    // unknown major opcodes, bad funct3/funct7 combos, bad SYSTEM
    // encodings; CSR existence/privilege is checked at EX)
    logic legal_d;
    always_comb begin
        legal_d = 1'b0;
        case (instr_d[6:0])
            7'b0110111, 7'b0010111, 7'b1101111: legal_d = 1'b1;  // U/J
            7'b1100111: legal_d = instr_d[14:12] == 3'b000;      // JALR
            7'b1100011: legal_d = instr_d[14:12] != 3'b010
                               && instr_d[14:12] != 3'b011;      // Bxx
            7'b0000011: legal_d = instr_d[14:12] <= 3'd2
                               || instr_d[14:12] == 3'd4
                               || instr_d[14:12] == 3'd5;        // loads
            7'b0100011: legal_d = instr_d[14:12] <= 3'd2;        // stores
            7'b0010011: legal_d =
                  (instr_d[14:12] == 3'b001) ? instr_d[31:25] == 7'd0
                : (instr_d[14:12] == 3'b101) ? (instr_d[31:25] == 7'd0
                                             || instr_d[31:25] == 7'h20)
                : 1'b1;                                          // OP-IMM
            7'b0110011: legal_d = instr_d[31:25] == 7'd0
                               || instr_d[31:25] == 7'h01
                               || (instr_d[31:25] == 7'h20
                                   && (instr_d[14:12] == 3'b000
                                    || instr_d[14:12] == 3'b101)); // OP/M
            7'b0001111: legal_d = 1'b1;                          // FENCE
            7'b0101111: legal_d = instr_d[14:12] == 3'b010
                && (instr_d[31:27] <= 5'd4 || instr_d[31:27] == 5'd8
                    || instr_d[31:27] == 5'd12
                    || (instr_d[31] && instr_d[28:27] == 2'b00)); // A
            7'b1110011: legal_d = (instr_d[14:12] != 3'b000
                                && instr_d[14:12] != 3'b100)     // CSRs
                || is_ecall_d || is_ebreak_d || is_mret_d
                || is_sret_d || is_sfence_d
                || sys12 == 12'h105;                             // WFI
            default: ;
        endcase
    end

    logic [31:0] imm_d;
    immgen ig (.instr(instr_d), .sel(c_imm_sel), .imm(imm_d));

    // regfile: written in W, read with a REGISTERED address — the
    // sync-read (read-first) timing of the tnt 32x32 RF macro, whose
    // instance replaces src/regfile.sv's body. The read output IS the
    // operand pipeline register (r1_e/r2_e are gone). While the pipe
    // is frozen the address mux re-selects the EX instruction's
    // registers so the output stays coherent with what EX is using;
    // W is frozen too, so the content cannot change mid-freeze.
    logic        reg_write_w, valid_w;
    logic [4:0]  rd_w;
    logic [31:0] wb_w, rf_r1, rf_r2;
    wire de_advance = !halted && !pstall;   // the ID/EX latch condition
    regfile rf (.clk(clk), .we(reg_write_w && valid_w && !halted),
                .waddr(rd_w), .wdata(wb_w),
                .raddr1(de_advance ? rs1_d : rs1_e),
                .raddr2(de_advance ? rs2_d : rs2_e),
                .rdata1(rf_r1), .rdata2(rf_r2));

    // WB -> ID bypass, latched into EX: the only write the edge-N
    // read misses (read-first) is the one landing at edge N itself —
    // a W writeback during the instruction's final D cycle. Writes on
    // earlier (stalled) D cycles are already inside the read.
    wire wb_hit1 = reg_write_w && valid_w && rd_w != 5'd0 && rd_w == rs1_d;
    wire wb_hit2 = reg_write_w && valid_w && rd_w != 5'd0 && rd_w == rs2_d;

    // ---- ID/EX ----
    logic        valid_e, reg_write_e, alu_b_src_e, mem_write_e;
    logic        is_branch_e, is_jump_e, is_md_e, is_amo_e;
    logic        ebreak_e, ecall_e, mret_e, sret_e, csr_e;
    logic        ipf_e, sfence_e, illegal_e;
    logic [31:0] instr_e;                // for mtval on illegal
    logic [4:0]  amo5_e;
    logic [1:0]  alu_a_src_e, wb_src_e;
    logic [3:0]  alu_op_e;
    logic [2:0]  funct3_e;
    logic [4:0]  rs1_e, rs2_e, rd_e;
    logic        byp1_e, byp2_e;
    logic [31:0] pc_e, imm_e, bypv_e;

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
                sret_e      <= is_sret_d;   sfence_e    <= is_sfence_d;
                ipf_e       <= ipf_d;
                illegal_e   <= !legal_d && !ipf_d;   // poison NOP is legal
                instr_e     <= instr_d;
                is_amo_e    <= c_is_amo;    amo5_e      <= instr_d[31:27];
                alu_a_src_e <= c_alu_a_src; wb_src_e    <= c_wb_src;
                alu_op_e    <= c_alu_op;    funct3_e    <= instr_d[14:12];
                rs1_e <= rs1_d; rs2_e <= rs2_d; rd_e <= rd_d;
                pc_e  <= pc_d;  imm_e <= imm_d;
                byp1_e <= wb_hit1; byp2_e <= wb_hit2; bypv_e <= wb_w;
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
    wire [31:0] base1 = byp1_e ? bypv_e : rf_r1;   // sync read + bypass
    wire [31:0] base2 = byp2_e ? bypv_e : rf_r2;
    wire [31:0] fwd1 = m_fwd1 ? value_m : w_fwd1 ? wb_w : base1;
    wire [31:0] fwd2 = m_fwd2 ? value_m : w_fwd2 ? wb_w : base2;

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
    wire md_op  = valid_e && is_md_e && !illegal_e;
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
    logic        csr_irq, csr_known;
    logic [31:0] csr_rval, csr_trap_vec, csr_mepc, csr_sepc;

    // ---- illegal instruction (cause 2): decode-level (illegal_e from
    // D) plus EX-level checks that need CSR/privilege context. An
    // illegal instruction must produce no side effects: it is excluded
    // from memory ops, muldiv, CSR writes, and branch redirects.
    wire csr_wen0 = (funct3_e[1:0] == 2'b01) || (rs1_e != 5'd0);
    wire csr_ill  = csr_e && (!csr_known
                 || imm_e[9:8] > csr_priv
                 || (csr_wen0 && imm_e[11:10] == 2'b11));  // RO CSR write
    wire ret_ill  = (mret_e && csr_priv != 2'b11)
                 || (sret_e && csr_priv == 2'b00)
                 || (sfence_e && csr_priv == 2'b00);
    wire ill_e    = illegal_e || csr_ill || ret_ill;

    // ---- sv32 data-side translation, at EX so traps stay precise and
    // stval gets the faulting VA ----
    wire mmu_d_on  = csr_satp[31] && csr_priv != 2'b11;   // (no MPRV)
    wire dmem_op_e = valid_e && !ill_e
                  && (mem_write_e || wb_src_e == 2'd1);

    // misaligned data address (4/6): lower priority than page faults
    wire dmis = dmem_op_e
             && ((funct3_e[1:0] == 2'b01 && alu_y[0])
              || (funct3_e[1:0] == 2'b10 && alu_y[1:0] != 2'b00));
    wire d_isstore = mem_write_e
                  || (is_amo_e && amo5_e != 5'b00010);    // SC/AMO: store pf

    wire [19:0] d_vpn = alu_y[31:12];
    logic        dtlb_hit;
    logic [21:0] dtlb_ppn;
    logic        dtlb_r, dtlb_w, dtlb_x, dtlb_u, dtlb_pd, dtlb_f;
    tlb #(.N(2)) dtlb0 (
        .clk(clk), .rst(rst), .flush(tlb_flush),
        .vpn(d_vpn), .hit(dtlb_hit), .ppn(dtlb_ppn),
        .p_r(dtlb_r), .p_w(dtlb_w), .p_x(dtlb_x), .p_u(dtlb_u),
        .p_d(dtlb_pd), .p_fault(dtlb_f),
        .fill(dw_fill), .f_vpn(dw_vpn), .f_ppn(dw_fppn),
        .f_r(dpte[1]), .f_w(dpte[2]), .f_x(dpte[3]), .f_u(dpte[4]),
        .f_d(dpte[7]), .f_fault(dw_pte_fault));

    wire dtlb_pfault = dtlb_f
        || (csr_priv == 2'b00 && !dtlb_u)
        || (csr_priv == 2'b01 &&  dtlb_u && !csr_sum)
        || (d_isstore ? (!dtlb_w || !dtlb_pd)             // D=0 store faults
                      : !(dtlb_r || (csr_mxr && dtlb_x)));
    wire d_xlate = dmem_op_e && mmu_d_on;
    assign tlb_stall = d_xlate && !dtlb_hit;              // walk in progress
    wire [31:0] d_pa = mmu_d_on ? {dtlb_ppn[19:0], alu_y[11:0]} : alu_y;

    // ---- physical access faults (PMA), on the resolved physical
    // address: writes to read-only flash and any access to the APS6404
    // 8 MiB high mirror (addr[24] && addr[23]). Device MMIO pages
    // (io_m 0x0001, CLINT 0x0002, PLIC 0x0003, VGA 0x0004) are writable;
    // everything else in flash space (addr[24]=0) is read-only XIP.
    wire pa_dev      = !d_pa[24] && d_pa[23:16] >= 8'h01
                                 && d_pa[23:16] <= 8'h04;
    wire pa_flash_ro = !d_pa[24] && !pa_dev;
    wire pa_psram_hi =  d_pa[24] &&  d_pa[23];
    wire dacc_fault  = dmem_op_e
                    && ((d_isstore && pa_flash_ro) || pa_psram_hi);

    // d-walker: two PTE reads on the data port, issued only while the
    // M stage isn't mid-transaction (its op completes under d_seen).
    // Never aborted: irqs are gated on !pstall, and nothing older than
    // EX can flush it.
    logic [1:0]  dw_state;
    logic [19:0] dw_vpn;
    logic [22:0] dw_addr;
    wire dw_req  = (dw_state != 2'd0) && !m_port_busy;
    wire dw_ack  = d_ack && dw_req;
    wire [31:0] dpte     = d_rdata;
    wire        dpte_bad = !dpte[0] || (!dpte[1] && dpte[2]);
    wire        dpte_leaf = dpte[1] || dpte[3];
    wire        dw_l1 = dw_ack && dw_state == 2'd1;
    wire        dw_l0 = dw_ack && dw_state == 2'd2;
    wire        dw_pte_fault = dpte_bad
                    || (dw_l1 && dpte_leaf && dpte[19:10] != 10'd0)
                    || (dw_l0 && !dpte_leaf)
                    || (dpte_leaf && !dpte[6]);           // A = 0
    wire        dw_fill = (dw_l1 && (dpte_bad || dpte_leaf)) || dw_l0;
    wire [21:0] dw_fppn = dw_l1 ? {dpte[31:20], dw_vpn[9:0]}
                                : dpte[31:10];

    always_ff @(posedge clk)
        if (rst) begin
            dw_state <= 2'd0; dw_vpn <= 20'd0; dw_addr <= 23'd0;
        end else if (dw_state == 2'd0) begin
            if (d_xlate && !dtlb_hit && !halted) begin
                dw_vpn   <= d_vpn;
                dw_addr  <= {csr_satp[12:0], d_vpn[19:10]};
                dw_state <= 2'd1;
            end
        end else if (dw_l1) begin
            if (dpte_bad || dpte_leaf)
                dw_state <= 2'd0;
            else begin
                dw_addr  <= {dpte[22:10], dw_vpn[9:0]};
                dw_state <= 2'd2;
            end
        end else if (dw_l0)
            dw_state <= 2'd0;

    wire take_ex = valid_e && !ill_e
                && (is_jump_e || (is_branch_e && br_taken));

    // ---- traps: EX commands fire only on the commit cycle.
    // Priority: irq > ipf > illegal > ecall > misaligned fetch target
    // > data page fault > data misalign (page faults outrank misalign
    // per the privileged spec's exception priority table).
    wire commit    = !pstall && !halted;
    wire irq_take  = valid_e && csr_irq && !is_md_e && commit;
    wire ipf_take  = valid_e && ipf_e && !irq_take && commit;
    wire ill_take  = valid_e && ill_e && !irq_take && commit;
    wire ecl_take  = valid_e && ecall_e && !irq_take && commit;
    wire imis_take = take_ex && alu_y[1] && !irq_take && commit;
    wire dpf_take  = d_xlate && dtlb_hit && dtlb_pfault
                  && !irq_take && commit;
    wire dmis_take = dmis && !dpf_take && !irq_take && commit;
    // access fault: only once misalign and page fault are ruled out
    wire dacc_take = dacc_fault && !dmis_take && !dpf_take && !irq_take
                  && commit;
    wire trap_take = irq_take || ipf_take || ill_take || ecl_take
                  || imis_take || dpf_take || dmis_take || dacc_take;
    wire mret_take = valid_e && mret_e && commit && !trap_take;
    wire sret_take = valid_e && sret_e && commit && !trap_take;
    wire sfence_take = valid_e && sfence_e && commit && !trap_take;

    wire [3:0]  trap_kind = ipf_take  ? 4'd1
                          : ill_take  ? 4'd4
                          : imis_take ? 4'd5
                          : dpf_take  ? (d_isstore ? 4'd3 : 4'd2)
                          : dmis_take ? (d_isstore ? 4'd7 : 4'd6)
                          : dacc_take ? (d_isstore ? 4'd9 : 4'd8)
                          :             4'd0;
    wire [31:0] trap_tval = ipf_take  ? pc_e
                          : ill_take  ? instr_e
                          : imis_take ? {alu_y[31:1], 1'b0}
                          : (dpf_take || dmis_take || dacc_take) ? alu_y
                          :             32'd0;

    wire csr_en  = valid_e && csr_e && !ill_e && !irq_take && commit;
    wire csr_wen = csr_wen0;
    wire [31:0] csr_wval = funct3_e[2] ? {27'd0, rs1_e} : fwd1;

    // a satp write serializes fetch exactly like sfence.vma: flush the
    // TLBs AND redirect so no instruction fetched under the old root can
    // retire under the new translation (F2).
    wire satp_take = csr_en && csr_wen && imm_e[11:0] == 12'h180;
    assign tlb_flush = sfence_take || satp_take;

    csr csr0 (.clk(clk), .rst(rst),
              .retire(valid_w && !pstall && !halted),
              .en(csr_en), .op(funct3_e[1:0]), .wen(csr_wen),
              .addr(imm_e[11:0]), .wval(csr_wval), .rval(csr_rval),
              .trap(trap_take), .trap_irq(irq_take), .trap_kind(trap_kind),
              .trap_pc(pc_e), .trap_tval(trap_tval),
              .mret(mret_take), .sret(sret_take),
              .mtip(mtip), .msip(msip), .meip(meip),
              .irq(csr_irq), .trap_vec(csr_trap_vec),
              .mepc_rd(csr_mepc), .sepc_rd(csr_sepc),
              .satp_rd(csr_satp), .priv_rd(csr_priv),
              .sum_rd(csr_sum), .mxr_rd(csr_mxr), .known(csr_known));

    assign flush_ex  = (take_ex && !imis_take) || trap_take || mret_take
                     || sret_take || satp_take
                     || sfence_take || (valid_e && ebreak_e);
    assign target_ex = trap_take             ? csr_trap_vec
                     : mret_take             ? csr_mepc
                     : sret_take             ? csr_sepc
                     : satp_take             ? pc_e + 32'd4  // serialize
                     : sfence_take           ? pc_e + 32'd4  // serialize
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
                         : dmem_op_e          ? d_pa           // translated
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
    // top decodes and acks them. Decode the FULL 64 KB window
    // (addr[31:16]==0x0001) — a partial 3-bit compare aliased flash data
    // past 64 KB into this carve-out every 512 KB (F1).
    wire io_m = addr_m[31:16] == 16'h0001;

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
    assign m_port_busy = d_active;
    wire m_ack_here = d_ack && !dw_req;       // else the walker owns it
    assign mstall = d_active && !m_ack_here;
    // port muxes: the EX-side page walker borrows the port only while
    // the M stage is quiet
    assign d_req   = (d_active && !m_ack_here) || dw_req;
    assign d_we    = !dw_req && (mem_write_m || amo_wr || (sc_m && sc_ok));
    assign d_addr  = dw_req ? dw_addr : addr_m[24:2];
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
