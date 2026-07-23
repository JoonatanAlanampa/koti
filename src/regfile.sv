// regfile.sv — Koti-1 register file, SYNC-READ (registered address,
// read-first): raddr is captured at the clock edge and rdata reflects
// the array state *before* that edge, one cycle later. This models
// the DFFRAM 32x32 2R1W RF macro's timing so the pipeline is built
// macro-ready — this module body is what gets swapped for the macro
// instance. core/regfile.sv remains the comb-read FPGA ancestor.
//
// TWO BODIES, ONE INTERFACE:
//   * default (behavioural) — the sync-read model. Used for ALL simulation
//     (run.py / cocotb), FPGA, and as the golden reference.
//   * `USE_MACRO`           — instantiates the DFFRAM DFFRF_2R1W hard macro and
//     converts its COMBINATIONAL read into this module's REGISTERED read by
//     registering the macro's DA/DB outputs. Selected only for hardening
//     (src/config.json sets VERILOG_DEFINES=USE_MACRO); the sim default stays
//     behavioural per the plan.
//
// WHY REGISTER THE OUTPUT (not the input address): the macro is comb-read, so
// DA = regs[RA] settles from the PRE-edge array with the PRE-edge address.
// Sampling that into a flop at the edge gives rdata1 = regs_before[raddr1_before]
// — exactly the behavioural block's `rdata1 <= regs[raddr1]` (read-first: the
// same-edge write is NOT seen; the pipeline's latched WB->ID bypass covers it).
// Registering the *input* address instead would make the read WRITE-first (it
// would see the same-edge write), diverging from the pipeline's read-first
// contract. Equivalence of the two bodies is proven by test/test_rf_macro.py,
// which runs the whole SoC suite with -DUSE_MACRO against the behavioural model
// of the macro (src/DFFRF_2R1W.v) and requires identical results.
module regfile (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  waddr,
    input  logic [31:0] wdata,
    input  logic [4:0]  raddr1,
    input  logic [4:0]  raddr2,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);
`ifdef USE_MACRO
    // ---- hard-macro body (hardening only) ----
    // Power (VPWR/VGND) is connected physically by the flow's global
    // connections + PDN, not through RTL (koti's top has no power ports).
    wire [31:0] da, db;
    DFFRF_2R1W u_rf (
        .CLK    (clk),
        .WE     (we),
        .RW     (waddr),
        .DW     (wdata),
        .RA     (raddr1),
        .RB     (raddr2),
        .DA     (da),
        .DB     (db)
    );
    // register the comb read -> reproduces the behavioural sync-read
    // (read-first, one-cycle) semantics bit-for-bit.
    always_ff @(posedge clk) begin
        rdata1 <= da;
        rdata2 <= db;
    end
`else
    // ---- behavioural body (default: sim / FPGA / golden reference) ----
    logic [31:0] regs [32];

    // read-first: same-edge writes are NOT visible in this read;
    // the pipeline's latched WB->ID bypass covers that window
    always_ff @(posedge clk) begin
        rdata1 <= (raddr1 == 5'd0) ? 32'd0 : regs[raddr1];
        rdata2 <= (raddr2 == 5'd0) ? 32'd0 : regs[raddr2];
        if (we)
            regs[waddr] <= wdata;
    end
`endif
endmodule
