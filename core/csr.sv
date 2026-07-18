// csr.sv — machine-mode CSR file + trap/interrupt bookkeeping (M-only;
// S/U modes arrive with the MMU milestone, so MPP reads fixed 11).
// The pipeline executes CSR instructions in EX: while `en`, the
// read-modify-write of `addr` happens with `rval` returning the old
// value; the write is idempotent so an mstall may hold `en` across
// cycles safely. `trap`/`mret` are commands from EX and win over `en`.
// Unknown CSRs read 0 and ignore writes — a compliance gap (no illegal
// -instruction trap yet) logged in PLAN.md, to be closed with the
// privilege test suite.
module csr (
    input  logic        clk, rst,
    // EX-stage CSR instruction
    input  logic        en,
    input  logic [1:0]  op,          // funct3[1:0]: 01 RW, 10 RS, 11 RC
    input  logic        wen,         // false for RS/RC with rs1/uimm = 0
    input  logic [11:0] addr,
    input  logic [31:0] wval,
    output logic [31:0] rval,
    // trap entry / return
    input  logic        trap,
    input  logic [31:0] trap_pc,
    input  logic [31:0] trap_cause,
    input  logic        mret,
    // interrupt lines (level)
    input  logic        mtip, msip, meip,
    // to the pipeline
    output logic        irq,         // enabled + pending irq exists
    output logic [31:0] irq_cause,
    output logic [31:0] tvec, epc
);
    logic        mie_g, mpie;                    // mstatus.MIE / .MPIE
    logic        mtie, msie, meie;
    logic [31:0] mtvec_q, mepc_q, mcause_q, mscratch_q, mtval_q;

    // mstatus: MPP=11 (bits 12:11), MPIE (7), MIE (3)
    wire [31:0] mstatus_r = {19'd0, 2'b11, 3'd0, mpie, 3'd0, mie_g, 3'd0};
    wire [31:0] mie_r     = {20'd0, meie, 3'd0, mtie, 3'd0, msie, 3'd0};
    wire [31:0] mip_r     = {20'd0, meip, 3'd0, mtip, 3'd0, msip, 3'd0};

    always_comb
        case (addr)
            12'h300: rval = mstatus_r;
            12'h301: rval = 32'h4000_1100;       // misa: RV32IM
            12'h304: rval = mie_r;
            12'h305: rval = mtvec_q;
            12'h340: rval = mscratch_q;
            12'h341: rval = mepc_q;
            12'h342: rval = mcause_q;
            12'h343: rval = mtval_q;
            12'h344: rval = mip_r;
            default: rval = 32'd0;               // incl. mvendorid etc.
        endcase

    wire [31:0] wnew = (op == 2'b01) ? wval
                     : (op == 2'b10) ? (rval | wval)
                     :                 (rval & ~wval);

    // spec priority: external, software, timer
    assign irq_cause = (meip && meie) ? 32'h8000_000B
                     : (msip && msie) ? 32'h8000_0003
                     :                  32'h8000_0007;
    assign irq  = mie_g && ((meip && meie) || (msip && msie)
                            || (mtip && mtie));
    assign tvec = {mtvec_q[31:2], 2'b00};        // direct mode only
    assign epc  = mepc_q;

    always_ff @(posedge clk)
        if (rst) begin
            mie_g <= 1'b0; mpie <= 1'b0;
            mtie  <= 1'b0; msie <= 1'b0; meie <= 1'b0;
            mtvec_q <= 32'd0; mepc_q <= 32'd0; mcause_q <= 32'd0;
            mscratch_q <= 32'd0; mtval_q <= 32'd0;
        end else if (trap) begin
            mepc_q   <= {trap_pc[31:1], 1'b0};
            mcause_q <= trap_cause;
            mtval_q  <= 32'd0;
            mpie     <= mie_g;
            mie_g    <= 1'b0;
        end else if (mret) begin
            mie_g <= mpie;
            mpie  <= 1'b1;
        end else if (en && wen)
            case (addr)
                12'h300: begin mie_g <= wnew[3]; mpie <= wnew[7]; end
                12'h304: begin msie <= wnew[3]; mtie <= wnew[7];
                               meie <= wnew[11]; end
                12'h305: mtvec_q    <= wnew;
                12'h340: mscratch_q <= wnew;
                12'h341: mepc_q     <= {wnew[31:1], 1'b0};
                12'h342: mcause_q   <= wnew;
                12'h343: mtval_q    <= wnew;
                default: ;
            endcase
endmodule
