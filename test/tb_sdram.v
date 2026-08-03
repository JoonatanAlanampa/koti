`default_nettype none
`timescale 1ns / 1ps

// tb_sdram — sdram_ctrl against the strict behavioural part.
//
// The initialisation wait is shortened to 2 us (T_INIT_US=2). The real part
// needs 200 us and the controller computes that from CLK_HZ, but simulating
// 5000 idle clocks before every test is 5000 clocks of nothing. What the tests
// care about is that the SEQUENCE is right — precharge-all, two refreshes,
// load mode — and the model fails the run if any of it is skipped or reordered.
//
// THE PART IS CLOCKED THE WAY THE BOARD CLOCKS IT, and that is not a detail.
// `ulx3s_top.sv` drives sdram_clk = ~clk_25mhz, so the part runs half a system
// clock ahead of the controller. This bench used to feed the model plain `clk`
// instead, which is a different machine: the read-data window moves by a whole
// system clock between the two, and the suite went 9/9 green against an
// arrangement that exists nowhere. The SoC then failed with all nine of these
// tests passing, because writes are insensitive to the phase and only reads
// are — 308 writes landed correctly and the machine died on its first read.
//
// So: default to the board's clocking, and let SDRAM_SAMECLK select the other
// arrangement so RD_ADV is provably the knob it claims to be rather than a
// number that happened to work once.
//   python run_sdram.py                 -> part on ~clk, RD_ADV=1 (the board)
//   iverilog -DSDRAM_SAMECLK ...        -> part on  clk, RD_ADV=0

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

`ifdef SDRAM_SAMECLK
  localparam integer RD_ADV = 0;
  wire part_clk = clk;
`else
  localparam integer RD_ADV = 1;
  wire part_clk = ~clk;
`endif

  sdram_ctrl #(
      .CLK_HZ(25_000_000),
      .T_INIT_US(2),
      .RD_ADV(RD_ADV)
  ) dut (
      .clk(clk), .rst(rst),
      .req(req), .we(we), .burst(burst), .addr(addr),
      .wdata(wdata), .be(be), .ack(ack), .rdata(rdata), .rdata2(rdata2),
      .sdram_cke(cke), .sdram_csn(csn), .sdram_rasn(rasn), .sdram_casn(casn),
      .sdram_wen(wen), .sdram_a(a), .sdram_ba(ba), .sdram_dqm(dqm),
      .sdram_dout(dout), .sdram_doe(doe), .sdram_din(sd_bus)
  );

  sdram_model #(.CL(2)) part (
      .clk(part_clk), .cke(cke), .csn(csn), .rasn(rasn), .casn(casn), .wen(wen),
      .a(a), .ba(ba), .dqm(dqm),
      .din(sd_bus), .doe(doe),
      .dout(model_dout), .dout_oe(model_oe)
  );

endmodule

`default_nettype wire
