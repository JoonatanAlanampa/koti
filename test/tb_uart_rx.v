// tb_uart_rx.v — the gate for src/uart_rx.sv.
//
// A receiver is one of the blocks that can be wrong by being QUIET, so a bench
// that only sends one clean byte and checks it arrives proves very little. The
// interesting failures all look like silence or like plausible wrong data:
//
//   sampling on the bit EDGE instead of the middle — passes with a testbench
//     that shares a timebase with the DUT, shreds data between two real
//     crystals. Tested here by sending at a bit rate that is deliberately OFF
//     by a few percent, which edge-sampling cannot survive and mid-sampling can.
//   no start-bit validation — a noise glitch on an idle line becomes a byte of
//     garbage, and the first thing anyone notices is a console typing by itself.
//   no stop-bit check — a wrong divisor delivers bytes that are wrong rather
//     than a signal that something is misconfigured.
//
// Plain Verilog, no cocotb, so it runs on the development host in seconds.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns / 1ps
`default_nettype none

module tb_uart_rx;

  // 20 clocks per bit rather than 217: same logic, a fortieth of the sim time.
  // DIV is a parameter precisely so the bench can pick a cheap one.
  localparam integer DIV = 20;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;                       // 100 MHz-ish, arbitrary

  reg         rx = 1;                         // the line idles HIGH
  wire [7:0]  data;
  wire        valid, frame_err;

  uart_rx #(.DIV(DIV)) dut (
      .clk(clk), .rst(rst), .rx_pin(rx),
      .data(data), .valid(valid), .frame_err(frame_err)
  );

  integer fails = 0;
  reg [7:0] got;
  integer   n_valid, n_frame;

  task check(input [55*8:1] what, input integer g, input integer w);
      begin
          if (g !== w) begin
              $display("  FAIL %0s: got %0d, want %0d", what, g, w);
              fails = fails + 1;
          end else
              $display("  ok   %0s = %0d", what, g);
      end
  endtask

  // Send one byte at `bit_clocks` per bit. Passing something other than DIV is
  // how the drift tolerance is exercised.
  task send(input [7:0] b, input integer bit_clocks);
      integer i;
      begin
          rx = 0; repeat (bit_clocks) @(posedge clk);          // start
          for (i = 0; i < 8; i = i + 1) begin
              rx = b[i];                                       // LSB first
              repeat (bit_clocks) @(posedge clk);
          end
          rx = 1; repeat (bit_clocks) @(posedge clk);           // stop
      end
  endtask

  // Count outputs continuously: a pulse is one clock wide and a task that
  // sampled at the wrong instant would miss it and report a false failure.
  always @(posedge clk) if (!rst) begin
      if (valid)     begin got <= data; n_valid <= n_valid + 1; end
      if (frame_err) n_frame <= n_frame + 1;
  end

  initial begin
    n_valid = 0; n_frame = 0; got = 0;
    repeat (4) @(posedge clk);
    rst = 0;
    repeat (4) @(posedge clk);

    $display("tb_uart_rx:");

    // ---- 1. one byte, exactly on rate -----------------------------------
    send(8'h41, DIV);                                  // 'A'
    repeat (DIV) @(posedge clk);
    check("one byte arrives", n_valid, 1);
    check("and it is the byte sent (0x41)", got, 8'h41);
    check("no framing error", n_frame, 0);

    // ---- 2. a byte with every bit set the other way ----------------------
    // 0x00 and 0xFF are the two that catch a shifter that is inverted or stuck:
    // 0xFF is indistinguishable from an idle line except for its start bit.
    send(8'h00, DIV);
    repeat (DIV) @(posedge clk);
    check("0x00 arrives (all data bits low)", got, 8'h00);
    send(8'hFF, DIV);
    repeat (DIV) @(posedge clk);
    check("0xFF arrives (all data bits high)", got, 8'hFF);
    check("three bytes so far", n_valid, 3);

    // ---- 3. BACK TO BACK, no idle between -------------------------------
    // The stop bit of one byte is immediately the start of the next. A receiver
    // that returns to IDLE late, or that re-arms on the wrong edge, drops the
    // second one — and this is the normal case on a busy link, not a corner.
    send(8'h55, DIV);
    send(8'hAA, DIV);
    repeat (DIV) @(posedge clk);
    check("back-to-back bytes both arrive", n_valid, 5);
    check("and the second is 0xAA", got, 8'hAA);

    // ---- 4. ⛔ A GLITCH IS NOT A START BIT -------------------------------
    // Two clocks low on an idle line. Without start-bit validation this begins
    // a reception and delivers a byte of noise; with it, nothing happens at all.
    rx = 0; repeat (2) @(posedge clk);
    rx = 1; repeat (DIV * 12) @(posedge clk);
    check("a 2-clock glitch produces no byte", n_valid, 5);
    check("and no framing error either", n_frame, 0);

    // ---- 5. ⛔ SENDER 4% FAST — the drift the midpoint buys --------------
    // 19 clocks per bit against the DUT's 20. Ten bit-times in, the sender is
    // most of a bit ahead; sampling at the middle still lands inside every bit,
    // sampling at the edge does not. This is the test that fails on a receiver
    // which "works" only because the bench shares its clock.
    send(8'h3C, DIV - 1);
    repeat (DIV * 2) @(posedge clk);
    check("a 5% fast sender still decodes", got, 8'h3C);
    check("six bytes now", n_valid, 6);

    // ---- 6. and 5% SLOW, the other direction -----------------------------
    send(8'hC3, DIV + 1);
    repeat (DIV * 2) @(posedge clk);
    check("a 5% slow sender still decodes", got, 8'hC3);

    // ---- 7. ⛔ A MISSING STOP BIT IS REPORTED, NOT DELIVERED --------------
    // Hold the line low where the stop bit belongs. That is what a wrong
    // divisor or a broken cable looks like, and a byte delivered anyway would
    // be silently wrong data instead of a signal to go and look.
    n_frame = 0;
    rx = 0; repeat (DIV) @(posedge clk);            // start
    begin : nostop
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            rx = 1'b0; repeat (DIV) @(posedge clk); // data 0x00
        end
    end
    rx = 0; repeat (DIV) @(posedge clk);            // stop bit LOW = framing err
    rx = 1; repeat (DIV * 2) @(posedge clk);
    check("a low stop bit raises frame_err", n_frame, 1);
    check("and delivers no byte", n_valid, 7);

    $display("");
    if (fails == 0) $display("tb_uart_rx: PASS");
    else begin
        $display("tb_uart_rx: FAIL (%0d)", fails);
        $fatal;
    end
    $finish;
  end

  initial begin
    #500000;
    $display("tb_uart_rx: FAIL (timeout)");
    $fatal;
  end

endmodule

`default_nettype wire
