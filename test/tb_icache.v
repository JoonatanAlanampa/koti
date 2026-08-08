// tb_icache.v — standalone self-checking testbench for src/icache.sv.
//
// WHY PURE VERILOG, when everything else here is cocotb. Two reasons, and the
// second is the important one:
//
//   1. It needs nothing but iverilog, so it runs on this machine. The rest of
//      koti's suites need cocotb, which is not installed on the Windows host,
//      so every iteration on them costs a CI round trip. A cache is exactly the
//      kind of block where you want twenty fast iterations, not four slow ones.
//   2. A cache can be WRONG BY BEING RIGHT. A cache that never hits — one whose
//      `valid` never sets, say — returns perfectly correct data for every
//      request and passes any purely functional test while delivering none of
//      the speedup it exists for. So this bench counts memory transactions and
//      asserts on the COUNT, which is the only way to tell a working cache from
//      an expensive wire. `expect_mem` below is the point of the file.
//
// This is the same principle sdram_ctrl was verified under: prove the block
// standalone, against a model that is strict about the protocol, before it goes
// anywhere near a running program. The SoC-level proof (that the cache is
// transparent to a program that actually boots) is test/run_fpga.py in CI.
//
// Run:  iverilog -g2012 -o tb_icache.vvp ../src/icache.sv tb_icache.v && vvp tb_icache.vvp
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`timescale 1ns / 1ps

module tb_icache;

  localparam int ENTRIES = 8;         // deliberately tiny: forces aliasing
  localparam int LATENCY = 5;         // clocks the model takes to answer

  reg clk = 1'b0;
  reg rst = 1'b1;
  always #5 clk = ~clk;               // 100 MHz; the DUT is fully synchronous

  reg         flush = 1'b0;
  reg         req   = 1'b0;
  reg         ptw   = 1'b0;
  reg  [23:0] addr  = 24'd0;
  wire        ack;
  wire [31:0] rdata, rdata2;

  wire        m_req;
  wire [23:0] m_addr;
  reg         m_ack   = 1'b0;
  reg  [31:0] m_rdata = 32'd0, m_rdata2 = 32'd0;

  icache #(.ENTRIES(ENTRIES)) dut (
      .clk(clk), .rst(rst), .flush(flush),
      .req(req), .ptw(ptw), .addr(addr),
      .ack(ack), .rdata(rdata), .rdata2(rdata2),
      .m_req(m_req), .m_addr(m_addr), .m_ack(m_ack),
      .m_rdata(m_rdata), .m_rdata2(m_rdata2)
  );

  // ---- backing memory model -------------------------------------------
  // Sparse: `mem_val(a)` is a pure function of the address plus a "generation"
  // that the tests bump to simulate the memory changing under the cache. That
  // is how the flush and bypass tests tell a cached answer from a fresh one
  // without needing a real array.
  integer gen = 0;
  function [31:0] mem_val(input [23:0] a);
    mem_val = {a[15:0], 8'hA5, gen[7:0]} ^ 32'h5EED_0000;
  endfunction

  integer mem_txns = 0;               // every completed memory transaction

  // Strict model: answers LATENCY clocks after `m_req` rises, one-cycle ack,
  // and returns the PAIR at (m_addr, m_addr+1) exactly as the arbiter's burst
  // fetch port does.
  integer wait_ct = 0;
  always @(posedge clk) begin
    m_ack <= 1'b0;
    if (rst) begin
      wait_ct <= 0;
    end else if (m_req && !m_ack) begin
      if (wait_ct == LATENCY) begin
        m_ack    <= 1'b1;
        m_rdata  <= mem_val(m_addr);
        m_rdata2 <= mem_val(m_addr + 24'd1);
        mem_txns <= mem_txns + 1;
        wait_ct  <= 0;
      end else begin
        wait_ct <= wait_ct + 1;
      end
    end else begin
      wait_ct <= 0;
    end
  end

  // ---- scoreboard ------------------------------------------------------
  integer errors = 0;
  integer txns_before = 0;

  task mark;                          // remember the transaction count
    begin txns_before = mem_txns; end
  endtask

  task expect_mem(input integer n, input [255:0] what);
    begin
      if (mem_txns - txns_before !== n) begin
        $display("FAIL %0s: expected %0d memory transaction(s), saw %0d",
                 what, n, mem_txns - txns_before);
        errors = errors + 1;
      end
    end
  endtask

  // One transaction on the fetch port. Holds `req` until `ack`, exactly as
  // koti_core does, then drops it for a cycle.
  //
  // DRIVE ON THE RISING EDGE, SAMPLE ON THE FALLING ONE. Both halves matter.
  // Driving with a nonblocking assign at the posedge means `addr` is settled
  // long before the DUT's negedge array read, so the bench cannot race the
  // lookup. Sampling `ack` at the negedge means it is read mid-cycle, when it
  // is unambiguously stable — reading it straight after `@(posedge clk)` races
  // the DUT's own nonblocking update of it, and the first version of this file
  // did exactly that. The symptom was subtle and worth remembering: every check
  // returned the PREVIOUS transaction's data, because the bench saw the tail of
  // the last ack and called the new transaction done before it had started.
  task xact(input [23:0] a, input is_ptw);
    begin
      @(posedge clk);
      addr <= a; ptw <= is_ptw; req <= 1'b1;
      @(negedge clk);
      while (!ack) @(negedge clk);
      @(posedge clk);
      req <= 1'b0; ptw <= 1'b0;
    end
  endtask

  task fetch_chk(input [23:0] a, input [31:0] e0, input [31:0] e1,
                 input [255:0] what);
    begin
      xact(a, 1'b0);
      if (rdata !== e0 || rdata2 !== e1) begin
        $display("FAIL %0s: addr %0h got %0h/%0h expected %0h/%0h",
                 what, a, rdata, rdata2, e0, e1);
        errors = errors + 1;
      end
    end
  endtask

  // Fetch and check against memory AS IT IS NOW.
  task fetch_fresh(input [23:0] a, input [255:0] what);
    begin fetch_chk(a, mem_val(a), mem_val(a + 24'd1), what); end
  endtask

  task pulse_flush;
    begin
      @(negedge clk); flush <= 1'b1;
      @(negedge clk); flush <= 1'b0;
    end
  endtask

  integer i;
  reg [31:0] old0, old1;

  initial begin
    repeat (4) @(posedge clk);
    rst <= 1'b0;
    @(negedge clk);

    // ---- 1. cold miss goes to memory, the repeat does not ----
    mark;
    fetch_fresh(24'h001000, "1a cold miss");
    expect_mem(1, "1a cold miss");

    mark;
    fetch_fresh(24'h001000, "1b hit");
    expect_mem(0, "1b hit must not reach memory");

    // ---- 2. every entry fills, and then the whole set hits ----
    // Stride 1, so the ENTRIES addresses land on ENTRIES distinct indices and
    // none of them evicts another. (Stride 2 here would only reach half the
    // indices and quietly test eviction instead of residency — which is test 3's
    // job, and having test 2 do it by accident cost a debugging round.)
    mark;
    for (i = 0; i < ENTRIES; i = i + 1)
      fetch_fresh(24'h002000 + i[23:0], "2 fill");
    expect_mem(ENTRIES, "2 each distinct line misses once");

    mark;
    for (i = 0; i < ENTRIES; i = i + 1)
      fetch_fresh(24'h002000 + i[23:0], "2 refetch");
    expect_mem(0, "2 refetch all hits");

    // ---- 3. aliasing: two addresses ENTRIES apart share an entry ----
    // Correctness must survive it even though both cannot be resident.
    fetch_fresh(24'h003000, "3 seed A");
    mark;
    fetch_fresh(24'h003000 + ENTRIES[23:0], "3 alias B");
    expect_mem(1, "3 alias B evicts A, so it misses");
    mark;
    fetch_fresh(24'h003000, "3 A again after eviction");
    expect_mem(1, "3 A was evicted, so it misses again");

    // ---- 4. fence.i: the cache DOES hold stale code, and flush drops it ----
    fetch_fresh(24'h004000, "4 seed");
    old0 = mem_val(24'h004000);
    old1 = mem_val(24'h004001);
    gen = gen + 1;                    // memory changes under the cache
    mark;
    fetch_chk(24'h004000, old0, old1, "4 stale hit is expected");
    expect_mem(0, "4 stale hit must not reach memory");
    pulse_flush;
    mark;
    fetch_fresh(24'h004000, "4 after fence.i");
    expect_mem(1, "4 flush forces a refetch");

    // ---- 5. page-table walks bypass, and do not pollute ----
    gen = gen + 1;
    xact(24'h005000, 1'b1);           // a walk read
    if (rdata !== mem_val(24'h005000)) begin
      $display("FAIL 5a: walk returned %0h expected %0h",
               rdata, mem_val(24'h005000));
      errors = errors + 1;
    end
    mark;
    xact(24'h005000, 1'b1);           // a second walk to the same address
    expect_mem(1, "5b every walk must reach memory, never the cache");

    // A walk must not have FILLED the line either: if it had, this fetch would
    // hit and return the pre-change value.
    gen = gen + 1;
    mark;
    fetch_fresh(24'h005000, "5c walk must not fill");
    expect_mem(1, "5c fetch after walk must still miss");

    // ---- 6. flush landing mid-fill must not leave the line resident ----
    gen = gen + 1;
    fork
      begin : drive
        xact(24'h006000, 1'b0);
      end
      begin : hit_it_mid_flight
        // land the flush while the fill is out at memory
        wait (m_req === 1'b1);
        repeat (2) @(negedge clk);
        flush <= 1'b1;
        @(negedge clk);
        flush <= 1'b0;
      end
    join
    gen = gen + 1;
    mark;
    fetch_fresh(24'h006000, "6 after mid-fill flush");
    expect_mem(1, "6 a line filled across a flush must not be kept");

    // ---- 7. overlapping pairs: the unaligned-key case ----
    // (A, A+1) and (A+1, A+2) are different lines that share a word. Both must
    // be correct; this is the case a conventional aligned-line cache would have
    // had to split into two lookups.
    mark;
    fetch_fresh(24'h007000, "7a pair at A");
    fetch_fresh(24'h007001, "7b pair at A+1");
    expect_mem(2, "7 two distinct pair keys");
    mark;
    fetch_fresh(24'h007000, "7c A again");
    fetch_fresh(24'h007001, "7d A+1 again");
    expect_mem(0, "7 both resident");

    repeat (4) @(posedge clk);
    if (errors == 0)
      $display("tb_icache: PASS (%0d memory transactions total)", mem_txns);
    else
      $display("tb_icache: FAIL with %0d error(s)", errors);
    $finish;
  end

  // watchdog: a cache that wedges must fail loudly rather than hang CI
  initial begin
    #200000;
    $display("tb_icache: FAIL - timeout (the DUT stopped acking)");
    $finish;
  end

endmodule
