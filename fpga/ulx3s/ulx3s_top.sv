// ulx3s_top.sv — Koti-1 on the ULX3S 85F (ECP5): the pre-tapeout
// validation build.
//
// Wraps the UNCHANGED `tt_um_koti`, so what runs on the FPGA is what gets
// hardened — only the pad ring differs. Everything in this file is harness:
// header permutation, straps, tristates. None of it exists on silicon, where
// the TT mux drives the pins directly.
//
// WHAT CHANGED FROM THE 2026-07-19 SCAFFOLD, AND WHY
// --------------------------------------------------
// The scaffold mapped `uio[7:0]` onto `gp[0..7]` and the VGA outputs onto
// `gn[0..7]`. Those are not Pmod footprints. On the ULX3S the 12-pin blocks
// are J1 = gp/gn[0..3] and J2 = gp/gn[4..7], so a Pmod wired gp[0..7] would
// straddle two physical connectors and could never be plugged in. Each Pmod
// now gets one header, with the row assignment selectable at runtime.
//
// HEADER ORIENTATION. A Pmod can be seated either way round, and a reversed
// one is a silent failure that looks like dead gateware. SW1 flips the J1
// rows, SW2 flips J2 — a switch flip instead of a rebuild. Same trick as
// tt-riscv/fpga and console/fpga.
//
// KOTI'S TWO PERSONALITIES. `uo` is not a fixed pinout: at reset the chip is
// headless (uo[0]=UART, uo[1]=HALTED, uo[7:2]=LEDs) and stays that way until
// software sets VGA_EN, after which uo carries Tiny VGA Pmod colour/sync and
// the UART optionally moves to the blue LSB, uo[6]. The harness cannot see
// VGA_EN — it is an internal register with no pin — so SW3 selects which uo
// bit feeds the serial line. Both personalities reach J2 regardless; a
// monitor simply sees no sync while the chip is headless, which is correct.
//
// Mapping:
//   clk_25mhz    -> clk (the design's real frequency)
//   btn[0] (PWR) -> reset, active low, gated with a power-on-reset counter
//   btn[6:1]     -> ui[7:2] GPIO inputs (MMIO 0x10008)
//   gp[8]/gp[9]  -> ui[1:0] PS/2 clock / data  (external pull-ups needed!)
//   J1 gp/gn0-3  -> uio[7:0] QSPI memory Pmod  (SW1 flips rows)
//   J2 gp/gn4-7  -> uo[7:0]  Tiny VGA Pmod     (SW2 flips rows)
//   ftdi_rxd     -> uo[0] or uo[6]             (SW3 selects)
//   led[7:0]     -> uo[7:0] raw, or a frame counter (SW4 selects)
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module ulx3s_top (
    input  wire        clk_25mhz,
    input  wire  [6:0] btn,
    input  wire  [3:0] sw,
    output logic [7:0] led,
    output logic       ftdi_rxd,
    output logic       wifi_gpio0,

    // J1 header: QSPI memory Pmod (Cartridge Pmod or stock TT QSPI Pmod)
    inout  wire  [3:0] pmod_gp,
    inout  wire  [3:0] pmod_gn,

    // J2 header: Tiny VGA Pmod (outputs only)
    output logic [3:0] vga_gp,
    output logic [3:0] vga_gn,

    // PS/2 keyboard: gp[8] = clock, gp[9] = data. Inputs only — koti's
    // ps2_rx samples the bus and never drives it, which is also why this
    // works on silicon, where `ui` is input-only.
    input  wire  [1:0] ps2_gp,

    // Onboard 32 MB SDRAM. This is the half of the memory map that used to be
    // the QSPI Pmod's PSRAM: same addresses, roughly ten times the speed and
    // four times the size. It exists here and not on the chip because it needs
    // forty pins, which is why the SoC builds it behind `KOTI_FPGA`.
    output logic        sdram_clk,
    output wire         sdram_cke,
    output wire         sdram_csn,
    output wire         sdram_rasn,
    output wire         sdram_casn,
    output wire         sdram_wen,
    output wire  [12:0] sdram_a,
    output wire  [1:0]  sdram_ba,
    output wire  [1:0]  sdram_dqm,
    inout  wire  [15:0] sdram_d
);

  assign wifi_gpio0 = 1'b1;                  // keep the ESP32 booted

  // ------------------------------------------------------- reset
  // BTN0 (PWR) is pulled up and reads 0 when pressed. The POR counter holds
  // reset for ~2.6 ms after configuration so the QSPI flash — which has its
  // own power-on timing — is ready before the first fetch goes out.
  logic [15:0] por = '0;
  always_ff @(posedge clk_25mhz) if (!(&por)) por <= por + 16'd1;

  wire por_done = &por;
  wire rst_n    = btn[0] && por_done;

  // ------------------------------------------------------- the chip
  wire [7:0] uo_out, uio_out, uio_oe;
  wire [7:0] uio_in;

  // ui[1:0] = PS/2 clock/data, ui[7:2] = the six board buttons as GPIO.
  // btn[1..6] are pulled down, so a press reads 1 at MMIO 0x10008.
  wire [7:0] ui_in = {btn[6:1], ps2_gp[1], ps2_gp[0]};

  // SDRAM data bus, resolved here rather than inside the SoC — same split as
  // the QSPI pins, and the same reason: a tri-state driver is a pad-ring
  // concern, not a design one.
  wire [15:0] sdram_dout;
  wire        sdram_doe;
`ifdef KOTI_FPGA
  assign sdram_d = sdram_doe ? sdram_dout : 16'bz;
`else
  // SDRAM build switched off: park the part safely rather than leaving its
  // pins floating. CKE low and CS# high means it ignores everything, so the
  // board is in a defined state and the QSPI Pmod serves RAM exactly as it did
  // before the swap. This branch exists so there is always a known-good
  // configuration to fall back to and to bisect against.
  assign sdram_d    = 16'bz;
  assign sdram_cke  = 1'b0;
  assign sdram_csn  = 1'b1;
  assign sdram_rasn = 1'b1;
  assign sdram_casn = 1'b1;
  assign sdram_wen  = 1'b1;
  assign sdram_a    = 13'd0;
  assign sdram_ba   = 2'd0;
  assign sdram_dqm  = 2'b11;
`endif

  // The part latches on the RISING edge of its own clock, so feeding it the
  // inverted system clock puts our outputs half a cycle ahead of it: 20 ns of
  // setup at 25 MHz, and 20 ns of hold on the way back. At this speed that is
  // ample and needs no ODDR or PLL phase shift.
  always_comb sdram_clk = ~clk_25mhz;

  tt_um_koti dut (
      .ui_in   (ui_in),
      .uo_out  (uo_out),
      .uio_in  (uio_in),
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
`ifdef KOTI_FPGA
      .sdram_cke  (sdram_cke),
      .sdram_csn  (sdram_csn),
      .sdram_rasn (sdram_rasn),
      .sdram_casn (sdram_casn),
      .sdram_wen  (sdram_wen),
      .sdram_a    (sdram_a),
      .sdram_ba   (sdram_ba),
      .sdram_dqm  (sdram_dqm),
      .sdram_dout (sdram_dout),
      .sdram_doe  (sdram_doe),
      .sdram_din  (sdram_d),
`endif
      .ena     (1'b1),
      .clk     (clk_25mhz),
      .rst_n   (rst_n)
  );

  // ------------------------------------------------------- J1: QSPI Pmod
  // uio numbering (TT QSPI Pmod standard):
  //   0=CS0 flash  1=SD0/MOSI  2=SD1/MISO  3=SCK  4=SD2  5=SD3  6=CS1 PSRAM
  //   7=CS2 — koti holds this high permanently, which is what makes the
  //   Cartridge Pmod (CS2 replaced by an audio chain) a drop-in fit here.
  //
  // Row algebra, identical to console's proven version:
  //   mapping A: gp[n] = uio[3-n], gn[n] = uio[7-n];  mapping B swaps rows.
  wire cart_map_b = sw[0];

  generate for (genvar n = 0; n < 4; n++) begin : g_cart_out
    wire [2:0] gpi = cart_map_b ? 3'(7 - n) : 3'(3 - n);
    wire [2:0] gni = cart_map_b ? 3'(3 - n) : 3'(7 - n);
    assign pmod_gp[n] = uio_oe[gpi] ? uio_out[gpi] : 1'bz;
    assign pmod_gn[n] = uio_oe[gni] ? uio_out[gni] : 1'bz;
  end endgenerate

  generate for (genvar k = 0; k < 8; k++) begin : g_cart_in
    assign uio_in[k] = ((k < 4) ^ cart_map_b) ? pmod_gp[3 - (k & 3)]
                                              : pmod_gn[3 - (k & 3)];
  end endgenerate

  // ------------------------------------------------------- J2: VGA Pmod
  // Same 2x6 geometry, so the same algebra — outputs only. In VGA mode uo
  // carries {HSync, B0/UART, G0, R0, VSync, B1, G1, R1}; in headless mode
  // the same pins carry UART/HALTED/LEDs and the monitor stays blank.
  wire vga_map_b = sw[1];

  generate for (genvar n = 0; n < 4; n++) begin : g_vga
    wire [2:0] pi = vga_map_b ? 3'(7 - n) : 3'(3 - n);
    wire [2:0] ni = vga_map_b ? 3'(3 - n) : 3'(7 - n);
    assign vga_gp[n] = uo_out[pi];
    assign vga_gn[n] = uo_out[ni];
  end endgenerate

  // ------------------------------------------------------- serial console
  // SW3 follows koti's uo personality: uo[0] while headless (the reset
  // default, and where every existing pin-level test expects it), uo[6]
  // once software has set VGA_EN and moved the UART to the blue LSB.
  assign ftdi_rxd = sw[2] ? uo_out[6] : uo_out[0];

  // ------------------------------------------------------- status LEDs
  // uo_out[3] is VSync in VGA mode, so counting it gives a free liveness
  // signal: blinking LEDs mean video timing is running. Useless while the
  // chip is headless (uo[3] is just LED1 there), hence the strap.
  wire vsync = uo_out[3];
  logic vsync_q;
  logic [7:0] frames;

  always_ff @(posedge clk_25mhz) begin
    vsync_q <= vsync;
    if (!rst_n)                 frames <= '0;
    else if (vsync && !vsync_q) frames <= frames + 8'd1;
  end

  // SW4 off = the raw chip personality, which is the view you want at first
  // power: LED0 flickers with UART traffic, LED1 is HALTED (a solid LED1
  // means the CPU hit EBREAK), LED2-7 are the software-driven LEDs at
  // MMIO 0x10000. SW4 on = the frame counter.
  always_comb led = sw[3] ? frames : uo_out;

endmodule

`default_nettype wire
