`default_nettype none
`timescale 1ns / 1ps

// tb_sdram — sdram_ctrl against the strict behavioural part.
//
// The initialisation wait is shortened to 2 us (T_INIT_US=2). The real part
// needs 200 us and the controller computes that from CLK_HZ, but simulating
// 5000 idle clocks before every test is 5000 clocks of nothing. What the tests
// care about is that the SEQUENCE is right — precharge-all, two refreshes,
// load mode — and the model fails the run if any of it is skipped or reordered.

module tb_sdram ();

  initial begin
    $dumpfile("tb_sdram.fst");
    $dumpvars(0, tb_sdram);
    #1;
  end

  reg clk = 0;
  reg rst;

  reg         req, we, burst;
  reg  [22:0] addr;
  reg  [31:0] wdata;
  reg  [3:0]  be;
  wire        ack;
  wire [31:0] rdata, rdata2;

  wire        cke, csn, rasn, casn, wen, doe;
  wire [12:0] a;
  wire [1:0]  ba, dqm;
  wire [15:0] dout;
  wire [15:0] model_dout;
  wire        model_oe;

  // The data bus, resolved. Only one side may drive at a time; if both ever
  // do, the model's input goes x and its stored data goes x with it, which is
  // exactly the failure a shared bus should produce rather than hide.
  wire [15:0] sd_bus = doe ? dout : (model_oe ? model_dout : 16'hzzzz);

  sdram_ctrl #(
      .CLK_HZ(25_000_000),
      .T_INIT_US(2)
  ) dut (
      .clk(clk), .rst(rst),
      .req(req), .we(we), .burst(burst), .addr(addr),
      .wdata(wdata), .be(be), .ack(ack), .rdata(rdata), .rdata2(rdata2),
      .sdram_cke(cke), .sdram_csn(csn), .sdram_rasn(rasn), .sdram_casn(casn),
      .sdram_wen(wen), .sdram_a(a), .sdram_ba(ba), .sdram_dqm(dqm),
      .sdram_dout(dout), .sdram_doe(doe), .sdram_din(sd_bus)
  );

  sdram_model #(.CL(2)) part (
      .clk(clk), .cke(cke), .csn(csn), .rasn(rasn), .casn(casn), .wen(wen),
      .a(a), .ba(ba), .dqm(dqm),
      .din(sd_bus), .doe(doe),
      .dout(model_dout), .dout_oe(model_oe)
  );

endmodule

`default_nettype wire
