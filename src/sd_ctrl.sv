`default_nettype none
//
// sd_ctrl.sv — microSD block reads, as three MMIO registers and a buffer.
//
// The thin adapter over `vendor/sd_spi.sv`, which does the actual SD protocol
// and is proven on this board (see vendor/README.md). Everything hard about SD
// — the 74 idle clocks, CMD0/CMD8/ACMD41/CMD58, SDHC vs byte addressing, CRC7
// on the two commands that need it — lives there. This file exists to turn its
// pulse-and-strobe interface into something software can drive, and it is
// deliberately boring.
//
// WHY A BUFFER RATHER THAN A BYTE FIFO SOFTWARE RACES. `sd_spi` emits `rvalid`
// one clock per byte at up to 12.5 MHz — a byte every two system clocks. No
// polling loop on a 2 MIPS machine can keep up, so a FIFO would have to be 512
// bytes deep anyway. Making it a plain buffer instead means the transfer either
// completes or does not, and software reads afterwards at its own pace. It also
// makes the eventual Linux block driver a `memcpy`, which is what a block
// driver wants to be.
//
// A WORD AT A TIME, not a byte: 128 reads per block instead of 512. At roughly
// ten clocks per MMIO read that is the difference between 0.4 s and 1.6 s for a
// 3.95 MB kernel, and the kernel is the whole reason this peripheral exists.
//
// REGISTERS (byte offsets in the 0x0005_0000 window):
//   +0x00  W  bit0 = start init, bit1 = start read of SD_LBA
//          R  bit0 ready, bit1 busy, bit2 err, bit3 DONE
//
// ⚠️ POLL `done`, NOT `busy`, AND NOT `ready`. This interface exists because
// sd_spi's two operations signal completion differently: `init` clears `ready`
// and sets it again at the end, while a READ leaves `ready` HIGH the whole time
// and only raises `busy`. So there is no single level software can wait on, and
// waiting on `busy` means catching a rise that may not have happened yet when
// the write returns — a race whose failure mode is reading a half-filled buffer
// and getting a plausible block. `done` is sticky: set when the block is fully
// in the buffer, cleared when a new read or init is started. One bit, one
// meaning, no ordering to get right.
//   +0x04  W  SD_LBA: the 512-byte block number to read
//          R  reads it back
//   +0x08  R  next 32 bits of the block buffer, little-endian, pointer++
//          W  reset the read pointer to 0 (value ignored)
//   +0x0C  W  BRING-UP ESCAPE HATCH: bit0 raw_en, bit1 cs_n, bit2 sck, bit3 mosi
//          R  bit0 = MISO **live off the pin**, bit1 raw_en, bit4:2 = the three
//             values being driven, read back so a write that never landed is
//             distinguishable from a card that never answered
//
// ⚠️ WHY THE ESCAPE HATCH EXISTS, AND WHY IT USES REGISTER 3. On 2026-08-07 the
// card returned SD_ERR on real hardware while `tb_sd` and `tb_fpga_bram +mark=1`
// were both green in simulation. Simulation cannot distinguish "the engine is
// wrong" from "no card is electrically there", because the Verilog card model
// answers unconditionally. Driving the four wires from software and reading MISO
// back splits exactly that: MISO stuck at 1 through a whole hand-clocked CMD0
// means the card never drives the line at all (seating, power, or a wrong pin),
// while any 0 bit coming back means the card is alive and the fault is upstream
// in `sd_spi`. One round trip, one bit, and the two halves of the problem
// separate.
//
// Register 3 is used **because it was the free one**: `reg_a` is `d_addr[1:0]`,
// so this window already decodes four registers and 3 fell through to `default`.
// Adding a whole MMIO window would have needed two edits — the decode in
// project.sv AND the `pa_dev` legalisation in koti_core.sv — and missing the
// second makes the first write fault, restart the program from mtvec=0, and look
// exactly like a reset bug. Nothing outside this file changes.
//
// ⚠️ FPGA ONLY. `sd_ctrl` is instantiated under `KOTI_FPGA` because a
// TinyTapeout tile has no pin for an SD card: all 8 `uo` are the VGA Pmod, all
// 8 `uio` the memory Pmod, and `ui` is input-only. Same reason `sdram_ctrl` and
// `icache` are FPGA-only, and the same reason console kept its SD loader in the
// harness.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

module sd_ctrl #(
    parameter int CLK_HZ = 25_000_000
) (
    input  wire        clk,
    input  wire        rst,

    // MMIO, on the data port's request/ack contract: `sel` is the select
    // cycle, `ack` comes back one clock later. Same shape as the VGA/PS2 block
    // in project.sv, so the intercept there needs no new pattern.
    input  wire        sel,
    input  wire        we,
    input  wire [1:0]  reg_a,          // which register: d_addr[1:0]
    input  wire [31:0] wdata,
    output logic [31:0] rdata,

    // the card
    output logic       sd_cs_n,
    output logic       sd_sck,
    output logic       sd_mosi,
    input  wire        sd_miso
);

  // ---------------------------------------------------------- the SD engine
  logic        init_pulse, rd_pulse;
  logic [31:0] lba;
  logic        ready, busy, err;
  logic        rvalid, rdone;
  logic [7:0]  rbyte;

  // The engine's pins are internal: the escape hatch below muxes them, so the
  // module's actual outputs are driven in one place further down.
  logic eng_cs_n, eng_sck, eng_mosi;

  sd_spi #(.CLK_HZ(CLK_HZ)) card (
      .clk(clk), .rst(rst),
      .init(init_pulse), .rd(rd_pulse), .blk(lba),
      .ready(ready), .busy(busy), .err(err),
      .rvalid(rvalid), .rdata(rbyte), .rdone(rdone),
      .cs_n(eng_cs_n), .sck(eng_sck), .mosi(eng_mosi), .miso(sd_miso)
  );

  // ------------------------------------------------- bring-up escape hatch
  // Idle-SPI reset values (CS high, MOSI high, clock low) so that coming out of
  // reset with raw_en already set cannot assert chip select at a card.
  logic raw_en, raw_cs_n, raw_sck, raw_mosi;

  // TWO flops on MISO before software sees it. The card drives this pin from its
  // own oscillator, so it is asynchronous to `clk` by construction; sampling it
  // straight into a register that feeds the read mux is a metastability path
  // whose failure mode is an occasional wrong bit — i.e. exactly the kind of
  // intermittent that would be blamed on the card. `sd_spi` samples it at its own
  // slow SPI clock, which is a different (and much more forgiving) discipline.
  logic miso_meta, miso_sync;
  always_ff @(posedge clk) begin
      miso_meta <= sd_miso;
      miso_sync <= miso_meta;
  end

  assign sd_cs_n = raw_en ? raw_cs_n : eng_cs_n;
  assign sd_sck  = raw_en ? raw_sck  : eng_sck;
  assign sd_mosi = raw_en ? raw_mosi : eng_mosi;

  // ---------------------------------------------------------- block buffer
  // 512 bytes as 128 words, written a byte at a time as they arrive. Byte lanes
  // rather than a shift register: a shifter would have to know the byte order
  // of the word AND the fill order of the block, and getting either backwards
  // produces a buffer that is subtly permuted rather than obviously empty.
  logic [31:0] buf_mem [0:127];
  // TEN bits, not nine: `fill` counts 0..512, and 512 is the TERMINAL value
  // that says "the block is complete, ignore further strobes". Nine bits cannot
  // represent it — iverilog says so ("numeric constant truncated to 9 bits"),
  // and the comparison would have been against 0 instead, so the buffer would
  // have accepted the CRC bytes over byte 0 on every read.
  logic [9:0]  fill;                    // byte index 0..511, then 512 = done
  logic [6:0]  rptr;                    // word index for software reads
  logic        done_q;                  // sticky: the buffer holds a full block

  wire [6:0] fill_w = fill[8:2];
  wire [1:0] fill_b = fill[1:0];

  always_ff @(posedge clk)
      if (rst) begin
          fill <= 10'd0;
      end else begin
          // Cleared on the read request, not on rdone: sd_spi consumes the
          // block's two CRC bytes after the 512th data byte and does not strobe
          // rvalid for them, so `fill` is already exactly 512 when rdone comes.
          if (rd_pulse)
              fill <= 10'd0;
          else if (rvalid && fill != 10'd512)
              fill <= fill + 10'd1;
      end

  always_ff @(posedge clk)
      if (rvalid && fill != 10'd512)
          case (fill_b)
              2'd0: buf_mem[fill_w][7:0]   <= rbyte;
              2'd1: buf_mem[fill_w][15:8]  <= rbyte;
              2'd2: buf_mem[fill_w][23:16] <= rbyte;
              2'd3: buf_mem[fill_w][31:24] <= rbyte;
          endcase

  // ---------------------------------------------------------- the registers
  wire sel_wr = sel &&  we;
  wire sel_rd = sel && !we;

  always_ff @(posedge clk)
      if (rst) begin
          init_pulse <= 1'b0;
          rd_pulse   <= 1'b0;
          lba        <= 32'd0;
          rptr       <= 7'd0;
          done_q     <= 1'b0;
          raw_en     <= 1'b0;
          raw_cs_n   <= 1'b1;          // deselected
          raw_sck    <= 1'b0;
          raw_mosi   <= 1'b1;          // MOSI idles high, as SPI mode 0 wants
      end else begin
          // Sticky, and cleared by STARTING work rather than by reading the
          // status: a flag cleared by its own read cannot be polled twice, and
          // the Linux driver will want to check it after the fact.
          if (rdone)                    done_q <= 1'b1;
          if (init_pulse || rd_pulse)   done_q <= 1'b0;
          // One-clock pulses: sd_spi wants a pulse, and a level would restart
          // the command for as long as the write was held.
          init_pulse <= 1'b0;
          rd_pulse   <= 1'b0;

          if (sel_wr)
              case (reg_a)
                  2'd0: begin
                      // Ignored unless the engine is idle. A read started
                      // mid-transfer would leave the buffer half from one block
                      // and half from another, which is the kind of corruption
                      // that reads as a filesystem bug.
                      if (!busy) begin
                          init_pulse <= wdata[0];
                          rd_pulse   <= wdata[1];
                      end
                      if (wdata[1] && !busy) rptr <= 7'd0;
                  end
                  2'd1: lba  <= wdata;
                  2'd2: rptr <= 7'd0;          // any write rewinds the buffer
                  2'd3: begin
                      raw_en   <= wdata[0];
                      raw_cs_n <= wdata[1];
                      raw_sck  <= wdata[2];
                      raw_mosi <= wdata[3];
                  end
                  default: ;
              endcase

          // Auto-increment on the SELECT cycle, so a burst of reads walks the
          // buffer without software touching a pointer. Wraps rather than
          // saturating: 128 words is the whole block and wrapping makes a
          // read-past-the-end obviously periodic instead of stuck on one value.
          if (sel_rd && reg_a == 2'd2)
              rptr <= rptr + 7'd1;
      end

  // Read data is captured on the select cycle and served on the ack cycle —
  // the same discipline the PLIC's claim register needed, and for the same
  // reason: `rptr` has already moved by the time the ack arrives.
  logic [31:0] rmux;
  always_comb
      case (reg_a)
          2'd0:    rmux = {28'd0, done_q, err, busy, ready};
          2'd1:    rmux = lba;
          2'd2:    rmux = buf_mem[rptr];
          // MISO first, so a test is `SD_RAW & 1`. The three driven values come
          // back too: if they read as what was written, the MMIO path is proven
          // in the same breath, and a stuck MISO cannot be blamed on a write
          // that silently went nowhere.
          2'd3:    rmux = {27'd0, raw_mosi, raw_sck, raw_cs_n, raw_en, miso_sync};
          default: rmux = 32'd0;
      endcase

  logic [31:0] rdata_q;
  always_ff @(posedge clk)
      if (sel_rd) rdata_q <= rmux;

  assign rdata = rdata_q;

endmodule

`default_nettype wire
