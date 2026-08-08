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
// has no block RAM to put this in. ✅ ENABLED on every FPGA build since
// 2026-08-08 — project.sv derives KOTI_DCACHE from KOTI_FPGA, and
// `KOTI_NO_DCACHE` is the bring-up switch that puts the bypass back.
//
// ══════════════════════════════════════════════════════════════════════════
// ⭐ THE ACK CYCLE IS NOT AN ACCEPT CYCLE. That single rule — the `!ack_q` term
// in the accept condition below — is what took this cache from "0 characters
// with a kernel" to a full Linux boot, and it is the one thing to preserve.
//
// `pending` clears on the SAME edge that sets `ack_q`, so without that term the
// cache is idle-looking during the very cycle it is presenting an
// acknowledgement, and it accepts whatever the request port still shows. What
// the port still shows is the transaction that just finished: a requester has
// not seen the ack yet and is still asking for it. So the cache re-latched a
// STALE ADDRESS and did the whole transaction again.
//
// ⇒ arbiter3.sv NEVER DOES THIS, which is why nothing had ever needed the rule.
// Its grant returns to G_NONE on the ack and it re-arbitrates the cycle AFTER,
// by which time the requester has moved on. It also passes `d_addr` through
// combinationally, so the address always belongs to whoever is asking now.
// Anything that LATCHES an address — a cache — needs the missing cycle back.
//
// ⚠️ WHY ONLY THE PAGE WALKER DIED OF IT. koti_core's M stage withdraws on its
// own ack (`d_req = (d_active && !m_ack_here) || dw_req`), so an M-stage
// request is already gone during the ack cycle and cannot be re-latched. The
// walker has no such term: `dw_req` is just `(dw_state != 0) && !m_port_busy`,
// and `dw_state` does not advance until the edge at the END of the ack cycle.
// So the walker's level-1 PTE read was re-issued, and its answer arrived while
// dw_state had moved to 2 — the level-1 PTE delivered as the level-0 PTE.
// A wrong translation faults, which walks again, which storms traps: 100% of
// samples inside handle_exception across 66 distinct addresses.
//
// ⇒ MMU-ONLY, which is exactly why every bench that passed, passed. bringup.S
// and the SBI firmware never enable paging, so the walker never runs.
// MEASURED, not deduced: an instrumented run printed 30 re-accepts, every one
// of them with ptw=1 and the same address as the transaction that had just
// completed.
// ══════════════════════════════════════════════════════════════════════════
//
// ⭐ AND A MEASUREMENT THAT INVITED THE OPPOSITE CONCLUSION. With the fix in,
// the first whole-boot benchmark said the cache made the machine 18% SLOWER.
// That number was real and it meant nothing: test/sim_mem.sv answers in ONE
// clock, so it is faster than any cache in front of it, and the boot bench had
// been scoring memory as free. Clocks to userspace, same kernel image, same
// 4392 characters of identical console output, `+memlat` = extra clocks per
// memory transaction:
//
//   +memlat   no cache        D-cache         verdict
//   0        503,134,412     594,781,497     18.2% SLOWER  (model artefact)
//   4      1,017,805,763   1,012,172,330      0.55% faster  (the crossover)
//   6      1,262,089,595   1,205,653,407      4.47% faster  ⭐ MATCHES THE BOARD
//   9      1,666,686,417   1,518,594,747       8.9% FASTER  (2x optimistic)
//
// ⇒ THE CACHE IS WORTH EXACTLY WHAT MEMORY COSTS, and it breaks even at about
// a five-clock memory. Read hit rate is a steady 73% at every latency measured.
// ⚠️ Never benchmark this cache at memlat=0 and conclude anything.
//
// ══════════════════════════════════════════════════════════════════════════
// 🏆 MEASURED ON THE REAL BOARD 2026-08-08 — AND THE MODEL WAS 2x OPTIMISTIC.
// Controlled A/B on the ULX3S: same commit, same `image: sbi`, same `bram`
// variant, one variable (`-DKOTI_NO_DCACHE`), two runs per arm, SRAM loads.
//
//   kernel time, run 1 / run 2      no cache 46.8252 / 46.8350 s
//                                   D-cache  44.7331 / 44.7233 s   -4.49%
//   host wall-clock to the prompt   no cache 83.41 / 83.50 s
//                                   D-cache  80.09 / 79.80 s       -4.21%
//
// ✅ CORRECT ON REAL SDRAM: both arms reach `buildroot login:`, all four boots
// print 4230 characters / 52 printks / 0 non-printable, and the logs are
// textually IDENTICAL once timestamps are stripped (bar one page of MemFree).
// Real refresh, real RD_ADV and the real row policy do not upset it.
// 📌 Run-to-run spread inside an arm is ≤0.01 s — 0.02%, so the 2.10 s gap is
// ~200x the noise.
//
// 🔴 **QUOTE 4.5%, NOT 8.9%.** The 8.9% is what a FLAT 10-clock memory model
// predicts, and the real sdram_ctrl is cheaper than that on a row hit.
// 8.9% is a property of test/sim_mem.sv; 4.5% is what this machine gained.
// Do not cite the model number as the board's speedup — that is the same class
// of mistake as the memlat=0 reading, one layer further out.
//
// ⭐ AND THE MODEL IS NOW CALIBRATED RATHER THAN DISCREDITED: `+memlat=6`
// predicts 4.47% against hardware's 4.49%. ~10 clocks is the WORST case (a
// random read missing the open row); as a flat average it overstates memory,
// and therefore overstates any cache. **Use +memlat=6 for the next memory
// decision** — the write buffer and the walker bypass below both need it.
// ⚠️ Span caveat: simulation counts clocks to `userspace is alive`; the
// hardware kernel-time figure is kernel entry → last printk and the wall-clock
// one includes the SBI microSD load (I/O, not memory). Neither flatters it.
// ══════════════════════════════════════════════════════════════════════════
//
// ⇒ Anything that makes memory cheaper (the open-row policy and 4-word burst
// PLAN.md still lists) moves the machine back TOWARD the crossover rather than
// away from it. Re-measure both together; do not assume they add up.
//
// WHAT LIMITS THE WIN, measured in the same run: 21.5M writes against 27.6M
// cacheable reads, and write-through means every one of those writes is a full
// memory round trip PLUS this cache's two cycles. A further 13.2M walker reads
// are bypassed and still pay the two cycles. Both are known, both are worth
// something, and neither was worth adding to the change that made it correct.
//
// REPRODUCE IN ~1 MINUTE (no CI, no board):
//   gh run download <a green linux run> -n koti-linux-Image -D kimg
//   python3 test/mkhex.py sw/sbi/sbi_sd.bin fw.hex
//   python3 test/mkhex.py kimg/arch/riscv/boot/Image kernel.hex
//   iverilog -g2012 -I src -DKOTI_FPGA -DKOTI_SIMMEM //     -o b.vvp src/*.sv src/usb_hid_host_rom.v vendor/*.sv vendor/*.v //     test/sim_prims.v test/sim_mem.sv test/tb_boot.v
//   vvp b.vvp +flash=fw.hex +ram=kernel.hex +ramoff=1048576 +maxclk=4000000
//   # the banner appears inside 3M clocks; add +memlat=9 for a real memory,
//   # -DKOTI_DCACHE_STATS for the hit rate, -DKOTI_NO_DCACHE to take it out.
//   # then: tools/ktrace.py <System.map> <trace> --image <Image>
// ⚠️ test/mkhex.py, NOT fpga/ulx3s/mkflashhex.py — the latter emits one BYTE
// per line for the fabric flash while sim_mem's array is WORDS, so it silently
// loads garbage and produces 0 characters, which looks exactly like a hang.
// ⚠️ A whole boot to userspace is ~4.7 HOURS under iverilog and ~3 MINUTES
// under Verilator. Use the Verilator recipe in .github/workflows/linux.yaml.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module dcache #(
    parameter integer IDX_BITS = 9,             // 512 lines of one word
    parameter integer ADDR_BITS = 24            // word address, as the core uses
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

  // ---- statistics, simulation only ---------------------------------------
  // Not decoration: the decision to enable this cache at all was made on the
  // hit rate, and a hit rate nobody can print is a hit rate nobody can check
  // when the workload changes. `KOTI_DCACHE_STATS` is defined by no synthesis
  // build and no CI job; pass it to a boot run to get the numbers back.
`ifdef KOTI_DCACHE_STATS
  integer n_rd, n_hit, n_wr, n_ptw;
  initial begin n_rd = 0; n_hit = 0; n_wr = 0; n_ptw = 0; end
  always_ff @(posedge clk)
      if (!rst && look) begin
          if (look_ptw)      n_ptw <= n_ptw + 1;
          else if (look_we)  n_wr  <= n_wr  + 1;
          else begin
              n_rd <= n_rd + 1;
              if (hit) n_hit <= n_hit + 1;
          end
      end
  final
      $display("dcache: %0d cacheable reads, %0d hits (%0d%%), %0d writes, %0d walker reads",
               n_rd, n_hit, (n_rd == 0) ? 0 : (100 * n_hit) / n_rd, n_wr, n_ptw);
`endif

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
          // ⛔ `!ack_q`: THE ACK CYCLE IS NOT AN ACCEPT CYCLE. See the header.
          if (!initing && c_req && !look && !pending && !ack_q) begin
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
