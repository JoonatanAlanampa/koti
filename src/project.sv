/*
 * Koti-1 — RV32IMA + Zicsr Linux-track SoC (headless v1).
 * koti_core (M-mode traps, muldiv, AMOs) + QSPI XIP memory + CLINT.
 *
 * Pinout (TinyTapeout QSPI Pmod standard on uio):
 *   uio[0] CS0 flash (out)    uio[4] SD2 (unused in SPI mode)
 *   uio[1] SD0/MOSI (out)     uio[5] SD3 (unused in SPI mode)
 *   uio[2] SD1/MISO (in)      uio[6] CS1 PSRAM (out)
 *   uio[3] SCK (out)          uio[7] CS2 (out, held high)
 *
 *   uo[0] UART TX (115200 8N1 @ 25 MHz)   uo[1] halted (EBREAK)
 *   uo[7:2] LED[5:0] (MMIO 0x10000)       ui[7:0] GPIO in (MMIO 0x10008)
 *
 * Headless v1: same demo-board layout as tt-riscv. The VGA/PS/2 pin
 * plan (PLAN.md) replaces uo/ui when the text controller lands.
 *
 * SoC MMIO on the data port: CLINT at 0x0002_0000 (mtime/mtimecmp/
 * msip), 1-cycle ack, intercepted before the memory arbiter.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// KOTI_FPGA: build the ULX3S variant, where the RAM half of the memory map is
// served by the board's onboard 32 MB SDRAM instead of the QSPI Pmod's PSRAM.
//
// Why a define rather than a second top: this file IS the SoC, and copying it
// would mean two versions of the CPU/video/arbiter wiring drifting apart. Why a
// define rather than a parameter: the SDRAM needs about forty pins, and a
// module's port list is not parameterisable.
//
// The memory MAP is deliberately unchanged — addr[22] still picks flash from
// RAM and RAM still starts at 0x01000000 — so the linker scripts, the SBI
// firmware, the charbuf address and every existing test carry over untouched.
// Only the thing on the other end of the request port changes. The cost is that
// the 16 MB window reaches half of the 32 MB part; widening it would mean a
// wider address bus through the core and the arbiter, for memory that mainline
// sv32 Linux does not need.
module tt_um_koti (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
`ifdef KOTI_FPGA
    output wire        sdram_cke,
    output wire        sdram_csn,
    output wire        sdram_rasn,
    output wire        sdram_casn,
    output wire        sdram_wen,
    output wire [12:0] sdram_a,
    output wire [1:0]  sdram_ba,
    output wire [1:0]  sdram_dqm,
    output wire [15:0] sdram_dout,
    output wire        sdram_doe,
    input  wire [15:0] sdram_din,
    // microSD in SPI mode. FPGA-only for the same reason the SDRAM pins are:
    // a TinyTapeout tile has no pin to spare — all 8 `uo` are the VGA Pmod, all
    // 8 `uio` the memory Pmod, and `ui` is input-only. On the ULX3S these land
    // on the onboard card slot.
    output wire        sd_cs_n,
    output wire        sd_sck,
    output wire        sd_mosi,
    input  wire        sd_miso,
    // Bring-up only: let software drive the MISO pin, to tell "the card is
    // silent" apart from "this pin is not the card's MISO". Both read 0 on a
    // board whose resting level is low, which is exactly what koti met on
    // 2026-08-07. See the SD_RAW block in src/sd_ctrl.sv.
    output wire        sd_miso_drv,
    output wire        sd_miso_oe,
    // Raw video for the harness's HDMI encoder. FPGA-only for the usual
    // reason — a TinyTapeout tile has no pin to spare — but ALSO because the
    // `uo` VGA personality genuinely cannot drive an HDMI link: it packs RGB222
    // and the two syncs into eight pins and carries **no `de`**, and a TMDS
    // encoder needs to know where the visible box is. console had to build a
    // timing replica to re-derive it; koti's vga_timing already produces
    // `active`, so it is exported here instead and the replica is unnecessary.
    output wire [5:0]  video_rgb,      // RGB222, {R1,R0,G1,G0,B1,B0}
    output wire        video_hs,       // active low
    output wire        video_vs,       // active low
    output wire        video_de,       // high inside the visible box
    // USB HID keyboard, from vendor/usb_hid_host.v in the harness. The core
    // needs its own 12 MHz domain, so it lives out there and only its results
    // come in here; src/usb_kbd.sv does the crossing.
    // ⚠️ `usb_report_tog` is a TOGGLE, not the core's one-clock pulse.
    input  wire        usb_report_tog,
    input  wire [1:0]  usb_typ,
    input  wire        usb_conerr,
    input  wire [7:0]  usb_key_modifiers,
    input  wire [7:0]  usb_key1, usb_key2, usb_key3, usb_key4,
`endif
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire rst = ~rst_n;

  wire        halted;
  wire [7:0]  led;
  wire        uart_txd;
  wire        mtip, msip;
  wire        kb_irq;      // pending keyboard byte -> meip (legacy, inert)
  // Declared here rather than beside the plic instance: the core is
  // instantiated above that point, and this file is read by a simulator that
  // rejects declare-after-use (the same constraint that produced koti_core's
  // forward-declaration block).
  wire        plic_eip;    // PLIC -> the core's S-level external interrupt

  wire        if_req, if_ack;
  wire [22:0] if_addr;
  // What the CORE sees on its fetch port. Without a cache these are just the
  // memory bus; with one they are the cache's answer.
  wire [31:0] if_rdata, if_rdata2;
  wire        if_ptw, icache_flush;
  // What the ARBITER sees on its fetch port. Same signals one level out.
  wire        fc_req, fc_ack;
  wire [22:0] fc_addr;
  wire        d_req, d_we, d_ack;
  wire [22:0] d_addr;
  wire [31:0] d_wdata, d_rdata;
  wire [3:0]  d_be;

  wire        m_req, m_we, m_burst, m_ack;
  wire [22:0] m_addr;
  wire [31:0] m_wdata, m_rdata, m_rdata2;
  wire [3:0]  m_be;

  wire sck, cs_flash_n, cs_ram_n;
  wire [3:0] sd_out, sd_oe, sd_in;
  wire [1:0] qspi_cfg;

  // 217 = 25 MHz / 115200. In the boot simulation it is 8 instead, and that is
  // not cosmetic: the firmware's uart_putc polls `busy`, so the divisor sets
  // how fast software can print, and a kernel boot log is thousands of
  // characters. At 217 the log alone costs several million clocks — more than
  // the boot. Nothing about the UART's correctness depends on the value; the
  // real one is tested at 217 by every other suite in the repo.
`ifdef KOTI_SIMMEM
  localparam UDIV = 8;
`else
  localparam UDIV = 217;
`endif

  koti_core #(.UART_DIV(UDIV)) core (
      .clk(clk), .rst(rst),
      .mtip(mtip), .msip(msip), .meip(kb_irq), .seip(plic_eip),
      .halted(halted), .led(led), .uart_txd(uart_txd), .gpio_in(ui_in),
      .qspi_cfg(qspi_cfg),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(if_rdata), .if_rdata2(if_rdata2),
      .if_ptw(if_ptw), .icache_flush(icache_flush),
      .d_req(d_req), .d_we(d_we), .d_addr(d_addr), .d_wdata(d_wdata),
      .d_be(d_be), .d_ack(d_ack), .d_rdata(d_rdata)
  );

  // SoC MMIO intercepts on the data port. d_addr = byte_addr[24:2], so
  // d_addr[22:14] == byte_addr[24:16]. Decode the FULL 64 KB windows:
  // CLINT at 0x0002_0000 (byte[24:16]==0x002), VGA/PS2 at 0x0004_0000
  // (0x004). 1-cycle ack, never reaches the arbiter. A partial compare
  // aliased flash data past 64 KB into these windows every 512 KB (F1).
  wire clint_range = d_addr[22:14] == 9'h002;
  wire vga_range   = d_addr[22:14] == 9'h004;
`ifdef KOTI_FPGA
  // microSD at 0x0005_0000, the next free 64 KB window after VGA/PS2. Decoded
  // in FULL like the others: a partial compare aliased flash data into these
  // windows every 512 KB (defect F1), which is the sort of bug that reads as
  // random memory corruption.
  wire sd_range    = d_addr[22:14] == 9'h005;
  // USB HID keyboard at 0x0006_0000, the next window after the microSD. Same
  // full compare, same reason.
  wire usb_range   = d_addr[22:14] == 9'h006;
`else
  wire sd_range    = 1'b0;
  wire usb_range   = 1'b0;
`endif
  // PLIC: the TOP 4 MB of flash address space, 0x00C0_0000..0x00FF_FFFF.
  //
  // It cannot live in a 64 KB carve-out beside the CLINT: the SiFive layout
  // puts the context registers at offset 0x200000 and mainline's driver
  // hard-codes that, so a register-compatible PLIC needs megabytes of window.
  // Taking it off the TOP of flash space rather than punching a hole in the
  // low addresses keeps software's run from zero contiguous.
  wire plic_range  = !d_addr[22] && d_addr[21:20] == 2'b11;
  wire clint_sel   = d_req && clint_range;
  wire vga_sel     = d_req && vga_range;
  wire sd_sel_i    = d_req && sd_range;
  wire usb_sel_i   = d_req && usb_range;
  wire plic_sel    = d_req && plic_range;
  reg  clint_ack, vga_ack, plic_ack, sd_ack, usb_ack;
  always @(posedge clk) begin
      clint_ack <= rst ? 1'b0 : (clint_sel && !clint_ack);
      vga_ack   <= rst ? 1'b0 : (vga_sel && !vga_ack);
      sd_ack    <= rst ? 1'b0 : (sd_sel_i && !sd_ack);
      usb_ack   <= rst ? 1'b0 : (usb_sel_i && !usb_ack);
      plic_ack  <= rst ? 1'b0 : (plic_sel && !plic_ack);
  end

  wire [31:0] clint_rdata;
  clint clint0 (
      .clk(clk), .rst(rst),
      .sel(clint_sel && !clint_ack), .we(d_we),
      .addr({d_addr[2:0], 2'b00}), .wdata(d_wdata), .rdata(clint_rdata),
      .mtip(mtip), .msip(msip)
  );

  // ---- VGA/PS2 register block: +0 ctrl (bit0 VGA_EN, bit1 UART on
  // the blue LSB), +4 charbuf byte address, +8 {bg[13:8], fg[5:0]},
  // +C PS/2 {avail[8], scancode[7:0]} (read clears avail) ----
  reg        vga_en, uart_b0;
  reg [22:0] vga_base;
  reg [5:0]  col_fg, col_bg;
  reg [7:0]  kb_code;
  reg        kb_avail;
  reg        kb_ovf;

  wire vga_wr = vga_sel && !vga_ack && d_we;
  wire vga_rd = vga_sel && !vga_ack && !d_we;
  always @(posedge clk)
      if (rst) begin
          vga_en <= 1'b0; uart_b0 <= 1'b0;
          vga_base <= 23'd0; col_fg <= 6'h3F; col_bg <= 6'h00;
      end else if (vga_wr)
          case (d_addr[1:0])
              2'd0: {uart_b0, vga_en} <= d_wdata[1:0];
              2'd1: vga_base <= d_wdata[24:2];
              2'd2: {col_bg, col_fg} <= {d_wdata[13:8], d_wdata[5:0]};
              default: ;
          endcase

  wire [7:0] ps2_code;
  wire       ps2_valid;
  ps2_rx #(.CLK_HZ(25_000_000)) ps2 (
      .clk(clk), .rst(rst),
      .ps2_clk(ui_in[0]), .ps2_dat(ui_in[1]),
      .data(ps2_code), .valid(ps2_valid)
  );
  // Keyboard byte: ONE entry, no FIFO — but it now REPORTS the byte it drops.
  //
  // Against a real keyboard the single entry is ample: a PS/2 device clocks at
  // 10-16.7 kHz, so a frame takes 0.7-1.1 ms, while software polling this
  // register through QSPI-XIP code gets round roughly every 7000 clocks
  // (~0.28 ms). Three to four polls per frame. Feed it frames any faster — as
  // test.py's first attempt did, at ~2200 clocks apart — and a byte is lost.
  //
  // Losing one is survivable. Losing one SILENTLY is not, once anything
  // decodes set-2 sequences: a dropped 0xF0 turns the next release into a
  // phantom press, a byte dropped after 0xE0 leaves the decoder waiting for a
  // second byte that already went by. One lost byte becomes a stream of wrong
  // characters, and software has no way to suspect it. Hence `kb_ovf` at
  // bit 9 of the read word: set when a byte arrives on top of an unread one,
  // cleared by the same read that clears `kb_avail`. A driver that sees it
  // knows to throw its prefix state away and resynchronise.
  //
  // ORDER MATTERS HERE. The read-clear is written FIRST so that `ps2_valid`
  // in the same cycle wins: the arriving byte is kept and stays available,
  // instead of being cleared as it is set. That is not just one fewer dropped
  // byte — without it the flag would be a liar. A read coinciding with an
  // arrival would clear `kb_ovf` at the very moment it should have been
  // raised, so the one case software could not otherwise detect would be the
  // one case the overrun bit failed to report.
  always @(posedge clk)
      if (rst) begin
          kb_avail <= 1'b0; kb_code <= 8'd0; kb_ovf <= 1'b0;
      end else begin
          if (vga_rd && d_addr[1:0] == 2'd3) begin
              kb_avail <= 1'b0;
              kb_ovf   <= 1'b0;
          end
          if (ps2_valid) begin
              kb_code  <= ps2_code;
              kb_avail <= 1'b1;
              // Overwriting a byte nobody has read is a LOST byte. A byte read
              // this same cycle was not lost, so that is not an overrun.
              if (kb_avail && !(vga_rd && d_addr[1:0] == 2'd3))
                  kb_ovf <= 1'b1;
          end
      end

  // read data is captured on the select cycle (before the read-clear
  // of kb_avail lands) and served on the ack cycle
  reg [31:0] vga_rmux;
  always @(*)
      case (d_addr[1:0])
          2'd0: vga_rmux = {30'd0, uart_b0, vga_en};
          2'd1: vga_rmux = {7'd0, vga_base, 2'b00};
          2'd2: vga_rmux = {18'd0, col_bg, 2'd0, col_fg};
          default: vga_rmux = {22'd0, kb_ovf, kb_avail, kb_code};
      endcase
  reg [31:0] vga_rdata_q;
  always @(posedge clk)
      if (vga_rd) vga_rdata_q <= vga_rmux;

  // ---- PLIC ----
  // Sources are level-sensitive and numbered from 1. Only the keyboard is
  // wired: `kb_avail` stays high until software reads the scancode register
  // and drops when it does, which is exactly the shape a PLIC gateway wants.
  //
  // VSync is deliberately NOT wired even though PLAN.md lists it as a source.
  // `vt_vs` is a PULSE, and a level-sensitive gateway would either miss it or
  // latch it forever depending on the cycle it landed on. It needs a
  // read-to-clear status bit of its own first, the way the keyboard has one.
  // Sources 2-4 are tied low so the register map already has room for them.
  wire [4:1]  plic_src = {3'b000, kb_avail};
  wire [31:0] plic_rdata;

  plic #(.SOURCES(4)) plic0 (
      .clk(clk), .rst(rst),
      .src(plic_src),
      .sel(plic_sel && !plic_ack), .we(d_we),
      .addr({d_addr[19:0], 2'b00}), .wdata(d_wdata), .rdata(plic_rdata),
      .eip(plic_eip)
  );

  // Captured on the SELECT cycle, served on the ack cycle — the same hazard
  // the VGA block has, and for a sharper reason. Reading the claim register
  // has a SIDE EFFECT: it takes the interrupt out of pending. By the ack cycle
  // the winning source is gone, so a combinational read sampled then would
  // return the next source or zero, and the handler would service the wrong
  // interrupt while the real one stayed claimed forever.
  reg [31:0] plic_rdata_q;
  always @(posedge clk)
      if (plic_sel && !plic_ack && !d_we) plic_rdata_q <= plic_rdata;

  // ---- microSD (FPGA only) ----
  wire [31:0] sd_rdata;
`ifdef KOTI_FPGA
  sd_ctrl sd (
      .clk(clk), .rst(rst),
      .sel(sd_sel_i && !sd_ack), .we(d_we), .reg_a(d_addr[1:0]),
      .wdata(d_wdata), .rdata(sd_rdata),
      .sd_cs_n(sd_cs_n), .sd_sck(sd_sck), .sd_mosi(sd_mosi), .sd_miso(sd_miso),
      .sd_miso_drv(sd_miso_drv), .sd_miso_oe(sd_miso_oe)
  );
`else
  // No pins on silicon, so the window reads as zero rather than as x. An x here
  // would reach the CPU through d_rdata and look like a core defect.
  assign sd_rdata = 32'd0;
`endif

  // ---- USB HID keyboard (FPGA only) ----
  // The vendored host core lives in the harness, in its own 12 MHz domain;
  // usb_kbd does the crossing and turns held keys into keystrokes.
  wire [31:0] usb_rdata;
  wire        usb_kb_irq;
`ifdef KOTI_FPGA
  usb_kbd ukbd (
      .clk(clk), .rst(rst),
      .sel(usb_sel_i && !usb_ack), .we(d_we), .reg_a(d_addr[1:0]),
      .rdata(usb_rdata),
      .usb_report_tog(usb_report_tog), .usb_typ(usb_typ),
      .usb_conerr(usb_conerr), .usb_key_modifiers(usb_key_modifiers),
      .usb_key1(usb_key1), .usb_key2(usb_key2),
      .usb_key3(usb_key3), .usb_key4(usb_key4),
      .kb_avail_irq(usb_kb_irq)
  );
`else
  assign usb_rdata  = 32'd0;
  assign usb_kb_irq = 1'b0;
`endif

  wire ad_ack;
  assign d_ack   = clint_ack || vga_ack || plic_ack || sd_ack || usb_ack || ad_ack;
  assign d_rdata = clint_ack ? clint_rdata
                 : vga_ack   ? vga_rdata_q
                 : plic_ack  ? plic_rdata_q
                 : sd_ack    ? sd_rdata
                 : usb_ack   ? usb_rdata    : m_rdata;

  // ---- video DMA + text pipeline ----
  wire        v_req, v_ack, vt_hs, vt_vs, vt_act, vt_pix;
  wire [22:0] v_addr;
  vga_text vt (
      .clk(clk), .rst(rst), .ce(1'b1),
      .en(vga_en), .base(vga_base),
      .v_req(v_req), .v_addr(v_addr), .v_ack(v_ack),
      .v_rdata(m_rdata), .v_rdata2(m_rdata2),
      .hsync(vt_hs), .vsync(vt_vs), .active(vt_act), .pix(vt_pix)
  );

  // ---- fetch path: core -> [I-cache] -> arbiter ----
  //
  // Only the FPGA build gets the cache. It is built out of block RAM, and a
  // TinyTapeout tile has none — the same reason sdram_ctrl.sv is an FPGA-only
  // source. Since koti stopped being a tapeout target (2026-08-02) the FPGA
  // build is the real design and this is where speed is worth buying.
`ifdef KOTI_FPGA
  icache #(.ENTRIES(512)) ic (
      .clk(clk), .rst(rst), .flush(icache_flush),
      .req(if_req), .ptw(if_ptw), .addr(if_addr),
      .ack(if_ack), .rdata(if_rdata), .rdata2(if_rdata2),
      .m_req(fc_req), .m_addr(fc_addr), .m_ack(fc_ack),
      .m_rdata(m_rdata), .m_rdata2(m_rdata2)
  );
`else
  // Straight through: the fetch port is wired to the arbiter exactly as it was
  // before the cache existed, and read data comes off the memory bus.
  assign fc_req    = if_req;
  assign fc_addr   = if_addr;
  assign if_ack    = fc_ack;
  assign if_rdata  = m_rdata;
  assign if_rdata2 = m_rdata2;
  wire _unused_ic  = &{if_ptw, icache_flush, 1'b0};
`endif

  mem_arbiter3 arb (
      .clk(clk), .rst(rst),
      .v_req(v_req), .v_addr(v_addr), .v_ack(v_ack),
      .f_req(fc_req), .f_addr(fc_addr), .f_ack(fc_ack),
      .d_req(d_req && !clint_range && !vga_range && !plic_range && !sd_range
                   && !usb_range), .d_we(d_we),
      .d_addr(d_addr), .d_wdata(d_wdata), .d_be(d_be), .d_ack(ad_ack),
      .m_req(m_req), .m_we(m_we), .m_burst(m_burst), .m_addr(m_addr),
      .m_wdata(m_wdata), .m_be(m_be), .m_ack(m_ack)
  );

`ifdef KOTI_FPGA
`ifdef KOTI_SIMMEM
  // ---- simulation only: one behavioural memory instead of two controllers --
  //
  // See test/sim_mem.sv for what this trades away. In short: it proves nothing
  // about qspi_ctrl or sdram_ctrl, both of which have their own strict benches
  // and are exercised by the whole-SoC suites — and it turns ~130 clocks (QSPI)
  // and ~8 clocks (SDRAM) per word into 1, which is what makes booting a kernel
  // in simulation a minute rather than a day.
  //
  // `KOTI_SIMMEM` is defined by no synthesis build: not the TinyTapeout flow,
  // not fpga-ulx3s.yaml, not fpga/ulx3s/synth.ps1.
  sim_mem simmem (
      .clk(clk), .rst(rst),
      .req(m_req), .we(m_we), .burst(m_burst), .addr(m_addr),
      .wdata(m_wdata), .be(m_be),
      .ack(m_ack), .rdata(m_rdata), .rdata2(m_rdata2)
  );

  // Everything the two real controllers would have driven. Tied rather than
  // left dangling: an undriven wire is x, and x reaching uio_out or the SDRAM
  // pins would show up in a boot log as unrelated nonsense.
  assign sck        = 1'b0;
  assign sd_out     = 4'd0;
  assign sd_oe      = 4'd0;
  assign cs_flash_n = 1'b1;
  assign cs_ram_n   = 1'b1;
  assign sdram_cke  = 1'b0;
  assign sdram_csn  = 1'b1;
  assign sdram_rasn = 1'b1;
  assign sdram_casn = 1'b1;
  assign sdram_wen  = 1'b1;
  assign sdram_a    = 13'd0;
  assign sdram_ba   = 2'd0;
  assign sdram_dqm  = 2'b11;
  assign sdram_dout = 16'd0;
  assign sdram_doe  = 1'b0;
  wire _unused_sim  = &{1'b0, sdram_din, sd_in, qspi_cfg};
`else
  // ---- ULX3S: flash stays on QSPI, RAM moves to the onboard SDRAM ----
  // addr[22] is the same select the QSPI controller uses internally, so the
  // split costs one wire and no change to any address anywhere.
  // Which device serves the transaction IN FLIGHT — latched, not combinational.
  //
  // The obvious version, `wire sel_ram = m_addr[22]`, is a trap. It makes each
  // controller's `req` depend on the live address, so anything that disturbs
  // m_addr mid-transaction yanks the request out from under whichever
  // controller is halfway through one. qspi_ctrl then sits in its read state
  // forever, the arbiter waits for an ack that will never come, and the CPU
  // stalls on a fetch — which is exactly the hang this replaced.
  //
  // m_addr is driven by a combinational case on the arbiter's grant, and grant
  // is a 2-bit register with no reset value in some paths, so it is not
  // something to route a live request line through.
  reg  inflight, sel_q;
  always @(posedge clk)
      if (rst) begin
          inflight <= 1'b0;
          sel_q    <= 1'b0;
      end else if (!inflight && m_req) begin
          inflight <= 1'b1;
          sel_q    <= m_addr[22];      // capture once, at the start
      end else if (m_ack || !m_req) begin
          // Release on a DROPPED request as well as on an ack. A requester may
          // walk away before it is served — the fetch port does exactly that on
          // a pipeline flush — and without this clause `inflight` latches
          // forever, `sel_ram` stays frozen on whichever device that abandoned
          // request wanted, and every later access to the OTHER device is
          // routed to a controller that never sees a request. The CPU then
          // stalls on a fetch that can never complete, which looks like the
          // machine simply stopping.
          inflight <= 1'b0;
      end

  wire sel_ram = inflight ? sel_q : m_addr[22];

  wire        q_ack, s_ack;
  wire [31:0] q_rdata, q_rdata2, s_rdata, s_rdata2;

  qspi_ctrl qspi (
      .clk(clk), .rst(rst), .cfg(qspi_cfg),
      .req(m_req && !sel_ram), .we(m_we), .burst(m_burst), .addr(m_addr),
      .wdata(m_wdata), .be(m_be),
      .ack(q_ack), .rdata(q_rdata), .rdata2(q_rdata2),
      .sck(sck), .sd_out(sd_out), .sd_oe(sd_oe), .sd_in(sd_in),
      .cs_flash_n(cs_flash_n), .cs_ram_n(cs_ram_n)
  );

  // addr[22] is dropped on the way in: it was the device select, and inside the
  // part it would be a bank bit. Passing it through would fold the 16 MB window
  // onto banks 2-3 and leave 0-1 dead.
  sdram_ctrl sdram (
      .clk(clk), .rst(rst),
      .req(m_req && sel_ram), .we(m_we), .burst(m_burst),
      .addr({1'b0, m_addr[21:0]}),
      .wdata(m_wdata), .be(m_be),
      .ack(s_ack), .rdata(s_rdata), .rdata2(s_rdata2),
      .sdram_cke(sdram_cke), .sdram_csn(sdram_csn), .sdram_rasn(sdram_rasn),
      .sdram_casn(sdram_casn), .sdram_wen(sdram_wen), .sdram_a(sdram_a),
      .sdram_ba(sdram_ba), .sdram_dqm(sdram_dqm),
      .sdram_dout(sdram_dout), .sdram_doe(sdram_doe), .sdram_din(sdram_din)
  );

  // Only one controller can have a request in flight, so OR the acks rather
  // than muxing on sel_ram — the requester may have moved on by the time a slow
  // QSPI access finally answers, and selecting on the LIVE address would then
  // route the ack to the wrong place.
  assign m_ack    = q_ack | s_ack;

  // Select on the ACK, and fall back to zero rather than to whichever
  // controller happens not to be acking.
  //
  // `s_ack ? s_rdata : q_rdata` looks equivalent — read data is only meaningful
  // during an ack, so who cares what it says otherwise — but it is not. An idle
  // qspi_ctrl has an undefined shift register, so that expression puts x on
  // m_rdata for most of the run. Anything that samples the bus off-ack, or any
  // x that leaks one gate further than expected, then latches x into the CPU,
  // and x in a register address turns into x on d_req, which the arbiter's
  // grant selector latches, and the SoC wedges with nothing pointing at memory.
  // Defaulting to zero cannot change any correct behaviour and denies x a path.
  assign m_rdata  = s_ack ? s_rdata  : q_ack ? q_rdata  : 32'd0;
  assign m_rdata2 = s_ack ? s_rdata2 : q_ack ? q_rdata2 : 32'd0;
`endif
`else
  qspi_ctrl qspi (
      .clk(clk), .rst(rst), .cfg(qspi_cfg),
      .req(m_req), .we(m_we), .burst(m_burst), .addr(m_addr),
      .wdata(m_wdata), .be(m_be),
      .ack(m_ack), .rdata(m_rdata), .rdata2(m_rdata2),
      .sck(sck), .sd_out(sd_out), .sd_oe(sd_oe), .sd_in(sd_in),
      .cs_flash_n(cs_flash_n), .cs_ram_n(cs_ram_n)
  );
`endif

  // QSPI Pmod: uio[1,2,4,5] = SD0..SD3, direction owned by the controller
  assign sd_in = {uio_in[5], uio_in[4], uio_in[2], uio_in[1]};

  assign uio_out = {1'b1, cs_ram_n, sd_out[3], sd_out[2], sck,
                    sd_out[1], sd_out[0], cs_flash_n};
  assign uio_oe  = {1'b1, 1'b1, sd_oe[3], sd_oe[2], 1'b1,
                    sd_oe[1], sd_oe[0], 1'b1};

  // uo personality: headless (reset default — UART/HALTED/LED, keeps
  // bring-up and all pin-level tests) vs Tiny VGA Pmod once software
  // sets VGA_EN. In VGA mode the blue LSB can carry UART instead
  // (ctrl bit 1) — text mode never misses it.
  wire [5:0] rgb = vt_pix ? col_fg : (vt_act ? col_bg : 6'd0);
  wire [7:0] uo_vga;
  assign uo_vga[0] = rgb[5];                        // R1
  assign uo_vga[1] = rgb[3];                        // G1
  assign uo_vga[2] = rgb[1];                        // B1
  assign uo_vga[3] = vt_vs;                         // VSync
  assign uo_vga[4] = rgb[4];                        // R0
  assign uo_vga[5] = rgb[2];                        // G0
  assign uo_vga[6] = uart_b0 ? uart_txd : rgb[0];   // B0 / UART
  assign uo_vga[7] = vt_hs;                         // HSync

  assign uo_out = vga_en ? uo_vga : {led[5:0], halted, uart_txd};

`ifdef KOTI_FPGA
  // The same pixels the VGA personality packs into `uo`, unpacked. Deliberately
  // NOT gated on `vga_en`: the HDMI link must keep running whatever the SoC is
  // doing, so the monitor holds its lock instead of resyncing every time
  // software touches VGA_CTRL — the blanking interval is still generated, so a
  // disabled console shows a black raster rather than "no signal".
  assign video_rgb = rgb;
  assign video_hs  = vt_hs;
  assign video_vs  = vt_vs;
  assign video_de  = vt_act;
`endif

  assign kb_irq = kb_avail;

  wire _unused = &{ena, uio_in[7:6], uio_in[3], uio_in[0], led[7:6], 1'b0};

endmodule
