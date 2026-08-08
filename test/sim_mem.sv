// sim_mem.sv — a behavioural memory on the arbiter's request port, so that
// software can be BOOTED in simulation rather than only exercised.
//
// SIMULATION ONLY. It is selected by `KOTI_SIMMEM`, which no synthesis build
// defines: not the TinyTapeout flow, not fpga-ulx3s.yaml, not synth.ps1. It
// contains a 16 MB array and could not be synthesised if anyone tried.
//
// WHAT IT REPLACES, AND THE HONEST COST. It stands in for qspi_ctrl AND
// sdram_ctrl at once, which means a boot run through this memory proves
// nothing about either of them: not the QSPI command encoding, not the SDRAM
// refresh, not RD_ADV. Both already have their own strict benches
// (test/test.py drives qspi_ctrl pin-level against SpiMem; test/tb_sdram.v
// drives sdram_ctrl against a protocol-checking part model, 9/9), and the
// whole SoC runs on the real ones in test/test_fpga.py. What this buys instead
// is speed: ~130 clocks for a QSPI word and ~8 for an SDRAM word become 1, and
// booting a kernel is tens of millions of clocks where that ratio decides
// whether the run takes a minute or a day.
//
// WHAT IT DOES NOT SIMPLIFY, on purpose: it speaks the same request-port
// protocol as both real controllers — req held until the 1-cycle ack, rdata
// (and rdata2 on a burst) valid during ack, word address, bit 22 selecting
// flash from RAM, writes taking only the byte lanes marked by `be`, and writes
// to flash acknowledged as no-ops. A memory that answered combinationally
// would hide every handshake bug in the arbiter and the cache.
//
// ⚠️ `+memlat=<n>` EXISTS BECAUSE ONE-CLOCK MEMORY CANNOT MEASURE A CACHE.
// Answering in a single clock makes this model FASTER than any cache in front
// of it, so a boot run through it scores every cache as pure overhead — which
// is exactly what happened when the D-cache was first benchmarked here
// (2026-08-08: 594.8M clocks with it against 503.1M without, on a board where
// the real part takes ~10 clocks for a random word). The number was real and
// the conclusion it invited was backwards.
//
// So the latency is a knob, and it DEFAULTS TO 0 = the historical behaviour,
// bit for bit: no existing gate, budget or recorded clock count moves.
//
// ⭐ USE `+memlat=6`. IT IS CALIBRATED AGAINST THE REAL BOARD, not guessed.
// The obvious choice was 9, because sdram_ctrl's measured random 32-bit read is
// ~10 clocks — and it was WRONG BY A FACTOR OF TWO on the one question anybody
// asked it. Predicted D-cache speedups against measured hardware:
//
//     +memlat=9   predicts  8.9% faster     hardware: 4.49%   (2x optimistic)
//     +memlat=6   predicts  4.47% faster    hardware: 4.49%   ✅
//
// ⇒ ~10 clocks is the WORST CASE, a random read that misses the open row, and
// using a worst case as a FLAT average overstates what memory costs — and so
// overstates what any cache in front of it can win. From the CPU's side this
// machine behaves like a flat ~6-clock memory.
//
// It is still a FLAT latency, and that is the simplification to keep naming:
// the real sdram_ctrl is cheaper on a row hit and dearer on a row miss, and
// this models neither, it only matches them on average for THIS workload.
// ⚠️ The calibration is against a Linux boot. A workload with a different
// locality mix — a memory bandwidth test, a framebuffer blit — has no reason to
// land at 6, and `+memlat` should be re-calibrated rather than assumed.
// It is the right instrument for "what is a memory round trip worth", and the
// wrong one for "how fast is this board" — for that, run the whole SoC on the
// real controller (test/test_fpga.py, tb_fpga_bram) or, better, boot the board.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module sim_mem #(
    // Flash is modelled at its real 64 KB. RAM is modelled at the FULL 16 MB
    // the core can address, and that is not a luxury: a kernel loads 4 MB into
    // the window, and test/sdram_model.sv's 512 KB would alias it on top of
    // the firmware's own .bss. An undersized memory model does not fail, it
    // silently answers with somebody else's data.
    parameter FLASH_WORDS = 16 * 1024,
    parameter RAM_WORDS   = 4 * 1024 * 1024
) (
    input  wire        clk,
    input  wire        rst,

    input  wire        req,
    input  wire        we,
    input  wire        burst,
    input  wire [22:0] addr,     // word address; bit 22: 0 = flash, 1 = RAM
    input  wire [31:0] wdata,    // bytes already in lane position
    input  wire [3:0]  be,
    output reg         ack,
    output reg  [31:0] rdata,
    output reg  [31:0] rdata2
);

  reg [31:0] flash [0:FLASH_WORDS-1];
  reg [31:0] ram   [0:RAM_WORDS-1];

  // Out-of-range flash reads return 0xFFFFFFFF — what an unprogrammed part
  // reads — and say so once, rather than aliasing. Aliasing is the failure
  // mode that makes a memory model dangerous: the test passes, for the wrong
  // reason, and nothing in the log mentions memory.
  reg warned;

  function [31:0] rd(input [22:0] a);
    begin
      if (a[22]) begin
        rd = (a[21:0] < RAM_WORDS) ? ram[a[21:0]] : 32'hFFFF_FFFF;
      end else begin
        rd = (a[21:0] < FLASH_WORDS) ? flash[a[21:0]] : 32'hFFFF_FFFF;
      end
    end
  endfunction

  // Images are loaded here rather than by the testbench poking a hierarchical
  // reference into these arrays, because $readmemh into an array reached
  // through an XMR is the kind of thing simulators disagree about.
  //   +flash=<hex>   32-bit words, one per line, from flash word 0
  //   +ram=<hex>     32-bit words, one per line
  //   +ramoff=<n>    word offset in RAM at which +ram is loaded; the kernel
  //                  lives at byte 0x0140_0000, i.e. word 0x100000 into the
  //                  window that starts at 0x0100_0000.
  integer i;
  integer ramoff;
  integer memlat;                    // extra clocks before the ack; 0 = as before
  reg [15:0] waitn;
  reg        counting;
  // 512 characters, not 128: a $value$plusargs("%s") target that is too
  // short truncates the FRONT of the path and then reports the truncated
  // name in its own error message, which sends you looking for a file that
  // was never asked for. CI paths are long.
  reg [4095:0] fname;
  initial begin
    for (i = 0; i < FLASH_WORDS; i = i + 1) flash[i] = 32'hFFFF_FFFF;
    // RAM starts at zero rather than x. Real DRAM comes up arbitrary, but a
    // sea of x here would not be realism: it would put x into the CPU on the
    // first speculative fetch past the end of the loaded image and stop the
    // run for a reason that has nothing to do with the software under test.
    for (i = 0; i < RAM_WORDS; i = i + 1) ram[i] = 32'h0000_0000;
    warned = 1'b0;

    if ($value$plusargs("flash=%s", fname)) begin
      $readmemh(fname, flash);
      $display("sim_mem: flash <- %0s", fname);
    end
    if (!$value$plusargs("memlat=%d", memlat)) memlat = 0;
    if (memlat != 0)
      $display("sim_mem: +memlat=%0d — each transaction waits %0d extra clocks",
               memlat, memlat);
    if (!$value$plusargs("ramoff=%d", ramoff)) ramoff = 0;
    if ($value$plusargs("ram=%s", fname)) begin
      $readmemh(fname, ram, ramoff);
      $display("sim_mem: ram[%0d..] <- %0s", ramoff, fname);
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      ack      <= 1'b0;
      counting <= 1'b0;
    end else begin
      ack <= 1'b0;
      // The wait, when there is one. With memlat = 0 neither of the first two
      // arms is ever taken and this is the original one-clock acknowledgement,
      // unchanged.
      if (req && !ack && memlat != 0 && !counting) begin
        counting <= 1'b1;
        waitn    <= memlat[15:0];
      end else if (counting && waitn != 16'd0) begin
        waitn <= waitn - 16'd1;
      end else if (req && !ack) begin
        counting <= 1'b0;
        ack    <= 1'b1;
        rdata  <= rd(addr);
        rdata2 <= burst ? rd(addr + 23'd1) : 32'h0000_0000;

        if (we) begin
          if (addr[22]) begin
            if (addr[21:0] < RAM_WORDS) begin
              if (be[0]) ram[addr[21:0]][7:0]   <= wdata[7:0];
              if (be[1]) ram[addr[21:0]][15:8]  <= wdata[15:8];
              if (be[2]) ram[addr[21:0]][23:16] <= wdata[23:16];
              if (be[3]) ram[addr[21:0]][31:24] <= wdata[31:24];
            end else if (!warned) begin
              warned <= 1'b1;
              $display("sim_mem: WRITE above %0d words at %h — dropped",
                       RAM_WORDS, addr);
            end
          end
          // else: a write to flash. Acknowledged and discarded, which is what
          // qspi_ctrl does with one.
        end
      end else if (!req) begin
        // The requester walked away mid-wait — the arbiter's fetch port does
        // exactly that on a pipeline flush. Drop the count rather than carrying
        // an expired one into the NEXT transaction, which would then be
        // acknowledged with no latency at all and quietly under-report the
        // cost of memory.
        counting <= 1'b0;
      end
    end
  end

endmodule

`default_nettype wire
