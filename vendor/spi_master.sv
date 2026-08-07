// spi_master.sv — 8-bit SPI mode-0 byte engine (HARNESS ONLY, never hardened).
//
// Shared by both halves of the SD loader: the microSD card and the cartridge
// flash are both plain 1-bit SPI mode 0, so one shifter serves both and only
// the chip select and the clock divider differ.
//
// Mode 0 = CPOL 0, CPHA 0: the slave samples MOSI on the RISING edge, so the
// master presents the next output bit on the FALLING edge and samples MISO on
// the rising one. `sh` carries both directions — the outgoing byte shifts out
// of the top while the incoming byte shifts in at the bottom, so after eight
// rising edges `sh` IS the received byte.
//
// SCK half-period = (div + 1) clk cycles, i.e. f_sck = f_clk / (2*(div+1)).
// The SD card spec requires 100-400 kHz until the card is initialised, which
// is why div is an input rather than a parameter.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module spi_master #(
    parameter int DIVW = 8
) (
    input  wire             clk,
    input  wire             rst,            // synchronous, active high

    input  wire [DIVW-1:0]  div,            // sck half-period - 1, in clk cycles
    input  wire             start,          // pulse: begin one byte transfer
    input  wire [7:0]       wdata,          // byte to send (MSB first)
    output logic [7:0]      rdata,          // byte received, valid with `done`
    output logic            busy,
    output logic            done,           // 1 cycle when rdata is valid

    output logic            sck,
    output logic            mosi,
    input  wire             miso
);

  logic [7:0]      sh;
  logic [3:0]      bits;                    // rising edges seen, 0..8
  logic [DIVW-1:0] cnt;

  wire tick = (cnt == '0);

  always_ff @(posedge clk) begin
    done <= 1'b0;

    if (rst) begin
      busy  <= 1'b0;
      sck   <= 1'b0;
      mosi  <= 1'b1;                        // idle high: SD cards want MOSI=1
      sh    <= 8'hFF;
      bits  <= '0;
      cnt   <= '0;
      rdata <= 8'h00;
    end else if (!busy) begin
      sck <= 1'b0;
      if (start) begin
        busy <= 1'b1;
        sh   <= wdata;
        mosi <= wdata[7];                   // first bit out before the first rise
        bits <= '0;
        cnt  <= div;
      end
    end else if (!tick) begin
      cnt <= cnt - 1'b1;
    end else begin
      cnt <= div;
      if (!sck) begin
        // ---- rising edge: slave samples MOSI, we sample MISO ----
        sck <= 1'b1;
        sh  <= {sh[6:0], miso};
        bits <= bits + 4'd1;
      end else begin
        // ---- falling edge: present the next outgoing bit ----
        sck <= 1'b0;
        if (bits == 4'd8) begin
          busy  <= 1'b0;
          done  <= 1'b1;
          rdata <= sh;
          mosi  <= 1'b1;
        end else begin
          mosi <= sh[7];
        end
      end
    end
  end

endmodule

`default_nettype wire
