// icache.sv — instruction cache for Koti-1 on the ULX3S.
//
// WHY THIS EXISTS. The SDRAM controller made memory fast in the absolute
// sense (a 32-bit read went from QSPI's ~130 clocks to about 8) but the CPU
// still pays that on every pair of instructions it executes. Walk the FSM in
// sdram_ctrl.sv at 25 MHz, where C_RCD and C_RP both collapse to one clock and
// RD_WAIT is zero: IDLE -> ACT -> RCD -> RD -> RD_WAIT x2 -> DONE x2 is eight
// clocks for one 32-bit word, and a burst is a second ACTIVE..DONE pass because
// the first one auto-precharged the row. So a 64-bit fetch is ~16 clocks for
// two instructions: ~8 clocks per instruction of pure fetch, which dominates
// everything else the pipeline does and puts the machine near 2 MIPS.
//
// A hit here answers in ONE clock. That is the single largest lever left on how
// fast the machine feels, and on an 85F it is nearly free: koti used zero of the
// ~3.7 Mbit of block RAM before this file existed.
//
// THE SHAPE, AND WHY IT IS THIS ONE. A line is exactly the PAIR the fetch port
// already deals in — the two words at `addr` and `addr+1`.
//
// That is an unusual choice (lines are normally aligned power-of-two blocks, and
// keying on an unaligned address means the same word can sit in two entries),
// and it is deliberate, because it makes two otherwise-nasty problems vanish:
//
//   1. NO STRADDLE CASE. The core asks for a pair at an arbitrary word address
//      — `npc` advances by 8 but a branch target is only 4-byte aligned. With a
//      conventional 4-word line, a pair starting at the last word of a line
//      spans TWO lines, so the lookup, the miss handling and the fill all need a
//      second path that is exercised only rarely and is therefore exactly where
//      a bug would hide. Keying on the pair makes every request exactly one
//      lookup, always.
//   2. NO MULTI-BEAT FILL. The arbiter asserts `m_burst` for the fetch port
//      unconditionally, so one memory transaction returns exactly 64 bits — one
//      whole line. The fill is therefore a single `m_ack`, with no beat counter
//      and no partially-filled-line state to get wrong.
//
// The capacity cost of the overlap is close to zero in practice: sequential
// execution requests (A, A+1), (A+2, A+3), ... which never overlap, so duplicate
// entries only appear when the same code is reached at both parities — entering
// a loop by fall-through and by branch, say. Paying a little capacity to delete
// two whole classes of edge case is a good trade in a design whose next step is
// booting an operating system.
//
// PHYSICALLY INDEXED, PHYSICALLY TAGGED. `if_addr` is `fpc_pa`, i.e. already
// translated (see koti_core.sv's fetch FSM). That is what makes this cache
// need NO flush on `sfence.vma` or on a `satp` write: those change which
// virtual address maps to a physical one, and nothing here is keyed on a
// virtual address. Getting this wrong in the other direction — a virtually
// tagged cache — is the classic way an MMU-capable core boots and then
// corrupts itself the first time a page is remapped.
//
// WHAT DOES NEED A FLUSH is `fence.i`: code written through the DATA port (a
// bootloader staging a kernel, a module loader, a JIT) is invisible to a cache
// that only ever sees the fetch port. RISC-V requires software to execute
// `fence.i` there, and koti_core now decodes it and pulses `flush`. Before this
// cache existed `fence.i` was legally a NOP (control.sv had no case for it) and
// that was harmless; it is not harmless any more, which is why the decode
// landed in the same commit as this file.
//
// PAGE-TABLE WALKS BYPASS. The i-walker reads PTEs through this same port
// (koti_core.sv: `if_addr` switches to `iw_addr` while `iw_state != 0`). Those
// reads must NOT be cached: the kernel edits page tables through the data port
// and announces it with `sfence.vma`, which — correctly, per the paragraph
// above — does not flush this cache. A cached PTE would therefore survive the
// one instruction that is supposed to retire it. `ptw` is the core's own
// `iw_state != 0`, and it is stable for the whole of any one transaction
// because a walk can only start from `iw_state == 0 && !fbusy`.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module icache #(
    // Entries are PAIRS, so ENTRIES=512 holds 1024 instructions = 4 KB of code
    // in ~3 of the 85F's 208 block RAMs. Must be a power of two.
    parameter int ENTRIES = 512
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,        // fence.i retired: invalidate everything

    // ---- CPU fetch port: the contract koti_core already speaks ----
    input  logic        req,          // held until ack
    input  logic        ptw,          // 1 = page-table walk read, do not cache
    input  logic [23:0] addr,         // word address, PHYSICAL
    output logic        ack,          // one cycle
    output logic [31:0] rdata,        // word at addr
    output logic [31:0] rdata2,       // word at addr+1

    // ---- memory side: the arbiter's fetch port, always a burst pair ----
    output logic        m_req,
    output logic [23:0] m_addr,
    input  logic        m_ack,
    input  logic [31:0] m_rdata,
    input  logic [31:0] m_rdata2
);

  localparam int IDX_W = $clog2(ENTRIES);
  localparam int TAG_W = 23 - IDX_W;

  wire [IDX_W-1:0] idx = addr[IDX_W-1:0];
  wire [TAG_W-1:0] tag = addr[22:IDX_W];

  // Data and tags live in block RAM; `valid` is flops so that `flush` can clear
  // the whole cache in one cycle instead of needing a sweep FSM that fetches
  // would have to wait behind.
  logic [63:0]        data [0:ENTRIES-1];
  logic [TAG_W-1:0]   tags [0:ENTRIES-1];
  logic [ENTRIES-1:0] valid;

  // Read on the FALLING edge, the same trick sdram_ctrl's neighbours use: the
  // address has settled by mid-cycle, so the result is ready at the next rising
  // edge and a hit can be answered without a second lookup cycle. Writes happen
  // on the rising edge, so a fill can never collide with this read.
  logic [63:0]      data_q;
  logic [TAG_W-1:0] tag_q;
  always_ff @(negedge clk) begin
    data_q <= data[idx];
    tag_q  <= tags[idx];
  end

  // A cacheable request is a real fetch that is not already being answered.
  wire cacheable = req && !ptw;
  wire lookup    = cacheable && !ack;
  wire hit       = valid[idx] && (tag_q == tag);

  // Bypass path: PTE reads go straight through, uncached, ack and data
  // forwarded verbatim. Nothing is written to the arrays on this path.
  wire bypass = req && ptw;

  logic filling;      // a miss is out at memory
  logic flush_seen;   // a flush arrived mid-fill: land the data, drop the line

  assign m_req  = bypass || filling;
  assign m_addr = addr;

  always_ff @(posedge clk) begin
    if (rst) begin
      valid      <= '0;
      filling    <= 1'b0;
      flush_seen <= 1'b0;
      ack        <= 1'b0;
      rdata      <= 32'd0;
      rdata2     <= 32'd0;
    end else begin
      ack <= 1'b0;

      // A flush that lands while a fill is in flight must not be undone by that
      // fill completing: the line was fetched before the invalidation point, so
      // it is exactly the stale copy `fence.i` exists to get rid of. Remember it
      // and drop the line on arrival rather than trying to abort the
      // transaction, which the arbiter would not honour anyway.
      if (flush) begin
        valid <= '0;
        if (filling) flush_seen <= 1'b1;
      end

      if (bypass) begin
        // uncached: forward whatever memory says, cache nothing
        if (m_ack) begin
          ack    <= 1'b1;
          rdata  <= m_rdata;
          rdata2 <= m_rdata2;
        end
      end else if (filling) begin
        if (m_ack) begin
          filling    <= 1'b0;
          flush_seen <= 1'b0;
          // Answer from the bus directly. Re-looking-up after the fill would
          // cost a cycle and buy nothing, since this IS the data being stored.
          ack    <= 1'b1;
          rdata  <= m_rdata;
          rdata2 <= m_rdata2;
          if (!flush_seen && !flush) valid[idx] <= 1'b1;
        end
      end else if (lookup) begin
        if (hit) begin
          ack    <= 1'b1;
          rdata  <= data_q[31:0];
          rdata2 <= data_q[63:32];
        end else begin
          filling <= 1'b1;
        end
      end
    end
  end

  // Fill write. Separate from the control block so the arrays stay simple
  // single-writer memories, which is what lets yosys infer block RAM.
  always_ff @(posedge clk)
    if (filling && m_ack) begin
      data[idx] <= {m_rdata2, m_rdata};
      tags[idx] <= tag;
    end

endmodule
