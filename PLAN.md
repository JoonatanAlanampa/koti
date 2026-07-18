# Koti-1 — plan

**Goal:** the first Tiny Tapeout chip to boot full MMU Linux *visibly* — a
single-chip home computer (fi. *kotitietokone*): monitor on the VGA Pmod,
keyboard on PS/2, mainline sv32 Linux with the console on screen. Ladder
rung 1 (nommu uLinux + VGA console) is already a TT first on its own;
rung 2 (sv32/S-mode) is the frontier. Precedent that the memory-starved
half works: KianV RV32IMA uLinux SoC (TT06, 30 MHz, QSPI Pmod).

Base: TinyRV32 (tt-riscv), core vendored in `core/`. The QSPI memory
subsystem (fetch FSM, 2:1 arbiter, serial-boot + quad opt-in) carries
over; it becomes a 3-port arbiter (ifetch / data / video DMA).

## Architecture deltas vs TinyRV32

1. **Back to 32 registers.** Mainline Linux has no usable RV32E port;
   RV32IMA is the floor. Routing evidence from tt-riscv hardening:
   32-reg regfile failed 4x2 @ 75% (390k violations) but routed at
   6x2 @ 55%. Target **8x2 tiles @ ~55%** — the largest size the
   template offers (16 tiles; the square 4x4/5x4 "colossal" formats
   were a TT08 experiment and would need arranging with TT). If the
   wide aspect ratio hurts routing, that conversation is the fallback.
2. **M extension**: iterative multiplier/divider (32 cycles, tiny).
   CPI is memory-dominated anyway; do not spend area on a fast one.
3. **A extension**: LR/SC as a reservation flag in the memory
   controller; AMOs as a locked read-modify-write sequence holding the
   bus. No other master exists besides video DMA, which never touches
   AMO targets mid-sequence (video reads are read-only bursts).
   *Sequenced with milestone 5's bus unification* — AMOs are RMW
   sequences in the memory controller, and building them against the
   vendored core's FPGA dmem model would be throwaway work.
4. **Privilege + CSR**: M/S/U modes, trap/mret/sret, wfi-as-nop,
   mstatus/mie/mip/mtvec/mepc/mcause/mscratch + S-mode twins, medeleg/
   mideleg, satp. One `csr.sv` module owned by the writeback stage.
5. **sv32 MMU**: hardware page-table walker sharing the data port;
   split I/D TLBs, 2–4 entries each, flop-based. sfence.vma flushes
   both. TLB miss = walker microsequence (2 loads). Keep it dumb.
6. **CLINT** (`src/clint.sv`, done): mtime/mtimecmp/msip, compact map.
7. **PLIC-lite**: 4 sources (UART rx, PS/2 rx, vsync, spare), fixed
   priority, claim/complete registers. Linux `plic` driver compatible
   enough, or a tiny custom driver — decide at software bring-up.
8. **VGA text mode** (`src/vga_timing.sv` done, `vga_text.sv` next):
   - 640x480@60. Core clock 50 MHz, pixel enable at /2 (25 MHz —
     monitors accept 25.0 vs 25.175).
   - 80x30 chars, 8x16 font. Charbuf lives in **PSRAM**; on-die is only
     a double line buffer (2x80 bytes) + font ROM (96 glyphs x 16 B =
     1536 B, synthesized as logic — budget ~3-5k cells, measure early;
     fallback 8x8 font / 64 glyphs halves it).
   - Prefetch: one 80-byte charbuf burst per 16 scanlines, issued at
     hblank with absolute priority in the arbiter. Bandwidth is trivial
     (~240 kB/s); the design problem is *latency bounding* — the burst
     must fit in hblank + inactive rows, verify worst case in sim.
9. **Pinout** (verify against Tiny VGA Pmod docs before freeze):
   - `uio[7:0]`: QSPI Pmod, identical to tt-riscv. All 8 taken.
   - `uo[7:0]`: Tiny VGA Pmod (RRGGBB + HS + VS). All 8 taken.
   - `ui`: ps2_clk, ps2_dat, uart_rx, boot straps (uart-mux, quad-dis).
   - **UART TX has no free pin** → mux onto the blue LSB `uo` pin,
     selected by reset strap on `ui` + MMIO override. Early bring-up
     runs headless with UART; once fbcon works, blue LSB returns.
     5-bit-blue cost is invisible in text mode.

## Memory map (draft)

| Range | What |
|---|---|
| 0x0000_0000+ | flash XIP: bootloader + kernel image staging |
| 0x0001_0000 | MMIO: UART, GPIO-lite, QSPI_CFG (as tt-riscv) |
| 0x0002_0000 | CLINT |
| 0x0003_0000 | PLIC-lite |
| 0x0004_0000 | VGA ctrl (charbuf base ptr, cursor, enable) |
| 0x0100_0000+ | PSRAM 8 MiB: kernel, rootfs (initramfs), charbuf |

M-mode firmware: **write our own minimal SBI** (console putchar via
UART/VGA, timer via CLINT, ~2-4 KB) — OpenSBI is too big for XIP+8 MiB
comfort. KianV's firmware is the reference.

## Software ladder

1. riscv-tests rv32ui/um/ua + privilege tests, pin-level (extend
   tt-riscv harness).
2. xv6-riscv (rv32 port) — sv32 smoke test, far faster to debug than
   Linux.
3. Buildroot nommu uLinux — rung 1, de-risks everything but the MMU.
4. Mainline Linux sv32 + custom dts + fbcon on the text console.
5. Yocto layer (meta-koti) once the kernel is stable — feeds the
   bigger own-PC project.

## Verification / bring-up

- Verilator full-boot sim (RTL) — Linux to shell before FPGA.
- ULX3S 85F: same RTL + real QSPI Pmod + real monitor.
- Gate-level of the arbiter/video corner: video underrun under worst
  case ifetch+data+walker contention.
- cocotb pin-level suite as in tt-riscv; TT precheck; then submit.

## Milestones

1. [~] Core surgery (2026-07-18):
       - 32 regs: free — the vendored core/ is the RV32I FPGA pipeline
         (the RV32E cut lived in tt-riscv's ASIC-side copies).
       - M: `core/muldiv.sv` (iterative, 32-cycle, shared datapath) +
         decode (`funct7[0]` on OP) + whole-pipe md_stall in cpu_pipe;
         result rides EX/MEM and forwards normally. Unit-tested: 1252
         vectors (edge cross-product + seeded random) green vs a
         Python golden model, `test/run_core.py`.
       - Found+fixed latent hazard: SDRAM ack landing while the pipe
         is frozen by md_stall would re-issue the transaction; added
         sd_seen/sd_data_r capture in M.
       - Instruction-level harness landed (same day): sim imem/dmem/
         audio_gen models + tb_cpu + a tiny Python assembler
         (`test/run_cpu.py`). 4 directed programs green on the real
         pipeline: 32-reg exercise, M ops incl. div-zero/overflow,
         M-result forwarding chains, load-use into muldiv, taken
         branch killing a speculative mul. CI runs both core suites
         (core-tests.yaml). This harness is the vehicle for the
         official riscv-tests later.
       - Open: A extension (milestone 5, see above).
2. [x] Peripheral trio: `vga_timing.sv`, `ps2_rx.sv`, `clint.sv`
       (2026-07-18).
3. [~] cocotb suite (2026-07-18): bring-up top `tt_um_koti` (VGA
       checkerboard + PS/2-selected colors) passes 3 pin-level tests —
       reset pattern, hsync width/period, PS/2 frames incl. bad-parity
       reject. Open: clint bench (not yet wired into top), vsync
       count, VGA frame dumped to PPM.
4. [ ] `vga_text.sv`: line buffer + font ROM + charbuf DMA; measure
       font ROM area in a trial harden immediately.
5. [ ] 3-port arbiter + video priority; worst-case latency proof.
6. [ ] csr.sv M-mode only; traps + CLINT irqs; riscv privilege tests.
7. [ ] nommu uLinux boots in Verilator, console on UART (rung 1
       secured — this alone is submittable).
8. [ ] S/U modes + sv32 TLBs + walker; xv6 boots.
9. [ ] Mainline Linux sv32 boots to shell on fbcon, Verilator + ULX3S.
10. [ ] Harden at 8x2 @ ~55%; iterate. Submit to the next shuttle
        after TTSKY26c (this is NOT a TTSKY26c project — no rushing a
        privilege-mode CPU past signoff in seven weeks).

## Risks (ranked)

1. Font ROM + line buffer + TLB flop area blows the 8x2 budget →
   measure in trial hardens from milestone 4 on; fallbacks: 8x8 font,
   2-entry TLBs, negotiating a colossal tile with TT.
2. sv32 walker/TLB bugs are the classic Linux-boot graveyard → xv6
   first, and the privilege test suite before any kernel.
3. Video underrun under contention → bounded-latency arbiter proof in
   sim before hardening.
4. 50 MHz timing on Sky130 through the MMU-extended load path → the
   TLB lookup must not sit in series with the whole ALU; pipeline it.
5. One-chip-per-tapeout: everything must work first silicon → the
   Verilator-boots-Linux gate is non-negotiable before submission.
