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
//   J1 gp/gn0-3  -> uio[7:0] QSPI memory Pmod  (SW1 flips rows)
//   J2 gp/gn4-7  -> uo[7:0]  Tiny VGA Pmod     (SW2 flips rows)
//   ftdi_rxd     -> uo[0] or uo[6]             (SW3 selects)
//   led[7:0]     -> uo[7:0] raw, or USB liveness (SW4 selects)
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
    // ⭐ THE FTDI'S TRANSMIT, i.e. OUR RECEIVE — site M1, from upstream
    // ulx3s_v20.lpf. Added 2026-08-09; before it koti could not be typed at
    // over the serial line at all, which is why every note in this project
    // calls the UART "transmit-only".
    // ⚠️ The naming is from the FTDI's point of view, as upstream has it:
    // ftdi_rxd is what the FTDI RECEIVES (we drive it) and ftdi_txd is what it
    // TRANSMITS (we read it). Wiring them by the local meaning of rx/tx gets
    // them backwards and produces a board that neither sends nor receives.
    input  wire        ftdi_txd,

    // ---- US2: USB HID keyboard, straight onto the FPGA ----
    // The bidirectional pair, which is what a soft host needs. `usb_fpga_dp/dn`
    // (E16/F16) are the differential INPUT-only pair and cannot drive a bus;
    // `usb_fpga_pu_dp/dn` (B12/C12) are the pull controls and are deliberately
    // left unconstrained — the ULX3S carries the host-side pull-downs on US2,
    // and the upstream usb_hid_host ULX3S example leaves them commented out too.
    inout  wire        usb_fpga_bd_dp,
    inout  wire        usb_fpga_bd_dn,

    // ---- GPDI / HDMI, koti's standard video output (user directive 2026-08-07)
    // Only the _p pin of each pair is a port: IO_TYPE=LVCMOS33D makes the ECP5
    // drive the paired _n site with the complement, so declaring gpdi_dn too
    // would be a SECOND DRIVER on the same pair. [0]=Blue [1]=Green [2]=Red
    // [3]=Clock, which is dvi_tx.sv's order.
    output wire  [3:0] gpdi_dp,

    // ---- onboard microSD, in SPI mode ----
    // The 4-bit SD bus used as SPI, exactly as console drives it on this board:
    // sd_clk = SCK, sd_cmd = MOSI, sd_d[3] = CS, sd_d[0] = MISO (driven by the
    // card, so the FPGA leaves it alone), and sd_d[2:1] are held HIGH because a
    // card in SPI mode expects its unused data lines idle-high rather than
    // floating.
    output logic       sd_clk,
    output logic       sd_cmd,
    inout  wire  [3:0] sd_d,
    // The ESP32's own serial pair, K3/K4. Verified against upstream's v3.1.6
    // constraint file, not remembered: unlike wifi_en (F1->J5) and wifi_gpio0
    // (L2->F1), these two did NOT move between board revisions.
    output logic       wifi_rxd,       // what the ESP32 RECEIVES — koti drives
    input  wire        wifi_txd,       // what the ESP32 TRANSMITS — koti reads
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

    // ---- J1, rows 8 and 9: the DS3231 RTC module's I2C bus (PLAN item 28) --
    // OPEN DRAIN, so both are `inout` and neither is ever driven high. The
    // pull-ups on the RTC module do that, with the ECP5's own weak pull-ups
    // (PULLMODE=UP in the LPF) as a fallback so the bus reads idle when
    // nothing is plugged in at all.
    //   rtc_scl  gp[8]  ball A4  J1 row 8, the "+" hole
    //   rtc_sda  gp[9]  ball A2  J1 row 9, the "+" hole
    //   rtc_sqw  gn[8]  ball A5  J1 row 8, the "-" hole — input only, spare
    inout  wire        rtc_scl,
    inout  wire        rtc_sda,
    input  wire        rtc_sqw,

    // ---- onboard 3.5 mm audio jack, 4-bit R2R ladder per channel ----
    // ⭐ THE ONE AUDIO PATH THAT NEEDS NO PMOD AND NO HEADER: these eight pins
    // ARE the DAC, and the socket is on the board. Every site is copied from
    // console/fpga/ulx3s.lpf, which played Beethoven out of this jack on this
    // board on 2026-08-04 — none of them is in the set that moved on PCB
    // v3.1.x (only five wifi_* pins did).
    // ⚠️ It is NOT the HDMI: koti's GPDI carries DVI, which has no audio.
    output wire  [3:0] audio_l,
    output wire  [3:0] audio_r,

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
  // ✅ THE REVISION IS SETTLED: **PCB v3.1.8**, read off the silkscreen by the
  // user on 2026-08-07. It had been carried as an open question because the pin
  // changed meaning across revisions, and upstream's v3.1.6 file annotates the
  // change itself:
  //     v3.0.x : F1 = wifi_en     (L2 = wifi_gpio0)
  //     v3.1.x : F1 = wifi_gpio0  (L2 = wifi_gpio22, wifi_en moved to J5)
  // ⛔ The board's USB descriptor says "85K v3.0.8" and it is WRONG — stale
  // factory EEPROM data, not the PCB revision. The silkscreen is the authority.
  //
  // ⇒ On this board F1 is `wifi_gpio0` and **J5 is the real enable**. Both are
  // driven low, which is correct here and would also have been correct on a
  // v3.0.x board, so the ambiguity is closed rather than merely survived:
  //   J5 = wifi_en  = 0  holds the ESP32 in reset — this is the one that counts
  //   F1 = gpio0    = 0  a boot-mode strap, read only when the ESP32 leaves
  //                      reset, so it is inert while J5 holds it there
  // Actively driven rather than pulled, so there is no ambiguity about who wins.
  //
  // ⚠️ THIS DID NOT FIX THE CARD. A bitstream holding both low still returned
  // SD_ERR (2026-08-07), so the ESP32 is now EXCLUDED as the cause rather than
  // suspected: it is provably held in reset on the revision the board actually
  // is. Do not spend another bitstream on ESP32 enables — use sw/sdraw.c.
  //
  // ⚠️ The line this replaces claimed "keep the ESP32 booted (it can power-cycle
  // the board otherwise)". If that is real the symptom is unmistakable — the
  // board dies and the COM port disappears — and it recovers by unplugging,
  // because every bitstream here is loaded to SRAM and gone at power-off. That
  // makes this a safe experiment rather than a gamble.
  // ⭐ SINCE 2026-08-10 THESE COME FROM SOFTWARE, and the power-on behaviour is
  // unchanged: esp_uart.sv's control register RESETS TO 0, so both pins are
  // driven low out of reset exactly as the two hardwired assignments below used
  // to drive them. What changes is that software can now raise them
  // deliberately — which is the only way to find out whether a booted ESP32
  // actually drives the six GPIOs it shares with the microSD, without spending
  // a bitstream per guess. And it can put the chip straight back into reset.
  //   J5 = wifi_en  = 0  holds the ESP32 in reset — this is the one that counts
  //   F1 = gpio0    = 0  a boot-mode strap, read only when it leaves reset
  //
  //   [was] assign wifi_gpio0 = 1'b0;
  //   [was] assign wifi_en    = 1'b0;

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

  // ui[7:2] = the six board buttons as GPIO; btn[1..6] are pulled down, so a
  // press reads 1 at MMIO 0x10008.
  // ui[1:0] were the PS/2 clock and data until 2026-08-08. PS/2 is gone and
  // gp[8]/gp[9] are unconstrained again, so these read a constant 0 rather
  // than a floating pin — GPIO_IN's low two bits are now defined, not noise.
  wire [7:0] ui_in = {btn[6:1], 2'b00};

  // SDRAM data bus, resolved here rather than inside the SoC — same split as
  // the QSPI pins, and the same reason: a tri-state driver is a pad-ring
  // concern, not a design one.
  wire [15:0] sdram_dout;
  wire        sdram_doe;
  assign sdram_d = sdram_doe ? sdram_dout : 16'bz;

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
      .sd_miso_drv(soc_sd_miso_drv),
      .sd_miso_oe (soc_sd_miso_oe),
      .uart_rxd   (ftdi_txd),
      // The ESP32 pair, crossed here exactly once and deliberately: koti's
      // transmitter drives what the ESP32 receives, and vice versa.
      .esp_rxd    (wifi_rxd),
      .esp_txd    (wifi_txd),
      .esp_en     (wifi_en),
      .esp_gpio0  (wifi_gpio0),
      .audio_l    (audio_l),
      .audio_r    (audio_r),
      .i2c_scl_oe (soc_i2c_scl_oe),
      .i2c_sda_oe (soc_i2c_sda_oe),
      .i2c_scl_in (rtc_scl),
      .i2c_sda_in (rtc_sda),
      .i2c_sqw_in (rtc_sqw),
      .dbg_halted (cpu_halted),
      .dbg_fetch  (cpu_fetch),
      .dbg_irq    (irq_state),
      .video_rgb  (video_rgb),
      .video_hs   (video_hs),
      .video_vs   (video_vs),
      .video_de   (video_de),
      .usb_report_tog   (usb_report_tog),
      .usb_typ          (usb_typ),
      .usb_conerr       (usb_conerr),
      .usb_key_modifiers(usb_key_modifiers),
      .usb_key1(usb_key1), .usb_key2(usb_key2),
      .usb_key3(usb_key3), .usb_key4(usb_key4),
      .ena     (1'b1),
      .clk     (clk_25mhz),
      .rst_n   (rst_n)
  );

  // ------------------------------------------------------- onboard microSD
  wire soc_sd_cs_n, soc_sd_sck, soc_sd_mosi;
  wire soc_sd_miso_drv, soc_sd_miso_oe;
  assign sd_clk  = soc_sd_sck;
  assign sd_cmd  = soc_sd_mosi;
  assign sd_d[3] = soc_sd_cs_n;
  assign sd_d[2] = 1'b1;
  assign sd_d[1] = 1'b1;
  // MISO: the card drives this, EXCEPT during the bring-up continuity test.
  //
  // ⛔⛔ DO NOT "SIMPLIFY" THIS BACK TO `assign sd_d[0] = 1'bz;`. THAT LINE IS
  // WHAT BROKE THE SD CARD FOR A DAY, and the failure is completely silent.
  //
  // With a bare `1'bz` and no other driver, yosys has nothing to build a
  // tristate out of, so the port collapses to a plain INPUT — and on a plain
  // input the LPF's `PULLMODE=UP` did not take effect. Proof, from the two
  // nextpnr logs of 2026-08-07:
  //     before: pin 'sd_d[0]$tr_io' constrained ...        (no $iobuf_i at all)
  //     after:  $sd_d[0]$iobuf_i: sd_d_$_TBUF__Y.Y         (a real tristate)
  // The pin then floated LOW instead of high, so every byte clocked in off the
  // card read 0x00, `sd_spi` never saw a response, and `sdtest` reported
  // `init: FAILED, status 00000004` — which reads exactly like "no card". The
  // card was healthy the whole time (verified in a PC reader: 29.12 GB, FAT32).
  //
  // Keeping a real `$_TBUF_` here is therefore LOAD-BEARING even though
  // `soc_sd_miso_oe` is 0 in all normal operation: the tristate is what makes
  // this a bidirectional IO, and a bidirectional IO is what carries the pull-up.
  // ⚠️ Nothing in CI can catch a regression here — the simulation model supplies
  // its own pull-up, so a bench stays green while the board goes deaf. The check
  // is the nextpnr log line above.
  assign sd_d[0] = soc_sd_miso_oe ? soc_sd_miso_drv : 1'bz;

  // ------------------------------------------------- J1 rows 8/9: the RTC
  // ⛔ OPEN DRAIN, AND THE `1'b0` IS THE WHOLE POINT: there is no expression
  // here that can put a 1 on either wire. I2C is wired-AND — the DS3231 pulls
  // SDA down to acknowledge a byte, and a master that drove high at that
  // instant would be a short circuit through two output stages.
  //
  // ⚠️ THE SAME TRISTATE TRAP AS sd_d[0] ABOVE APPLIES, and it would be worse
  // here. If this ever collapses to a plain output or a plain input, the LPF's
  // PULLMODE=UP stops taking effect and the bus floats — an I2C bus that
  // floats does not fail cleanly, it reads whatever the last edge left on the
  // trace. Verified in yosys 2026-08-14 on a minimal case: `oe ? 1'b0 : 1'bz`
  // synthesises to `$_TBUF_` with A tied to 0 and E from a register, while a
  // bare `1'bz` leaves the port bit as the literal 'z' with no driver at all.
  // fpga/ulx3s/check_tristate.py now asserts that on the REAL netlist, in CI,
  // which is the gate sd_d[0]'s comment says does not exist.
  wire soc_i2c_scl_oe, soc_i2c_sda_oe;
  assign rtc_scl = soc_i2c_scl_oe ? 1'b0 : 1'bz;
  assign rtc_sda = soc_i2c_sda_oe ? 1'b0 : 1'bz;

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
  //
  // ⚠️ NOT CURRENTLY DISPLAYED — SW4 shows USB liveness instead (2026-08-09),
  // because a working HDMI monitor already answers "is video running?" and
  // nothing else answered "is the USB host still there?". Kept, and cheap
  // (yosys prunes it), so re-pointing SW4 at `frames` is a one-line change if
  // video ever needs watching without a monitor.
  wire vsync = uo_out[3];
  logic vsync_q;
  logic [7:0] frames;

  always_ff @(posedge clk_25mhz) begin
    vsync_q <= vsync;
    if (!rst_n)                 frames <= '0;
    else if (vsync && !vsync_q) frames <= frames + 8'd1;
  end

  // ------------------------------------------------- USB HID keyboard (US2)
  // The core is vendored (vendor/usb_hid_host.v, Apache-2.0, and its author
  // ships a ULX3S example that this wiring follows). It does the whole USB
  // protocol with no CPU: enumeration, boot protocol, periodic IN transfers.
  //
  // ⚠️ IT NEEDS 12 MHz AND KOTI RUNS AT 25. USB low speed is 1.5 Mbps and the
  // core oversamples 8x, so 12 MHz is not negotiable — it is the bit rate. The
  // two clocks are unrelated, so a proper crossing is mandatory; src/usb_kbd.sv
  // does it, and everything crossing is the ONE toggle generated below.
  wire clk_usb, usb_pll_lock;
  // ⚠️ The module really is called `clock` — a regrettably generic name, but it
  // is vendored verbatim from the core author's own ULX3S example and renaming
  // it would break the "byte-identical copy" audit that vendor/README rests on.
  // It burns TWO PLLs (25->100, then 100->12); with the HDMI PLL that is three
  // of the 85F's four.
  clock uclk (.clkin(clk_25mhz), .clk12(clk_usb), .clk100(), .locked(usb_pll_lock));

  wire       usb_report;        // one 12 MHz clock wide — do NOT cross this
  wire [1:0] usb_typ;
  wire       usb_conerr;
  wire [7:0] usb_key_modifiers, usb_key1, usb_key2, usb_key3, usb_key4;

  usb_hid_host usbhid (
      .usbclk(clk_usb), .usbrst_n(usb_pll_lock),
      .usb_dm(usb_fpga_bd_dn), .usb_dp(usb_fpga_bd_dp),
      .typ(usb_typ), .report(usb_report), .conerr(usb_conerr),
      .key_modifiers(usb_key_modifiers),
      .key1(usb_key1), .key2(usb_key2), .key3(usb_key3), .key4(usb_key4),
      .mouse_btn(), .mouse_dx(), .mouse_dy(),
      .game_l(), .game_r(), .game_u(), .game_d(),
      .game_a(), .game_b(), .game_x(), .game_y(), .game_sel(), .game_sta(),
      .dbg_hid_report()
  );

  // THE ONLY SIGNAL THAT CROSSES. A 12 MHz single-clock pulse is 83 ns; a
  // 25 MHz sampler has no guarantee of catching it, and "usually catches it"
  // means dropped keystrokes that look like a flaky keyboard. A toggle cannot
  // be missed however the clocks drift, so the pulse is converted here, in the
  // domain that owns it, and usb_kbd edge-detects it on the other side.
  logic usb_report_tog = 1'b0;
  always_ff @(posedge clk_usb) if (usb_report) usb_report_tog <= ~usb_report_tog;

  // ---- USB liveness on the LEDs, because a dead keyboard cannot be asked ----
  // The instrument this design lacked on 2026-08-09. When the keyboard stops
  // responding there is no way in: the UART is transmit-only, the screen's
  // shell needs the keyboard, and reading the status register needs a shell.
  // A lamp needs none of them.
  //
  // ⚠️ READ THIS BEFORE INTERPRETING THE LAMPS. `report` pulses when a report
  // is RECEIVED (the falling edge of `data_rdy` in vendor/usb_hid_host.v), and
  // a HID keyboard NAKs the host's poll when nothing has changed. So these bits
  // move WHILE KEYS ARE PRESSED and sit still when the keyboard is idle:
  // **a frozen counter on an untouched keyboard is normal, not a fault.**
  // The test is to mash keys and watch. (The first version of this comment
  // claimed ~125 reports/s regardless of typing, which would have made an idle
  // board look like a dead core — corrected 2026-08-09 after reading the core.)
  //
  // What it does answer, and nothing else could: on 2026-08-09 the keyboard
  // appeared dead while these bits still counted under a keypress, with typ=01
  // and conerr clear — which cleared the USB core outright and moved the hunt
  // downstream, where it belonged.
  logic [7:0] usb_rep_cnt = 8'd0;
  always_ff @(posedge clk_usb) if (usb_report) usb_rep_cnt <= usb_rep_cnt + 8'd1;

  // Brought into the SoC domain for display only. The four bits are NOT
  // sampled coherently and do not need to be — this drives lamps, and the
  // question is "is this counting?", not "what is the count?".
  logic [3:0] usb_rep_q, usb_rep_qq;
  always_ff @(posedge clk_25mhz) begin
      usb_rep_q  <= usb_rep_cnt[7:4];
      usb_rep_qq <= usb_rep_q;
  end
  // ---- CPU liveness, the other half of the lamp ----
  // `dbg_fetch` is one clock wide per fetch ack, far too fast to see, so it is
  // divided down. A CPU that is executing rolls these bits; a CPU that has
  // stopped freezes them. Together with `cpu_halted` that separates the three
  // states this board could not tell apart on 2026-08-09:
  //   halted lit                      -> EBREAK in M-mode; the firmware stopped
  //   halted dark, activity ROLLING   -> the CPU runs; the fault is above it
  //                                      (a loop, an IRQ storm, stuck userspace)
  //   halted dark, activity FROZEN    -> not fetching at all: stalled on memory
  wire cpu_halted, cpu_fetch;
  wire [4:0] irq_state;   // {keyrep, enq, fifo_has_data, pending, inflight}
  // Two COUNTERS, because the levels below them are microsecond pulses on a
  // healthy machine and therefore read the same as a dead one.
  //   kb_enq  rolls when usb_kbd turns a report into a queued keystroke
  //   kb_key  rolls when a report arrives that CONTAINS a key at all
  logic [17:0] kb_enq = 18'd0, kb_key = 18'd0;
  logic [23:0] cpu_act = 24'd0;
  always_ff @(posedge clk_25mhz) if (cpu_fetch) cpu_act <= cpu_act + 24'd1;
  always_ff @(posedge clk_25mhz) begin
      if (irq_state[3]) kb_enq <= kb_enq + 18'd1;
      if (irq_state[4]) kb_key <= kb_key + 18'd1;
  end

  // ⚠️ `cpu_act` rolling means the CPU is EXECUTING. It does NOT mean the CPU
  // is spinning — a healthy idle Linux fetches instructions too. It separates
  // halted / stalled / executing and nothing finer. (Read as "spinning" on
  // 2026-08-09, which sent the hunt after a hang that was not happening.)
  //
  // ⭐ THE THREE BITS THAT MATTER NOW, straight from the interrupt path:
  //   LED6 inflight   claimed and not completed. STUCK HIGH = the wedge:
  //                   ip[1] is pinned to 0 and the keyboard is never delivered
  //                   again until reset.
  //   LED5 pending    the PLIC is offering the interrupt to the hart
  //   LED4 fifo       usb_kbd has a keystroke waiting for Linux
  // With a dead keyboard: LED4 lit + LED6 lit = claim without complete.
  // LED4 DARK while keys are pressed = the keystrokes never reached the queue,
  // so the fault is in usb_kbd's diff and not in the interrupt path at all.
  // LED7 halted | LED6:5 ENQUEUED keystrokes | LED4:3 KEYED reports
  // LED2 fifo occupied | LED1:0 all USB reports
  wire [7:0] usb_diag = {cpu_halted, kb_enq[1:0], kb_key[1:0],
                         irq_state[2], usb_rep_qq[1:0]};

  // ------------------------------------------------------------ GPDI / HDMI
  // koti's standard video output (user directive 2026-08-07). The encoder trio
  // is vendored VERBATIM from console, which drove this exact board's HDMI on
  // 2026-08-06 — see vendor/README.md. A TMDS encoder is not where original
  // work belongs.
  wire [5:0] video_rgb;
  wire       video_hs, video_vs, video_de;

  wire clk_shift, pll_lock;
  pll_25_125 pll (.clkin(clk_25mhz), .clkout0(clk_shift), .locked(pll_lock));

  // Reset out of a FLOP in the shift domain, never straight off a pad through a
  // LUT: console measured 5.3 ns on one such hop across this die, against an
  // 8 ns period at 125 MHz. Deliberately NOT gated on the SoC's reset — the
  // video link keeps running while the CPU is held in reset, so the monitor
  // holds its lock rather than resyncing on every BTN0.
  logic [1:0] rst_sh_q;
  always_ff @(posedge clk_shift) rst_sh_q <= {rst_sh_q[0], !pll_lock};
  wire rst_shift = rst_sh_q[1];

  // RGB222 -> 8 bits per channel by REPLICATION, not zero-padding: {2{2'b11}}
  // is 0xFF so full-scale stays full-scale, whereas 2'b11 << 6 would cap white
  // at 0xC0 and make the whole picture dim. dvi_tx takes the top bits it needs.
  wire [1:0] px_r = video_rgb[5:4];
  wire [1:0] px_g = video_rgb[3:2];
  wire [1:0] px_b = video_rgb[1:0];

  wire dvi_phase_err;
  dvi_tx dvi (
      .clk_pixel (clk_25mhz),
      .clk_shift (clk_shift),
      .rst_shift (rst_shift),
      .r ({4{px_r}}), .g ({4{px_g}}), .b ({4{px_b}}),
      .hsync (video_hs), .vsync (video_vs), .de (video_de),
      .gpdi_dp (gpdi_dp), .phase_err (dvi_phase_err)
  );

  // SW4 off = the raw chip personality, which is the view you want at first
  // power: LED0 flickers with UART traffic, LED1 is HALTED (a solid LED1
  // means the CPU hit EBREAK), LED2-7 are the software-driven LEDs at
  // MMIO 0x10000.
  //
  // SW4 on = LIVENESS (changed 2026-08-09; it used to be the frame counter).
  // The frame counter answered "is video running?" — a question the HDMI
  // monitor now answers by being lit. These answer the two that nothing else
  // could, and each cost a wrong diagnosis on the day they were added:
  //   LED7  HALTED    — the core hit EBREAK in M-mode. ⭐ Works in VGA mode,
  //                     unlike uo[1], whose HALTED lamp is replaced by a video
  //                     bit the moment software enables the display — i.e. it
  //                     was missing in exactly the mode that runs the OS.
  //   LED6  inflight  — PLIC source 1 claimed and NOT completed
  //   LED5  pending   — PLIC source 1 offered to the hart
  //   LED4  fifo      — usb_kbd has a keystroke queued for Linux
  //   LED3:2 CPU      — rolling = instructions are being fetched
  //   LED1:0 USB      — rolling WHILE KEYS ARE PRESSED = reports arriving
  // ⚠️ LED1:0 frozen on an untouched keyboard is NORMAL, and LED3:2 rolling
  // means EXECUTING, not spinning — an idle Linux rolls it too.
  // The keyboard path reads left to right: reports arrive (LED1:0) -> a
  // keystroke is queued (LED4) -> the PLIC offers it (LED5) -> a handler
  // claims it (LED6 pulses and clears). LED6 stuck ON is the wedge; LED4 dark
  // under typing means the queue never saw the key.
`ifdef KOTI_FLASH_BRAM
  // led[7] carries the fabric flash's `bad_cmd` instead of uo[7]. uo[7] is the
  // top LED bit in headless mode and carries nothing a person watches, whereas
  // an opcode this model does not implement is the difference between "the SoC
  // is broken" and "the memory refused a command" — and that is worth a lamp
  // rather than a waveform. With SW4 on, the frame counter still wins.
  always_comb led = sw[3] ? usb_diag : {flash_bad_cmd, uo_out[6:0]};
`else
  always_comb led = sw[3] ? usb_diag : uo_out;
`endif

endmodule

`default_nettype wire
