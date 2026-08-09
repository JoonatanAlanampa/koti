// tb_usb_kbd.v — the gate for src/usb_kbd.sv, and especially for its SECOND
// read port.
//
// WHY THIS EXISTS. `usb_kbd.sv` had no bench of its own until 2026-08-08. It
// was compiled only into whole-SoC builds (test/run_fpga.py, test/tb_boot.v),
// which means the two-port FIFO added for the Linux input driver was covered by
// nothing that could fail on it: a boot test notices a keyboard that is
// completely dead, and notices nothing at all about a second reader that
// silently steals the first one's keystrokes.
//
// ⛔ THE PROPERTY THIS FILE EXISTS FOR IS TEST 5: a stalled port 2 CANNOT
// starve port 1. Port 1 is what feeds `hvc0`, which is what makes the login
// prompt typeable. If a Linux driver that stopped draining — nothing has the
// evdev node open, say — could fill the FIFO and block the writer, the symptom
// would be a console that stops accepting keys because of a feature that was
// supposed to be purely additive. That guarantee was written down in a comment
// and checked by nothing.
//
// The other half is test 2: both ports must see EVERY keystroke. A single-
// consumer queue read by two consumers splits the stream between them, which on
// real hardware looks like a keyboard that drops every other character — and
// looks fine in any test that only reads one port.
//
// Plain Verilog, not cocotb, for the same reason tb_icache.v and tb_dcache.v
// are: it runs on the development host in seconds.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps
`default_nettype none

module tb_usb_kbd;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;

  reg        sel = 0, we = 0;
  reg  [1:0] reg_a = 0;
  wire [31:0] rdata;

  reg        tog = 0;
  reg  [1:0] typ = 2'b01;
  reg        conerr = 0;
  reg  [7:0] mods = 0, key1 = 0, key2 = 0, key3 = 0, key4 = 0;
  wire       irq;

  usb_kbd dut (
      .clk(clk), .rst(rst),
      .sel(sel), .we(we), .reg_a(reg_a), .rdata(rdata),
      .usb_report_tog(tog), .usb_typ(typ), .usb_conerr(conerr),
      .usb_key_modifiers(mods),
      .usb_key1(key1), .usb_key2(key2), .usb_key3(key3), .usb_key4(key4),
      .kb_avail_irq(irq)
  );

  integer fails = 0;

  task check(input [55*8:1] what, input integer got, input integer want);
      begin
          if (got !== want) begin
              $display("  FAIL %0s: got %0d, want %0d", what, got, want);
              fails = fails + 1;
          end else
              $display("  ok   %0s = %0d", what, got);
      end
  endtask

  // A register read: `sel` for one cycle, and the value is registered, so it is
  // sampled on the negedge AFTER the posedge that latched it. Reading register
  // 0 or 2 POPS, so a task that samples at the wrong instant does not merely
  // read the wrong value — it eats a keystroke and the next check fails
  // somewhere else entirely.
  task rd(input [1:0] a, output [31:0] v);
      begin
          @(negedge clk);
          sel = 1; we = 0; reg_a = a;
          @(negedge clk);
          sel = 0;
          v = rdata;
      end
  endtask

  // Deliver one HID report and let the diff pass finish. The toggle crosses
  // three flops and the diff walks four slots, so ~12 clocks is comfortable.
  task report(input [7:0] a, input [7:0] b, input [7:0] c, input [7:0] d);
      begin
          @(negedge clk);
          key1 = a; key2 = b; key3 = c; key4 = d;
          tog = ~tog;
          repeat (12) @(posedge clk);
      end
  endtask

  reg [31:0] v;
  integer i;
  integer got1, got2;

  initial begin
    repeat (4) @(posedge clk);
    rst = 0;
    repeat (4) @(posedge clk);

    $display("tb_usb_kbd:");

    // ---- 1. a new key is queued, and reading port 1 pops it --------------
    report(8'h04, 0, 0, 0);                       // 'a' down
    rd(2'd0, v);
    check("port1 avail", v[8], 1);
    check("port1 code", v[7:0], 8'h04);
    rd(2'd0, v);
    check("port1 empty after pop", v[8], 0);

    // ---- 2. BOTH PORTS SEE THE SAME KEYSTROKE ---------------------------
    // The whole point of the second port. Port 1 already drained 0x04 above,
    // and port 2 must still have it: the queue is read twice, not shared.
    rd(2'd2, v);
    check("port2 still has the key port1 already took", v[8], 1);
    check("port2 code is the same keystroke", v[7:0], 8'h04);
    rd(2'd2, v);
    check("port2 empty after its own pop", v[8], 0);

    // ---- 3. the pointers are independent in both directions -------------
    report(8'h05, 0, 0, 0);
    report(8'h06, 0, 0, 0);
    rd(2'd0, v); check("port1 gets 05 first", v[7:0], 8'h05);
    rd(2'd2, v); check("port2 unmoved by port1: also 05", v[7:0], 8'h05);
    rd(2'd0, v); check("port1 gets 06", v[7:0], 8'h06);
    rd(2'd2, v); check("port2 gets 06 on its own pointer", v[7:0], 8'h06);

    // ---- 4. a held key is ONE keystroke, and slots may move -------------
    // Holding 'a' puts 0x04 in every report ~125x/s. Only the transition is a
    // keystroke. And a key that changes slot as others are pressed must not
    // read as a new press — that is why the diff checks all four old slots.
    report(8'h07, 0, 0, 0);
    rd(2'd0, v); check("07 queued once", v[7:0], 8'h07);
    report(8'h07, 0, 0, 0);                       // still held
    rd(2'd0, v); check("held key does not repeat", v[8], 0);
    report(8'h08, 8'h07, 0, 0);                   // 07 moved slot, 08 is new
    rd(2'd0, v); check("only the genuinely new key queued", v[7:0], 8'h08);
    rd(2'd0, v); check("no phantom from the moved key", v[8], 0);
    // Drain port 2's copies of the above so later counts start clean.
    rd(2'd2, v); rd(2'd2, v); rd(2'd2, v);

    // ---- 5. ⛔ A STALLED PORT 2 MUST NOT STARVE PORT 1 -------------------
    // The safety property the two-port design exists to guarantee. Port 2 is
    // never read in this loop, standing in for a Linux driver with nothing
    // holding the evdev node open. Port 1 — the console — must keep working
    // indefinitely. 40 keystrokes is five times the FIFO depth, so if `f_full`
    // were computed against the laggier reader this loop deadlocks.
    got1 = 0;
    for (i = 0; i < 40; i = i + 1) begin
        report(8'h10 + i[7:0], 0, 0, 0);
        rd(2'd0, v);
        if (v[8] && v[7:0] == (8'h10 + i[7:0])) got1 = got1 + 1;
    end
    // Label kept short: `check` takes 55 characters and truncates the FRONT,
    // which silently renamed this very assertion in its first run.
    check("port1 not starved by a stalled port2 (want 40)", got1, 40);

    // ---- 6. and port 2 is TOLD it was lapped ----------------------------
    // It cannot have the 40 it missed — only eight entries exist — but it must
    // report the overflow rather than return stale or wrong data.
    rd(2'd2, v);
    check("port2 overflow flag set after being lapped", v[9], 1);
    check("port2 still returns a real entry, not garbage", v[8], 1);

    // ---- 6b. ⛔ AND THE CONVERSE: A STALLED PORT 1 MUST NOT STARVE PORT 2 -
    // The mirror of test 5, and the direction the design got wrong. Port 1 is
    // never read in this loop, standing in for the SBI firmware when hvc0 has
    // no tty attached — which is not a hypothetical: the UART is transmit-only
    // and the screen is the console Linux actually owns, so hvc0's consumer is
    // the one that can quietly go away.
    //
    // ⚠️ WHY THIS IS THE WORSE DIRECTION, not merely the missing one. If the
    // writer stalls on port 1's fullness the KEYBOARD DIES ENTIRELY — both
    // consoles at once, permanently, and draining port 2 does not bring it
    // back because the entries were never enqueued. Test 5 protects the path
    // that no longer has to work from the one that does.
    rd(2'd0, v); while (v[8]) rd(2'd0, v);        // drain port 1
    rd(2'd2, v); while (v[8]) rd(2'd2, v);        // drain port 2
    got2 = 0;
    for (i = 0; i < 40; i = i + 1) begin
        report(8'h10 + i[7:0], 0, 0, 0);
        rd(2'd2, v);
        if (v[8] && v[7:0] == (8'h10 + i[7:0])) got2 = got2 + 1;
    end
    check("port2 not starved by a stalled port1 (want 40)", got2, 40);
    // Leave port 1 as this test found it. Skipping this drain does not fail
    // HERE — it fails in tests 7 and 8, which then read the stale entries this
    // loop left behind and look like two unrelated bugs.
    rd(2'd0, v); while (v[8]) rd(2'd0, v);

    // ---- 7. the status register has NO side effects ----------------------
    // Reading register 1 must not eat a keystroke: a "is a keyboard attached?"
    // check that consumed the key it was asked about would be a bug nobody
    // finds by reading the caller.
    report(8'h30, 0, 0, 0);
    rd(2'd1, v);
    check("status reports modifiers, not a keystroke", v[7:0], mods);
    rd(2'd0, v);
    check("the keystroke survived the status read", v[7:0], 8'h30);

    // ---- 8. HID error codes are never keystrokes ------------------------
    // 0x01..0x03 are rollover/POST-fail/undefined. A rollover typed as a
    // character is what happens when several keys are held at once.
    rd(2'd2, v); while (v[8]) rd(2'd2, v);        // drain port 2
    report(8'h01, 8'h02, 8'h03, 0);
    rd(2'd0, v);
    check("rollover and error codes are not queued", v[8], 0);

    $display("");
    if (fails == 0) $display("tb_usb_kbd: PASS");
    else begin
        $display("tb_usb_kbd: FAIL (%0d)", fails);
        $fatal(1);
    end
    $finish;
  end

  // A FIFO that never acknowledges would hang rather than fail.
  initial begin
      repeat (200000) @(posedge clk);
      $display("tb_usb_kbd: FAIL (timeout)");
      $fatal(1);
  end

endmodule

`default_nettype wire
