`default_nettype none
`timescale 1ns / 1ps

/* tb_cpu.v — instruction-level harness around the ASIC core
   (src/koti_core.sv) with the XIP memory model standing in for
   qspi_ctrl + Pmod. cocotb pokes programs into mem.flash, runs to
   `halted` (EBREAK), and reads results back via c0.rf.regs. */
module tb_cpu ();

  initial begin
    $dumpfile("tb_cpu.fst");
    $dumpvars(0, tb_cpu);
    #1;
  end

  reg clk;
  reg rst;
  reg mtip, msip, meip;

  // The serial receive line, drivable so a test can actually send koti a
  // character. Initialised HIGH because that is what an idle serial line is,
  // and what uart_rx's synchroniser resets to; starting low would look like a
  // start bit at t=0. Tests that do not touch it simply leave it idle.
  reg uart_rxd_r = 1'b1;

  wire        halted;
  wire [7:0]  led;
  wire        uart_txd;
  wire [1:0]  qspi_cfg;

  wire        if_req, if_ack;
  wire [22:0] if_addr;
  wire [31:0] if_rdata, if_rdata2;
  wire        d_req, d_we, d_ack;
  wire [22:0] d_addr;
  wire [31:0] d_wdata, d_rdata;
  wire [3:0]  d_be;

  koti_core #(.UART_DIV(4)) c0 (
      .clk(clk), .rst(rst),
      // seip tied low: this bench drives the core directly, with no PLIC in
      // sight. It must be TIED rather than left unconnected — an open input
      // reads as x, and x on the S-external line propagates straight into the
      // interrupt-pending comparison, so every test here would start taking
      // decisions on an unknown.
      .mtip(mtip), .msip(msip), .meip(meip), .seip(1'b0),
      .halted(halted), .led(led), .uart_txd(uart_txd),
      // Driven from uart_rxd_r above rather than tied, so a test can send a
      // byte. It must not be left OPEN, for the same reason seip is tied: an
      // open input reads as x, and x through the receiver's synchroniser makes
      // rx_fall unknown for the whole run.
      .uart_rxd(uart_rxd_r),
      .gpio_in(8'd0), .qspi_cfg(qspi_cfg),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(if_rdata), .if_rdata2(if_rdata2),
      .d_req(d_req), .d_we(d_we), .d_addr(d_addr),
      .d_wdata(d_wdata), .d_be(d_be), .d_ack(d_ack), .d_rdata(d_rdata)
  );

  xipmem #(.LAT(4)) mem (
      .clk(clk), .rst(rst),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(if_rdata), .if_rdata2(if_rdata2),
      .d_req(d_req), .d_we(d_we), .d_addr(d_addr),
      .d_wdata(d_wdata), .d_be(d_be), .d_ack(d_ack), .d_rdata(d_rdata)
  );

endmodule
