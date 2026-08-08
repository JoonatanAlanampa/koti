// tb_vga_grant.v — the F3 guard: a video refill that has been accepted for
// arbitration MUST finish, even if software disables the display mid-row.
//
// WHY THIS FILE EXISTS. F3 was a real defect and it had a cocotb test,
// `test_vga_disable_does_not_park_grant` in test/test.py. That suite was built
// on the ASIC configuration — the CPU reaching flash AND PSRAM over the QSPI
// pins — and it retired on 2026-08-08 when koti became an FPGA-only project
// and the second configuration was removed. The DEFECT did not retire with it,
// so its guard is re-expressed here at the module level, where it needs no CPU
// and runs locally in a second.
//
// THE DEFECT: `v_req` used to be gated on `en`. The 3-port arbiter latches a
// grant and then waits for the memory to acknowledge; `mem_arbiter3` releases
// on `m_ack` OR on the request being dropped, but a requester that walks away
// after being granted and before the ack leaves the arbiter holding a grant for
// a request that no longer exists. `m_req` is low, so no controller starts a
// transaction, so no ack ever arrives, so the grant is never released — and the
// CPU stalls forever on its next fetch. The machine simply stops, which looks
// like a CPU hang and is a video bug.
//
// ⇒ The rule is: `en` may stop a refill from STARTING, and may never stop one
// from FINISHING. `assign v_req = f_busy` is the fix; anything that reintroduces
// `en` into that expression brings F3 back.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps
`default_nettype none

module tb_vga_grant;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;

  reg  en = 1, ce = 1;
  reg  [23:0] base = 24'h400000;      // somewhere in the RAM window
  wire        v_req;
  wire [23:0] v_addr;
  reg         v_ack = 0;
  reg  [31:0] v_rdata = 32'h20202020, v_rdata2 = 32'h20202020;
  wire        hsync, vsync, active, pix;

  vga_text dut (
      .clk(clk), .rst(rst), .ce(ce), .en(en), .base(base),
      .v_req(v_req), .v_addr(v_addr), .v_ack(v_ack),
      .v_rdata(v_rdata), .v_rdata2(v_rdata2),
      .hsync(hsync), .vsync(vsync), .active(active), .pix(pix)
  );

  integer fails = 0;
  integer i;
  integer waited;

  task fail(input [70*8:1] why);
      begin $display("  FAIL %0s", why); fails = fails + 1; end
  endtask

  initial begin
    repeat (4) @(posedge clk);
    rst = 0;

    $display("tb_vga_grant:");

    // Wait for the row-fetch FSM to ask for a refill. It triggers on the
    // hblank of specific scanlines, so this is a wait, not a poke.
    waited = 0;
    while (!v_req && waited < 2_000_000) begin
        @(posedge clk);
        waited = waited + 1;
    end
    if (!v_req) begin
        fail("the video port never requested a refill at all");
    end else begin
        $display("  ok   refill requested after %0d clocks", waited);

        // ⛔ THE TEST. Software disables the display while the request is up
        // and BEFORE the arbiter acknowledges. `v_req` must stay asserted:
        // dropping it here is what parks the grant.
        @(negedge clk);
        en = 0;
        i = 0;
        for (i = 0; i < 20 && fails == 0; i = i + 1) begin
            @(posedge clk);
            if (!v_req)
                fail("v_req was withdrawn after `en` went low - F3 is back");
        end
        $display("  ok   v_req held for 20 clocks with en low");

        // And it must still complete when the memory finally answers.
        // ⚠️ A ROW REFILL IS FIVE TRANSACTIONS (10 words = 40 characters), not
        // one. The first draft of this test acked once, watched `v_req` stay
        // high for the remaining four, and reported the DESIGN as broken. Ack
        // until the port lets go.
        waited = 0;
        while (v_req && waited < 200) begin
            @(negedge clk); v_ack = 1;
            @(negedge clk); v_ack = 0;
            waited = waited + 1;
        end
        if (v_req) fail("the refill never finished even when acked");
        else $display("  ok   the refill completed in %0d transactions", waited);

        // With `en` still low, no NEW refill may start: `en` gates starting,
        // which is the half of the rule that must also survive.
        waited = 0;
        for (i = 0; i < 400000; i = i + 1) begin
            @(posedge clk);
            if (v_req) waited = waited + 1;
        end
        // Allow the in-flight transaction's tail, but a re-triggering FSM
        // would keep asserting for whole rows.
        if (waited > 100) fail("new refills started while en was low");
        else $display("  ok   no new refill started while en was low (%0d)", waited);
    end

    begin
      $display("");
      if (fails == 0) $display("tb_vga_grant: PASS");
      else begin
          $display("tb_vga_grant: FAIL (%0d)", fails);
          $fatal(1);
      end
      $finish;
    end
  end

  initial begin
      repeat (4_000_000) @(posedge clk);
      $display("tb_vga_grant: FAIL (timeout)");
      $fatal(1);
  end

endmodule

`default_nettype wire
