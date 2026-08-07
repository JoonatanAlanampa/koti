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

    // ---- onboard microSD, in SPI mode ----
    // The 4-bit SD bus used as SPI, exactly as console drives it on this board:
    // sd_clk = SCK, sd_cmd = MOSI, sd_d[3] = CS, sd_d[0] = MISO (driven by the
    // card, so the FPGA leaves it alone), and sd_d[2:1] are held HIGH because a
    // card in SPI mode expects its unused data lines idle-high rather than
    // floating.
    output logic       sd_clk,
    output logic       sd_cmd,
    inout  wire  [3:0] sd_d,
    output logic       wifi_gpio0,
    // wifi_en on a v3.1.x board; NOT ASSIGNED AT ALL in the v2.0/v3.0.x
    // constraint file, so driving it there costs nothing. Belt and braces with
    // F1: whichever revision this board is, one of the two pins is the ESP32's
    // enable and both are held low, so the ESP32 cannot be awake on the microSD
    // bus it shares with us.
    output logic       wifi_en,

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

  // ⛔ DRIVEN LOW, AND IT IS WHY THE SD CARD CAN WORK AT ALL.
  //
  // The SD bus IS the ESP32's GPIOs — upstream's constraint file says so:
  //   sd_clk=GPIO14 sd_cmd=GPIO15 sd_d[0]=GPIO2 sd_d[1]=GPIO4
  //   sd_d[2]=GPIO12 sd_d[3]=GPIO13
  //   "# wifi_gpio2,4,12,13,14,15 are shared with SD card."
  // An ESP32 that is awake and driving those pins fights the FPGA for the card,
  // and the FPGA loses on whichever line the ESP32 holds.
  //
  // AND F1 IS THE ESP32's ENABLE ON THIS BOARD. The pin changed meaning across
  // revisions, and upstream's v3.1.6 file annotates the change itself:
  //     v3.0.x : F1 = wifi_en     (L2 = wifi_gpio0)
  //     v3.1.x : F1 = wifi_gpio0  (L2 = wifi_gpio22, wifi_en moved to J5)
  // The board's USB descriptor says "85K v3.0.8", which had been written off as
  // stale factory data. On v3.0.x that makes F1 `wifi_en`, so the pull-up this
  // line used to carry was ENABLING the ESP32 onto the SD bus.
  //
  // LOW is correct on either revision: on v3.0.x it holds the ESP32 in reset; on
  // v3.1.x it is gpio0, which puts the ESP32 in serial-download mode where it
  // runs no firmware and drives none of the shared pins. Actively driven rather
  // than pulled, so there is no ambiguity about who wins the pin.
  //
  // ⚠️ The line this replaces claimed "keep the ESP32 booted (it can power-cycle
  // the board otherwise)". If that is real the symptom is unmistakable — the
  // board dies and the COM port disappears — and it recovers by unplugging,
  // because every bitstream here is loaded to SRAM and gone at power-off. That
  // makes this a safe experiment rather than a gamble.
  assign wifi_gpio0 = 1'b0;
  assign wifi_en    = 1'b0;      // the v3.1.x enable; unused on v3.0.x

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
      .sd_cs_n    (soc_sd_cs_n),
      .sd_sck     (soc_sd_sck),
      .sd_mosi    (soc_sd_mosi),
      .sd_miso    (sd_d[0]),
`endif
      .ena     (1'b1),
      .clk     (clk_25mhz),
      .rst_n   (rst_n)
  );

  // ------------------------------------------------------- onboard microSD
`ifdef KOTI_FPGA
  wire soc_sd_cs_n, soc_sd_sck, soc_sd_mosi;
  assign sd_clk  = soc_sd_sck;
  assign sd_cmd  = soc_sd_mosi;
  assign sd_d[3] = soc_sd_cs_n;
  assign sd_d[2] = 1'b1;
  assign sd_d[1] = 1'b1;
  assign sd_d[0] = 1'bz;                  // MISO: the card drives this
`else
  // The QSPI build has no SD peripheral, so park the bus rather than leave it
  // floating: CS high means the card ignores the pins entirely.
  assign sd_clk  = 1'b0;
  assign sd_cmd  = 1'b1;
  assign sd_d    = {1'b1, 1'b1, 1'b1, 1'bz};
`endif

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

  wire [7:0] uio_in_pmod;
  generate for (genvar k = 0; k < 8; k++) begin : g_cart_in
    assign uio_in_pmod[k] = ((k < 4) ^ cart_map_b) ? pmod_gp[3 - (k & 3)]
                                                   : pmod_gn[3 - (k & 3)];
  end endgenerate

`ifdef KOTI_FLASH_BRAM
  // ---------------------------------------- the boot flash, in fabric
  // With nothing on J1 the CPU cannot fetch, so the board could only ever be
  // checked as far as "it configures". `bram_flash` is a QSPI device on these
  // same wires, backed by block RAM — see that file for why it answers on the
  // negedge. The controller, the arbiter and the I-cache are untouched and all
  // still run on hardware; only the part on the other end of the bus is ours.
  //
  // The J1 OUTPUT drivers above are left exactly as they are, deliberately:
  // CS, SCK and MOSI keep reaching the header, so the transaction can be put on
  // a scope, and a real Pmod could even be seated alongside — its MISO would
  // land on a pin nothing reads. Only the INPUT side is redirected.
  //
  // ⚠️ SW1 (the seating strap) therefore does NOTHING in this build. It is not
  // broken; there is no seating to be wrong about.
  wire fabric_miso, flash_bad_cmd;

  bram_flash #(
      .FLASH_BYTES(32768),
      // Overridable so a bench can point at its own image without editing this
      // file; the default is what the builders generate.
`ifdef KOTI_FLASH_HEX
      .IMAGE_HEX  (`KOTI_FLASH_HEX)
`else
      .IMAGE_HEX  ("fpga/ulx3s/build/flash.hex")
`endif
  ) flash (
      .clk     (clk_25mhz),
      .rst     (!rst_n),
      .cs_n    (uio_out[0]),
      .sck     (uio_out[3]),
      .mosi    (uio_out[1]),
      .miso    (fabric_miso),
      .bad_cmd (flash_bad_cmd)
  );

  // Everything the controller does not read is tied low rather than left to the
  // header: an unseated Pmod is a floating wire, and x reaching sd_in poisons
  // the shift register the CPU is about to execute out of.
  assign uio_in = {5'b0, fabric_miso, 2'b0};   // only uio[2] = sd_in[1] is read

  wire _unused_pmod_in = &{1'b0, uio_in_pmod};
`else
  assign uio_in = uio_in_pmod;
`endif

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
`ifdef KOTI_FLASH_BRAM
  // led[7] carries the fabric flash's `bad_cmd` instead of uo[7]. uo[7] is the
  // top LED bit in headless mode and carries nothing a person watches, whereas
  // an opcode this model does not implement is the difference between "the SoC
  // is broken" and "the memory refused a command" — and that is worth a lamp
  // rather than a waveform. With SW4 on, the frame counter still wins.
  always_comb led = sw[3] ? frames : {flash_bad_cmd, uo_out[6:0]};
`else
  always_comb led = sw[3] ? frames : uo_out;
`endif

endmodule

`default_nettype wire
