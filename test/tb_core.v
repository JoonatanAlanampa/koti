`default_nettype none
`timescale 1ns / 1ps

/* tb_core.v — core-level unit testbench (RTL only, not part of the TT
   gate-level flow; tb.v stays the TT harness). Currently hosts the
   muldiv unit; core CSR/MMU blocks join here as they appear. */
module tb_core ();

  initial begin
    $dumpfile("tb_core.fst");
    $dumpvars(0, tb_core);
    #1;
  end

  reg         clk;
  reg         rst;
  reg         start, ack;
  reg  [2:0]  funct3;
  reg  [31:0] a, b;
  wire [31:0] result;
  wire        busy, done;

  muldiv md (
      .clk(clk), .rst(rst),
      .start(start), .ack(ack),
      .funct3(funct3), .a(a), .b(b),
      .result(result), .busy(busy), .done(done)
  );

endmodule
