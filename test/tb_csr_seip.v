// tb_csr_seip.v — mip.SEIP must survive a read-modify-write.
//
// THE BUG THIS PINS, found 2026-08-09 after a full day of chasing it through
// every device on the machine. csr.sv read mip.SEIP as the OR of the PLIC's pin
// and the software-writable bit -- correct for a READ -- and then fed that same
// value into the CSRRS/CSRRC modify path, so a set/clear of ANY OTHER BIT of
// mip copied the live pin into `seip_sw`. Nothing ever cleared it again.
//
// The privileged spec names this case exactly:
//
//   the value read from mip.SEIP is the logical-OR of the software-writable bit
//   and the interrupt signal from the external interrupt controller. HOWEVER,
//   the value used in the read-modify-write sequences of CSRRS/CSRRC is only
//   the software-writable SEIP bit, ignoring the interrupt value from the
//   external interrupt controller.
//
// WHY IT MATTERED SO MUCH HERE. koti's firmware does a read-modify-write on mip
// one hundred times a second -- csr_set(mip, 1<<5) in the M-timer handler and
// csr_clear(mip, 1<<5) in sbi_set_timer -- so any tick coinciding with the
// keyboard's PLIC line being high latched SEIP on permanently. Linux then took
// an external interrupt that would never go away, claimed from a PLIC that had
// nothing pending, failed to resolve hwirq 0, handled nothing and took it
// again, for ever. Userspace was never scheduled again. Every device instrument
// read healthy throughout, because every device WAS healthy.
//
// ⚠️ The failure is invisible to any test that only checks what mip READS,
// because the read was always right. It only shows when the pin DROPS and the
// stale software copy is left behind, which is what test 3 does.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

module tb_csr_seip;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;

  reg         en = 0, wen = 0;
  reg  [1:0]  op = 2'b00;
  reg  [11:0] addr = 12'h000;
  reg  [31:0] wval = 32'd0;
  wire [31:0] rval;
  reg         seip_pin = 0;

  integer fails = 0;

  csr dut (
      .clk(clk), .rst(rst), .retire(1'b0),
      .en(en), .op(op), .wen(wen), .addr(addr), .wval(wval), .rval(rval),
      .trap(1'b0), .trap_irq(1'b0), .trap_kind(4'd0),
      .trap_pc(32'd0), .trap_tval(32'd0),
      .mret(1'b0), .sret(1'b0),
      .mtip(1'b0), .msip(1'b0), .meip(1'b0),
      .seip_pin(seip_pin),
      .irq(), .trap_vec(), .mepc_rd(), .sepc_rd(),
      .satp_rd(), .priv_rd(), .sum_rd(), .mxr_rd(), .known()
  );

  task check(input [55*8:1] what, input integer got, input integer want);
      begin
          if (got !== want) begin
              $display("  FAIL %0s: got %0d, want %0d", what, got, want);
              fails = fails + 1;
          end else
              $display("  ok   %0s = %0d", what, got);
      end
  endtask

  // One CSR access: `en` for a single cycle, the way EX drives it.
  task csr_access(input [1:0] o, input [11:0] a, input [31:0] v);
      begin
          @(negedge clk);
          en = 1; wen = 1; op = o; addr = a; wval = v;
          @(negedge clk);
          en = 0; wen = 0;
      end
  endtask

  task csr_read(input [11:0] a, output [31:0] v);
      begin
          @(negedge clk);
          en = 1; wen = 0; op = 2'b10; addr = a; wval = 32'd0;  // CSRRS x0
          #1 v = rval;
          @(negedge clk);
          en = 0;
      end
  endtask

  reg [31:0] v;

  initial begin
    repeat (4) @(posedge clk);
    rst = 0;
    repeat (2) @(posedge clk);

    $display("tb_csr_seip:");

    // ---- 1. the READ is the OR, and must stay that way ------------------
    // This is the half that was always correct, and it is checked first so a
    // "fix" that simply stopped ORing would fail here rather than pass by
    // breaking the other direction.
    seip_pin = 1;
    csr_read(12'h344, v);
    check("mip.SEIP reads the pin", (v >> 9) & 1, 1);

    seip_pin = 0;
    csr_read(12'h344, v);
    check("mip.SEIP follows the pin down", (v >> 9) & 1, 0);

    // ---- 2. a read-modify-write of ANOTHER bit, pin HIGH -----------------
    // csr_set(mip, 1<<5) — exactly what the M-timer handler does every tick.
    // It must set STIP and must NOT capture the pin into the software bit.
    seip_pin = 1;
    csr_access(2'b10, 12'h344, 32'h0000_0020);      // CSRRS mip, STIP
    csr_read(12'h344, v);
    check("STIP set by the RMW", (v >> 5) & 1, 1);
    check("SEIP still reads high while the pin is high", (v >> 9) & 1, 1);

    // ---- 3. ⛔ THE BUG: drop the pin and see what is left behind ---------
    // With the spec-correct behaviour the software bit was never written, so
    // SEIP falls with the pin. With the OR fed back into the modify, seip_sw
    // holds the captured 1 and SEIP is pending FOR EVER — an interrupt no
    // device is requesting and no handler can clear.
    seip_pin = 0;
    csr_read(12'h344, v);
    check("SEIP CLEARS when the pin drops (the bug)", (v >> 9) & 1, 0);

    // ---- 4. the same for CSRRC, which sbi_set_timer uses -----------------
    seip_pin = 1;
    csr_access(2'b11, 12'h344, 32'h0000_0020);      // CSRRC mip, STIP
    seip_pin = 0;
    csr_read(12'h344, v);
    check("SEIP clears after a CSRRC too", (v >> 9) & 1, 0);

    // ---- 5. and M-mode must still be able to INJECT SEIP deliberately ----
    // The software bit is a real feature: M-mode injects a supervisor external
    // interrupt with it. A fix that merely made bit 9 unwritable would pass
    // everything above and break this.
    csr_access(2'b01, 12'h344, 32'h0000_0200);      // CSRRW mip, SEIP
    csr_read(12'h344, v);
    check("M-mode can still inject SEIP by hand", (v >> 9) & 1, 1);

    // and clear it again
    csr_access(2'b01, 12'h344, 32'h0000_0000);
    csr_read(12'h344, v);
    check("and clear its own injection", (v >> 9) & 1, 0);

    $display("");
    if (fails == 0) $display("tb_csr_seip: PASS");
    else begin
        $display("tb_csr_seip: FAIL (%0d)", fails);
        $fatal;
    end
    $finish;
  end

  initial begin
    #200000;
    $display("tb_csr_seip: FAIL (timeout)");
    $fatal;
  end

endmodule
