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

module tt_um_koti (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire rst = ~rst_n;

  wire        halted;
  wire [7:0]  led;
  wire        uart_txd;
  wire        mtip, msip;

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
      .mtip(mtip), .msip(msip), .meip(1'b0),   // PLIC later
      .halted(halted), .led(led), .uart_txd(uart_txd), .gpio_in(ui_in),
      .qspi_cfg(qspi_cfg),
      .if_req(if_req), .if_addr(if_addr), .if_ack(if_ack),
      .if_rdata(m_rdata), .if_rdata2(m_rdata2),
      .d_req(d_req), .d_we(d_we), .d_addr(d_addr), .d_wdata(d_wdata),
      .d_be(d_be), .d_ack(d_ack), .d_rdata(d_rdata)
  );

  // CLINT intercept: d_addr = addr[24:2], so bit 22 = PSRAM select,
  // bit 15 = addr[17], bit 14 = addr[16]. 0x0002_0000 = flash-side,
  // bit 17 set, bit 16 clear. Never reaches the arbiter.
  wire clint_range = !d_addr[22] && d_addr[15] && !d_addr[14];
  wire clint_sel   = d_req && clint_range;
  reg  clint_ack;
  always @(posedge clk)
      clint_ack <= rst ? 1'b0 : (clint_sel && !clint_ack);

  wire [31:0] clint_rdata;
  clint clint0 (
      .clk(clk), .rst(rst),
      .sel(clint_sel && !clint_ack), .we(d_we),
      .addr({d_addr[2:0], 2'b00}), .wdata(d_wdata), .rdata(clint_rdata),
      .mtip(mtip), .msip(msip)
  );

  wire ad_ack;
  assign d_ack   = clint_ack || ad_ack;
  assign d_rdata = clint_ack ? clint_rdata : m_rdata;
  mem_arbiter arb (
      .clk(clk), .rst(rst),
      .f_req(if_req), .f_addr(if_addr), .f_ack(if_ack),
      .d_req(d_req && !clint_range), .d_we(d_we), .d_addr(d_addr),
      .d_wdata(d_wdata), .d_be(d_be), .d_ack(ad_ack),
      .m_req(m_req), .m_we(m_we), .m_burst(m_burst), .m_addr(m_addr),
      .m_wdata(m_wdata), .m_be(m_be), .m_ack(m_ack)
  );

  qspi_ctrl qspi (
      .clk(clk), .rst(rst), .cfg(qspi_cfg),
      .req(m_req), .we(m_we), .burst(m_burst), .addr(m_addr),
      .wdata(m_wdata), .be(m_be),
      .ack(m_ack), .rdata(m_rdata), .rdata2(m_rdata2),
      .sck(sck), .sd_out(sd_out), .sd_oe(sd_oe), .sd_in(sd_in),
      .cs_flash_n(cs_flash_n), .cs_ram_n(cs_ram_n)
  );

  // QSPI Pmod: uio[1,2,4,5] = SD0..SD3, direction owned by the controller
  assign sd_in = {uio_in[5], uio_in[4], uio_in[2], uio_in[1]};

  assign uio_out = {1'b1, cs_ram_n, sd_out[3], sd_out[2], sck,
                    sd_out[1], sd_out[0], cs_flash_n};
  assign uio_oe  = {1'b1, 1'b1, sd_oe[3], sd_oe[2], 1'b1,
                    sd_oe[1], sd_oe[0], 1'b1};

  assign uo_out = {led[5:0], halted, uart_txd};

  wire _unused = &{ena, uio_in[7:6], uio_in[3], uio_in[0], led[7:6], 1'b0};

endmodule
