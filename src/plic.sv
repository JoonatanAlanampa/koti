// plic.sv — Koti-1's platform-level interrupt controller.
//
// WHY THIS EXISTS. PLAN.md has listed a "PLIC-lite" among the architecture
// deltas since the beginning and it was never built. What stood in for it was
// one wire: project.sv did `assign kb_irq = kb_avail` straight into the core's
// `meip`. That is enough to poll a keyboard and not enough to run an operating
// system, for two separate reasons:
//
//   Linux has no interrupt controller to bind a driver to, so no device can
//   claim an interrupt at all.
//
//   The keyboard raised an M-MODE interrupt while `mideleg` delegates SEIP,
//   which nothing ever raised. A keystroke could not reach supervisor mode
//   however the kernel was configured.
//
// REGISTER-COMPATIBLE ON PURPOSE. The layout below is the SiFive PLIC's, so
// mainline's `sifive,plic-1.0.0` driver drives this unmodified. That is worth
// real estate: koti's other devices all need custom drivers (the PS/2 block is
// one MMIO word, not an i8042), and the interrupt controller is the one place
// where following somebody else's register map buys a whole working driver.
//
// The price is the address window. The context registers live at offset
// 0x200000 in the spec and the driver hard-codes that, so the PLIC cannot fit
// in a 64 KB carve-out like the CLINT does — it needs a multi-megabyte region.
// project.sv gives it the TOP 4 MB of flash address space rather than carving
// a hole in the low addresses, so software keeps a contiguous run from zero.
//
// CLAIM/COMPLETE IS WHY THIS IS BETTER THAN FORWARDING MEIP. The obvious
// cheap alternative was to leave the wire alone and have M-mode firmware
// forward `meip` into `mip.SEIP`. It does not work: `sip.SEIP` is read-only to
// supervisor mode (csr.sv only lets S write SSIP), so after the handler runs,
// nothing S can do clears the bit and it re-traps forever. Breaking that needs
// a non-standard SBI call on every interrupt. A real gateway has an
// acknowledgement path built in — claim takes the interrupt out of pending,
// complete re-arms it — and koti's sources are level-sensitive, so the source
// having gone away by completion time is exactly the normal case.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module plic #(
    // Source IDs are 1..SOURCES. Zero is reserved by the spec and reads as a
    // permanently-quiet source, which is what makes "claim returned 0" mean
    // "nothing was pending".
    parameter int SOURCES = 4
) (
    input  logic               clk,
    input  logic               rst,

    // Level-sensitive request lines, index = source ID.
    input  logic [SOURCES:1]   src,

    // MMIO, same shape as clint.sv: `sel` is high for exactly one cycle per
    // access and `rdata` is combinational from state. The one-cycle guarantee
    // matters more here than it does for the CLINT — reading the claim
    // register has a SIDE EFFECT, and a `sel` that lingered would claim the
    // same interrupt twice.
    input  logic               sel,
    input  logic               we,
    input  logic [21:0]        addr,      // byte address within the window
    input  logic [31:0]        wdata,
    output logic [31:0]        rdata,

    // to the core's S-mode external interrupt input
    output logic               eip
);

  localparam int CTX = 0;   // the single context, serving S-mode. See below.

  logic [2:0]         prio [1:SOURCES];
  logic [SOURCES:1]   enable;
  logic [2:0]         threshold;
  logic [SOURCES:1]   ip;         // pending at the gateway
  logic [SOURCES:1]   inflight;   // claimed, awaiting completion

  // ---- address decode -------------------------------------------------
  // 0x000000 + 4*id : priority[id]
  // 0x001000        : pending bits (read-only)
  // 0x002000        : enable bits for the context
  // 0x200000        : priority threshold
  // 0x200004        : claim (read) / complete (write)
  wire is_ctx   = addr[21];
  wire is_thr   = is_ctx && addr[11:0] == 12'h000;
  wire is_claim = is_ctx && addr[11:0] == 12'h004;
  wire is_prio  = !is_ctx && addr[20:12] == 9'd0;
  wire is_pend  = !is_ctx && addr[20:12] == 9'd1;
  wire is_en    = !is_ctx && addr[20:12] == 9'd2;
  wire [31:0] prio_id = {22'd0, addr[11:2]};

  // ---- arbitration ----------------------------------------------------
  // Highest priority wins; the spec breaks ties toward the LOWEST id, which is
  // why the loop counts down and the comparison is >=: the last writer wins,
  // and the last one visited is the lowest-numbered.
  logic [31:0] best_id;
  logic [2:0]  best_prio;
  integer      i;
  always_comb begin
    best_id   = 32'd0;
    best_prio = 3'd0;
    for (i = SOURCES; i >= 1; i = i - 1)
      if (ip[i] && enable[i] && prio[i] > threshold && prio[i] >= best_prio) begin
        best_prio = prio[i];
        best_id   = i[31:0];
      end
  end

  assign eip = (best_id != 32'd0);

  wire claim_fires    = sel && !we && is_claim && best_id != 32'd0;
  wire complete_fires = sel &&  we && is_claim
                     && wdata >= 32'd1 && wdata <= SOURCES[31:0];

  always_comb begin
    rdata = 32'd0;
    if (is_prio) begin
      // id 0 is reserved and reads 0; anything past SOURCES reads 0 too, which
      // is how a driver probing the source count finds the end.
      rdata = (prio_id >= 32'd1 && prio_id <= SOURCES[31:0])
            ? {29'd0, prio[prio_id[$clog2(SOURCES+1)-1:0]]} : 32'd0;
    end else if (is_pend) begin
      rdata = {{(32 - SOURCES){1'b0}}, ip, 1'b0};
    end else if (is_en) begin
      rdata = {{(32 - SOURCES){1'b0}}, enable, 1'b0};
    end else if (is_thr) begin
      rdata = {29'd0, threshold};
    end else if (is_claim) begin
      rdata = best_id;
    end
  end

  integer j;
  always_ff @(posedge clk)
    if (rst) begin
      enable    <= '0;
      threshold <= 3'd0;
      ip        <= '0;
      inflight  <= '0;
      for (j = 1; j <= SOURCES; j = j + 1)
        prio[j] <= 3'd0;      // priority 0 = never interrupt, per the spec
    end else begin
      if (sel && we) begin
        if (is_prio && prio_id >= 32'd1 && prio_id <= SOURCES[31:0])
          prio[prio_id[$clog2(SOURCES+1)-1:0]] <= wdata[2:0];
        if (is_en)  enable    <= wdata[SOURCES:1];
        if (is_thr) threshold <= wdata[2:0];
      end

      // Gateway, one per source. While a source is not in flight its pending
      // bit simply FOLLOWS the request line, which is the level-sensitive
      // behaviour koti's devices actually have — `kb_avail` stays high until
      // software reads the scancode register, and drops on its own when it
      // does. A claim removes the bit and marks the source in flight so it
      // cannot re-arm underneath the handler; completion lets it follow again,
      // by which time the handler has usually already silenced the device.
      for (j = 1; j <= SOURCES; j = j + 1) begin
        if (claim_fires && best_id == j[31:0]) begin
          ip[j]       <= 1'b0;
          inflight[j] <= 1'b1;
        end else if (complete_fires && wdata == j[31:0]) begin
          inflight[j] <= 1'b0;
          ip[j]       <= src[j];
        end else if (!inflight[j]) begin
          ip[j]       <= src[j];
        end
      end
    end

  // A single context, and it belongs to SUPERVISOR mode.
  //
  // The spec numbers contexts per (hart, privilege) pair and a full PLIC would
  // give hart 0 both an M and an S context. koti's M-mode firmware has no use
  // for device interrupts — it services ecalls, the timer and rdtime, and
  // everything else is delegated — so the M context would be dead registers.
  //
  // This is visible in the devicetree and has to stay consistent with it:
  // mainline's driver derives the hardware context index from the POSITION of
  // each entry in `interrupts-extended`, so koti.dts lists exactly one entry,
  // `<&cpu0_intc 9>`, and the driver therefore drives context 0 — this one.
  // Listing an M-mode entry first would silently shift it to context 1 and the
  // driver would program registers that do not exist.
  wire _unused = &{CTX == 0, 1'b0};

endmodule
