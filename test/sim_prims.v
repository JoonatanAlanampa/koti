// sim_prims.v — behavioural ECP5 hard blocks, FOR SIMULATION ONLY.
//
// ⛔ NOT in fpga/sources.txt, and it must never be. Synthesis gets the real
// EHXPLLL and ODDRX1F out of the ECP5 cell library; if this file ever reached
// yosys it would shadow them and the bitstream would contain soft logic where
// a hard block belongs.
//
// It exists because test/run.py's `fpga` suite is the only one that elaborates
// ulx3s_top, and ulx3s_top now instantiates a PLL and four DDR output
// registers. Without these two models that suite stops running — and it is the
// suite that covers the header permutations, the orientation straps and the
// bus mux, so losing it to add HDMI would be a bad trade.
//
// These are behavioural, not timing-accurate: no jitter, no lock time worth
// the name, no phase from CPHASE/FPHASE. What they DO model correctly is the
// frequency ratio, which is the one thing dvi_tx.sv depends on (5 shift clocks
// per pixel) and the one thing its `phase_err` watchdog can catch.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`timescale 1ns / 1ps

module EHXPLLL #(
    parameter PLLRST_ENA     = "DISABLED",
    parameter INTFB_WAKE     = "DISABLED",
    parameter STDBY_ENABLE   = "DISABLED",
    parameter DPHASE_SOURCE  = "DISABLED",
    parameter OUTDIVIDER_MUXA = "DIVA",
    parameter OUTDIVIDER_MUXB = "DIVB",
    parameter OUTDIVIDER_MUXC = "DIVC",
    parameter OUTDIVIDER_MUXD = "DIVD",
    parameter CLKI_DIV       = 1,
    parameter CLKOP_ENABLE   = "ENABLED",
    parameter CLKOP_DIV      = 1,
    parameter CLKOP_CPHASE   = 0,
    parameter CLKOP_FPHASE   = 0,
    parameter CLKOS_ENABLE   = "DISABLED",
    parameter CLKOS_DIV      = 1,
    parameter CLKOS_CPHASE   = 0,
    parameter CLKOS_FPHASE   = 0,
    parameter FEEDBK_PATH    = "CLKOP",
    parameter CLKFB_DIV      = 1
) (
    input  wire RST, STDBY, CLKI, CLKFB,
    input  wire PHASESEL0, PHASESEL1, PHASEDIR, PHASESTEP, PHASELOADREG,
    input  wire PLLWAKESYNC, ENCLKOP,
    output wire CLKOP, CLKOS, CLKINTFB,
    output wire LOCK
);
  // The loop equation, for FEEDBK_PATH="CLKOP": the feedback divider forces
  //     CLKOP = CLKI * CLKFB_DIV / CLKI_DIV
  // and every other output is the VCO divided down, VCO = CLKOP * CLKOP_DIV.
  real t0, per_in, per_op, per_vco, per_os;
  reg  clkop_r = 1'b0;
  reg  clkos_r = 1'b0;
  reg  lock_r  = 1'b0;

  initial begin
    @(posedge CLKI); t0 = $realtime;
    @(posedge CLKI); per_in = $realtime - t0;

    per_op  = per_in * CLKI_DIV / CLKFB_DIV;
    per_vco = per_op / CLKOP_DIV;
    per_os  = per_vco * CLKOS_DIV;
    lock_r  = 1'b1;

    fork
      forever #(per_op / 2.0) clkop_r = ~clkop_r;
      forever #(per_os / 2.0) clkos_r = ~clkos_r;
    join
  end

  assign CLKOP    = clkop_r;
  assign CLKOS    = clkos_r;
  assign CLKINTFB = clkop_r;
  assign LOCK     = lock_r;

  wire _unused = &{1'b0, RST, STDBY, CLKFB, PHASESEL0, PHASESEL1, PHASEDIR,
                   PHASESTEP, PHASELOADREG, PLLWAKESYNC, ENCLKOP};
endmodule

// DDR output register: D0 goes out on the rising edge, D1 on the falling.
module ODDRX1F (
    input  wire D0, D1, SCLK, RST,
    output reg  Q
);
  always @(posedge SCLK) Q <= RST ? 1'b0 : D0;
  always @(negedge SCLK) Q <= RST ? 1'b0 : D1;
endmodule

`default_nettype wire
