`default_nettype none
`timescale 1ns / 1ps

/* tb_sd.v — sd_ctrl against a card, standalone.
 *
 * The SD path is the rung that turns a booting kernel into a computer: it is
 * both how a 3.95 MB kernel gets into the machine and where the rootfs will
 * live. So it is verified on its own, before the SoC, for the same reason
 * sdram_ctrl and plic are: a memory or storage controller that is wrong in a
 * corner is far cheaper to find here than under a running kernel, where the
 * symptom is a corrupted filesystem ten million instructions later.
 *
 * Plain Verilog, no cocotb — runs on the development host in seconds.
 *
 * WHAT IT ASSERTS, and each one is a different failure:
 *   1. the engine reports `ready` after init — the ACMD41 retry loop works
 *      (the model deliberately answers BUSY three times first)
 *   2. a block read completes and `busy` falls
 *   3. all 512 bytes match `payload(lba, i)` EXACTLY, checked per byte
 *   4. a read of a DIFFERENT block returns different data — which is what
 *      catches an address that is ignored, the failure a constant payload or a
 *      single-block test cannot see
 *   5. the buffer rewinds on a write to SD_DATA, so re-reading gives byte 0
 *      again rather than continuing off the end
 *
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 */
module tb_sd ();

  reg clk = 1'b0, rst = 1'b1;
  always #20 clk = ~clk;                    // 25 MHz

  reg         sel = 1'b0, we = 1'b0;
  reg  [2:0]  reg_a = 3'd0;
  reg  [31:0] wdata = 32'd0;
  wire [31:0] rdata;

  wire cs_n, sck, mosi, miso;

  sd_ctrl #(.CLK_HZ(25_000_000)) dut (
      .clk(clk), .rst(rst),
      .sel(sel), .we(we), .reg_a(reg_a), .wdata(wdata), .rdata(rdata),
      .sd_cs_n(cs_n), .sd_sck(sck), .sd_mosi(mosi), .sd_miso(miso)
  );

  sd_card_model #(.BUSY_TRIES(3)) card (
      .cs_n(cs_n), .sck(sck), .mosi(mosi), .miso(miso)
  );

  integer errors = 0;
  integer i, bad;
  reg [31:0] got, word;
  reg [7:0]  want_b, got_b;

  task check(input cond, input [8*40:1] what);
    begin
      if (!cond) begin
        $display("  FAIL %0s", what);
        errors = errors + 1;
      end
    end
  endtask

  task mmio_wr(input [2:0] a, input [31:0] d);
    begin
      @(posedge clk); sel = 1'b1; we = 1'b1; reg_a = a; wdata = d;
      @(posedge clk); sel = 1'b0; we = 1'b0;
    end
  endtask

  // rdata is registered on the select cycle and valid the cycle after — the
  // same contract project.sv's data port uses.
  //
  // ⚠️ THE EXTRA EDGE IS LOAD-BEARING. `rdata_q <= rmux` is a non-blocking
  // assignment, so sampling `rdata` immediately after the edge that performs it
  // reads the OLD value — every read then returns the PREVIOUS read's answer.
  // That failure is almost invisible in a polling loop, because consecutive
  // reads of an unchanging register agree; it only shows up when the value is
  // supposed to change, which is exactly the buffer walk. Cost: the first
  // version of this bench reported the whole block as wrong data while the
  // capture was byte-perfect.
  task mmio_rd(input [2:0] a, output [31:0] d);
    begin
      @(posedge clk); sel = 1'b1; we = 1'b0; reg_a = a;
      @(posedge clk); sel = 1'b0;
      @(posedge clk); d = rdata;
    end
  endtask

  // ⚠️ POLL `ready`, NOT `busy`, and this cost two wrong benches to learn.
  // `busy` is not a "still working" flag: it drops between the commands of the
  // init sequence, so a loop waiting for `!busy` returns while the card is
  // half-way through ACMD41 — which made every later check fail against an
  // engine that had not started. sd_spi's own port comment is the spec:
  // `ready` means "initialised, idle, accepting rd". That is the completion
  // signal for both operations, and it is what the C driver will poll too.
  task wait_ready(input [8*40:1] what);
    integer n;
    begin
      n = 0;
      got = 32'd0;
      // `!==`, not `!`: an X status makes `!got[0]` FALSE, so a plain negation
      // exits the loop instantly and the bench then fails for the wrong reason.
      while (got[0] !== 1'b1 && n < 400_000) begin
        mmio_rd(3'd0, got);
        n = n + 1;
      end
      if (n >= 400_000) begin
        $display("  FAIL timed out waiting for %0s (status %08h)", what, got);
        errors = errors + 1;
      end
    end
  endtask

  // A read completes when the sticky `done` bit (bit 3) sets. It is cleared by
  // starting the read, so this cannot pass on a stale flag, and there is no
  // rise-then-fall race to lose.
  task wait_block(input [8*40:1] what);
    integer n;
    begin
      n = 0;
      got = 32'd0;
      while (got[3] !== 1'b1 && n < 400_000) begin
        mmio_rd(3'd0, got);
        n = n + 1;
      end
      if (n >= 400_000) begin
        $display("  FAIL timed out waiting for %0s (status %08h)", what, got);
        errors = errors + 1;
      end
    end
  endtask

  // Read the whole block back and compare against the model's own function, so
  // the expected values cannot drift from what a card would serve.
  task read_block_and_check(input [31:0] lba);
    begin
      mmio_wr(3'd1, lba);                            // SD_LBA
      mmio_wr(3'd0, 32'h2);                          // start read
      wait_block("the block read");
      mmio_rd(3'd0, got);
      check(!got[2], "err raised on a good read");

      mmio_wr(3'd2, 32'd0);                          // rewind the buffer
      for (i = 0; i < 128; i = i + 1) begin
        mmio_rd(3'd2, word);
        for (integer b = 0; b < 4; b = b + 1) begin
          want_b = card.payload(lba, i * 4 + b);
          got_b  = word[8*b +: 8];
          if (want_b !== got_b) begin
            if (errors < 8)
              $display("  FAIL lba %0d byte %0d: want %02h got %02h",
                       lba, i * 4 + b, want_b, got_b);
            errors = errors + 1;
          end
        end
      end
    end
  endtask

  initial begin
    repeat (4) @(posedge clk);
    rst = 1'b0;

    $display("tb_sd: init");
    mmio_wr(3'd0, 32'h1);                            // start init
    wait_ready("init");
    mmio_rd(3'd0, got);
    $display("  status after init = %08h", got);
    check(got[0] === 1'b1, "ready after init");
    check(got[2] !== 1'b1, "err after init");

    $display("tb_sd: block 0");
    read_block_and_check(32'd0);

    // A DIFFERENT block, and not an adjacent one: 12345 exercises high address
    // bits, so an argument that is truncated or byte-swapped on the way into
    // CMD17 produces the wrong payload rather than a plausible one.
    $display("tb_sd: block 12345");
    read_block_and_check(32'd12345);

    // The rewind: after 128 reads the pointer has wrapped to 0 anyway, so
    // rewind explicitly and confirm the first word again.
    mmio_wr(3'd2, 32'd0);
    mmio_rd(3'd2, word);
    check(word[7:0] === card.payload(32'd12345, 0), "buffer rewinds on write");

    // ---- CMD24: write a block, then read it back -----------------------
    // The engine gained a write path on 2026-08-07. Before this the hardware
    // could not write at all, so a Linux filesystem on the card was read-only.
    //
    // The pattern is DERIVED FROM THE INDEX and not constant: a constant would
    // pass even if every byte written were the same one, and byte-order bugs in
    // the word-to-byte unpacking are exactly what this has to catch.
    $display("tb_sd: write block 77");
    mmio_wr(3'd5, 32'd0);                            // rewind the fill pointer
    for (i = 0; i < 128; i = i + 1)
      mmio_wr(3'd4, {8'(i*4+3), 8'(i*4+2), 8'(i*4+1), 8'(i*4+0)});
    mmio_wr(3'd1, 32'd77);                           // LBA
    mmio_wr(3'd0, 32'h4);                            // start write
    wait_block("write");

    check(card.wr_got === 1'b1, "card received a block");
    check(card.wr_lba === 32'd77, "card saw the right LBA");
    // Every byte, in order. This is the check that catches a word unpacked
    // big-endian: the block would arrive complete and byte-swapped within each
    // word, which reads back as plausible data rather than as an error.
    bad = 0;
    for (i = 0; i < 512; i = i + 1)
      if (card.wmem[i] !== 8'(i)) bad = bad + 1;
    check(bad === 0, "all 512 bytes arrived in order");
    if (bad !== 0)
      $display("  %0d byte(s) wrong; wmem[0..3] = %02h %02h %02h %02h",
               bad, card.wmem[0], card.wmem[1], card.wmem[2], card.wmem[3]);

    // And the engine must be usable again afterwards — the busy wait is the
    // part of a write with no analogue in a read, and getting it wrong corrupts
    // the NEXT command rather than this one.
    $display("tb_sd: read after write");
    read_block_and_check(32'd7);

    $display("--- %0d error(s)", errors);
    if (errors == 0) $display("--- tb_sd: PASS");
    else begin
      $display("--- tb_sd: FAIL");
      $fatal(1);
    end
    $finish;
  end

`ifdef SD_TRACE
  // The first bytes the buffer captures, with the index they land at. If the
  // payload does not start at index 0 this says so immediately, and says what
  // arrived instead.
  integer seen = 0;
  always @(posedge clk)
      if (dut.rvalid && seen < 10) begin
          $display("  [cap %0t] fill=%0d byte=%02h", $time, dut.fill, dut.rbyte);
          seen = seen + 1;
      end
`endif

  // A hang is a failure, not a reason to wait: if the SPI engine stops
  // clocking, nothing else in this bench will ever complete.
  initial begin
    #200_000_000;
    $display("--- tb_sd: FAIL (bench timeout — the engine stopped clocking)");
    $fatal(1);
  end

endmodule

`default_nettype wire
