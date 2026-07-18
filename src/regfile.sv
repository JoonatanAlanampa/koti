// regfile.sv — RV32I register file: 32 x 32-bit, x0 hardwired to zero.
// Same design as the tiny CPU's, scaled up: x0 is a read mux, not storage.
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

    always_ff @(posedge clk)
        if (we)
            regs[waddr] <= wdata;

    assign rdata1 = (raddr1 == 5'd0) ? 32'd0 : regs[raddr1];
    assign rdata2 = (raddr2 == 5'd0) ? 32'd0 : regs[raddr2];
endmodule
