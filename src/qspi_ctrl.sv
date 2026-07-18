// qspi_ctrl.sv — external memory controller for the TinyTapeout QSPI Pmod
// (W25Q128 flash + APS6404 PSRAM), plus the 2:1 fetch/data arbiter.
//
// v2: optional QUAD data paths, opt-in per device via the cfg input
// (wired to the CPU's QSPI_CFG MMIO register, which RESETS TO 0 = plain
// 1-bit SPI mode 0 — the chip always boots in the mode that cannot fail,
// software enables quad afterwards):
//   cfg[0]: flash reads use 6Bh Fast Read Quad Output (command + address
//           + 8 dummies serial on SD0, data quad on SD3..0). Requires the
//           flash QE bit — factory-set on the QSPI Pmod's W25Q128JV.
//   cfg[1]: PSRAM reads use EBh (cmd serial, address quad, 6 waits, data
//           quad) and writes use 38h (cmd serial, address + data quad).
// SCK = clk/2 throughout. Serial 64-bit burst read: ~132 clk; quad flash
// burst: ~114 clk of which only 16 SCK are data; quad PSRAM word write:
// ~50 clk.
//
// Request port protocol (unchanged from v1): master holds req until the
// 1-cycle ack; rdata (+rdata2 for burst) valid during ack. Word address
// bit 22 selects the device: 0 = flash (CS0), 1 = PSRAM (CS1). Writes
// send only the contiguous byte run marked by `be`; writes to flash are
// acknowledged no-ops.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module qspi_ctrl (
    input  logic        clk,
    input  logic        rst,

    input  logic [1:0]  cfg,     // 0: flash quad read, 1: PSRAM quad rd/wr

    input  logic        req,
    input  logic        we,
    input  logic        burst,   // read 64 bits: rdata = word@addr, rdata2 = word@addr+1
    input  logic [22:0] addr,    // word address; bit 22: 0=flash, 1=PSRAM
    input  logic [31:0] wdata,   // bytes pre-shifted into lane position
    input  logic [3:0]  be,
    output logic        ack,
    output logic [31:0] rdata,
    output logic [31:0] rdata2,

    output logic        sck,
    output logic [3:0]  sd_out,  // SD3..0 output values
    output logic [3:0]  sd_oe,   // SD3..0 output enables
    input  logic [3:0]  sd_in,   // SD3..0 input values
    output logic        cs_flash_n,
    output logic        cs_ram_n
);

  localparam [3:0] S_IDLE  = 4'd0, S_CMDA = 4'd1, S_QADDR = 4'd2,
                   S_DUMMY = 4'd3, S_WR   = 4'd4, S_QWR   = 4'd5,
                   S_RD    = 4'd6, S_QRD  = 4'd7, S_FIN   = 4'd8;

  logic [3:0]  state;
  logic [39:0] osh;      // output shift register (cmd [+addr [+dummies]])
  logic [63:0] ish;      // input shift register
  logic [6:0]  nbits;    // units left in phase: bits / nibbles / SCK ticks
  logic [31:0] wsh_q;
  logic [6:0]  wbits_q;
  logic        burst_q;

  // per-transaction phase plan, latched in S_IDLE
  logic        we_q;       // write transaction
  logic        qaddr_q;    // CMDA is cmd-only; address goes out quad next
  logic        dq_q;       // data phase is quad
  logic        dummy_q;    // 6 wait SCK between quad address and quad data
  logic [23:0] baddr_q;

  wire dev_ram = addr[22];
  wire [1:0] first = be[0] ? 2'd0 : be[1] ? 2'd1 : be[2] ? 2'd2 : 2'd3;
  wire [23:0] baddr = {addr[21:0], we ? first : 2'b00};

  wire fl_quad  = cfg[0] && !dev_ram && !we;
  wire ram_quad = cfg[1] && dev_ram;

  logic [7:0] cmd;
  always_comb
    if (we)           cmd = ram_quad ? 8'h38 : 8'h02;
    else if (dev_ram) cmd = ram_quad ? 8'hEB : 8'h03;
    else              cmd = fl_quad ? 8'h6B : 8'h03;

  // write bytes, packed first-sent at the top (memory order; MSB-first
  // bits serially, high-nibble-first in quad — same packing serves both)
  logic [31:0] wpack;
  logic [6:0]  wbits;
  always_comb
    case (be)
      4'b1111: begin wpack = {wdata[7:0], wdata[15:8], wdata[23:16], wdata[31:24]}; wbits = 7'd32; end
      4'b0011: begin wpack = {wdata[7:0],  wdata[15:8],  16'h0}; wbits = 7'd16; end
      4'b1100: begin wpack = {wdata[23:16], wdata[31:24], 16'h0}; wbits = 7'd16; end
      4'b0001: begin wpack = {wdata[7:0],   24'h0}; wbits = 7'd8; end
      4'b0010: begin wpack = {wdata[15:8],  24'h0}; wbits = 7'd8; end
      4'b0100: begin wpack = {wdata[23:16], 24'h0}; wbits = 7'd8; end
      default: begin wpack = {wdata[31:24], 24'h0}; wbits = 7'd8; end
    endcase

  // pad drive: serial phases talk on SD0 only; quad-out phases drive all
  // four; input/dummy phases release the bus (Pmod pull-ups keep the
  // flash's WP#/HOLD# deasserted while SD2/SD3 float in serial mode)
  logic serial_out, quad_out;
  assign serial_out = (state == S_IDLE) || (state == S_CMDA) || (state == S_WR)
                   || (state == S_FIN);
  assign quad_out   = (state == S_QADDR) || (state == S_QWR);
  assign sd_oe  = quad_out ? 4'b1111 : serial_out ? 4'b0001 : 4'b0000;
  assign sd_out = quad_out ? osh[39:36] : {3'b000, osh[39]};

  always_ff @(posedge clk)
    if (rst) begin
      state      <= S_IDLE;
      sck        <= 1'b0;
      cs_flash_n <= 1'b1;
      cs_ram_n   <= 1'b1;
      ack        <= 1'b0;
      rdata      <= 32'd0;
      rdata2     <= 32'd0;
      osh        <= 40'd0;
      ish        <= 64'd0;
      nbits      <= 7'd0;
      wsh_q      <= 32'd0;
      wbits_q    <= 7'd0;
      burst_q    <= 1'b0;
      we_q       <= 1'b0;
      qaddr_q    <= 1'b0;
      dq_q       <= 1'b0;
      dummy_q    <= 1'b0;
      baddr_q    <= 24'd0;
    end else begin
      ack <= 1'b0;

      case (state)
        S_IDLE:
          if (req && !ack) begin
            if (we && !dev_ram) begin
              ack <= 1'b1;                      // flash is read-only: no-op
            end else begin
              // phase plan
              we_q    <= we;
              burst_q <= burst && !we;
              wsh_q   <= wpack;
              wbits_q <= wbits;
              baddr_q <= baddr;
              qaddr_q <= ram_quad;              // EBh/38h: address goes quad
              dq_q    <= fl_quad || ram_quad;
              dummy_q <= ram_quad && !we;       // EBh: 6 waits before data
              if (ram_quad) begin
                osh   <= {cmd, 32'd0};          // cmd only; address follows quad
                nbits <= 7'd8;
              end else if (fl_quad) begin
                osh   <= {cmd, baddr, 8'd0};    // 6Bh + addr + 8 dummy bits
                nbits <= 7'd40;
              end else begin
                osh   <= {cmd, baddr, 8'd0};    // classic 03h/02h + addr
                nbits <= 7'd32;
              end
              cs_flash_n <= dev_ram;
              cs_ram_n   <= ~dev_ram;
              sck        <= 1'b0;
              state      <= S_CMDA;
            end
          end

        S_CMDA:                                 // serial out, MSB on SD0
          if (!sck) sck <= 1'b1;                // rising edge: slave samples
          else begin                            // falling edge: next bit out
            sck   <= 1'b0;
            osh   <= {osh[38:0], 1'b0};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) begin
              if (qaddr_q) begin
                osh   <= {baddr_q, 16'd0};      // 6 nibbles, high first
                nbits <= 7'd6;
                state <= S_QADDR;
              end else if (we_q) begin
                osh   <= {wsh_q, 8'd0};
                nbits <= wbits_q;
                state <= S_WR;
              end else if (dq_q) begin
                nbits <= burst_q ? 7'd16 : 7'd8;
                state <= S_QRD;
              end else begin
                nbits <= burst_q ? 7'd64 : 7'd32;
                state <= S_RD;
              end
            end
          end

        S_QADDR:                                // quad out: address nibbles
          if (!sck) sck <= 1'b1;
          else begin
            sck   <= 1'b0;
            osh   <= {osh[35:0], 4'b0};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) begin
              if (we_q) begin
                osh   <= {wsh_q, 8'd0};
                nbits <= {2'b00, wbits_q[6:2]}; // nibble count = bits/4
                state <= S_QWR;
              end else begin
                nbits <= 7'd6;                  // EBh wait cycles
                state <= S_DUMMY;
              end
            end
          end

        S_DUMMY:                                // bus released, clock runs
          if (!sck) sck <= 1'b1;
          else begin
            sck   <= 1'b0;
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) begin
              nbits <= burst_q ? 7'd16 : 7'd8;
              state <= S_QRD;
            end
          end

        S_WR:                                   // serial data out
          if (!sck) sck <= 1'b1;
          else begin
            sck   <= 1'b0;
            osh   <= {osh[38:0], 1'b0};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) state <= S_FIN;
          end

        S_QWR:                                  // quad data out
          if (!sck) sck <= 1'b1;
          else begin
            sck   <= 1'b0;
            osh   <= {osh[35:0], 4'b0};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) state <= S_FIN;
          end

        S_RD:                                   // serial in on SD1
          if (!sck) begin                       // rising edge: sample
            sck   <= 1'b1;
            ish   <= {ish[62:0], sd_in[1]};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) state <= S_FIN;
          end else
            sck <= 1'b0;

        S_QRD:                                  // quad in, nibble per edge
          if (!sck) begin
            sck   <= 1'b1;
            ish   <= {ish[59:0], sd_in};
            nbits <= nbits - 7'd1;
            if (nbits == 7'd1) state <= S_FIN;
          end else
            sck <= 1'b0;

        default: begin                          // S_FIN: deselect + ack
          sck        <= 1'b0;
          cs_flash_n <= 1'b1;
          cs_ram_n   <= 1'b1;
          // serial MSB-first and quad high-nibble-first leave the same
          // layout in ish: first byte from memory is the lowest byte
          if (burst_q) begin
            rdata  <= {ish[39:32], ish[47:40], ish[55:48], ish[63:56]};
            rdata2 <= {ish[7:0], ish[15:8], ish[23:16], ish[31:24]};
          end else
            rdata <= {ish[7:0], ish[15:8], ish[23:16], ish[31:24]};
          ack        <= 1'b1;
          state      <= S_IDLE;
        end
      endcase
    end

endmodule

// 2:1 arbiter: data port has priority (rarer, and the pipeline is frozen on
// it); grant is held until the controller acks.
module mem_arbiter (
    input  logic        clk,
    input  logic        rst,

    // instruction fetch port
    input  logic        f_req,
    input  logic [22:0] f_addr,
    output logic        f_ack,

    // data port
    input  logic        d_req,
    input  logic        d_we,
    input  logic [22:0] d_addr,
    input  logic [31:0] d_wdata,
    input  logic [3:0]  d_be,
    output logic        d_ack,

    // downstream (qspi_ctrl)
    output logic        m_req,
    output logic        m_we,
    output logic        m_burst,
    output logic [22:0] m_addr,
    output logic [31:0] m_wdata,
    output logic [3:0]  m_be,
    input  logic        m_ack
);

  localparam [1:0] G_NONE = 2'd0, G_FETCH = 2'd1, G_DATA = 2'd2;

  logic [1:0] grant;

  always_ff @(posedge clk)
    if (rst)                  grant <= G_NONE;
    else if (grant == G_NONE) grant <= d_req ? G_DATA : f_req ? G_FETCH : G_NONE;
    else if (m_ack)           grant <= G_NONE;

  assign m_req   = (grant == G_DATA) ? d_req : (grant == G_FETCH) ? f_req : 1'b0;
  assign m_we    = (grant == G_DATA) ? d_we : 1'b0;
  assign m_burst = (grant == G_FETCH);          // fetches always read a pair
  assign m_addr  = (grant == G_DATA) ? d_addr : f_addr;
  assign m_wdata = d_wdata;
  assign m_be    = (grant == G_DATA) ? d_be : 4'b1111;
  assign f_ack   = (grant == G_FETCH) && m_ack;
  assign d_ack   = (grant == G_DATA) && m_ack;

endmodule
