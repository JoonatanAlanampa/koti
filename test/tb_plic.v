// tb_plic.v — standalone self-checking testbench for src/plic.sv.
//
// Pure Verilog for the same two reasons tb_icache.v is: it runs on the Windows
// host where cocotb is not installed, and an interrupt controller is another
// block that can be wrong by being quiet. A PLIC that never asserts `eip`
// breaks nothing visible in a polling system — it just means interrupts never
// arrive, which looks exactly like "the device is idle".
//
// So the assertions here are mostly about the SEQUENCE: that eip rises only
// when a source is enabled AND above threshold, that claim returns the right
// id and drops eip, that a level-sensitive source which is still asserted
// re-arms on completion, and that priority order and tie-breaking match the
// spec. Those are the properties Linux's driver depends on.
//
// Run: iverilog -g2012 -o tb_plic.vvp ../src/plic.sv tb_plic.v && vvp tb_plic.vvp
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`timescale 1ns / 1ps

module tb_plic;

  localparam int SOURCES = 4;

  reg clk = 1'b0;
  reg rst = 1'b1;
  always #5 clk = ~clk;

  reg  [SOURCES:1] src = '0;
  reg              sel = 1'b0;
  reg              we  = 1'b0;
  reg  [21:0]      addr = 22'd0;
  reg  [31:0]      wdata = 32'd0;
  wire [31:0]      rdata;
  wire             eip;

  plic #(.SOURCES(SOURCES)) dut (
      .clk(clk), .rst(rst), .src(src),
      .sel(sel), .we(we), .addr(addr), .wdata(wdata), .rdata(rdata),
      .eip(eip)
  );

  // Register offsets, straight from the SiFive layout the DUT implements.
  localparam [21:0] PRIO0   = 22'h000000;
  localparam [21:0] PENDING = 22'h001000;
  localparam [21:0] ENABLE  = 22'h002000;
  localparam [21:0] THRESH  = 22'h200000;
  localparam [21:0] CLAIM   = 22'h200004;

  integer errors = 0;

  task chk(input cond, input [255:0] what);
    begin
      if (!cond) begin
        $display("FAIL %0s", what);
        errors = errors + 1;
      end
    end
  endtask

  // One MMIO access. `sel` is high for exactly one cycle, which is the
  // contract project.sv provides and which the claim register depends on.
  task wr(input [21:0] a, input [31:0] d);
    begin
      @(posedge clk); addr <= a; wdata <= d; we <= 1'b1; sel <= 1'b1;
      @(posedge clk); sel <= 1'b0; we <= 1'b0;
      @(negedge clk);
    end
  endtask

  reg [31:0] rv;
  task rd(input [21:0] a);
    begin
      @(posedge clk); addr <= a; we <= 1'b0; sel <= 1'b1;
      @(negedge clk); rv = rdata;      // combinational, sampled mid-cycle
      @(posedge clk); sel <= 1'b0;
      @(negedge clk);
    end
  endtask

  initial begin
    repeat (4) @(posedge clk);
    rst <= 1'b0;
    @(negedge clk);

    // ---- 1. reset state is quiet ----
    // Every priority resets to 0, which the spec defines as "never
    // interrupt". A PLIC that came up hot would storm before any driver
    // had configured it.
    src = 4'b1111;
    repeat (3) @(negedge clk);
    chk(eip === 1'b0, "1 no interrupt before anything is configured");
    rd(PENDING);
    chk(rv[4:1] == 4'b1111, "1 pending still tracks the sources");

    // ---- 2. priority alone is not enough; enable is also required ----
    wr(PRIO0 + 22'd4, 32'd3);            // source 1, priority 3
    repeat (2) @(negedge clk);
    chk(eip === 1'b0, "2 priority without enable must not interrupt");
    wr(ENABLE, 32'b0010);                // enable source 1
    repeat (2) @(negedge clk);
    chk(eip === 1'b1, "2 enabled and above threshold must interrupt");

    // ---- 3. threshold gates it ----
    wr(THRESH, 32'd3);                   // priority must EXCEED threshold
    repeat (2) @(negedge clk);
    chk(eip === 1'b0, "3 priority == threshold must not interrupt");
    wr(THRESH, 32'd2);
    repeat (2) @(negedge clk);
    chk(eip === 1'b1, "3 priority > threshold interrupts");

    // ---- 4. claim returns the id, drops eip, and clears pending ----
    rd(CLAIM);
    chk(rv == 32'd1, "4 claim returns source 1");
    repeat (2) @(negedge clk);
    chk(eip === 1'b0, "4 eip drops once claimed");
    rd(PENDING);
    chk(rv[1] === 1'b0, "4 claimed source is no longer pending");

    // ---- 5. a still-asserted level source re-arms on completion ----
    // This is the case koti actually has: kb_avail stays high until software
    // reads the scancode. A gateway that re-armed on claim instead would
    // re-enter the handler immediately; one that never re-armed would wedge
    // the keyboard after a single keystroke.
    wr(CLAIM, 32'd1);                    // complete
    repeat (2) @(negedge clk);
    chk(eip === 1'b1, "5 source still high: re-arms after completion");

    // and once the device is silenced, completion leaves it quiet
    rd(CLAIM);
    chk(rv == 32'd1, "5 claim again");
    src[1] = 1'b0;                       // handler silenced the device
    wr(CLAIM, 32'd1);                    // complete
    repeat (2) @(negedge clk);
    chk(eip === 1'b0, "5 silenced source stays quiet after completion");

    // ---- 6. highest priority wins ----
    src = 4'b1111;
    wr(ENABLE, 32'b11110);               // sources 1..4
    wr(PRIO0 + 22'd4,  32'd3);           // src1 prio 3
    wr(PRIO0 + 22'd8,  32'd7);           // src2 prio 7
    wr(PRIO0 + 22'd12, 32'd5);           // src3 prio 5
    wr(PRIO0 + 22'd16, 32'd0);           // src4 disabled by priority 0
    repeat (2) @(negedge clk);
    rd(CLAIM);
    chk(rv == 32'd2, "6 highest priority (source 2) claimed first");
    wr(CLAIM, 32'd2);
    src[2] = 1'b0;
    repeat (2) @(negedge clk);
    rd(CLAIM);
    chk(rv == 32'd3, "6 then source 3");
    wr(CLAIM, 32'd3);
    src[3] = 1'b0;
    repeat (2) @(negedge clk);
    rd(CLAIM);
    chk(rv == 32'd1, "6 then source 1");
    wr(CLAIM, 32'd1);
    src[1] = 1'b0;
    repeat (2) @(negedge clk);
    // source 4 is asserted and enabled but priority 0: never delivered
    chk(eip === 1'b0, "6 priority 0 source is never delivered");
    rd(CLAIM);
    chk(rv == 32'd0, "6 claim with nothing pending returns 0");

    // ---- 7. ties break toward the LOWEST id ----
    src = 4'b1111;
    wr(PRIO0 + 22'd4,  32'd4);
    wr(PRIO0 + 22'd8,  32'd4);
    wr(PRIO0 + 22'd12, 32'd4);
    wr(PRIO0 + 22'd16, 32'd4);
    repeat (2) @(negedge clk);
    rd(CLAIM);
    chk(rv == 32'd1, "7 equal priorities break toward the lowest id");

    repeat (4) @(posedge clk);
    if (errors == 0) $display("tb_plic: PASS");
    else             $display("tb_plic: FAIL with %0d error(s)", errors);
    $finish;
  end

  initial begin
    #200000;
    $display("tb_plic: FAIL - timeout");
    $finish;
  end

endmodule
