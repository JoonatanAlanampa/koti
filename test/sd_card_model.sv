`default_nettype none
`timescale 1ns / 1ps

/* sd_card_model.sv — a microSD card in SPI mode, enough of one to boot from.
 *
 * SIMULATION ONLY. console verifies its copy of `sd_spi.sv` with a Python card
 * model under cocotb; koti needs a Verilog one, because cocotb is not installed
 * on the development host and the whole point of this repo's plain-Verilog
 * benches is that the loop costs seconds instead of a CI round trip.
 *
 * WHAT IT ANSWERS, in the order sd_spi.sv asks:
 *   CMD0  -> R1 = 0x01   (idle state)
 *   CMD8  -> R1 = 0x01 + 0x00 0x00 0x01 0xAA   (R7, echoes the check pattern)
 *   CMD55 -> R1 = 0x01
 *   ACMD41-> R1 = 0x01 for BUSY_TRIES attempts, then 0x00
 *   CMD58 -> R1 = 0x00 + OCR with CCS set (an SDHC card, block-addressed)
 *   CMD16 -> R1 = 0x00   (accepted even though an SDHC card ignores it)
 *   CMD17 -> R1 = 0x00, some idle bytes, token 0xFE, 512 data bytes, 2 CRC
 *   anything else -> R1 = 0x04 (illegal command), which is what makes a wrong
 *                    command visible instead of hanging the bench
 *
 * ⚠️ ACMD41 STAYS BUSY ON PURPOSE. A card that is ready on the first try lets a
 * broken retry loop pass, and the retry loop is the part of SD bring-up that is
 * actually easy to get wrong. console's suite makes the same choice.
 *
 * DATA IS DERIVED FROM THE BLOCK NUMBER — `data(lba, i) = lba*13 + i*7`. A
 * constant payload would pass even if every read returned block 0, which is the
 * failure a boot loader cannot survive and cannot see.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 */
module sd_card_model #(
    parameter integer BUSY_TRIES = 3,     // ACMD41s answered 0x01 before 0x00
    parameter integer IMG_BLOCKS = 64     // how many blocks the overlay covers
) (
    input  wire cs_n,
    input  wire sck,
    input  wire mosi,
    output wire miso
);

  // ---- optional real-image overlay --------------------------------------
  // +sdimg=<hexfile> +sdimg_lba=<n> makes blocks [n, n+IMG_BLOCKS) come from a
  // file instead of the synthetic pattern. That is what lets the firmware's
  // microSD kernel loader be tested against a REAL header and a real checksum:
  // the synthetic pattern can never carry a valid one, so without this the
  // loader could only ever be exercised down its reject path.
  // Off unless BOTH plusargs are given, so every existing bench is untouched.
  reg  [7:0]      img [0:IMG_BLOCKS*512-1];
  reg  [8*256-1:0] img_file;
  reg  [31:0]     img_lba = 32'd0;
  reg             img_on  = 1'b0;
  integer         img_lba_i;

  initial begin
    if ($value$plusargs("sdimg_lba=%d", img_lba_i)
        && $value$plusargs("sdimg=%s", img_file)) begin
      // Zero first: $readmemh leaves anything the file does not cover as x,
      // and x bytes reaching the loader would corrupt its checksum in a way
      // that looks like a transport bug rather than a short file.
      for (int k = 0; k < IMG_BLOCKS*512; k = k + 1)
        img[k] = 8'h00;
      $readmemh(img_file, img);
      img_lba = img_lba_i[31:0];
      img_on  = 1'b1;
      $display("SD MODEL: overlay %0d blocks from LBA %0d", IMG_BLOCKS, img_lba);
    end
  end

  // The byte a real card computes for block `lba`, offset `i`, or the overlay
  // byte when one is loaded and covers that block. Exposed as a function so the
  // bench checks against the SAME expression the model serves — one definition,
  // so a disagreement is impossible.
  function automatic [7:0] payload(input [31:0] lba, input [31:0] i);
    if (img_on && lba >= img_lba && lba < (img_lba + IMG_BLOCKS))
      payload = img[((lba - img_lba) * 32'd512) + i];
    else
      payload = 8'((lba * 32'd13) + (i * 32'd7));
  endfunction

  localparam [3:0] S_IDLE = 4'd0, S_RESP = 4'd1, S_WAIT = 4'd2,
                   S_TOK  = 4'd3, S_DATA = 4'd4, S_CRC  = 4'd5;

  // ⚠️ STATE OWNERSHIP IS SPLIT ON PURPOSE, and getting this wrong is what the
  // first version of this file got wrong. Two processes on the two sck edges
  // both writing `st`/`resp_i` is a race: the response came out shifted and the
  // engine never initialised. Now the RECEIVE side (posedge) owns the command
  // frame and hands over a one-shot; the TRANSMIT side (negedge) owns the
  // response state machine and nothing else touches it.
  reg  [7:0]  rx_sh   = 8'hFF;
  reg  [3:0]  rx_n    = 4'd0;
  reg  [7:0]  frame [0:5];
  reg  [2:0]  fn      = 3'd0;
  reg         in_frame = 1'b0;

  // the handover: receive -> transmit
  reg         cmd_ready = 1'b0;          // one-shot: a response is queued
  reg  [7:0]  resp [0:4];
  reg  [2:0]  resp_n  = 3'd0;
  reg         is_read = 1'b0;            // CMD17: continue into a data phase
  reg  [31:0] rd_lba  = 32'd0;

  // transmit-side only
  reg  [3:0]  st      = S_IDLE;
  reg  [2:0]  resp_i  = 3'd0;
  reg  [9:0]  data_i  = 10'd0;
  reg  [3:0]  wait_i  = 4'd0;
  reg  [7:0]  tx_sh   = 8'hFF;

  reg  [7:0]  acmd41_left = BUSY_TRIES;

  assign miso = cs_n ? 1'b1 : tx_sh[7];

  // ---- receive: the slave samples MOSI on the RISING edge (mode 0) --------
  always @(posedge sck) if (!cs_n) begin
    if (rx_n == 4'd7) begin
      rx_n = 4'd0;
      byte_in({rx_sh[6:0], mosi});
    end else begin
      rx_n  = rx_n + 4'd1;
      rx_sh = {rx_sh[6:0], mosi};
    end
  end

  task byte_in(input [7:0] b);
    begin
      if (in_frame) begin
        frame[fn] = b;
        if (fn == 3'd5) begin
          in_frame = 1'b0;
          fn       = 3'd0;
          do_cmd();
        end else begin
          fn = fn + 3'd1;
        end
      // A command byte is 01xxxxxx. Everything else on MOSI while a response is
      // clocking out is the master's 0xFF filler and must not start a frame.
      end else if (b[7:6] == 2'b01) begin
        in_frame = 1'b1;
        frame[0] = b;
        fn       = 3'd1;
      end
    end
  endtask

  task queue_r1(input [7:0] r1);
    begin
      resp[0] = r1; resp_n = 3'd1; cmd_ready = 1'b1;
    end
  endtask

  task do_cmd;
    reg [5:0]  cmd;
    reg [31:0] arg;
    begin
      cmd     = frame[0][5:0];
      arg     = {frame[1], frame[2], frame[3], frame[4]};
      is_read = (cmd == 6'd17);
`ifdef SD_MODEL_DEBUG
      $display("[card %0t] CMD%0d arg=%08h", $time, cmd, arg);
`endif
      case (cmd)
        6'd0:  queue_r1(8'h01);                     // GO_IDLE
        6'd8:  begin                                // SEND_IF_COND -> R7
                 resp[0] = 8'h01; resp[1] = 8'h00; resp[2] = 8'h00;
                 resp[3] = 8'h01; resp[4] = 8'hAA;
                 resp_n = 3'd5; cmd_ready = 1'b1;
               end
        6'd55: queue_r1(8'h01);                     // APP_CMD
        6'd41: begin                                // ACMD41, busy N times first
                 if (acmd41_left != 8'd0) begin
                   acmd41_left = acmd41_left - 8'd1;
                   queue_r1(8'h01);
                 end else
                   queue_r1(8'h00);
               end
        6'd58: begin                                // READ_OCR, CCS=1 (SDHC)
                 resp[0] = 8'h00; resp[1] = 8'hC0; resp[2] = 8'hFF;
                 resp[3] = 8'h80; resp[4] = 8'h00;
                 resp_n = 3'd5; cmd_ready = 1'b1;
               end
        6'd16: queue_r1(8'h00);                     // SET_BLOCKLEN
        6'd17: begin                                // READ_SINGLE_BLOCK
                 rd_lba  = arg;
                 queue_r1(8'h00);
               end
        default: queue_r1(8'h04);                   // illegal command
      endcase
    end
  endtask

  // ---- transmit: the slave changes MISO on the FALLING edge ---------------
  // A byte boundary is the falling edge at which rx_n has just wrapped to 0,
  // i.e. straight after the 8th rising edge — so the first bit of the next byte
  // is on the wire before the master samples it. That ordering is the whole
  // mode-0 contract; loading one edge later shifts every response by a bit.
  always @(negedge sck) if (!cs_n) begin
    if (rx_n == 4'd0) begin
      if (cmd_ready) begin
        cmd_ready = 1'b0;
        st        = S_RESP;
        resp_i    = 3'd0;
        data_i    = 10'd0;
        wait_i    = 4'd0;
      end
      case (st)
        S_RESP: begin
          tx_sh = resp[resp_i];
          if (resp_i + 3'd1 == resp_n) st = is_read ? S_WAIT : S_IDLE;
          else                         resp_i = resp_i + 3'd1;
        end
        // Idle bytes before the data token: a real card takes microseconds to
        // fetch a block, so sd_spi has to WAIT for 0xFE rather than assume it
        // comes next. This is what tests that it does.
        S_WAIT: begin
          tx_sh = 8'hFF;
          if (wait_i == 4'd3) st = S_TOK; else wait_i = wait_i + 4'd1;
        end
        S_TOK:  begin tx_sh = 8'hFE; st = S_DATA; end
        S_DATA: begin
          tx_sh = payload(rd_lba, {22'd0, data_i});
          if (data_i == 10'd511) begin data_i = 10'd0; wait_i = 4'd0; st = S_CRC; end
          else                        data_i = data_i + 10'd1;
        end
        S_CRC:  begin                    // CRC16: not checked in SPI mode
          tx_sh = 8'h00;
          if (wait_i == 4'd0) wait_i = 4'd1;
          else begin wait_i = 4'd0; st = S_IDLE; end
        end
        default: tx_sh = 8'hFF;
      endcase
    end else begin
      tx_sh = {tx_sh[6:0], 1'b1};
    end
  end

  initial begin
    tx_sh = 8'hFF;
    rx_sh = 8'hFF;
  end

endmodule

`default_nettype wire
