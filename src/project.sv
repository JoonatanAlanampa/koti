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
  wire        kb_irq;      // pending keyboard byte -> meip (PLIC later)

  wire        if_req, if_ack;
  wire [22:0] if_addr;
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

  koti_core #(.UART_DIV(217)) core (
      .clk(clk), .rst(rst),
      .mtip(mtip), .msip(msip), .meip(kb_irq),
      .halted(halted), .led(led), .uart_txd(uart_txd), .gpio_in(ui_in),
      .qspi_cfg(qspi_cfg),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(m_rdata), .if_rdata2(m_rdata2),
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
  wire clint_sel   = d_req && clint_range;
  wire vga_sel     = d_req && vga_range;
  reg  clint_ack, vga_ack;
  always @(posedge clk) begin
      clint_ack <= rst ? 1'b0 : (clint_sel && !clint_ack);
      vga_ack   <= rst ? 1'b0 : (vga_sel && !vga_ack);
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
  // Keyboard byte: ONE entry, no FIFO, and no overrun flag. Two consequences
  // worth knowing before trusting it, both measured 2026-08-02:
  //   * a second `ps2_valid` overwrites kb_code whether or not the first byte
  //     was ever read, and
  //   * a read landing in the same cycle as `ps2_valid` clears kb_avail as it
  //     is being set — the clear is later in the block, so the clear wins.
  // Either way the byte is dropped silently; software cannot tell.
  //
  // This is fine against a real keyboard and only a fool would call it safe by
  // accident: a PS/2 device clocks at 10-16.7 kHz, so a frame takes 0.7-1.1 ms,
  // while software polling this register through QSPI-XIP code gets round
  // roughly every 7000 clocks (~0.28 ms). Three to four polls per frame is
  // ample. Feed it frames any faster — as test.py's first attempt did, at
  // ~2200 clocks apart — and bytes vanish without a trace.
  //
  // If a keyboard driver ever needs to KNOW it lost a byte (a real one will,
  // for E0/F0 prefix sequences, where a dropped byte desynchronises the
  // decoder), this needs an overrun bit: set it when ps2_valid arrives with
  // kb_avail already high, and expose it in the read word.
  always @(posedge clk)
      if (rst) begin
          kb_avail <= 1'b0; kb_code <= 8'd0;
      end else begin
          if (ps2_valid) begin
              kb_code  <= ps2_code;
              kb_avail <= 1'b1;
          end
          if (vga_rd && d_addr[1:0] == 2'd3) kb_avail <= 1'b0;
      end

  // read data is captured on the select cycle (before the read-clear
  // of kb_avail lands) and served on the ack cycle
  reg [31:0] vga_rmux;
  always @(*)
      case (d_addr[1:0])
          2'd0: vga_rmux = {30'd0, uart_b0, vga_en};
          2'd1: vga_rmux = {7'd0, vga_base, 2'b00};
          2'd2: vga_rmux = {18'd0, col_bg, 2'd0, col_fg};
          default: vga_rmux = {23'd0, kb_avail, kb_code};
      endcase
  reg [31:0] vga_rdata_q;
  always @(posedge clk)
      if (vga_rd) vga_rdata_q <= vga_rmux;

  wire ad_ack;
  assign d_ack   = clint_ack || vga_ack || ad_ack;
  assign d_rdata = clint_ack ? clint_rdata
                 : vga_ack   ? vga_rdata_q : m_rdata;

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

  mem_arbiter3 arb (
      .clk(clk), .rst(rst),
      .v_req(v_req), .v_addr(v_addr), .v_ack(v_ack),
      .f_req(if_req), .f_addr(if_addr), .f_ack(if_ack),
      .d_req(d_req && !clint_range && !vga_range), .d_we(d_we),
      .d_addr(d_addr), .d_wdata(d_wdata), .d_be(d_be), .d_ack(ad_ack),
      .m_req(m_req), .m_we(m_we), .m_burst(m_burst), .m_addr(m_addr),
      .m_wdata(m_wdata), .m_be(m_be), .m_ack(m_ack)
  );

`ifdef KOTI_FPGA
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
      end else if (m_ack) begin
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
  assign m_rdata  = s_ack ? s_rdata  : q_rdata;
  assign m_rdata2 = s_ack ? s_rdata2 : q_rdata2;
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

  assign kb_irq = kb_avail;

  wire _unused = &{ena, uio_in[7:6], uio_in[3], uio_in[0], led[7:6], 1'b0};

endmodule
