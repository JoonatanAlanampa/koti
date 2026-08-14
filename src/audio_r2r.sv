// audio_r2r.sv — koti's 8-bit sample onto the ULX3S's 4-bit R2R ladder.
//
// THE JACK IS FOUR BITS. `ulx3s_v20.lpf` wires the onboard 3.5 mm socket as an
// R2R resistor ladder per channel driven straight from FPGA pins — four pins
// for the tip, four for the ring — so the hardware DAC on this board has
// SIXTEEN LEVELS and no anti-alias filter beyond the speaker itself. The synth
// upstream (vendor/audio.sv) produces eight bits. Something has to give up four
// of them, and WHICH four is the whole content of this file.
//
// ⛔ THE OBVIOUS ANSWER — `dac = sample[7:4]` — THROWS AWAY THE QUIET HALF OF
// THE MUSIC. Truncation makes the error a deterministic function of the signal,
// so it is not noise: it is distortion that tracks the waveform, worst exactly
// where the ear is most sensitive to it, on sustained quiet notes. console's
// tune_top.sv says the same thing in its own words about volume control — "the
// DAC is 4 bits, so >>1 leaves ~3 bits and >>2 leaves ~2 bits (levels 7/8/9
// only)". That is a real limit of the ladder and this block is how to spend it
// well rather than a way around it.
//
// ⭐ SO: FIRST-ORDER SIGMA-DELTA, AT THE FULL CLOCK, AND THE CLOCK RATE IS THE
// POINT. `sample` changes at 48.8 kHz (vendor/audio.sv's SAMPLE_DIV=512) while
// this modulator re-quantises it every 40 ns — 512 decisions per audio sample.
// The four bits it discards are carried into the next decision, so the OUTPUT
// AVERAGE tracks the input to far better than one part in sixteen, and the
// quantisation error is pushed up to hundreds of kHz where the ladder, the
// cable and the speaker cannot reproduce it and the ear could not hear it if
// they did. It is the same trick vendor/audio.sv already uses to reach ONE bit
// for the cartridge Pmod's RC filter, with the quantiser widened to four.
//
// 🪤 SILENCE MUST BE MID-SCALE, NOT ZERO. The ladder is unsigned: 0 is the
// negative rail, 15 the positive, and 8 is the middle. The synth encodes
// silence as 128, which lands on 8 here with an error of exactly zero, so a
// machine with the audio block idle holds the output pins steady at half rail.
// Driving 0 instead would put a DC step on the jack at every silence — a click
// in the speaker on every note boundary, and a DC bias through the amp between
// them. Reset therefore starts at 8, not at 0.
//
// ⚠️ The output is REGISTERED. An R2R ladder sums its inputs continuously, so a
// combinational output would put every intermediate value of the adder onto the
// pins as a glitch, and glitches on a DAC are audible clicks — there is no
// sample-and-hold downstream to swallow them.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module audio_r2r (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] sample,     // unsigned, 128 = silence
    output logic [3:0] dac         // to the R2R ladder, 8 = silence
);

  // The carried error is the four bits the quantiser dropped last time. Nine
  // bits of sum is exactly enough and provably so: 255 + 15 = 270 < 512.
  logic [3:0] err;
  logic [8:0] sum;

  always_comb sum = {1'b0, sample} + {5'd0, err};

  always_ff @(posedge clk)
    if (rst) begin
      err <= 4'd0;
      dac <= 4'd8;                 // mid-scale: silence, and no step into it
    end else begin
      err <= sum[3:0];
      // The carry-in can push a full-scale sample past 255; the ladder has no
      // level above 15 to represent that, so it saturates rather than wrapping.
      // Wrapping would turn the loudest peak of a waveform into the quietest
      // sample in it, which is not a rounding error, it is a crack.
      dac <= sum[8] ? 4'd15 : sum[7:4];
    end

endmodule

`default_nettype wire
