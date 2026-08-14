`default_nettype none
`timescale 1ns / 1ps

/* tb_boot.v — boot software on koti and print what it says.
 *
 * Self-driving on purpose: no cocotb, so it runs under BOTH iverilog (for a
 * short look) and Verilator (for a whole kernel boot, which is tens of
 * millions of clocks and out of iverilog's reach). That is the same reason
 * tb_icache.v and tb_plic.v are plain Verilog, one scale up.
 *
 * It builds with -DKOTI_SIMMEM, so the machine is the ULX3S one —
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
 * is not a boot. The run ends when the core halts, but a halt is only a PASS
 * if the machine also SAID it got there: see the success marker below. koti
 * halts on EBREAK and the firmware reaches EBREAK from more than one place,
 * so "halted" and "succeeded" are not the same claim.
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
  // ui[1:0] were the PS/2 clock and data until 2026-08-08 and had to idle
  // HIGH so ps2_rx did not see a start bit at time zero. PS/2 is gone; these
  // are plain GPIO inputs now and the value no longer matters. Left as-is
  // because GPIO_IN is readable from software and changing what a running
  // kernel reads is not what removing a keyboard should do.
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
      // Idle high: an open input reads as x, and x through the receiver's
      // synchroniser makes its edge detection unknown for the whole run.
      .esp_txd(1'b1),
      .ui_in(ui_in), .uo_out(uo_out),
      .uio_in(uio_in), .uio_out(uio_out), .uio_oe(uio_oe),
      .sdram_cke(sdram_cke), .sdram_csn(sdram_csn),
      .sdram_rasn(sdram_rasn), .sdram_casn(sdram_casn), .sdram_wen(sdram_wen),
      .sdram_a(sdram_a), .sdram_ba(sdram_ba), .sdram_dqm(sdram_dqm),
      .sdram_dout(sdram_dout), .sdram_doe(sdram_doe), .sdram_din(16'd0),
      // No keyboard on this bench, and TIED rather than left dangling. An
      // unconnected input is x, and these feed usb_kbd's report state machine —
      // x there would propagate into its FIFO pointers, which is precisely the
      // class of defect that makes a bench lie rather than fail.
      // No RTC on this bench. Tied HIGH, which is what a real idle I2C bus
      // reads: both lines are pulled up and nothing is holding them down. An
      // open input would be x, and x in i2c_bit's synchronisers propagates
      // into the register a booting kernel reads.
      .i2c_scl_in(1'b1), .i2c_sda_in(1'b1), .i2c_sqw_in(1'b1),
      .usb_report_tog(1'b0), .usb_typ(2'd0), .usb_conerr(1'b0),
      .usb_key_modifiers(8'd0),
      .usb_key1(8'd0), .usb_key2(8'd0), .usb_key3(8'd0), .usb_key4(8'd0),
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

  // ---- the success marker -------------------------------------------------
  // A halt is NOT a success on its own, and treating it as one was a real
  // defect in this bench rather than a nicety. koti halts on EBREAK, and EBREAK
  // is reached from places that mean opposite things: SBI SRST, which is what a
  // finished boot asks for (sw/sbi/sbi.c), and the firmware's own panic path,
  // which prints '!' and then halts. Both used to print "PASS (machine halted)".
  //
  // Until 2026-08-05 there was a third and much worse one. RISC-V Linux
  // compiles every WARN_ON() and BUG_ON() into an EBREAK plus a __bug_table
  // entry — 2812 of them in the 6.12 image koti boots — and koti's core halted
  // on all of them instead of trapping. So a kernel that tripped a warning it
  // was designed to survive stopped dead, and this bench called it a PASS.
  // src/koti_core.sv now traps an S/U EBREAK as cause 3 and only M-mode halts,
  // which removes that case at the source; this check is what would have caught
  // it, and is what still catches the other two.
  //
  // The marker is the line sw/linux/init.S writes immediately before asking for
  // power-off — the one point in this boot where userspace has demonstrably
  // run. Matching the UART byte stream rather than snooping state keeps the
  // check honest for the same reason the receiver above reads the line.
  localparam integer MARKLEN = 24;
  localparam [8*MARKLEN-1:0] MARKER = "koti: userspace is alive";
  reg [8*MARKLEN-1:0] markbuf = {(8*MARKLEN){1'b0}};
  reg                 saw_marker = 1'b0;

  // Heartbeat deferral: at_line_start is true when the last character emitted
  // was a newline (or nothing has been emitted yet), hb_pending means a
  // heartbeat came due mid-message and is waiting for the line to end.
  reg         at_line_start = 1'b1;
  reg         hb_pending    = 1'b0;
  integer     hb_mclk       = 0;

  always @(posedge clk) begin
    uart_prev <= uart_line;
    // Held out of reset, and that is for VERILATOR rather than for iverilog.
    // The === guards below are enough under a 4-state simulator: uart_txd is x
    // until the transmitter's reset branch drives it, and x === 1'b0 is false.
    // The other engine is 2-STATE — every variable starts at 0 — so at the
    // first posedge the line reads 0 against uart_prev's initial 1, which is
    // the falling edge this receiver is looking for. It would then clock in
    // eight bits of the idle line and print one character out of nothing,
    // before the machine has executed an instruction. That costs the
    // "nothing was printed" verdict its meaning (nchars would already be 1)
    // for the sake of a byte no hardware sent.
    if (!rst_n) begin
      uart_prev <= 1'b1;                           // idle, in both engines
      urx       <= 1'b0;
    end else if (!urx) begin
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
      markbuf = {markbuf[8*(MARKLEN-1)-1:0], ush};
      if (markbuf == MARKER) saw_marker = 1'b1;
      // Track whether the machine is mid-line, so the heartbeat below can stay
      // out of the middle of a kernel message. See hb_pending.
      at_line_start = (ush == 8'h0A);
      if (hb_pending && at_line_start) begin
        $display("[tb_boot: %0d Mclk, %0d chars]", hb_mclk, nchars);
        hb_pending = 1'b0;
      end
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
    // A plusarg so the line-splitting behaviour above can actually be TESTED:
    // at the 10M default a boot emits one or two heartbeats, which is far too
    // coarse to prove they never land mid-message. With +heartbeat=500 a short
    // program produces hundreds and the property is checkable in seconds.
    if (!$value$plusargs("heartbeat=%d", heartbeat)) heartbeat = 10000000;
    $display("tb_boot: maxclk=%0d quiet=%0d uart_div=%0d",
             maxclk, quiet, UART_DIV);
    repeat (10) @(posedge clk);
    rst_n <= 1'b1;
  end

  // [8*64:1], not [255:0]. At 256 bits this held 32 characters and Verilog
  // truncates a longer string to the LOW bits, so the two messages that matter
  // most came out beheaded: "core HALTED (ebreak: SBI SRST, or a firmware
  // panic)" printed as ": SBI SRST, or a firmware panic)" and "no output for
  // the quiet window; assuming stuck" as "the quiet window; assuming stuck".
  // Both are what a person reads at the exact moment a boot has gone wrong.
  task finish_with(input [8*64:1] why);
    begin
      $display("\n--- tb_boot: %0s", why);
      $display("--- %0d clocks, %0d characters", clkcnt, nchars);
      if (nchars == 0) begin
        $display("--- tb_boot: FAIL (nothing was printed)");
        $fatal(1);
      end else if (uut.halted && !saw_marker) begin
        $display("--- tb_boot: FAIL (halted without saying \"%0s\")", MARKER);
        $display("--- A halt nobody asked for. SBI SRST only happens after");
        $display("--- userspace runs; the firmware's panic path prints '!'");
        $display("--- first; and an S/U EBREAK is supposed to trap, not halt.");
        $fatal(1);
      end else if (saw_marker) begin
        $display("--- tb_boot: PASS (%0s)",
                 uut.halted ? "userspace ran, then halted"
                            : "userspace ran");
      end else begin
        $display("--- tb_boot: INCOMPLETE");
      end
      $finish;
    end
  endtask

  always @(posedge clk) begin
    clkcnt <= clkcnt + 64'd1;
    if (rst_n) begin
      if (uut.halted)
        finish_with("core HALTED (ebreak: SBI SRST, or a firmware panic)");
      // Reaching userspace ENDS the run successfully, and a halt is no longer
      // required for that. The real rootfs runs busybox init, whose inittab
      // puts a getty on hvc0 and respawns it forever — so a healthy machine
      // with a login prompt on the console never halts, and never should. The
      // earlier model ("a successful boot ENDS") only held while /init was a
      // stand-in that asked for power-off. Waiting for a halt that correct
      // behaviour will not produce would have burned the clock limit on every
      // run and reported INCOMPLETE for a machine that had done everything
      // asked of it.
      else if (saw_marker)
        finish_with("userspace reached: the marker was printed");
      else if (clkcnt >= maxclk)
        finish_with("clock limit reached");
      else if (nchars > 0 && (clkcnt - last_char_clk) > quiet)
        finish_with("no output for the quiet window; assuming stuck");
      // The heartbeat waits for a line boundary, and that is not cosmetic.
      // $write emits characters with no newline while $display appends one, so
      // a heartbeat landing mid-message SPLITS it:
      //
      //     [    0.000
      //     [tb_boot: 10 Mclk, 1903 chars]
      //     151] sched_clock: 64 bits at 25MHz
      //
      // Every grep in the `boot` job then fails on a boot that was perfectly
      // healthy. That is not hypothetical — the line above is copied out of run
      // 31042251426. The kernel spends only about 1% of its clocks actually
      // transmitting, so it bites a couple of percent of runs: rare enough to
      // look like flakiness, frequent enough to teach people to re-run red
      // jobs, which is the worst thing a regression gate can do.
      else if (clkcnt % heartbeat == 0 && clkcnt != 0) begin
        hb_mclk = clkcnt / 1000000;
        if (at_line_start)
          $display("[tb_boot: %0d Mclk, %0d chars]", hb_mclk, nchars);
        else
          hb_pending = 1'b1;      // emitted by the receiver at the next '\n'
      end

      // +trace=<n>: where the fetch port is pointing, every n clocks. This is
      // the only question worth asking of a boot that prints nothing — a
      // physical address near the load address means the kernel is in head.S,
      // one near 0xC000_0000 means it has turned the MMU on and relocated,
      // and the same address twice running means it is stuck.
      // +tfrom=<n> +tlen=<n>: every clock in a window, which is the only
      // resolution at which a stuck instruction explains itself.
      // ⚠️ ONE string literal, not a concatenation of two. `$display({"a","b"},
      // args)` is legal Verilog and iverilog formats it, but Verilator does NOT
      // treat a concatenation as a format string — it prints the concatenated
      // BITS as one enormous decimal number and then the arguments positionally,
      // so the line becomes 190 digits of nothing and ktrace.py matches none of
      // it. Measured on the local Verilator build: the trace was silently
      // useless while the boot itself was correct, which is the worst way for a
      // diagnostic to fail. Keep both trace formats on a single literal.
      if (tlen != 0 && clkcnt >= tfrom && clkcnt < tfrom + tlen)
        $display("[%0d] pc_d %h pc_e %h | d %h rq%b we%b ak%b rd %h | rmw%b amo_wr%b astall%b mstall%b pstall%b trap%b valid_m%b",
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
        // One literal — see the note on the per-clock trace above.
        $display("[%0d] fetch %h if(rq%b ak%b) d %h (rq%b we%b ak%b) m %h (rq%b ak%b) satp %h",
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
