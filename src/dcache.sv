// dcache.sv — data cache for Koti-1 on the ULX3S.
//
// WHY, and the arithmetic that says so. `icache.sv` took fetch from ~8 clocks
// per instruction to 1 on a hit, and that moved the bottleneck rather than
// removing it: the DATA side still pays a full SDRAM round trip on every load
// and store. A random 32-bit read through sdram_ctrl is 10 clocks measured, and
// roughly a third of instructions are loads or stores, so the data side costs
// about 3 clocks per instruction against the fetch side's 1. Boot to userspace
// is ~49 s on real hardware; this is where it goes.
//
// ⭐ WRITE-THROUGH, AND THAT IS THE WHOLE COHERENCE ARGUMENT. The video DMA
// reads the 40x30 charbuf out of the same SDRAM the CPU writes, so a write-BACK
// cache could hold text that never reached the screen — the objection PLAN.md
// recorded against building this at all. Write-through removes it rather than
// managing it: main memory is correct at all times, so the DMA cannot read
// anything stale. There is no opposite direction to worry about, because the
// video port only ever READS. The same reasoning covers the I-cache: code
// written through this port lands in memory immediately, and `fence.i` already
// flushes the fetch side.
//
// ⇒ NOTHING ELSE IN THIS MACHINE WRITES MEMORY. Video reads, fetch reads, the
// walker reads. So the only way a line here can go stale is by this cache's own
// writes, which it updates in place. That is why there is no snooping and no
// invalidation protocol, and why adding a second bus master later would break
// that argument and require one.
//
// ONE WORD PER LINE, deliberately, and the reason is byte enables. A multi-word
// line would need per-byte merge logic on every partial store, plus a
// multi-beat fill — and the arbiter only bursts the FETCH port, so a wider line
// would cost several transactions per miss. `icache.sv` avoided the same class
// of edge case by making a line exactly the pair the fetch port asks for; this
// makes a line exactly the word the data port asks for, so every request is one
// lookup and every miss is one transaction. The cost is no spatial prefetch:
// walking an array pays a miss per word. The win is latency on re-reads — the
// stack, the current struct, a hot loop counter — which is where the data side
// actually spends its time.
//
// NO-WRITE-ALLOCATE. A store that misses goes to memory and does not pull the
// line in. Allocating on write costs a read of a word that is about to be
// overwritten, and the common miss-write (initialising memory, memset, .bss)
// is exactly the case where that read is pure waste.
//
// PHYSICALLY INDEXED, PHYSICALLY TAGGED — `d_addr` is already translated, so
// this needs NO flush on `sfence.vma` or on a `satp` write, for the same reason
// icache.sv does not. What it DOES need is for page-table reads to bypass, and
// they do: `c_ptw` is high while the EX-side walker owns the port, and a
// bypassed read neither hits nor fills. A cached PTE would otherwise outlive
// the sfence.vma meant to retire it — the classic way an MMU-capable core boots
// and then corrupts itself the first time a page is remapped.
//
// ⚠️ WRITES ARE NEVER BYPASSED, even when `c_ptw` is set. Every write goes to
// memory AND updates a matching line if one exists. The walker does not write
// today (A=0 or D=0-on-store raises a fault instead), so this costs nothing —
// but it means the cache cannot be left stale by a write from any source,
// which is a property worth having by construction rather than by argument.
//
// FPGA-only, behind KOTI_FPGA like sdram_ctrl and icache: a TinyTapeout tile
// has no block RAM to put this in.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module dcache #(
    parameter integer IDX_BITS = 9,             // 512 lines of one word
    parameter integer ADDR_BITS = 23            // word address, as the core uses
) (
    input  wire        clk,
    input  wire        rst,

    // ---- core side: the same req/ack contract the arbiter offers ----------
    input  wire        c_req,
    input  wire        c_we,
    input  wire        c_ptw,                   // page-table read: do not cache
    input  wire [ADDR_BITS-1:0] c_addr,
    input  wire [31:0] c_wdata,
    input  wire [3:0]  c_be,
    output wire        c_ack,
    output wire [31:0] c_rdata,

    // ---- memory side ------------------------------------------------------
    output wire        m_req,
    output wire        m_we,
    output wire [ADDR_BITS-1:0] m_addr,
    output wire [31:0] m_wdata,
    output wire [3:0]  m_be,
    input  wire        m_ack,
    input  wire [31:0] m_rdata
);

  localparam integer TAG_BITS = ADDR_BITS - IDX_BITS;
  localparam integer LINES    = 1 << IDX_BITS;

  wire [IDX_BITS-1:0] idx = c_addr[IDX_BITS-1:0];
  wire [TAG_BITS-1:0] tag = c_addr[ADDR_BITS-1:IDX_BITS];

  // Tags and data in separate arrays so yosys infers block RAM for the data
  // and keeps the tags where they can be compared in the same cycle.
  logic [TAG_BITS-1:0] tags  [0:LINES-1];
  logic [31:0]         data  [0:LINES-1];
  logic                valid [0:LINES-1];

  // Reset clears `valid` one line per clock rather than all at once: a
  // 512-entry parallel clear is a 512-bit fanout that would show up in timing
  // on a design whose post-route Fmax is already inside 20% of its target.
  logic [IDX_BITS-1:0] init_i;
  logic                initing;

  logic [TAG_BITS-1:0] rd_tag;
  logic [31:0]         rd_data;
  logic                rd_valid;
  always_ff @(posedge clk) begin
      rd_tag   <= tags[idx];
      rd_data  <= data[idx];
      rd_valid <= valid[idx];
  end

  // A lookup is only meaningful on the cycle after the request appeared, which
  // is the same discipline the PLIC claim register and sd_ctrl's buffer need.
  logic                    look;      // a lookup is in flight
  logic [TAG_BITS-1:0]     look_tag;
  logic [IDX_BITS-1:0]     look_idx;
  logic                    look_we, look_ptw;

  wire hit = look && rd_valid && (rd_tag == look_tag);

  // A read that hits answers from `rd_data`; everything else is memory's.
  // ⚠️ Reads are bypassed when the walker owns the port, so `hit` is qualified
  // by !look_ptw and a PTE can never be answered from here.
  wire read_hit = hit && !look_we && !look_ptw;

  // ---- the memory side --------------------------------------------------
  // Everything that is not a read hit goes to memory: read misses, every
  // write (write-through), and every page-table read.
  logic pending;                       // a memory transaction is outstanding
  // Declared before the assigns that use them: this repo is read by a
  // simulator that rejects declare-after-use (see koti_core.sv's
  // forward-declaration block for the same constraint).
  logic [31:0] c_wdata_q;
  logic [3:0]  c_be_q;
  assign m_req   = pending;
  assign m_we    = look_we;
  assign m_addr  = {look_tag, look_idx};
  assign m_wdata = c_wdata_q;
  assign m_be    = c_be_q;

  // ---- the answer -------------------------------------------------------
  // One clock for a hit, memory's latency plus one for anything else.
  logic        ack_q;
  logic [31:0] rdata_q;
  assign c_ack   = ack_q;
  assign c_rdata = rdata_q;

  // Byte-enable merge, used both to fill on a read miss (be = 1111) and to
  // update a line under a partial store.
  function automatic logic [31:0] merge(input logic [31:0] old,
                                        input logic [31:0] neu,
                                        input logic [3:0]  be);
      merge = {be[3] ? neu[31:24] : old[31:24],
               be[2] ? neu[23:16] : old[23:16],
               be[1] ? neu[15:8]  : old[15:8],
               be[0] ? neu[7:0]   : old[7:0]};
  endfunction

  always_ff @(posedge clk) begin
      if (rst) begin
          initing  <= 1'b1;
          init_i   <= '0;
          look     <= 1'b0;
          pending  <= 1'b0;
          ack_q    <= 1'b0;
      end else begin
          ack_q <= 1'b0;

          if (initing) begin
              valid[init_i] <= 1'b0;
              init_i <= init_i + 1'b1;
              if (&init_i) initing <= 1'b0;
          end

          // ---- accept a request -------------------------------------------
          if (!initing && c_req && !look && !pending) begin
              look      <= 1'b1;
              look_tag  <= tag;
              look_idx  <= idx;
              look_we   <= c_we;
              look_ptw  <= c_ptw;
              c_wdata_q <= c_wdata;
              c_be_q    <= c_be;
          end else if (look) begin
              look <= 1'b0;
              if (read_hit) begin
                  rdata_q <= rd_data;
                  ack_q   <= 1'b1;
              end else begin
                  // Miss, write, or walker read: memory has to answer.
                  // A WRITE updates a matching line in place as it goes past.
                  // ⚠️ This happens whether or not `look_ptw` is set — see the
                  // header: a write must never be able to leave a stale line.
                  if (look_we && rd_valid && (rd_tag == look_tag))
                      data[look_idx] <= merge(rd_data, c_wdata_q, c_be_q);
                  pending <= 1'b1;
              end
          end

          // ---- memory answered --------------------------------------------
          if (pending && m_ack) begin
              pending <= 1'b0;
              rdata_q <= m_rdata;
              ack_q   <= 1'b1;
              // Fill on a read miss only. No-write-allocate, and never for a
              // page-table read.
              if (!look_we && !look_ptw) begin
                  tags[look_idx]  <= look_tag;
                  data[look_idx]  <= m_rdata;
                  valid[look_idx] <= 1'b1;
              end
          end
      end
  end

endmodule

`default_nettype wire
