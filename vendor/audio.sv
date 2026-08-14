// audio.sv — the console's chiptune sound: 4 DDS voices (square / triangle /
// noise + volume) mixed to an 8-bit sample and first-order sigma-delta modulated
// to one bit, for the cartridge Pmod's RC low-pass + amp on uio[7] (the same
// analog output stage CORDIC-1 already ships).
//
// Each voice has a 16-bit phase accumulator advanced by v_freq every audio
// sample tick (clk / SAMPLE_DIV -> ~48.8 kHz at 25 MHz). The waveform comes from
// the phase; v_vol (0..15) scales it about mid-scale. Voices sum and average to
// an 8-bit sample; the sigma-delta runs at the full clock so its quantisation
// noise sits far above the audio band. The CPU owns v_freq/v_wave/v_vol (MMIO
// in the SoC); here they are inputs. `sample` is exposed for test / an alt DAC.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module audio #(
    parameter int NVOICES    = 4,
    parameter int SAMPLE_DIV = 512               // 25 MHz / 512 ~= 48.8 kHz
) (
    input  logic                   clk,
    input  logic                   rst,
    input  logic [NVOICES*16-1:0]  v_freq,        // phase increment / voice
    input  logic [NVOICES*2-1:0]   v_wave,        // 0 square, 1 triangle, 2 noise, 3 off
    input  logic [NVOICES*4-1:0]   v_vol,         // 0..15
    output logic [7:0]             sample,        // mixed 8-bit sample
    output logic                   audio_out      // 1-bit sigma-delta -> uio[7]
);

  // waveform + volume for one voice -> 8-bit unsigned about 128
  function automatic [7:0] voice_val(input [15:0] ph, input [1:0] wave,
                                     input [3:0] vol, input [7:0] noise);
    logic [7:0]         raw;
    logic signed [8:0]  sw;
    logic signed [12:0] scaled;
    logic signed [8:0]  vout;
    begin
      case (wave)
        2'd0:    raw = ph[15] ? 8'd255 : 8'd0;                        // square
        2'd1:    raw = ph[15] ? (8'd255 - {ph[14:8], 1'b0})          // triangle
                              : {ph[14:8], 1'b0};
        2'd2:    raw = noise;                                         // noise
        default: raw = 8'd128;                                        // off
      endcase
      sw     = $signed({1'b0, raw}) - 9'sd128;    // -128..127
      scaled = sw * $signed({5'b0, vol});         // * 0..15
      vout   = 9'sd128 + (scaled >>> 4);          // /16 about mid; stays 8..247
      voice_val = vout[7:0];
    end
  endfunction

  // sample-rate tick
  logic [15:0] divcnt;
  wire         tick = (divcnt == SAMPLE_DIV[15:0] - 16'd1);
  always_ff @(posedge clk)
    if (rst)      divcnt <= 16'd0;
    else          divcnt <= tick ? 16'd0 : divcnt + 16'd1;

  // per-voice phase accumulators + a shared noise LFSR, advanced each tick
  logic [15:0] phase [NVOICES];
  logic [15:0] lfsr;
  always_ff @(posedge clk)
    if (rst) begin
      for (int i = 0; i < NVOICES; i++) phase[i] <= 16'd0;
      lfsr <= 16'hACE1;
    end else if (tick) begin
      for (int i = 0; i < NVOICES; i++)
        phase[i] <= phase[i] + v_freq[i*16 +: 16];
      lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
    end

  // mix (average) the voices
  logic [9:0] mixsum;
  always_comb begin
    mixsum = 10'd0;
    for (int i = 0; i < NVOICES; i++)
      mixsum = mixsum + {2'd0, voice_val(phase[i], v_wave[i*2 +: 2],
                                         v_vol[i*4 +: 4], lfsr[7:0])};
  end
  assign sample = mixsum[9:2];                   // / NVOICES (=4)

  // first-order sigma-delta at the full clock
  logic [8:0] sd;
  always_ff @(posedge clk)
    if (rst) sd <= 9'd0;
    else     sd <= {1'b0, sd[7:0]} + {1'b0, sample};
  assign audio_out = sd[8];

endmodule
