`default_nettype none
//
// dvi_tx.sv — RUNG 3: the console's own video engine, on the HDMI connector.
//
// Rung 0 (fpga/gpdi_test_top.sv) proved this monitor accepts the ULX3S GPDI
// output. It did so with ONE clock domain: pattern, timing and encoders all in
// the 125 MHz shift domain with a mod-5 clock enable. The console cannot work
// that way — the SoC runs at 25 MHz and misses timing by a mile at 125 — so the
// pixels arrive here from a different clock, and the one new problem this file
// solves is handing them over.
//
// THE HANDOVER, AND WHY IT IS NOT A NORMAL CDC
// -------------------------------------------
// clk_pixel (the board's 25 MHz oscillator) and clk_shift (125 MHz out of the
// PLL that same oscillator drives) are phase-LOCKED: exactly 5 shift clocks per
// pixel, forever. What is unknown is the phase OFFSET between them — it depends
// on the PLL's CPHASE settings and its internal delays, and it is not a number
// this file should have to know.
//
// So it measures it instead. A flop in the pixel domain toggles once per pixel;
// two flops in the shift domain sample it; an edge on that sampled toggle IS a
// pixel-clock edge, observed ~2 shift clocks late. Register that edge once more
// and the resulting `pce` lands 2.5-3.5 clocks — 20-28 ns — into a 40 ns pixel:
// the middle, which is where you want to sample a signal you did not clock.
// Nothing here depends on the PLL's phase, so nothing breaks if it is retuned.
//
// The mod-5 counter is a WATCHDOG, not the datapath. It free-runs and expects
// the measured pixel edge to arrive exactly on its wrap; if it ever does not,
// `phase_err` latches high and says the 1:5 relationship is broken (PLL not
// locked, wrong PLL divider, pixel clock stopped). The pixels themselves follow
// the measurement, so they stay correct even while that bit is complaining.
//
// Everything downstream is the rung-0 arrangement, unchanged, because it is the
// arrangement that closed at 149.95 MHz: three-stage encoders in the shift
// domain gated by pce, 10:2 serialisers into ODDRX1F. See tmds_encoder.sv for
// why the encoder is pipelined and why a clock enable does not relax timing.
//
// SYNC POLARITY. `hsync`/`vsync` come in exactly as src/vga_timing.sv emits
// them — ACTIVE LOW for 640x480@60 (H_POL/V_POL default to 0) — which is also
// what DVI wants for this mode, so they pass through untouched.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

module dvi_tx (
    input  wire       clk_pixel,     // 25 MHz — the SoC's clock
    input  wire       clk_shift,     // 125 MHz — PLL, exactly 5x clk_pixel
    input  wire       rst_shift,     // synchronous, active high, clk_shift domain

    input  wire [7:0] r,             // pixel colour, clk_pixel domain
    input  wire [7:0] g,
    input  wire [7:0] b,
    input  wire       hsync,         // active low
    input  wire       vsync,         // active low
    input  wire       de,            // high inside the visible box

    output wire [3:0] gpdi_dp,       // [0]=Blue [1]=Green [2]=Red [3]=Clock
    output reg        phase_err      // sticky: clk_pixel is not 1/5 of clk_shift
);

  // ------------------------------------------------- measure the pixel edge
  reg pix_tog = 1'b0;
  always @(posedge clk_pixel) pix_tog <= ~pix_tog;

  // Two flops, so a metastable sample cannot reach the logic below. The edge is
  // therefore observed ~2 shift clocks after the pixel clock actually ticked.
  reg [1:0] tog_sync;
  always @(posedge clk_shift) tog_sync <= {tog_sync[0], pix_tog};
  wire pix_edge = tog_sync[1] ^ tog_sync[0];

  // pce is REGISTERED — rung 0's timing fix, and here it also buys the last
  // 8 ns of settling. It is the only enable in the design, so every consumer
  // shifts together and the 5-clock cadence is unchanged.
  reg pce;
  always @(posedge clk_shift) pce <= !rst_shift && pix_edge;

  // ------------------------------------------------------------- watchdog
  // Mod-5. It does not drive a single pixel; it exists so that a broken clock
  // ratio shows up as one LED instead of as a picture that is subtly wrong in
  // a way nobody can name.
  //
  // ⚠ IT MUST ACQUIRE BEFORE IT JUDGES, and the first version did not. Reset
  // is released at an arbitrary point between pixel edges, so a counter that
  // free-runs from zero meets the first edge at a random phase and latches an
  // error immediately — measured on hardware 2026-08-07: perfect colour bars
  // with the fault LED lit. `wd_armed` makes the first edge define the phase
  // and every edge after it be checked against that, which is the difference
  // between a status bit and a bit that is always on.
  reg [2:0] wd;
  reg       wd_armed;
  always @(posedge clk_shift) begin
    if (rst_shift) begin
      wd        <= 3'd0;
      wd_armed  <= 1'b0;
      phase_err <= 1'b0;
    end else if (pix_edge) begin
      wd       <= 3'd1;                                 // this clock is phase 0
      wd_armed <= 1'b1;
      if (wd_armed && wd != 3'd0) phase_err <= 1'b1;    // arrived off-cadence
    end else begin
      wd <= (wd == 3'd4) ? 3'd0 : wd + 3'd1;
    end
  end

  // ---------------------------------------------------------- TMDS encoders
  // Channel 0 = Blue and carries {vsync,hsync} during blanking; 1 = Green,
  // 2 = Red, both with control 00. That assignment is fixed by the DVI spec.
  //
  // The encoders' stage-1 flops, clocked by pce, ARE the domain crossing: they
  // capture r/g/b/de/hsync/vsync mid-pixel. There is deliberately no extra
  // capture register in front of them — one more stage would push the sample
  // point back off the middle of the pixel, which is the thing being bought.
  wire [9:0] tq0, tq1, tq2;
  tmds_encoder e0 (.clk(clk_shift), .ce(pce), .rst(rst_shift),
                   .d(b), .c({vsync, hsync}), .de(de), .q(tq0));
  tmds_encoder e1 (.clk(clk_shift), .ce(pce), .rst(rst_shift),
                   .d(g), .c(2'b00),          .de(de), .q(tq1));
  tmds_encoder e2 (.clk(clk_shift), .ce(pce), .rst(rst_shift),
                   .d(r), .c(2'b00),          .de(de), .q(tq2));

  // ------------------------------------------------------------- serialisers
  // TMDS goes LSB first. Load at the pixel boundary, then shift 2 bits per
  // clock; ODDRX1F emits bit 0 on the rising edge and bit 1 on the falling.
  // The clock channel is a fixed 5-high/5-low word = a square wave at pixel
  // rate. If the monitor will not lock, inverting this word shifts the clock
  // phase half a bit and is the first thing to try.
  localparam [9:0] CLK_WORD = 10'b1111100000;

  reg [9:0] s0, s1, s2, s3;
  always @(posedge clk_shift) begin
    if (rst_shift) begin
      s0 <= 10'd0; s1 <= 10'd0; s2 <= 10'd0; s3 <= CLK_WORD;
    end else if (pce) begin
      s0 <= tq0; s1 <= tq1; s2 <= tq2; s3 <= CLK_WORD;
    end else begin
      s0 <= {2'b00, s0[9:2]};
      s1 <= {2'b00, s1[9:2]};
      s2 <= {2'b00, s2[9:2]};
      s3 <= {2'b00, s3[9:2]};
    end
  end

  // Only the _p pin is driven: IO_TYPE=LVCMOS33D makes the ECP5 drive the
  // paired _n site with the complement automatically.
  ODDRX1F o0 (.D0(s0[0]), .D1(s0[1]), .SCLK(clk_shift), .RST(1'b0), .Q(gpdi_dp[0]));
  ODDRX1F o1 (.D0(s1[0]), .D1(s1[1]), .SCLK(clk_shift), .RST(1'b0), .Q(gpdi_dp[1]));
  ODDRX1F o2 (.D0(s2[0]), .D1(s2[1]), .SCLK(clk_shift), .RST(1'b0), .Q(gpdi_dp[2]));
  ODDRX1F o3 (.D0(s3[0]), .D1(s3[1]), .SCLK(clk_shift), .RST(1'b0), .Q(gpdi_dp[3]));

endmodule
`default_nettype wire
