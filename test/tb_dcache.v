// tb_dcache.v — the gate for src/dcache.sv.
//
// Plain Verilog, not cocotb, for the same reason tb_icache.v is: it runs on the
// development host in seconds, so a cache change does not cost a CI round trip.
//
// ⚠️ IT ASSERTS ON THE MEMORY TRANSACTION COUNT, not just on returned data.
// A cache whose `valid` never sets returns the correct value for every request
// and delivers none of the speedup — it passes any purely functional test while
// being an expensive wire. Counting is the only check that tells a working
// cache from that. tb_icache.v makes the same point and for the same reason.
//
// The other half is the COHERENCE property this cache exists to preserve: every
// write must reach memory, because the video DMA reads the charbuf out of the
// same SDRAM. A write-back cache would pass the hit-rate tests and silently
// leave text off the screen, so `writes_seen` is checked as carefully as `hits`.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps
`default_nettype none

module tb_dcache;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;

  reg         c_req = 0, c_we = 0, c_ptw = 0;
  reg  [22:0] c_addr = 0;
  reg  [31:0] c_wdata = 0;
  reg  [3:0]  c_be = 4'hF;
  wire        c_ack;
  wire [31:0] c_rdata;

  wire        m_req, m_we;
  wire [22:0] m_addr;
  wire [31:0] m_wdata;
  wire [3:0]  m_be;
  reg         m_ack = 0;
  reg  [31:0] m_rdata = 0;

  dcache dut (
      .clk(clk), .rst(rst),
      .c_req(c_req), .c_we(c_we), .c_ptw(c_ptw), .c_addr(c_addr),
      .c_wdata(c_wdata), .c_be(c_be), .c_ack(c_ack), .c_rdata(c_rdata),
      .m_req(m_req), .m_we(m_we), .m_addr(m_addr), .m_wdata(m_wdata),
      .m_be(m_be), .m_ack(m_ack), .m_rdata(m_rdata)
  );

  // ---- a memory with real latency, so a hit is visibly cheaper ------------
  // Backed by a sparse store keyed on the low address bits, which is enough
  // for a cache test and avoids a 8M-entry array.
  reg [31:0] mem [0:1023];
  integer    reads_seen = 0, writes_seen = 0;

  // A COUNTER, not a blocking `while` inside a clocked block. The first draft
  // of this model used the latter and writes silently never reached memory:
  // an always block parked in a wait loop is not re-entrant, so it is a
  // testbench that can lie about the very thing it exists to observe.
  reg [3:0] m_cnt = 0;
  reg       m_busy = 0;
  always @(posedge clk) begin
      m_ack <= 1'b0;
      if (!m_busy) begin
          if (m_req) begin m_busy <= 1'b1; m_cnt <= 4'd8; end
      end else if (m_cnt != 0) begin
          m_cnt <= m_cnt - 1'b1;
      end else begin
          m_busy <= 1'b0;
          m_ack  <= 1'b1;
          if (m_we) begin
              writes_seen = writes_seen + 1;
              if (m_be[0]) mem[m_addr[9:0]][7:0]   = m_wdata[7:0];
              if (m_be[1]) mem[m_addr[9:0]][15:8]  = m_wdata[15:8];
              if (m_be[2]) mem[m_addr[9:0]][23:16] = m_wdata[23:16];
              if (m_be[3]) mem[m_addr[9:0]][31:24] = m_wdata[31:24];
          end else begin
              reads_seen = reads_seen + 1;
              m_rdata <= mem[m_addr[9:0]];
          end
      end
  end

  integer fails = 0;

  task check(input [55*8:1] what, input integer got, input integer want);
      begin
          if (got !== want) begin
              $display("  FAIL %0s: got %0d, want %0d", what, got, want);
              fails = fails + 1;
          end else begin
              $display("  ok   %0s = %0d", what, got);
          end
      end
  endtask

  // ⚠️ WAIT FOR THE PREVIOUS ACK TO FALL FIRST. `c_ack` is high for exactly one
  // cycle, and a task that asserts its request and then samples `c_ack` on the
  // next edge can see the PREVIOUS transaction's ack and return before its own
  // has even started. That race made a perfectly correct write look like a
  // write that never reached memory — the testbench, not the cache.
  // ⚠️ EVERY SAMPLE OF c_ack IS TAKEN AT A NEGEDGE, never at the posedge that
  // produced it. `ack_q` is a non-blocking assignment, so a `while (!c_ack)
  // @(posedge clk)` loop reads the value from BEFORE the edge — which means a
  // task can see the PREVIOUS transaction's one-cycle ack and return before its
  // own request has even been latched. That is exactly what happened here: it
  // made a correct write look like a write that never reached memory, and the
  // trace showed the write being issued one cycle after the bench had already
  // moved on. The cache was right; the testbench was reading the wrong instant.
  task settle;
      begin
          @(negedge clk);
          while (c_ack) @(negedge clk);
      end
  endtask

  task do_read(input [22:0] a, input ptw);
      begin
          settle;
          c_addr = a; c_we = 0; c_ptw = ptw; c_be = 4'hF; c_req = 1;
          @(negedge clk);
          while (!c_ack) @(negedge clk);
          c_req = 0; c_ptw = 0;
      end
  endtask

  task do_write(input [22:0] a, input [31:0] d, input [3:0] be);
      begin
          settle;
          c_addr = a; c_we = 1; c_ptw = 0; c_wdata = d; c_be = be; c_req = 1;
          @(negedge clk);
          while (!c_ack) @(negedge clk);
          c_req = 0; c_we = 0; c_be = 4'hF;
      end
  endtask

  // Two page-table reads back to back, driven the way koti_core's walker
  // drives them — which is the ONLY access pattern in the machine that keeps
  // `c_req` asserted through an acknowledgement. See test 9.
  task walk_two_levels(input [22:0] a, input [22:0] b);
      begin
          settle;
          c_addr = a; c_we = 0; c_ptw = 1; c_be = 4'hF; c_req = 1;
          @(negedge clk);
          while (!c_ack) @(negedge clk);
          // ⚠️ THE ADDRESS DOES NOT MOVE DURING THE ACK CYCLE, and that is the
          // whole test. Moving it here instead would hand the cache the level-0
          // address one cycle early and hide the defect completely.
          @(negedge clk);
          c_addr = b;
          @(negedge clk);
          while (!c_ack) @(negedge clk);
          c_req = 0; c_ptw = 0;
      end
  endtask

  integer base_reads, base_writes;
  integer i;

  initial begin
    for (i = 0; i < 1024; i = i + 1) mem[i] = 32'hA0000000 + i;

    repeat (4) @(posedge clk);
    rst = 0;
    // The cache clears `valid` one line per clock out of reset; give it time.
    repeat (600) @(posedge clk);

    $display("tb_dcache:");

    // ---- 1. a read miss goes to memory and returns the right word ---------
    base_reads = reads_seen;
    do_read(23'h000010, 0);
    check("read miss: memory reads", reads_seen - base_reads, 1);
    if (c_rdata !== 32'hA0000010) begin
        $display("  FAIL miss data: %08x", c_rdata); fails = fails + 1;
    end else $display("  ok   miss returned %08x", c_rdata);

    // ---- 2. THE POINT OF THE WHOLE FILE: the second read must NOT ---------
    base_reads = reads_seen;
    do_read(23'h000010, 0);
    check("re-read: memory reads (0 = it hit)", reads_seen - base_reads, 0);
    if (c_rdata !== 32'hA0000010) begin
        $display("  FAIL hit data: %08x", c_rdata); fails = fails + 1;
    end else $display("  ok   hit returned %08x", c_rdata);

    // ---- 3. write-through: the write reaches memory ----------------------
    base_writes = writes_seen;
    do_write(23'h000010, 32'hDEADBEEF, 4'hF);
    check("write: memory writes (write-through)", writes_seen - base_writes, 1);
    if (mem[10'h010] !== 32'hDEADBEEF) begin
        $display("  FAIL memory not updated: %08x", mem[10'h010]); fails = fails + 1;
    end else $display("  ok   memory holds DEADBEEF");

    // ---- 4. write-update: the cached line moved with it -------------------
    base_reads = reads_seen;
    do_read(23'h000010, 0);
    check("read after write: memory reads (0 = updated in place)",
          reads_seen - base_reads, 0);
    if (c_rdata !== 32'hDEADBEEF) begin
        $display("  FAIL stale line: %08x", c_rdata); fails = fails + 1;
    end else $display("  ok   line was updated, not left stale");

    // ---- 5. a partial store merges bytes, in the cache and in memory ------
    do_write(23'h000010, 32'h000000AA, 4'b0001);
    do_read(23'h000010, 0);
    if (c_rdata !== 32'hDEADBEAA) begin
        $display("  FAIL byte merge in cache: %08x", c_rdata); fails = fails + 1;
    end else $display("  ok   byte store merged to %08x", c_rdata);
    if (mem[10'h010] !== 32'hDEADBEAA) begin
        $display("  FAIL byte merge in memory: %08x", mem[10'h010]); fails = fails + 1;
    end else $display("  ok   memory agrees with the cache");

    // ---- 6. NO-WRITE-ALLOCATE: a store to an uncached line stays uncached --
    base_writes = writes_seen;
    do_write(23'h000020, 32'h11112222, 4'hF);
    check("store to uncached line: memory writes", writes_seen - base_writes, 1);
    base_reads = reads_seen;
    do_read(23'h000020, 0);
    check("read after uncached store: memory reads (1 = not allocated)",
          reads_seen - base_reads, 1);

    // ---- 7. PAGE-TABLE READS MUST NEVER CACHE ----------------------------
    // The one that would corrupt an MMU: a cached PTE outliving the
    // sfence.vma meant to retire it. Two identical walker reads must both
    // reach memory, and neither may leave anything behind.
    base_reads = reads_seen;
    do_read(23'h000030, 1);
    do_read(23'h000030, 1);
    check("two walker reads: memory reads (2 = neither cached)",
          reads_seen - base_reads, 2);
    base_reads = reads_seen;
    do_read(23'h000030, 0);
    check("normal read after walker reads: memory reads (1 = nothing filled)",
          reads_seen - base_reads, 1);

    // ---- 8. two addresses sharing an index must not alias ----------------
    // 512 lines, so 0x000040 and 0x000240 land on the same index with
    // different tags. A tag comparison that was wrong would return the other
    // one's data, which is the worst possible failure: silently wrong memory.
    do_read(23'h000040, 0);
    base_reads = reads_seen;
    do_read(23'h000240, 0);
    check("aliasing index, different tag: memory reads (1 = it missed)",
          reads_seen - base_reads, 1);
    if (c_rdata !== mem[10'h040]) begin
        // mem is keyed on addr[9:0], so both map to entry 0x40 in the model;
        // what matters is that the CACHE missed rather than answering from
        // the other tag's line.
        $display("  note memory model aliases; the count above is the check");
    end

    // ---- 9. THE ACK CYCLE IS NOT AN ACCEPT CYCLE -------------------------
    // The defect that made this cache produce zero characters with a kernel,
    // and the reason every other test here passed while it did: it needs a
    // requester that is still asking DURING the acknowledgement, which is the
    // page walker and nothing else. Everything above drops `c_req` the moment
    // it sees the ack, so none of it can see this.
    //
    // walk_two_levels drives the port the way koti_core drives it: the level-0
    // address does not appear until the cycle AFTER the level-1 answer, because
    // dw_state only advances on the edge that ends the ack cycle. A cache that
    // accepts during its own ack re-latches the level-1 address and hands back
    // the level-1 PTE a second time — a wrong translation, then a trap storm.
    base_reads = reads_seen;
    walk_two_levels(23'h000051, 23'h0000A2);
    check("two-level walk: memory reads (2 = both levels fetched)",
          reads_seen - base_reads, 2);
    check("two-level walk: level-0 answer is the level-0 word",
          c_rdata, mem[10'h0A2]);
    // Without this the check above could pass on two equal words and prove
    // nothing. The model fills mem[i] = 0xA0000000 + i, so they differ.
    if (mem[10'h0A2] === mem[10'h051]) begin
        $display("  FAIL the two levels hold the same word: the check above is vacuous");
        fails = fails + 1;
    end

    $display("");
    if (fails == 0) $display("tb_dcache: PASS");
    else begin
        $display("tb_dcache: FAIL (%0d)", fails);
        $fatal(1);
    end
    $finish;
  end

  // A cache that never acks would hang rather than fail.
  initial begin
      repeat (200000) @(posedge clk);
      $display("tb_dcache: FAIL (timeout — a request was never acknowledged)");
      $fatal(1);
  end

endmodule

`default_nettype wire
