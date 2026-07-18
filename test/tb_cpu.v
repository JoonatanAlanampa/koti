`default_nettype none
`timescale 1ns / 1ps

/* tb_cpu.v — instruction-level harness around the RV32IM pipeline
   (cpu_pipe.sv + sim_models.sv). cocotb pokes programs into
   c0.im.mem, runs to `halted`, and reads results back through
   c0.rf.regs / c0.dm.mem. SDRAM is tied off: test programs stay in
   the BRAM/MMIO address space. */
module tb_cpu ();

  initial begin
    $dumpfile("tb_cpu.fst");
    $dumpvars(0, tb_cpu);
    #1;
  end

  reg clk;
  reg rst;

  wire        halted;
  wire [7:0]  led;
  wire        uart_txd;
  wire        vid_we;
  wire [17:0] vid_addr;
  wire [31:0] vid_wdata;
  wire [3:0]  audio;
  wire        sd_req, sd_we;
  wire [22:0] sd_addr;
  wire [31:0] sd_wdata;
  wire [3:0]  sd_be;

  cpu #(.HEXFILE(""), .UART_DIV(4)) c0 (
      .clk(clk), .rst(rst),
      .halted(halted), .led(led), .uart_txd(uart_txd),
      .vid_we(vid_we), .vid_addr(vid_addr), .vid_wdata(vid_wdata),
      .vid_status(32'd0), .pad(16'd0), .audio(audio),
      .sd_req(sd_req), .sd_we(sd_we), .sd_addr(sd_addr),
      .sd_wdata(sd_wdata), .sd_be(sd_be),
      .sd_ack(1'b0), .sd_rdata(32'd0)
  );

endmodule
