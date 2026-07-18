// regfile.sv — Koti-1 register file, SYNC-READ (registered address,
// read-first): raddr is captured at the clock edge and rdata reflects
// the array state *before* that edge, one cycle later. This models
// the tnt 32x32 RF macro's assumed timing so the pipeline is built
// macro-ready — this module body is what gets swapped for the macro
// instance. (If the macro turns out combinational, an address
// register at its input reproduces exactly these semantics.)
// core/regfile.sv remains the comb-read FPGA ancestor.
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
    logic [31:0] regs [32];

    // read-first: same-edge writes are NOT visible in this read;
    // the pipeline's latched WB->ID bypass covers that window
    always_ff @(posedge clk) begin
        rdata1 <= (raddr1 == 5'd0) ? 32'd0 : regs[raddr1];
        rdata2 <= (raddr2 == 5'd0) ? 32'd0 : regs[raddr2];
        if (we)
            regs[waddr] <= wdata;
    end
endmodule
