// tb_audio.v — koti's sound path: the 4-bit R2R DAC, and the synth behind it.
//
// WHAT IS ACTUALLY BEING CHECKED. `vendor/audio.sv` is console's, proven there
// and copied unchanged, so this bench does not re-verify its waveforms. The new
// work is `src/audio_r2r.sv`, and its correctness claim is a STATISTICAL one:
// the mean of a 4-bit output tracks an 8-bit input to far better than one part
// in sixteen. That claim is exactly what a testbench can check and what reading
// the code cannot, so it is what this file measures.
//
// It also pins the two properties that are audible rather than numerical:
// silence must sit at mid-scale (or every note boundary clicks), and full scale
// must saturate rather than wrap (or the loudest peak becomes the quietest
// sample, which is a crack, not a rounding error).
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps
`default_nettype none

module tb_audio;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;                  // 100 MHz sim clock, ratios are what matter

  reg  [7:0] sample = 8'd128;
  wire [3:0] dac;

  audio_r2r dut (.clk(clk), .rst(rst), .sample(sample), .dac(dac));

  integer fails = 0;
  integer i;
  integer acc;
  real    mean, want, err;

  task check_mean(input [7:0] s, input integer n);
    begin
      sample = s;
      @(posedge clk);
      // Let the modulator settle out of the previous level before measuring.
      repeat (64) @(posedge clk);
      acc = 0;
      for (i = 0; i < n; i = i + 1) begin
        @(posedge clk);
        acc = acc + dac;
      end
      mean = acc * 1.0 / n;
      want = s / 16.0;
      err  = (mean > want) ? (mean - want) : (want - mean);
      // A quarter of one DAC step. Truncation — the thing this block exists
      // to avoid — is wrong by up to a whole step, i.e. four times this, and
      // always in the same direction.
      if (err > 0.25) begin
        $display("FAIL: sample %0d -> mean %f, wanted %f (err %f)", s, mean, want, err);
        fails = fails + 1;
      end else
        $display("  ok  sample %3d -> mean %6.3f  (want %6.3f, err %5.3f)", s, mean, want, err);
    end
  endtask

  // ---- the synth behind it, driven the way project.sv's MMIO drives it ----
  reg  [63:0] v_freq = 64'd0;
  reg  [7:0]  v_wave = 8'd0;
  reg  [15:0] v_vol  = 16'd0;
  wire [7:0]  synth_sample;
  wire        synth_bit;

  audio synth (
      .clk(clk), .rst(rst), .v_freq(v_freq), .v_wave(v_wave), .v_vol(v_vol),
      .sample(synth_sample), .audio_out(synth_bit)
  );

  integer hi, lo;

  initial begin
    repeat (4) @(posedge clk);
    rst = 0;
    @(posedge clk);

    $display("== the DAC's average tracks its input ==");
    check_mean(8'd128, 4096);            // silence, dead centre
    check_mean(8'd136, 4096);            // +0.5 step: only dithering can reach it
    check_mean(8'd131, 4096);            // +3/16 of a step
    check_mean(8'd200, 4096);
    check_mean(8'd64,  4096);
    check_mean(8'd8,   4096);            // deep quiet, where truncation is worst

    $display("== silence sits at mid-scale, and holds there ==");
    sample = 8'd128;
    repeat (64) @(posedge clk);
    for (i = 0; i < 256; i = i + 1) begin
      @(posedge clk);
      if (dac !== 4'd8) begin
        $display("FAIL: silence moved the ladder to %0d — that is a click", dac);
        fails = fails + 1;
        i = 256;
      end
    end

    $display("== full scale saturates, it does not wrap ==");
    sample = 8'd255;
    repeat (64) @(posedge clk);
    for (i = 0; i < 512; i = i + 1) begin
      @(posedge clk);
      if (dac < 4'd14) begin
        $display("FAIL: full scale dropped to %0d — a wrap, i.e. a crack", dac);
        fails = fails + 1;
        i = 512;
      end
    end

    $display("== reset parks the ladder at mid-scale, not at the rail ==");
    rst = 1;
    sample = 8'd255;
    repeat (4) @(posedge clk);
    if (dac !== 4'd8) begin
      $display("FAIL: reset left the ladder at %0d, so power-on is a thump", dac);
      fails = fails + 1;
    end
    rst = 0;
    repeat (4) @(posedge clk);

    $display("== a voice with volume 0 is silent, whatever its wave bits ==");
    // This is the property that makes an all-zero register file safe, which is
    // what every boot before software knows about the audio block looks like.
    v_freq = {16'd590, 16'd590, 16'd590, 16'd590};
    v_wave = 8'b00_01_10_00;             // square, triangle, noise, square
    v_vol  = 16'd0;
    repeat (4096) @(posedge clk);
    if (synth_sample !== 8'd128) begin
      $display("FAIL: volume 0 emitted %0d, not 128 — reset would be audible",
               synth_sample);
      fails = fails + 1;
    end

    $display("== a voice with volume moves the sample both sides of centre ==");
    v_vol = 16'h000F;                    // voice 0 at full, the rest silent
    hi = 0; lo = 0;
    for (i = 0; i < 200000; i = i + 1) begin
      @(posedge clk);
      if (synth_sample > 8'd140) hi = 1;
      if (synth_sample < 8'd116) lo = 1;
    end
    if (!hi || !lo) begin
      $display("FAIL: a sounding voice never swung both ways (hi=%0d lo=%0d)", hi, lo);
      fails = fails + 1;
    end

    if (fails == 0) $display("tb_audio: PASS");
    else            $display("tb_audio: FAIL (%0d)", fails);
    $finish;
  end

endmodule

`default_nettype wire
