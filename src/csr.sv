// csr.sv — Koti-1 CSR file: M/S/U privilege modes, trap/interrupt
// bookkeeping, delegation, and the S-mode CSR set. (core/csr.sv is the
// frozen M-only ancestor.) sv32 translation state (satp) is held here;
// the walker/TLBs consume it in the MMU milestone.
//
// The pipeline gates all commands (`en`, `trap`, `mret`, `sret`) on
// the commit cycle, so each fires exactly once. `trap_vec` is valid
// combinationally in the trap cycle so the fetch redirect can use it.
// Interrupt take/delegation follows the privileged spec: M-level
// pending goes to M if (priv<M) or MIE; delegated (mideleg) pending
// goes to S if (priv<S) or (priv==S and SIE), never while in M.
//
// Known gaps (PLAN.md, milestone 8): no illegal-instruction traps
// (unknown CSRs read 0/ignore writes, CSR privilege not checked), no
// misalign traps, no mcycle/minstret, stval/mtval always 0.
module csr (
    input  logic        clk, rst,
    input  logic        retire,      // one instruction commits this cycle
    // EX-stage CSR instruction
    input  logic        en,
    input  logic [1:0]  op,          // funct3[1:0]: 01 RW, 10 RS, 11 RC
    input  logic        wen,
    input  logic [11:0] addr,
    input  logic [31:0] wval,
    output logic [31:0] rval,
    // trap entry / returns (single-cycle commands from EX)
    input  logic        trap,        // take a trap now
    input  logic        trap_irq,    // it is the pending irq we report
    input  logic [3:0]  trap_kind,   // else: 0 ecall, 1 ipf, 2 lpf,
                                     // 3 spf, 4 illegal, 5 misaligned
                                     // fetch, 6 misload, 7 misstore,
                                     // 8 load-access, 9 store/AMO-access,
                                     // 10 breakpoint (S/U EBREAK)
    input  logic [31:0] trap_pc,
    input  logic [31:0] trap_tval,
    input  logic        mret, sret,
    // interrupt lines (level)
    input  logic        mtip, msip, meip,
    // S-level external interrupt from the PLIC. Separate from the
    // software-set mip.SEIP bit below, and ORed with it — which is what the
    // spec asks for: mip.SEIP reads as the union of the platform's pin and
    // whatever M-mode software has injected, and M-mode writes must not be
    // able to clear a request the PLIC is still making.
    input  logic        seip_pin,
    // to the pipeline
    output logic        irq,         // take an interrupt now
    output logic [31:0] trap_vec,    // where this cycle's trap goes
    output logic [31:0] mepc_rd, sepc_rd,
    // MMU context
    output logic [31:0] satp_rd,
    output logic [1:0]  priv_rd,
    output logic        sum_rd, mxr_rd,
    // the addressed CSR exists (illegal-instruction check in EX)
    output logic        known
);
    // privilege: 11 = M, 01 = S, 00 = U
    logic [1:0]  priv;

    // mstatus fields
    logic        sie_g, mie_g, spie, mpie, spp;
    logic        sum_b, mxr_b;
    logic [1:0]  mpp;
    // interrupt enables (mie register bits)
    logic        ssie, stie, seie, msie, mtie, meie;
    // software-set pending bits (the rest of mip is wired from inputs)
    logic        ssip, stip, seip_sw;
    // What the rest of the file sees as "S external pending": the PLIC's line
    // ORed with the software-injected bit. Everything downstream — mip/sip
    // reads and the p_sei enable term — is unchanged and simply picks this up.
    wire         seip = seip_sw | seip_pin;
    // trap state
    logic [31:0] mtvec_q, mepc_q, mcause_q, mscratch_q, mtval_q;
    logic [31:0] stvec_q, sepc_q, scause_q, sscratch_q, stval_q;
    logic [31:0] satp_q;
    logic [31:0] medeleg_q, mideleg_q;
    logic [63:0] mcycle_q, minstret_q;

    wire [31:0] mstatus_r = {12'd0, mxr_b, sum_b, 5'd0, mpp, 2'd0, spp,
                             mpie, 1'b0, spie, 1'b0, mie_g, 1'b0,
                             sie_g, 1'b0};
    wire [31:0] sstatus_r = {12'd0, mxr_b, sum_b, 9'd0, spp, 2'd0, spie,
                             3'd0, sie_g, 1'b0};
    wire [31:0] mie_r = {20'd0, meie, 1'b0, seie, 1'b0, mtie, 1'b0, stie,
                         1'b0, msie, 1'b0, ssie, 1'b0};
    // sie/sip are mideleg-masked views/aliases of mie/mip: a bit not
    // delegated to S must read 0 and be unwritable through them (F6).
    wire [31:0] sie_r = {22'd0, seie && mideleg_q[9], 3'd0,
                         stie && mideleg_q[5], 3'd0,
                         ssie && mideleg_q[1], 1'b0};
    wire [31:0] mip_r = {20'd0, meip, 1'b0, seip, 1'b0, mtip, 1'b0, stip,
                         1'b0, msip, 1'b0, ssip, 1'b0};
    wire [31:0] sip_r = {22'd0, seip && mideleg_q[9], 3'd0,
                         stip && mideleg_q[5], 3'd0,
                         ssip && mideleg_q[1], 1'b0};

    always_comb
        case (addr)
            12'h100: rval = sstatus_r;
            12'h104: rval = sie_r;
            12'h105: rval = stvec_q;
            12'h140: rval = sscratch_q;
            12'h141: rval = sepc_q;
            12'h142: rval = scause_q;
            12'h143: rval = stval_q;
            12'h144: rval = sip_r;
            12'h180: rval = satp_q;
            12'h300: rval = mstatus_r;
            12'h301: rval = 32'h4014_1101;       // misa: RV32IMA + S + U (A=bit0)
            12'h302: rval = medeleg_q;
            12'h303: rval = mideleg_q;
            12'h304: rval = mie_r;
            12'h305: rval = mtvec_q;
            12'h340: rval = mscratch_q;
            12'h341: rval = mepc_q;
            12'h342: rval = mcause_q;
            12'h343: rval = mtval_q;
            12'h344: rval = mip_r;
            12'hB00: rval = mcycle_q[31:0];
            12'hB02: rval = minstret_q[31:0];
            12'hB80: rval = mcycle_q[63:32];
            12'hB82: rval = minstret_q[63:32];
            default: rval = 32'd0;
        endcase

    wire [31:0] wnew = (op == 2'b01) ? wval
                     : (op == 2'b10) ? (rval | wval)
                     :                 (rval & ~wval);

    // ---- interrupt selection: pending & enabled, split by
    // delegation; the M level wins ----
    wire p_mei = meip && meie, p_msi = msip && msie, p_mti = mtip && mtie;
    wire p_sei = seip && seie, p_ssi = ssip && ssie, p_sti = stip && stie;
    wire d_sei = mideleg_q[9], d_ssi = mideleg_q[1], d_sti = mideleg_q[5];
    wire pend_m = p_mei || p_msi || p_mti
               || (p_sei && !d_sei) || (p_ssi && !d_ssi) || (p_sti && !d_sti);
    wire pend_s = (p_sei && d_sei) || (p_ssi && d_ssi) || (p_sti && d_sti);
    wire take_m = pend_m && (priv != 2'b11 || mie_g);
    wire take_s = !take_m && pend_s
               && (priv == 2'b00 || (priv == 2'b01 && sie_g));
    assign irq = take_m || take_s;

    logic [31:0] irq_cause;
    always_comb
        if (take_m)
            // only NON-delegated supervisor sources are eligible in M;
            // a delegated one pending alongside a machine source must not
            // be reported as the M cause (F5).
            irq_cause = p_mei              ? 32'h8000_000B
                      : p_msi              ? 32'h8000_0003
                      : p_mti              ? 32'h8000_0007
                      : (p_sei && !d_sei)  ? 32'h8000_0009
                      : (p_ssi && !d_ssi)  ? 32'h8000_0001
                      :                      32'h8000_0005;
        else
            irq_cause = (p_sei && d_sei) ? 32'h8000_0009
                      : (p_ssi && d_ssi) ? 32'h8000_0001
                      :                    32'h8000_0005;

    // ---- trap routing ----
    wire [31:0] ecall_cause = (priv == 2'b11) ? 32'd11
                            : (priv == 2'b01) ? 32'd9 : 32'd8;
    logic [31:0] exc_cause;
    always_comb
        case (trap_kind)
            4'd1:    exc_cause = 32'd12;      // instruction page fault
            4'd2:    exc_cause = 32'd13;      // load page fault
            4'd3:    exc_cause = 32'd15;      // store/AMO page fault
            4'd4:    exc_cause = 32'd2;       // illegal instruction
            4'd5:    exc_cause = 32'd0;       // fetch addr misaligned
            4'd6:    exc_cause = 32'd4;       // load addr misaligned
            4'd7:    exc_cause = 32'd6;       // store/AMO misaligned
            4'd8:    exc_cause = 32'd5;       // load access fault
            4'd9:    exc_cause = 32'd7;       // store/AMO access fault
            4'd10:   exc_cause = 32'd3;       // breakpoint (S/U EBREAK)
            default: exc_cause = ecall_cause;
        endcase
    wire [31:0] cause  = trap_irq ? irq_cause : exc_cause;
    wire trap_to_s = trap_irq ? take_s
                   : (medeleg_q[cause[4:0]] && priv != 2'b11);
    assign trap_vec = trap_to_s ? {stvec_q[31:2], 2'b00}
                                : {mtvec_q[31:2], 2'b00};
    assign mepc_rd = mepc_q;
    assign sepc_rd = sepc_q;
    assign satp_rd = satp_q;
    assign priv_rd = priv;
    assign sum_rd  = sum_b;
    assign mxr_rd  = mxr_b;

    always_comb
        case (addr)
            12'h100, 12'h104, 12'h105, 12'h140, 12'h141, 12'h142,
            12'h143, 12'h144, 12'h180,
            12'h300, 12'h301, 12'h302, 12'h303, 12'h304, 12'h305,
            12'h340, 12'h341, 12'h342, 12'h343, 12'h344,
            12'hB00, 12'hB02, 12'hB80, 12'hB82:
                     known = 1'b1;
            default: known = 1'b0;
        endcase

    // counters run in their own process: CSR writes override the tick
    always_ff @(posedge clk)
        if (rst) begin
            mcycle_q <= 64'd0; minstret_q <= 64'd0;
        end else begin
            mcycle_q <= mcycle_q + 64'd1;
            if (retire) minstret_q <= minstret_q + 64'd1;
            if (en && wen)
                case (addr)
                    12'hB00: mcycle_q   <= {mcycle_q[63:32], wnew};
                    12'hB02: minstret_q <= {minstret_q[63:32], wnew};
                    12'hB80: mcycle_q   <= {wnew, mcycle_q[31:0]};
                    12'hB82: minstret_q <= {wnew, minstret_q[31:0]};
                    default: ;
                endcase
        end

    always_ff @(posedge clk)
        if (rst) begin
            priv <= 2'b11;
            sie_g <= 1'b0; mie_g <= 1'b0; spie <= 1'b0; mpie <= 1'b0;
            spp <= 1'b0; mpp <= 2'b00; sum_b <= 1'b0; mxr_b <= 1'b0;
            ssie <= 1'b0; stie <= 1'b0; seie <= 1'b0;
            msie <= 1'b0; mtie <= 1'b0; meie <= 1'b0;
            ssip <= 1'b0; stip <= 1'b0; seip_sw <= 1'b0;
            mtvec_q <= 32'd0; mepc_q <= 32'd0; mcause_q <= 32'd0;
            mscratch_q <= 32'd0; mtval_q <= 32'd0;
            stvec_q <= 32'd0; sepc_q <= 32'd0; scause_q <= 32'd0;
            sscratch_q <= 32'd0; stval_q <= 32'd0;
            satp_q <= 32'd0; medeleg_q <= 32'd0; mideleg_q <= 32'd0;
        end else if (trap) begin
            if (trap_to_s) begin
                sepc_q   <= {trap_pc[31:1], 1'b0};
                scause_q <= cause;
                stval_q  <= trap_tval;
                spie     <= sie_g;
                sie_g    <= 1'b0;
                spp      <= priv[0];
                priv     <= 2'b01;
            end else begin
                mepc_q   <= {trap_pc[31:1], 1'b0};
                mcause_q <= cause;
                mtval_q  <= trap_tval;
                mpie     <= mie_g;
                mie_g    <= 1'b0;
                mpp      <= priv;
                priv     <= 2'b11;
            end
        end else if (mret) begin
            priv  <= mpp;
            mie_g <= mpie;
            mpie  <= 1'b1;
            mpp   <= 2'b00;
        end else if (sret) begin
            priv  <= spp ? 2'b01 : 2'b00;
            sie_g <= spie;
            spie  <= 1'b1;
            spp   <= 1'b0;
        end else if (en && wen)
            case (addr)
                12'h100: begin sie_g <= wnew[1]; spie <= wnew[5];
                               spp <= wnew[8]; sum_b <= wnew[18];
                               mxr_b <= wnew[19]; end
                12'h104: begin                    // sie: only delegated bits
                    if (mideleg_q[1]) ssie <= wnew[1];
                    if (mideleg_q[5]) stie <= wnew[5];
                    if (mideleg_q[9]) seie <= wnew[9];
                end
                12'h105: stvec_q    <= {wnew[31:2], 2'b00};  // Direct only (WARL)
                12'h140: sscratch_q <= wnew;
                12'h141: sepc_q     <= {wnew[31:1], 1'b0};
                12'h142: scause_q   <= wnew;
                12'h143: stval_q    <= wnew;
                12'h144: if (mideleg_q[1]) ssip <= wnew[1];  // only if delegated
                12'h180: satp_q     <= wnew;
                12'h300: begin sie_g <= wnew[1]; mie_g <= wnew[3];
                               spie <= wnew[5]; mpie <= wnew[7];
                               spp <= wnew[8];
                               // MPP is WARL: coerce the reserved 2'b10 to U
                               mpp <= (wnew[12:11] == 2'b01 ||
                                       wnew[12:11] == 2'b11)
                                    ? wnew[12:11] : 2'b00;   // (F8)
                               sum_b <= wnew[18]; mxr_b <= wnew[19]; end
                12'h302: medeleg_q  <= wnew;
                12'h303: mideleg_q  <= wnew;
                12'h304: begin ssie <= wnew[1]; msie <= wnew[3];
                               stie <= wnew[5]; mtie <= wnew[7];
                               seie <= wnew[9]; meie <= wnew[11]; end
                12'h305: mtvec_q    <= {wnew[31:2], 2'b00};  // Direct only (WARL, F7)
                12'h340: mscratch_q <= wnew;
                12'h341: mepc_q     <= {wnew[31:1], 1'b0};
                12'h342: mcause_q   <= wnew;
                12'h343: mtval_q    <= wnew;
                12'h344: begin ssip <= wnew[1]; stip <= wnew[5];
                               seip_sw <= wnew[9]; end  // M injects S irqs
                default: ;
            endcase
endmodule
