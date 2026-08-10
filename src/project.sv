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
// THE MEMORY MAP, on the 24-bit WORD address the core drives (PA[25:2]):
//     a[23:22] == 00   flash + MMIO   PA 0x0000_0000..0x00FF_FFFF (16 MB)
//     a[23:22] == 01   RAM low        PA 0x0100_0000..0x01FF_FFFF
//     a[23:22] == 10   RAM high       PA 0x0200_0000..0x02FF_FFFF
//     a[23:22] == 11   nothing        faulted by koti_core's pa_ram_hi
//
// ⚠️ IT WAS 23 BITS UNTIL 2026-08-08, with `addr[22]` doing double duty as the
// device select — which meant only 16 MB of the soldered 32 MB was reachable
// and Linux reported `MemTotal: 8796 kB`. Widening by one bit is what PLAN.md
// item 12 was; the old note here said that memory "mainline sv32 Linux does not
// need", which was true of booting and false of using the machine.
//
// ⭐ RAM'S BASE ADDRESS DID NOT MOVE, and that was the design goal. 0x0100_0000
// is baked into both linker scripts, koti.dts, sbi.c's KERNEL_ADDR, sdboot.c,
// tools/sdkernel.py, tools/ktrace.py and tb_boot's `+ramoff`. Only the DTS
// length changed. See the select in the ULX3S block below for why the offset
// costs no adder.
module tt_um_koti (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
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
    // The console's receive pin. koti was transmit-only until 2026-08-09; this
    // is what makes the serial console typeable and is the same wire an ESP32
    // link would use on wifi_txd.
    input  wire        uart_rxd,
    // ---- the ESP32 link, added 2026-08-10 (PLAN item 11). ----
    // ⚠️ NAMED FROM THE ESP32's POINT OF VIEW, as upstream's constraint file
    // names them: wifi_rxd (K3) is what the ESP32 RECEIVES, so koti drives it;
    // wifi_txd (K4) is what it TRANSMITS, so koti reads it. Wiring these by the
    // local sense of rx/tx crosses them and the link is silent in both
    // directions with nothing to see on either end.
    output wire        esp_rxd,       // -> wifi_rxd K3
    input  wire        esp_txd,       // <- wifi_txd K4
    // ⛔ Both reset LOW = the ESP32 held in reset, which is what ulx3s_top.sv
    // hardwired before this existed. Software raises them deliberately.
    output wire        esp_en,        // -> wifi_en    J5 on v3.1.x
    output wire        esp_gpio0,     // -> wifi_gpio0 F1 on v3.1.x
    // ---- Liveness, for the harness's lamps. Added 2026-08-09. ----
    // ⛔ WHY THIS IS A PORT AND NOT A COMMENT SAYING "USE LED1".
    // `uo_out = vga_en ? uo_vga : {led[5:0], halted, uart_txd}` — so the HALTED
    // lamp EXISTS ONLY IN HEADLESS MODE, and vanishes the moment software turns
    // the display on. That is precisely backwards: headless is the mode where
    // the UART already tells you everything, and VGA mode is where you are
    // running an OS with no other way in. On 2026-08-09 that gap cost a wrong
    // diagnosis — LED1 was read as HALTED on a machine in VGA mode, where it is
    // a green video bit.
    //   dbg_halted  the core hit EBREAK in M-MODE. In S/U mode EBREAK traps
    //               (koti_core: `ebreak_halt_e` requires csr_priv==2'b11), so
    //               this fires for the FIRMWARE stopping, never for a kernel
    //               BUG(). Solid = the machine is stopped, not merely quiet.
    //   dbg_fetch   one pulse per instruction-fetch ack. This is the core's own
    //               port, upstream of the icache, so it ticks on cache HITS too
    //               — it is "the CPU is executing", not "the CPU is missing".
    //               Frozen with dbg_halted low = looping in something that does
    //               not fetch, or stalled on memory.
    output wire        dbg_halted,
    output wire        dbg_fetch,
    output wire [4:0]  dbg_irq,        // see the assign for the bit meanings
    // USB HID keyboard, from vendor/usb_hid_host.v in the harness. The core
    // needs its own 12 MHz domain, so it lives out there and only its results
    // come in here; src/usb_kbd.sv does the crossing.
    // ⚠️ `usb_report_tog` is a TOGGLE, not the core's one-clock pulse.
    input  wire        usb_report_tog,
    input  wire [1:0]  usb_typ,
    input  wire        usb_conerr,
    input  wire [7:0]  usb_key_modifiers,
    input  wire [7:0]  usb_key1, usb_key2, usb_key3, usb_key4,
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire rst = ~rst_n;

  wire        halted;
  wire [7:0]  led;
  wire        uart_txd;
  wire        mtip, msip;
  // Declared here rather than beside the usb_kbd instance: the PLIC's source
  // list is wired above that point, and this file is read by a simulator that
  // rejects declare-after-use (the same constraint that produced koti_core's
  // forward-declaration block).
  wire        usb_kb_irq;  // USB keyboard has something queued -> PLIC source 1
  wire        d_ptw;       // the data port is carrying a page-table read
  wire        plic_eip;    // PLIC -> the core's S-level external interrupt
  wire [4:1]  plic_dbg_ip, plic_dbg_inflight;   // observation only, to the lamps
  wire        usb_dbg_enq, usb_dbg_keyrep;      // ditto, from usb_kbd

  wire        if_req, if_ack;
  wire [23:0] if_addr;
  // What the CORE sees on its fetch port. Without a cache these are just the
  // memory bus; with one they are the cache's answer.
  wire [31:0] if_rdata, if_rdata2;
  wire        if_ptw, icache_flush;
  // What the ARBITER sees on its fetch port. Same signals one level out.
  wire        fc_req, fc_ack;
  wire [23:0] fc_addr;
  wire        d_req, d_we, d_ack;
  wire [23:0] d_addr;
  wire [31:0] d_wdata, d_rdata;
  wire [3:0]  d_be;

  wire        m_req, m_we, m_burst, m_ack;
  wire [23:0] m_addr;
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
      // meip is tied low. It was the PS/2 byte-available line, which predates
      // the PLIC and was already marked inert once the PLIC took over S-level
      // delivery; with PS/2 gone there is no M-level interrupt source at all.
      // Every interrupt Linux sees arrives through seip and the PLIC.
      .mtip(mtip), .msip(msip), .meip(1'b0), .seip(plic_eip),
      .halted(halted), .led(led), .uart_txd(uart_txd), .uart_rxd(uart_rxd),
      .gpio_in(ui_in),
      .qspi_cfg(qspi_cfg),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(if_rdata), .if_rdata2(if_rdata2),
      .if_ptw(if_ptw), .icache_flush(icache_flush),
      .d_req(d_req), .d_we(d_we), .d_addr(d_addr), .d_wdata(d_wdata),
      .d_be(d_be), .d_ack(d_ack), .d_rdata(d_rdata), .d_ptw(d_ptw)
  );

  // SoC MMIO intercepts on the data port. d_addr = byte_addr[25:2], so
  // d_addr[22:14] == byte_addr[24:16]. Decode the FULL 64 KB windows:
  // CLINT at 0x0002_0000 (byte[24:16]==0x002), VGA/PS2 at 0x0004_0000
  // (0x004). 1-cycle ack, never reaches the arbiter. A partial compare
  // aliased flash data past 64 KB into these windows every 512 KB (F1).
  wire clint_range = d_addr[23:14] == 10'h002;
  wire vga_range   = d_addr[23:14] == 10'h004;
  // microSD at 0x0005_0000, the next free 64 KB window after VGA/PS2. Decoded
  // in FULL like the others: a partial compare aliased flash data into these
  // windows every 512 KB (defect F1), which is the sort of bug that reads as
  // random memory corruption.
  wire sd_range    = d_addr[23:14] == 10'h005;
  // USB HID keyboard at 0x0006_0000, the next window after the microSD. Same
  // full compare, same reason.
  wire usb_range   = d_addr[23:14] == 10'h006;
  // The ESP32 link at 0x0007_0000, the next window after the keyboard. Same
  // full compare, same reason. ⚠️ Adding a window takes TWO edits: this one,
  // and koti_core.sv's `pa_dev`, which decides whether WRITES to it are legal.
  // With only this one, reads work and the first write takes a store fault —
  // which with mtvec still 0 restarts the program and reads as a reset bug.
  // The PLIC hit that first, then the microSD; this is the third.
  wire esp_range   = d_addr[23:14] == 10'h007;
  // PLIC: the TOP 4 MB of flash address space, 0x00C0_0000..0x00FF_FFFF.
  //
  // It cannot live in a 64 KB carve-out beside the CLINT: the SiFive layout
  // puts the context registers at offset 0x200000 and mainline's driver
  // hard-codes that, so a register-compatible PLIC needs megabytes of window.
  // Taking it off the TOP of flash space rather than punching a hole in the
  // low addresses keeps software's run from zero contiguous.
  wire plic_range  = d_addr[23:22] == 2'b00 && d_addr[21:20] == 2'b11;
  wire clint_sel   = d_req && clint_range;
  wire vga_sel     = d_req && vga_range;
  wire sd_sel_i    = d_req && sd_range;
  wire usb_sel_i   = d_req && usb_range;
  wire esp_sel_i   = d_req && esp_range;
  wire plic_sel    = d_req && plic_range;
  reg  clint_ack, vga_ack, plic_ack, sd_ack, usb_ack, esp_ack;
  always @(posedge clk) begin
      clint_ack <= rst ? 1'b0 : (clint_sel && !clint_ack);
      vga_ack   <= rst ? 1'b0 : (vga_sel && !vga_ack);
      sd_ack    <= rst ? 1'b0 : (sd_sel_i && !sd_ack);
      usb_ack   <= rst ? 1'b0 : (usb_sel_i && !usb_ack);
      esp_ack   <= rst ? 1'b0 : (esp_sel_i && !esp_ack);
      plic_ack  <= rst ? 1'b0 : (plic_sel && !plic_ack);
  end

  wire [31:0] clint_rdata;
  clint clint0 (
      .clk(clk), .rst(rst),
      .sel(clint_sel && !clint_ack), .we(d_we),
      .addr({d_addr[2:0], 2'b00}), .wdata(d_wdata), .rdata(clint_rdata),
      .mtip(mtip), .msip(msip)
  );

  // ---- VGA register block: +0 ctrl (bit0 VGA_EN, bit1 UART on
  // the blue LSB), +4 charbuf byte address, +8 {bg[13:8], fg[5:0]} ----
  //
  // +C used to be the PS/2 scancode word. PS/2 was REMOVED 2026-08-08, once
  // the USB HID keyboard had typed on real hardware — the condition PLAN.md
  // had set for retiring it. The offset is left decoded and reading zero
  // rather than reused: software built before the removal reads a register
  // that says "no key", which is the harmless answer, whereas handing the
  // offset to something else would make that stale software do damage.
  reg        vga_en, uart_b0;
  reg [23:0] vga_base;
  reg [5:0]  col_fg, col_bg;

  wire vga_wr = vga_sel && !vga_ack && d_we;
  wire vga_rd = vga_sel && !vga_ack && !d_we;
  always @(posedge clk)
      if (rst) begin
          vga_en <= 1'b0; uart_b0 <= 1'b0;
          vga_base <= 24'd0; col_fg <= 6'h3F; col_bg <= 6'h00;
      end else if (vga_wr)
          case (d_addr[1:0])
              2'd0: {uart_b0, vga_en} <= d_wdata[1:0];
              2'd1: vga_base <= d_wdata[25:2];
              2'd2: {col_bg, col_fg} <= {d_wdata[13:8], d_wdata[5:0]};
              default: ;
          endcase

  // read data is captured on the select cycle and served on the ack cycle
  reg [31:0] vga_rmux;
  always @(*)
      case (d_addr[1:0])
          2'd0: vga_rmux = {30'd0, uart_b0, vga_en};
          2'd1: vga_rmux = {6'd0, vga_base, 2'b00};
          2'd2: vga_rmux = {18'd0, col_bg, 2'd0, col_fg};
          // +C was the PS/2 scancode word, removed 2026-08-08. It reads zero,
          // which to any surviving PS/2 driver means "no key waiting" — the
          // one answer that makes stale software idle instead of misbehave.
          default: vga_rmux = 32'd0;
      endcase
  reg [31:0] vga_rdata_q;
  always @(posedge clk)
      if (vga_rd) vga_rdata_q <= vga_rmux;

  // ---- PLIC ----
  // Sources are level-sensitive and numbered from 1. Only the keyboard is
  // wired: `usb_kb_irq` is the USB FIFO's not-empty flag, which stays high
  // until software drains it and drops when it does — exactly the shape a
  // level-sensitive PLIC gateway wants, and the same shape PS/2's `kb_avail`
  // had before it was removed on 2026-08-08.
  // ⚠️ On the NON-FPGA (TinyTapeout) build usb_kbd does not exist and this is
  // tied low, so that build has no interrupt source at all. That is honest
  // rather than broken: with PS/2 gone the tile has no keyboard either.
  //
  // VSync is deliberately NOT wired even though PLAN.md lists it as a source.
  // `vt_vs` is a PULSE, and a level-sensitive gateway would either miss it or
  // latch it forever depending on the cycle it landed on. It needs a
  // read-to-clear status bit of its own first, the way the keyboard has one.
  // Sources 2-4 are tied low so the register map already has room for them.
  wire [4:1]  plic_src = {3'b000, usb_kb_irq};
  wire [31:0] plic_rdata;

  plic #(.SOURCES(4)) plic0 (
      .clk(clk), .rst(rst),
      .src(plic_src),
      .sel(plic_sel && !plic_ack), .we(d_we),
      .addr({d_addr[19:0], 2'b00}), .wdata(d_wdata), .rdata(plic_rdata),
      .eip(plic_eip),
      .dbg_ip(plic_dbg_ip), .dbg_inflight(plic_dbg_inflight)
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
  sd_ctrl sd (
      .clk(clk), .rst(rst),
      .sel(sd_sel_i && !sd_ack), .we(d_we), .reg_a(d_addr[2:0]),
      .wdata(d_wdata), .rdata(sd_rdata),
      .sd_cs_n(sd_cs_n), .sd_sck(sd_sck), .sd_mosi(sd_mosi), .sd_miso(sd_miso),
      .sd_miso_drv(sd_miso_drv), .sd_miso_oe(sd_miso_oe)
  );

  // ---- USB HID keyboard (FPGA only) ----
  // The vendored host core lives in the harness, in its own 12 MHz domain;
  // usb_kbd does the crossing and turns held keys into keystrokes.
  wire [31:0] usb_rdata;
  usb_kbd ukbd (
      .clk(clk), .rst(rst),
      .sel(usb_sel_i && !usb_ack), .we(d_we), .reg_a(d_addr[1:0]),
      .rdata(usb_rdata),
      .usb_report_tog(usb_report_tog), .usb_typ(usb_typ),
      .usb_conerr(usb_conerr), .usb_key_modifiers(usb_key_modifiers),
      .usb_key1(usb_key1), .usb_key2(usb_key2),
      .usb_key3(usb_key3), .usb_key4(usb_key4),
      .kb_avail_irq(usb_kb_irq),
      .dbg_enq(usb_dbg_enq), .dbg_keyrep(usb_dbg_keyrep)
  );

  // ---- the ESP32 link (PLAN item 11, networking) ----
  // A second serial port on the ESP32's own dedicated pins, plus the two
  // straps that decide whether that chip is running. ⛔ Both straps reset LOW,
  // which is exactly what this file's top level hardwired before now: nothing
  // about power-on behaviour changes, and waking the ESP32 is a write software
  // has to make on purpose. That matters because the ESP32's GPIOs ARE the
  // microSD bus.
  wire [31:0] esp_rdata;
  esp_uart #(.DIV(UDIV)) esp0 (
      .clk(clk), .rst(rst),
      .sel(esp_sel_i && !esp_ack), .we(d_we), .reg_a(d_addr[1:0]),
      .wdata(d_wdata), .rdata(esp_rdata),
      .esp_rxd(esp_rxd), .esp_txd(esp_txd),
      .esp_en(esp_en), .esp_gpio0(esp_gpio0)
  );

  wire ad_ack;
  assign d_ack   = clint_ack || vga_ack || plic_ack || sd_ack || usb_ack
                   || esp_ack || ad_ack;
  assign d_rdata = clint_ack ? clint_rdata
                 : vga_ack   ? vga_rdata_q
                 : plic_ack  ? plic_rdata_q
                 : sd_ack    ? sd_rdata
                 : usb_ack   ? usb_rdata
                 : esp_ack   ? esp_rdata    : ad_rdata;

  // ---- video DMA + text pipeline ----
  wire        v_req, v_ack, vt_hs, vt_vs, vt_act, vt_pix;
  wire [23:0] v_addr;
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
  icache #(.ENTRIES(512)) ic (
      .clk(clk), .rst(rst), .flush(icache_flush),
      .req(if_req), .ptw(if_ptw), .addr(if_addr),
      .ack(if_ack), .rdata(if_rdata), .rdata2(if_rdata2),
      .m_req(fc_req), .m_addr(fc_addr), .m_ack(fc_ack),
      .m_rdata(m_rdata), .m_rdata2(m_rdata2)
  );

  // ---- data cache (FPGA only) --------------------------------------------
  // Sits between the data port and the arbiter. MMIO is already excluded here
  // — the request below is d_req minus every device window — which is what
  // makes caching safe at all: a cached UART status register would spin
  // forever. That filtering existed for the arbiter's benefit and this reuses
  // it rather than repeating the decode, so a new MMIO window cannot become
  // cacheable by being forgotten in a second place.
  wire dc_req = d_req && !clint_range && !vga_range && !plic_range
                      && !sd_range && !usb_range && !esp_range;
  wire        am_req, am_we;
  wire [23:0] am_addr;
  wire [31:0] am_wdata;
  wire [3:0]  am_be;
  wire        am_ack;
  wire [31:0] ad_rdata;
// ---- is the cache in the path? -----------------------------------------
// ON for every FPGA build, exactly the way `icache` above is, and deliberately
// NOT behind a switch of its own. This repo has already been bitten twice by a
// list that had to be told about a new file (see test/check_sources.py), and a
// build flag that must be added to seven workflow steps to take effect is that
// same mistake wearing a different hat — a cache nobody compiles is not a
// cache. The ASIC build takes the bypass because a TinyTapeout tile has no
// block RAM to put one in.
//
// `KOTI_NO_DCACHE` turns it off again, for one purpose: A/B-ing the cache on
// the real board without editing RTL. What that selects is not an untested
// special case — it is the same bypass every ASIC build compiles and every
// ASIC test exercises, and it is what booted Linux on hardware before this.
`ifndef KOTI_NO_DCACHE
`ifndef KOTI_DCACHE
`define KOTI_DCACHE
`endif
`endif

`ifdef KOTI_DCACHE
  dcache dc (
      .clk(clk), .rst(rst),
      .c_req(dc_req), .c_we(d_we), .c_ptw(d_ptw), .c_addr(d_addr),
      .c_wdata(d_wdata), .c_be(d_be), .c_ack(ad_ack), .c_rdata(ad_rdata),
      .m_req(am_req), .m_we(am_we), .m_addr(am_addr), .m_wdata(am_wdata),
      .m_be(am_be), .m_ack(am_ack), .m_rdata(m_rdata)
  );
`else
  // A TinyTapeout tile has no block RAM, so the ASIC build is unchanged: the
  // data port goes straight at the arbiter as it always did.
  assign am_req   = dc_req;
  assign am_we    = d_we;
  assign am_addr  = d_addr;
  assign am_wdata = d_wdata;
  assign am_be    = d_be;
  assign ad_ack   = am_ack;
  assign ad_rdata = m_rdata;
`endif

  mem_arbiter3 arb (
      .clk(clk), .rst(rst),
      .v_req(v_req), .v_addr(v_addr), .v_ack(v_ack),
      .f_req(fc_req), .f_addr(fc_addr), .f_ack(fc_ack),
      .d_req(am_req), .d_we(am_we),
      .d_addr(am_addr), .d_wdata(am_wdata), .d_be(am_be), .d_ack(am_ack),
      .m_req(m_req), .m_we(m_we), .m_burst(m_burst), .m_addr(m_addr),
      .m_wdata(m_wdata), .m_be(m_be), .m_ack(m_ack)
  );

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
  //
  // ⭐ THE SELECT IS `m_addr[23:22] != 00`, AND IT COSTS NO ADDRESS BIT.
  // Until 2026-08-08 it was `m_addr[22]` — a single bit doing double duty as
  // device select AND top address bit, which left the part's upper 16 MB
  // unreachable and Linux reporting `MemTotal: 8796 kB` on a 32 MB board.
  //
  // The map is now, on a 24-bit WORD address:
  //     a[23:22] == 00   flash + MMIO   PA 0x0000_0000..0x00FF_FFFF (16 MB)
  //     a[23:22] == 01   RAM, low half  PA 0x0100_0000..0x01FF_FFFF
  //     a[23:22] == 10   RAM, high half PA 0x0200_0000..0x02FF_FFFF
  //     a[23:22] == 11   nothing — koti_core faults it (pa_ram_hi)
  //
  // ⭐ AND THE OFFSET IS A BIT SELECTION, NOT A SUBTRACTION. RAM starts at word
  // 0x400000 and is 0x800000 words long — the base is exactly half the size —
  // so `a - 0x400000` collapses to `{a[23], a[21:0]}`. Verified exhaustively
  // over all 8,388,608 addresses before this was written, because "obviously
  // equivalent" address arithmetic is how memory maps go quietly wrong.
  //
  // ⇒ RAM'S BASE ADDRESS DID NOT MOVE. That was the point: 0x0100_0000 is
  // baked into both linker scripts, koti.dts, sbi.c's KERNEL_ADDR, sdboot.c,
  // sdkernel.py, ktrace.py and tb_boot's `+ramoff`. Doubling the window by
  // moving the base would have touched every one of them, and each is a place
  // where a wrong constant produces a machine that does not boot with no clue
  // as to why. Only the DTS `reg` length changes.
  //
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
          sel_q    <= (m_addr[23:22] != 2'b00);   // capture once, at the start
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

  wire sel_ram = inflight ? sel_q : (m_addr[23:22] != 2'b00);

  wire        q_ack, s_ack;
  wire [31:0] q_rdata, q_rdata2, s_rdata, s_rdata2;

  // Flash only on this build, so a[23:22] is 00 by construction and the
  // controller's own internal select (its addr[22]) must be 0. Spelled out
  // rather than left to width truncation: relying on a pruned high bit is how
  // a map change silently reaches the wrong device.
  qspi_ctrl qspi (
      .clk(clk), .rst(rst), .cfg(qspi_cfg),
      .req(m_req && !sel_ram), .we(m_we), .burst(m_burst),
      .addr({1'b0, m_addr[21:0]}),
      .wdata(m_wdata), .be(m_be),
      .ack(q_ack), .rdata(q_rdata), .rdata2(q_rdata2),
      .sck(sck), .sd_out(sd_out), .sd_oe(sd_oe), .sd_in(sd_in),
      .cs_flash_n(cs_flash_n), .cs_ram_n(cs_ram_n)
  );

  // {a[23], a[21:0]} IS `a - 0x400000`, exactly, over the whole window — see
  // the map above. a[22] is not dropped any more; it is the low half of the
  // window and a[23] is the high half, and swapping them into this order is
  // what makes the subtraction free. Getting this wrong folds the window onto
  // the wrong banks and leaves half the part dead, which is the bug this whole
  // change exists to remove.
  sdram_ctrl sdram (
      .clk(clk), .rst(rst),
      .req(m_req && sel_ram), .we(m_we), .burst(m_burst),
      .addr({m_addr[23], m_addr[21:0]}),
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

  // The same two facts, on pins that do not depend on the video personality.
  assign dbg_halted = halted;
  assign dbg_fetch  = if_req && if_ack;

  // The whole keyboard interrupt path, in three bits. Read together they say
  // WHERE a keystroke stopped, which no amount of staring from the outside can:
  //   dbg_irq[4]  keyrep       a report arrived CONTAINING A KEY  (pulse)
  //   dbg_irq[3]  enq          a keystroke was ENQUEUED           (pulse)
  //   dbg_irq[2]  usb_kb_irq   the FIFO has something for Linux   (level)
  //   dbg_irq[1]  plic ip[1]   the PLIC is offering it to the hart
  //   dbg_irq[0]  inflight[1]  claimed and NOT yet completed — the wedge state
  //
  // ⚠️ THE LEVELS ARE NEARLY USELESS ON A HEALTHY MACHINE and that cost a round
  // on 2026-08-09: the driver drains within microseconds, so [2:0] read dark
  // whether the path is working perfectly or producing nothing at all. The
  // PULSES are the ones to count — they say whether keystrokes exist.
  // [2] high with [1] low and [0] high is a claim that never completed: the
  // source is pinned off and only a reset brings it back.
  // [2] low while keys are being pressed means the keystrokes never reached
  // the queue at all, which puts the fault in usb_kbd's diff, not here.
  assign dbg_irq = {usb_dbg_keyrep, usb_dbg_enq,
                    usb_kb_irq, plic_dbg_ip[1], plic_dbg_inflight[1]};

  // The same pixels the VGA personality packs into `uo`, unpacked. Deliberately
  // NOT gated on `vga_en`: the HDMI link must keep running whatever the SoC is
  // doing, so the monitor holds its lock instead of resyncing every time
  // software touches VGA_CTRL — the blanking interval is still generated, so a
  // disabled console shows a black raster rather than "no signal".
  assign video_rgb = rgb;
  assign video_hs  = vt_hs;
  assign video_vs  = vt_vs;
  assign video_de  = vt_act;

  wire _unused = &{ena, uio_in[7:6], uio_in[3], uio_in[0], led[7:6], 1'b0};

endmodule
