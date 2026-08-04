`default_nettype none
`timescale 1ns / 1ps

/* tb_boot.v — boot software on koti and print what it says.
 *
 * Self-driving on purpose: no cocotb, so it runs under BOTH iverilog (for a
 * short look) and Verilator (for a whole kernel boot, which is tens of
 * millions of clocks and out of iverilog's reach). That is the same reason
 * tb_icache.v and tb_plic.v are plain Verilog, one scale up.
 *
 * It builds with -DKOTI_FPGA -DKOTI_SIMMEM, so the machine is the ULX3S one —
 * I-cache, 16 MB window, the real core, CLINT, PLIC and UART — with
 * test/sim_mem.sv standing in for qspi_ctrl and sdram_ctrl. What that costs is
 * written down in sim_mem.sv; the short version is that this bench proves
 * nothing about the memory controllers and everything about the software.
 *
 * Plusargs:
 *   +flash=<hex>  +ram=<hex>  +ramoff=<words>   see sim_mem.sv
 *   +maxclk=<n>   give up after n clocks (default 200M)
 *   +quiet=<n>    give up after n clocks with no character out (default 20M)
 *
 * Exit: 0 chars out is a failure however it ends — a boot that says nothing
 * is not a boot. Otherwise the run ends when the core halts (which is what
 * SBI SRST does, which is what init asks for), and that is the success case.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 */
module tb_boot ();

  // Must match project.sv's `KOTI_SIMMEM` UDIV. If they disagree the receiver
  // below samples at the wrong rate and the log is mojibake rather than empty,
  // which reads like a broken machine instead of a broken bench.
  localparam integer UART_DIV = 8;

  reg         clk = 1'b0;
  reg         rst_n = 1'b0;
  reg         ena = 1'b1;
  // ui[1:0] are the PS/2 clock and data, which idle HIGH. Driving them low
  // would look to ps2_rx like a start bit at time zero.
  reg  [7:0]  ui_in = 8'b0000_0011;
  reg  [7:0]  uio_in = 8'd0;
  wire [7:0]  uo_out, uio_out, uio_oe;

  // The SDRAM pins are in the port list whenever KOTI_FPGA is defined, even
  // in this build where nothing drives them from a real controller.
  wire        sdram_cke, sdram_csn, sdram_rasn, sdram_casn, sdram_wen;
  wire [12:0] sdram_a;
  wire [1:0]  sdram_ba, sdram_dqm;
  wire [15:0] sdram_dout;
  wire        sdram_doe;

  tt_um_koti uut (
      .ui_in(ui_in), .uo_out(uo_out),
      .uio_in(uio_in), .uio_out(uio_out), .uio_oe(uio_oe),
      .sdram_cke(sdram_cke), .sdram_csn(sdram_csn),
      .sdram_rasn(sdram_rasn), .sdram_casn(sdram_casn), .sdram_wen(sdram_wen),
      .sdram_a(sdram_a), .sdram_ba(sdram_ba), .sdram_dqm(sdram_dqm),
      .sdram_dout(sdram_dout), .sdram_doe(sdram_doe), .sdram_din(16'd0),
      .ena(ena), .clk(clk), .rst_n(rst_n)
  );

  always #20 clk = ~clk;              // 40 ns period = 25 MHz

  // ---- UART receiver ------------------------------------------------------
  // Reads the serial line rather than snooping the MMIO write, because the
  // line is what the machine actually emits: a receiver cannot double-count a
  // write strobe that stays high through a pipeline stall, and it fails
  // visibly if the divisor is ever wrong.
  wire       uart_line = uut.uart_txd;
  reg        uart_prev = 1'b1;
  reg        urx = 1'b0;
  reg  [3:0] ubit = 4'd0;
  reg [15:0] ucnt = 16'd0;
  reg  [7:0] ush = 8'd0;

  integer      nchars = 0;
  reg   [63:0] clkcnt = 64'd0;
  reg   [63:0] last_char_clk = 64'd0;

  always @(posedge clk) begin
    uart_prev <= uart_line;
    if (!urx) begin
      // Falling edge = start bit. The === guards keep an x line during reset
      // from being read as a start.
      if (uart_prev === 1'b1 && uart_line === 1'b0) begin
        urx  <= 1'b1;
        ubit <= 4'd0;
        ucnt <= UART_DIV + (UART_DIV / 2) - 1;   // sample mid-bit-0
      end
    end else if (ucnt != 0) begin
      ucnt <= ucnt - 16'd1;
    end else if (ubit < 4'd8) begin
      ush  <= {uart_line, ush[7:1]};             // 8N1, LSB first
      ubit <= ubit + 4'd1;
      ucnt <= UART_DIV - 1;
    end else begin
      urx <= 1'b0;                               // mid stop bit; done
      $write("%c", ush);
      $fflush;
      nchars = nchars + 1;
      last_char_clk = clkcnt;
    end
  end

  // ---- run control --------------------------------------------------------
  integer maxclk, quiet, heartbeat, trace, tfrom, tlen;

  initial begin
    if (!$value$plusargs("maxclk=%d", maxclk)) maxclk = 200000000;
    if (!$value$plusargs("quiet=%d", quiet))   quiet  = 20000000;
    if (!$value$plusargs("trace=%d", trace))   trace  = 0;
    if (!$value$plusargs("tfrom=%d", tfrom))   tfrom  = 0;
    if (!$value$plusargs("tlen=%d", tlen))     tlen   = 0;
    heartbeat = 10000000;
    $display("tb_boot: maxclk=%0d quiet=%0d uart_div=%0d",
             maxclk, quiet, UART_DIV);
    repeat (10) @(posedge clk);
    rst_n <= 1'b1;
  end

  task finish_with(input [255:0] why);
    begin
      $display("\n--- tb_boot: %0s", why);
      $display("--- %0d clocks, %0d characters", clkcnt, nchars);
      if (nchars == 0) begin
        $display("--- tb_boot: FAIL (nothing was printed)");
        $fatal(1);
      end else begin
        $display("--- tb_boot: %0s",
                 uut.halted ? "PASS (machine halted)" : "INCOMPLETE");
      end
      $finish;
    end
  endtask

  always @(posedge clk) begin
    clkcnt <= clkcnt + 64'd1;
    if (rst_n) begin
      if (uut.halted)
        finish_with("core HALTED (ebreak: SBI SRST, or a firmware panic)");
      else if (clkcnt >= maxclk)
        finish_with("clock limit reached");
      else if (nchars > 0 && (clkcnt - last_char_clk) > quiet)
        finish_with("no output for the quiet window; assuming stuck");
      else if (clkcnt % heartbeat == 0 && clkcnt != 0)
        $display("\n[tb_boot: %0d Mclk, %0d chars]", clkcnt / 1000000, nchars);

      // +trace=<n>: where the fetch port is pointing, every n clocks. This is
      // the only question worth asking of a boot that prints nothing — a
      // physical address near the load address means the kernel is in head.S,
      // one near 0xC000_0000 means it has turned the MMU on and relocated,
      // and the same address twice running means it is stuck.
      // +tfrom=<n> +tlen=<n>: every clock in a window, which is the only
      // resolution at which a stuck instruction explains itself.
      if (tlen != 0 && clkcnt >= tfrom && clkcnt < tfrom + tlen)
        $display({"[%0d] pc_d %h pc_e %h | d %h rq%b we%b ak%b rd %h | rmw%b",
                  " amo_wr%b astall%b mstall%b pstall%b trap%b valid_m%b"},
                 clkcnt, uut.core.pc_d, uut.core.pc_e,
                 {uut.d_addr, 2'b00}, uut.d_req, uut.d_we, uut.d_ack,
                 // The DATA that came back, not just that something did. A
                 // compare that always fails is indistinguishable from a
                 // compare that is never reached unless you can see the value
                 // it compared — which is the whole question when a cmpxchg
                 // loop will not converge.
                 uut.d_rdata,
                 uut.core.rmw_m, uut.core.amo_wr, uut.core.astall,
                 uut.core.mstall, uut.core.pstall, uut.core.trap_take,
                 uut.core.valid_m);

      if (trace != 0 && clkcnt % trace == 0) begin
        $display({"[%0d] fetch %h if(rq%b ak%b) d %h (rq%b we%b ak%b) ",
                  "m %h (rq%b ak%b) satp %h"},
                 clkcnt, {uut.if_addr, 2'b00}, uut.if_req, uut.if_ack,
                 {uut.d_addr, 2'b00}, uut.d_req, uut.d_we, uut.d_ack,
                 {uut.m_addr, 2'b00}, uut.m_req, uut.m_ack,
                 uut.core.csr0.satp_q);
        // Flushed, because the only reason to ask for a coarse trace is to
        // watch a run that is not printing anything else — and stdout to a
        // file or a pipe is block-buffered, so without this the trace of a
        // silent kernel appears in 4 KB lumps, minutes behind the simulation.
        // The UART receiver above flushes on every character and therefore
        // never had the problem.
        $fflush;
      end
    end
  end

endmodule

`default_nettype wire
