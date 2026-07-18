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
      .mtip(mtip), .msip(msip), .meip(meip),
      .halted(halted), .led(led), .uart_txd(uart_txd),
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
