// sd_spi.sv — microSD card in SPI mode: init + 512-byte block reads.
// HARNESS ONLY (fpga/), never hardened — see sd_loader.sv for why.
//
// STRUCTURE. Two flat state machines, deliberately:
//   * a byte engine that owns `spi_master` and answers one-cycle `b_req`
//     pulses with a `b_ack` pulse;
//   * a command sequencer whose `seq` register names WHICH command is in
//     flight while `st` names WHERE in that command we are.
// Nothing nests, so there is no return-address register to get clobbered —
// an earlier draft of this file tried to share leaf routines through a single
// `ret` register and could not survive one leaf calling another.
//
// SD SPI bring-up, in order:
//   >=74 clocks with CS high    card samples the bus and wakes
//   CMD0  (0x95 CRC)            go idle          -> R1 = 0x01
//   CMD8  (0x87 CRC, 0x1AA)     voltage check    -> R1 + 4 bytes (R7)
//   CMD55 + ACMD41(HCS)         init, loop until -> R1 = 0x00
//   CMD58                       read OCR         -> R1 + 4 bytes, CCS = OCR[30]
//   CMD16 (512)                 block length — only needed when CCS = 0
// CRC7 is only checked for CMD0 and CMD8 (SPI mode boots with CRC off), which
// is why just those two carry real CRC bytes and everything else sends 0x01.
//
// Block reads use CMD17 one block at a time. CMD18 multi-block would be
// faster, but a 256 KiB image is ~500 blocks ~= 0.2 s at 12.5 MHz either way,
// and single-block is markedly easier to prove correct.
//
// Byte addressing (CCS=0, cards <=2 GB) shifts the block number left 9 bits;
// SDHC/SDXC (CCS=1) addresses in blocks directly.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module sd_spi #(
    parameter int CLK_HZ   = 25_000_000,
    parameter int DIV_SLOW = (CLK_HZ / 400_000) / 2,   // ~198 kHz at 25 MHz
    parameter int DIV_FAST = 0                         // 12.5 MHz at 25 MHz
) (
    input  wire        clk,
    input  wire        rst,

    input  wire        init,            // pulse: run the bring-up sequence
    input  wire        rd,              // pulse: read block `blk`
    input  wire        wr,              // pulse: write block `blk`
    input  wire [31:0] blk,
    output logic       ready,           // initialised, idle, accepting rd/wr
    output logic       busy,
    output logic       err,

    output logic       rvalid,          // one pulse per received data byte
    output logic [7:0] rdata,
    output logic       rdone,           // pulse: 512 bytes + CRC consumed

    // Write side. The engine PULLS its data: it drives `wptr` and expects
    // `wbyte` to be that byte of the block, combinationally. No handshake,
    // because a handshake is one more thing to get wrong and the source is a
    // plain buffer that can always answer.
    output logic [8:0] wptr,
    input  wire [7:0]  wbyte,
    output logic       wdone,           // pulse: written AND the card is idle

    output logic       cs_n,
    output logic       sck,
    output logic       mosi,
    input  wire        miso
);

  // ------------------------------------------------------------ byte engine
  logic [7:0] spi_div, spi_tx, spi_rx;
  logic       spi_start, spi_busy, spi_done;

  spi_master #(.DIVW(8)) spi (
      .clk (clk), .rst (rst),
      .div (spi_div), .start (spi_start), .wdata (spi_tx), .rdata (spi_rx),
      .busy (spi_busy), .done (spi_done),
      .sck (sck), .mosi (mosi), .miso (miso)
  );

  logic       b_req, b_ack, b_run;
  logic [7:0] b_tx, b_rx;

  always_ff @(posedge clk) begin
    b_ack     <= 1'b0;
    spi_start <= 1'b0;
    if (rst) begin
      b_run <= 1'b0;
    end else if (b_req) begin           // b_req is always a one-cycle pulse
      spi_tx    <= b_tx;
      spi_start <= 1'b1;
      b_run     <= 1'b1;
    end else if (b_run && spi_done) begin
      b_rx  <= spi_rx;
      b_ack <= 1'b1;
      b_run <= 1'b0;
    end
  end

  // --------------------------------------------------------------- sequencer
  typedef enum logic [4:0] {
    S_IDLE, S_PWR, S_SEQ, S_TX, S_R1, S_EXTRA, S_AFTER,
    S_TOKEN, S_DATA, S_CRC, S_TAIL, S_READY, S_ERR,
    // The write path. A write is NOT a read with the arrows reversed: after
    // the card accepts the data it goes BUSY for milliseconds, holding MISO
    // low while it erases and programs, and nothing on the read path waits on
    // anything like that. S_WBUSY is that wait, and skipping it corrupts the
    // NEXT command rather than this one.
    S_WGAP, S_WTOK, S_WDATA, S_WCRC, S_WRESP, S_WBUSY
  } st_t;

  typedef enum logic [2:0] {
    Q_CMD0, Q_CMD8, Q_CMD55, Q_ACMD41, Q_CMD58, Q_CMD16, Q_READ, Q_WRITE
  } seq_t;

  st_t  st;
  seq_t seq;

  logic [7:0]  cmdbuf [0:5];
  logic [2:0]  cmd_idx;
  logic [2:0]  extra;                   // trailing R3/R7 bytes to drain
  logic [7:0]  r1;
  logic [3:0]  r1_tries;
  logic [15:0] budget;                  // ACMD41 / CMD0 retry budget
  logic [15:0] tok_tries;
  logic [9:0]  dcnt;
  logic        ccs;
  logic        pending;                 // a byte request is in flight

  // Build the 6-byte command frame for `seq`.
  task automatic mkcmd(input logic [7:0] c, input logic [31:0] a,
                       input logic [7:0] crc, input logic [2:0] ex);
    cmdbuf[0] <= c;
    cmdbuf[1] <= a[31:24];
    cmdbuf[2] <= a[23:16];
    cmdbuf[3] <= a[15:8];
    cmdbuf[4] <= a[7:0];
    cmdbuf[5] <= crc;
    cmd_idx   <= 3'd0;
    extra     <= ex;
  endtask

  wire [31:0] blk_arg = ccs ? blk : (blk << 9);

  always_ff @(posedge clk) begin
    b_req  <= 1'b0;                     // default: no byte requested
    rvalid <= 1'b0;
    rdone  <= 1'b0;
    wdone  <= 1'b0;

    if (rst) begin
      st      <= S_IDLE;
      seq     <= Q_CMD0;
      ready   <= 1'b0;
      busy    <= 1'b0;
      err     <= 1'b0;
      cs_n    <= 1'b1;
      spi_div <= 8'(DIV_SLOW);
      ccs     <= 1'b0;
      pending <= 1'b0;
      dcnt    <= '0;
      wptr    <= 9'd0;
    end else begin
      unique case (st)

        S_IDLE: begin
          busy <= 1'b0;
          if (init) begin
            busy    <= 1'b1;
            ready   <= 1'b0;
            err     <= 1'b0;
            cs_n    <= 1'b1;            // wake-up clocks go out DESELECTED
            spi_div <= 8'(DIV_SLOW);
            dcnt    <= 10'd10;          // 10 bytes = 80 clocks >= the required 74
            pending <= 1'b0;
            st      <= S_PWR;
          end else if (rd && ready) begin
            busy    <= 1'b1;
            cs_n    <= 1'b0;
            budget  <= 16'd16;
            mkcmd(8'h51, blk_arg, 8'h01, 3'd0);   // CMD17 READ_SINGLE_BLOCK
            seq     <= Q_READ;
            pending <= 1'b0;
            st      <= S_TX;
          end else if (wr && ready) begin
            busy    <= 1'b1;
            cs_n    <= 1'b0;
            budget  <= 16'd16;
            mkcmd(8'h58, blk_arg, 8'h01, 3'd0);   // CMD24 WRITE_BLOCK
            seq     <= Q_WRITE;
            wptr    <= 9'd0;
            pending <= 1'b0;
            st      <= S_TX;
          end
        end

        // ---- 80 idle clocks with CS high ----
        S_PWR: begin
          if (!pending) begin
            if (dcnt == 0) begin
              cs_n    <= 1'b0;
              budget  <= 16'd500;
              seq     <= Q_CMD0;
              mkcmd(8'h40, 32'h0000_0000, 8'h95, 3'd0);
              st      <= S_TX;
            end else begin
              b_req   <= 1'b1;
              b_tx    <= 8'hFF;
              pending <= 1'b1;
            end
          end else if (b_ack) begin
            pending <= 1'b0;
            dcnt    <= dcnt - 1'b1;
          end
        end

        // ---- shift the 6 command bytes ----
        S_TX: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= cmdbuf[cmd_idx];
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (cmd_idx == 3'd5) begin
              r1_tries <= 4'd15;
              st       <= S_R1;
            end else begin
              cmd_idx <= cmd_idx + 3'd1;
            end
          end
        end

        // ---- poll 0xFF until the card answers (R1 has bit 7 clear) ----
        S_R1: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (!b_rx[7]) begin
              r1 <= b_rx;
              st <= (extra != 0) ? S_EXTRA : S_AFTER;
            end else if (r1_tries == 0) begin
              st <= S_ERR;
            end else begin
              r1_tries <= r1_tries - 4'd1;
            end
          end
        end

        // ---- drain the 4 trailing bytes of R3/R7; OCR[30] is CCS ----
        S_EXTRA: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            // first trailing byte of CMD58's R3 is OCR[31:24]
            if (seq == Q_CMD58 && extra == 3'd4) ccs <= b_rx[6];
            if (extra == 3'd1) st <= S_AFTER;
            extra <= extra - 3'd1;
          end
        end

        // ---- decide what follows, per command ----
        S_AFTER: begin
          unique case (seq)
            Q_CMD0:
              if (r1 == 8'h01) begin
                seq <= Q_CMD8;
                mkcmd(8'h48, 32'h0000_01AA, 8'h87, 3'd4);
                st  <= S_TX;
              end else if (budget == 0) begin
                st <= S_ERR;
              end else begin
                budget <= budget - 16'd1;
                mkcmd(8'h40, 32'h0000_0000, 8'h95, 3'd0);
                st     <= S_TX;
              end

            Q_CMD8: begin
              // r1 == 0x05 means a v1 card (illegal command); it still works,
              // it simply never sets CCS, so carry on either way.
              budget <= 16'd8000;
              seq    <= Q_CMD55;
              mkcmd(8'h77, 32'h0000_0000, 8'h01, 3'd0);
              st     <= S_TX;
            end

            Q_CMD55: begin
              seq <= Q_ACMD41;
              mkcmd(8'h69, 32'h4000_0000, 8'h01, 3'd0);   // HCS set
              st  <= S_TX;
            end

            Q_ACMD41:
              if (r1 == 8'h00) begin
                seq <= Q_CMD58;
                mkcmd(8'h7A, 32'h0000_0000, 8'h01, 3'd4);
                st  <= S_TX;
              end else if (budget == 0) begin
                st <= S_ERR;
              end else begin
                budget <= budget - 16'd1;
                seq    <= Q_CMD55;
                mkcmd(8'h77, 32'h0000_0000, 8'h01, 3'd0);
                st     <= S_TX;
              end

            Q_CMD58:
              if (ccs) begin
                st <= S_READY;                            // SDHC: 512 B fixed
              end else begin
                seq <= Q_CMD16;
                mkcmd(8'h50, 32'd512, 8'h01, 3'd0);
                st  <= S_TX;
              end

            Q_CMD16: st <= S_READY;

            Q_READ:
              if (r1 == 8'h00) begin
                tok_tries <= 16'd50000;                   // ~4 ms at 12.5 MHz
                st        <= S_TOKEN;
              end else begin
                st <= S_ERR;
              end

            Q_WRITE:
              if (r1 == 8'h00) begin
                st <= S_WGAP;
              end else begin
                st <= S_ERR;
              end

            default: st <= S_ERR;
          endcase
        end

        S_READY: begin
          spi_div <= 8'(DIV_FAST);
          cs_n    <= 1'b1;
          ready   <= 1'b1;
          busy    <= 1'b0;
          st      <= S_IDLE;
        end

        // ---- wait for the 0xFE start-of-data token ----
        S_TOKEN: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (b_rx == 8'hFE) begin
              dcnt <= 10'd0;
              st   <= S_DATA;
            end else if (b_rx[7:4] == 4'h0) begin
              st <= S_ERR;                                // data error token
            end else if (tok_tries == 0) begin
              st <= S_ERR;
            end else begin
              tok_tries <= tok_tries - 16'd1;
            end
          end
        end

        // ---- 512 payload bytes ----
        S_DATA: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            rvalid  <= 1'b1;
            rdata   <= b_rx;
            if (dcnt == 10'd511) begin
              dcnt <= 10'd2;
              st   <= S_CRC;
            end else begin
              dcnt <= dcnt + 10'd1;
            end
          end
        end

        // ---- 2 CRC bytes, discarded (SPI-mode CRC is off) ----
        S_CRC: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (dcnt == 10'd1) st <= S_TAIL;
            dcnt <= dcnt - 10'd1;
          end
        end

        // ================= CMD24 WRITE_BLOCK, the write path =================

        // ---- one idle byte between the R1 and the data token ----
        // The spec calls for at least one byte of gap. Cards do accept the
        // token immediately, but not all of them, and the failure is a write
        // that reports success and lands nowhere.
        S_WGAP: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            st      <= S_WTOK;
          end
        end

        // ---- the start-of-block token ----
        // 0xFE for a single-block write, the same token the card sends us on a
        // read. (Multi-block writes use 0xFC and a stop token; not implemented,
        // because CMD24 is enough for a block driver that writes one at a time.)
        S_WTOK: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFE;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            wptr    <= 9'd0;
            st      <= S_WDATA;
          end
        end

        // ---- 512 payload bytes, pulled from the caller ----
        // `wbyte` is expected to be combinational on `wptr`, so the byte is
        // already there when it is loaded. wptr advances only on b_ack, so a
        // byte cannot be skipped by a stall in the SPI master.
        S_WDATA: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= wbyte;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (wptr == 9'd511) begin
              dcnt <= 10'd2;
              st   <= S_WCRC;
            end else begin
              wptr <= wptr + 9'd1;
            end
          end
        end

        // ---- 2 CRC bytes ----
        // Dummy: SPI-mode CRC is off, and the card ignores these. They are not
        // optional though — the card counts them, and swallowing them would
        // leave it waiting two bytes into the next command.
        S_WCRC: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if (dcnt == 10'd1) begin
              tok_tries <= 16'd50000;
              st        <= S_WRESP;
            end
            dcnt <= dcnt - 10'd1;
          end
        end

        // ---- the data response token: xxx0sss1 ----
        // ⚠️ THIS IS THE ONLY THING THAT SAYS THE WRITE WORKED. Without
        // checking it a rejected block looks exactly like an accepted one, and
        // the corruption shows up much later as a damaged filesystem. Wait for
        // a byte with bit0 set and bit4 clear, then sss must be 010.
        //   010 accepted   101 CRC error   110 write error
        S_WRESP: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            if ((b_rx & 8'h11) == 8'h01) begin
              if ((b_rx & 8'h1F) == 8'h05) begin
                tok_tries <= 16'hFFFF;
                st        <= S_WBUSY;
              end else begin
                st <= S_ERR;                              // rejected, and said so
              end
            end else if (tok_tries == 0) begin
              st <= S_ERR;
            end else begin
              tok_tries <= tok_tries - 16'd1;
            end
          end
        end

        // ---- the card is BUSY: it holds MISO LOW while it programs ----
        // Milliseconds, not microseconds, and there is nothing like it on the
        // read path. Deselecting before the card lets go corrupts whatever
        // command comes next, so this wait is part of the write.
        S_WBUSY: begin
          if (!pending) begin
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            // ⚠️ DO NOT PULSE `wdone` HERE. Completion is signalled in
            // S_TAIL, at the same instant `busy` drops — that is the whole
            // discipline `rdone` follows, and it is what makes "done" mean
            // "and you may issue the next command". Signalling here instead
            // let software start a read while busy was still high, and
            // sd_ctrl's `if (!busy)` guard silently DROPPED it: the next read
            // returned the previous block's data, which looks like a
            // addressing bug and is not one. Caught by tb_sd's read-after-write.
            if (b_rx != 8'h00) begin
              st <= S_TAIL;
            end else if (tok_tries == 0) begin
              st <= S_ERR;
            end else begin
              tok_tries <= tok_tries - 16'd1;
            end
          end
        end

        // ---- deselect, then one trailing byte so the card releases MISO ----
        S_TAIL: begin
          if (!pending) begin
            cs_n    <= 1'b1;
            b_req   <= 1'b1;
            b_tx    <= 8'hFF;
            pending <= 1'b1;
          end else if (b_ack) begin
            pending <= 1'b0;
            // One completion point for both operations, distinguished by which
            // one is in flight. Two separate points would be two chances to get
            // the busy/done ordering wrong.
            rdone   <= (seq != Q_WRITE);
            wdone   <= (seq == Q_WRITE);
            busy    <= 1'b0;
            st      <= S_IDLE;
          end
        end

        S_ERR: begin
          cs_n  <= 1'b1;
          err   <= 1'b1;
          ready <= 1'b0;
          busy  <= 1'b0;
          st    <= S_IDLE;
        end

        default: st <= S_ERR;
      endcase
    end
  end

endmodule

`default_nettype wire
