# Koti-1 — plan

## TODO (state as of 2026-07-19: hardware-complete, 6 suites green)

User actions — everything below is blocked on one of these:
1. [x] **RF macro — DONE 2026-07-23, no generation needed.** The DFFRAM flow is a
       Nix job (macOS/Linux + Nix per its Usage.md), and WSL is NOT usable on the
       dev host (virtualization disabled in firmware; no distro; no docker) — but
       generation turned out to be UNNECESSARY: AUCOHL/DFFRAM's 2025.11.10 release
       ships a `merged-artifacts.tgz` with the PREBUILT, signoff-clean DFFRF_2R1W
       (design of `dffram.py -s 32x32 -b ::rf -v 2R1W`): .gds/.lef/.nl.v/.pnl.v +
       9-corner .lib + 3 .spef. Vendored verbatim to macros/ (Apache-2.0, see
       macros/README.txt). Interface CLK/WE/RA/RB/RW[4:0]/DW[31:0]->DA/DB[31:0],
       power VPWR/VGND; COMBINATIONAL read, SYNC write, R0_ZERO (x0 reads 0).
2. [ ] **Submit TinyRV32 + ServoCtl-8 to TTSKY26c** — hard deadline
       ~2026-09-07. Both repos are ready; form-filling only.
3. [ ] **Order the ULX3S 85F** (~$155 Crowd Supply, ~1 month lead).
4. [ ] **Install WSL** (`wsl --install`, admin + reboot) — unblocks
       the kernel ladder.

Then, in order (mostly Claude-executable once unblocked):
5. [~] Integrate the RF macro — RTL + config DONE 2026-07-23 (commits 0c29e07,
       cdb4af0; NOT pushed). regfile.sv has a USE_MACRO branch that instantiates
       DFFRF_2R1W and REGISTERS ITS OUTPUT to recover the registered read-first
       timing (the macro is comb-read; output-register = exact, input-address-reg
       would be write-first). Read-timing question CLOSED. Proven cycle-identical
       to the behavioural regfile: run_cpu_macro 15/15 + run_riscv_macro 58/58.
       src/config.json wires MACROS(gds/lef/nl/9lib/3spef) + VERILOG_DEFINES=
       USE_MACRO + EXTRA_VERILOG_MODELS + PDN align (VPITCH 153.6/VOFFSET 106.32).
       All on branch `rf-macro-harden` (main = behavioural, untouched).
       HARDEN STATUS 2026-07-23: BANKED (user: "harden later"). CI got through
       synthesis + floorplan + MACRO PLACEMENT (core.rf.u_rf @ [90,24], 78.2%
       util) then BLOCKED at PDN generation:
         [PDN-0232] grid "macro - core.rf.u_rf" does not contain any shapes/vias
         [PDN-0233] Failed to generate full power grid
       ROOT CAUSE: the macro's VPWR/VGND pins are on **met4**; standard pdngen
       wires a macro's top-layer straps FROM THE LAYER ABOVE (met5), but TT
       forbids met5 (RT_MAX_LAYER=met4) -> auto macro-grid yields nothing. The
       tt05/tt06 dffram examples fix this with a CUSTOM build.py + odb_power.py
       (draw met4 stripes over the pins) + pdn_cfg.tcl -- but that is the
       @openlane2 mechanism; the @ttsky26c action runs `tt_tool.py --harden`
       (fixed LibreLane Classic flow), NOT a repo build.py, so it does NOT port.
       RESUME OPTIONS (pick when revisiting):
         (a) custom FP_PDN_CFG tcl: stdcell grid + a macro grid that straps met4
             OVER the macro and connects met4->met4 (no met5). Standard flow reads
             FP_PDN_CFG; iterate in CI (~5 min/round, fails fast at PDN). Uncertain
             whether met4-met4 connects without an odb step.
         (b) TT Discord: ask the supported ttsky26c way to power a met4 user-macro
             (met5 forbidden, no build.py hook). Then configure per their answer.
         (c) DFFRAM has a LATCH-based variant too; check whether either variant
             ships met3-or-lower power pins (would let a met4 stripe connect from
             above) -- would sidestep the whole issue if so.
       Macro geometry for a custom pdn/odb: VPWR met4 straps at macro-x +
       {18.28,171.88,325.48}um, VGND at +{21.58,175.18,328.78}um, y-span
       +{2.48..174.32}um, 153.6um pitch (from macros/DFFRF_2R1W.lef).
6. [ ] xv6 rv32 port on the SBI firmware (first sv32 workload).
7. [ ] Buildroot nommu uLinux, console on UART (frontier rung 1 —
       submittable on its own).
8. [ ] Mainline sv32 Linux, console on the VGA text mode (rung 2 —
       the frontier claim). Yocto layer after.
9. [ ] ULX3S bring-up: verify LPF pins, build, **font glyph visual
       check** on a real monitor.
10.[ ] Submit Koti-1 to the shuttle after TTSKY26c.

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
3. **A extension** — DONE 2026-07-18, in the core, not the controller
   (revising the earlier sequencing note): AMOs are a 2-phase M-stage
   RMW microsequence (astall) that rides whatever memory M talks to,
   so the same logic works over BRAM now and QSPI after unification —
   nothing throwaway. LR = load + reservation; SC = conditional store
   + success flag, no FSM. Uniprocessor reservation rules: dies on any
   store/SC/RMW/trap. 2 tests: all 9 AMO ops with hazard checks; the
   LR/SC protocol incl. intervening-store kill. Bonus fix while adding
   commit gating: EX commands (trap/mret/csr-write) held across a
   multi-cycle stall used to re-fire and clobber the MPIE/MIE stack —
   all now gated on the actual commit cycle (!pstall).
4. **Privilege + CSR**: M/S/U modes, trap/mret/sret, wfi-as-nop,
   mstatus/mie/mip/mtvec/mepc/mcause/mscratch + S-mode twins, medeleg/
   mideleg, satp. One `csr.sv` module — M-mode half DONE 2026-07-18:
   CSR ops execute in EX and forward like ALU results; precise
   EX-taken traps (older stages always commit, the wrong-path fetch
   dies like a mispredict); ECALL traps (it is the SBI path), **EBREAK
   now halts** (role moved from tt-riscv's ECALL); MRET; WFI=NOP;
   mtip/msip/meip ports (never injected onto an in-flight muldiv).
   Compliance gaps CLOSED 2026-07-18: **illegal-instruction traps**
   (cause 2, mtval = instruction bits) for unknown major opcodes,
   bad funct3/funct7 combos, bad SYSTEM encodings, unknown CSRs,
   CSR privilege + read-only-write violations, and mret/sret/sfence
   below their privilege — illegal instructions are excluded from
   memory ops, muldiv, CSR writes and branch redirects.
   **Misaligned traps**: load (4) / store-AMO (6) with mtval =
   address (page faults outrank misalign per the spec priority
   table), and misaligned fetch targets (cause 0) on taken jumps
   with mtval = target. Verified by a 7-trap cause/mtval sequence
   test and a U-mode CSR-privilege test (incl. SRET-in-U); 15/15
   directed + 58/58 official + pin-level green. Remaining known
   gaps: mcycle/minstret, MPRV, EBREAK halts instead of raising
   breakpoint (deliberate), coarse funct7 legality corners.
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

1. riscv-tests rv32ui/um/ua — DONE 2026-07-18: **all 58 official
   tests pass** on koti_core over the XIP model (fence_i and ma_data
   skipped as on tt-riscv: XIP ROM / no misalign support). Koti env
   uses EBREAK for pass/fail (ECALL traps here). Prebuilt bins
   committed (44 KB) so CI runs the suite without the toolchain;
   rebuild with test/build_riscv_tests.py (needs CPU repo + xpack
   gcc). Privilege (rv32mi subset) deferred until illegal-instr +
   misalign traps exist (milestone 8).
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
       - A extension DONE in-core (see delta 3). Core ISA is now
         RV32IMA + Zicsr + M-mode traps — KianV-class. 9/9
         instruction-level tests green.
2. [x] Peripheral trio: `vga_timing.sv`, `ps2_rx.sv`, `clint.sv`
       (2026-07-18).
3. [~] cocotb suite (2026-07-18): bring-up top `tt_um_koti` (VGA
       checkerboard + PS/2-selected colors) passes 3 pin-level tests —
       reset pattern, hsync width/period, PS/2 frames incl. bad-parity
       reject. Open: clint bench (not yet wired into top), vsync
       count, VGA frame dumped to PPM.
4. [x] `vga_text.sv` DONE (2026-07-18): 80x30 text, 8x8 font in 8x16
       cells (line-doubled) — font ROM only 768 B (tools/genfont.py
       generates src/font_rom.svh from the public-domain font8x8 set;
       **glyph art needs visual verification on FPGA before tapeout**).
       Ping-pong 80-byte line buffers; row r+1 fetched during row r
       (10 pair-reads, ~3.3 scanlines worst-case serial vs 16
       available); row 0 prefetched at vblank line 508, swap at row
       ends + line 524. `arbiter3.sv`: video > data > fetch, grant
       held to ack (worst video wait = one serial burst, ~132 clk).
       SoC: VGA/PS2 MMIO block at 0x0004_0000 (ctrl/base/colors/
       keyboard, read-clears avail — captured pre-clear after a
       classic read-race bug), ps2_rx wired to ui[1:0], kb_avail →
       meip. uo personality is software-switched: headless at reset
       (UART/HALTED/LED — all older tests still pass), Tiny VGA once
       VGA_EN set, UART mux onto blue LSB via ctrl bit 1. Pin-level
       test renders 'K' row 0 pixel-exact on uo after a PS/2 MMIO
       round-trip. Bug found: hblank_start was visible-lines-only,
       silently killing the vblank prefetch + frame swap.
       **First 8x2 harden attempt FAILED as predicted by risk #1**
       (run 29655252221): 247.9k um^2 of logic on a 302.4k um^2 core
       = 94.5% utilization, detailed placement (DPL-0036) gave up.
       Fallback levers pulled (2026-07-18): TLBs 4->2 entries each;
       **40x30 text** (16x16 cells, pixels doubled both ways — halves
       the line buffers to 2x40 B and the row DMA to 5 bursts);
       **64-glyph font** (lowercase folds to uppercase in vga_text,
       C64 style — ROM now 512 B). All suites re-green.
       **Harden campaign log (2026-07-18, 5 attempts)**:
       1. 50 MHz, full design: 94.5% util, DPL-0036 at placement.
       2. After cuts: 69.7% util, PLACES; dies in setup repair — the
          template's CLOCK_PERIOD was 20 ns (50 MHz), never our
          target. 1338 violating endpoints.
       3. CLOCK_PERIOD=40 (25 MHz real): CI network timeout (noise).
       4. Re-run: setup violations 1338 -> 223, but pre-CTS
          fanout/slew repair inserts ~2900 buffers -> placement
          80.8% -> post-CTS legalization fails (DPL-0036).
       5. + registered VGA pixel pipe: no change (251 endpoints,
          81.4%) — the dominant fanout/timing is in the CPU (pstall
          network, TLB-after-ALU), not the video path.
       **Conclusion**: flop-everything RV32IMA+MMU+VGA saturates 8x2
       at ~70% pre-repair; the flow needs ~10-15% more headroom than
       exists. The design is CLOSE — it places and mostly times at
       the real clock; only repair margin is missing.
       **RF-macro research (2026-07-18)**: TT has an experimental
       **32x32 register file macro by Sylvain Munaut** — *exactly*
       our regfile: 2 read ports + 1 write port, 32x32, ~88% of ONE
       tile (vs our multi-tile flop version), no DRC waivers,
       validated on ttsky25b (tt_um_tnt_rf_validation; repo cloned
       to ../rf-val for reference — public sources are a stub, the
       macro GDS/LEF/lib/model are NOT publicly packaged).
       **Pipeline made macro-ready (2026-07-18)**: decided not to
       wait on the read-timing question — architected for sync-read
       (registered address, read-first), the superset-compatible
       assumption (a comb macro + input address register reproduces
       it exactly). src/regfile.sv is now the sync-read behavioral
       model; the pipeline's r1_e/r2_e operand registers are GONE
       (the RF read output is the pipeline register), the WB->ID
       bypass became latched hit flags + value (byp*_e/bypv_e), and
       a freeze-time address mux re-selects the EX instruction's
       registers so operands stay coherent through stalls. All
       suites green first run. The macro is now a body-swap in
       regfile.sv + LibreLane config.
       **CORRECTED 2026-07-22 (verified, NOT a human ask):** AUCOHL/DFFRAM
       generates the sky130 32x32 2R1W register file directly (netlist+LEF+GDS+
       lib) — its docs list "Register File: 32x32 (2R1W)". The old fallback line
       was WRONG: DFFRAM is not 1RW-only. Path: run dffram.py under OpenLane/nix
       (CI, or WSL once installed) -> commit the macro -> body-swap regfile.sv
       (guard a USE_MACRO branch, keep the behavioral model for sim) + LibreLane
       EXTRA_LEFS/GDS/LIB + macro placement -> re-harden 8x2. CONFIRM the DFFRAM
       RF read timing (comb vs registered) vs regfile.sv's sync-read/read-first
       model; add an input address register if the macro reads combinationally.
       Deeper fallbacks (fanout pruning, colossal tile) unchanged, now unlikely
       needed.
5. [~] Bus unification (2026-07-18): `src/koti_core.sv` is now THE
       core — rv32_core.sv's fetch FSM/data port/MMIO merged with the
       RV32IMA+Zicsr pipeline; `src/qspi_ctrl.sv` (+2:1 arbiter)
       vendored from tt-riscv. core/cpu_pipe.sv and cpu.sv remain as
       frozen references. All 9 instruction-level tests re-run against
       koti_core over the XIP model (LAT=4) — green first run; data
       moved to the PSRAM map (0x0100_0000+). CLINT/PLIC/VGA MMIO
       (0x0002_0000+) rides the data port for the SoC top to decode.
       SoC top DONE (same day): `src/project.sv` is the real
       `tt_um_koti` — koti_core + arbiter + qspi_ctrl + CLINT
       (intercepted on the data port at 0x0002_0000, 1-cycle ack,
       mtip/msip wired to the core). Headless v1 pinout = tt-riscv's
       proven demo layout (uio QSPI Pmod, uo UART/HALTED/LED, ui
       GPIO). Shared modules copied core/ -> src/ (TT wants sources in
       src/; src/ is canonical now). Pin-level test: boots from the
       SpiMem flash model over real SPI protocol, PSRAM serial+quad
       traffic, CLINT timer irq into a handler, EBREAK halt — 1/1,
       first run. VGA/PS2 bring-up stub retired; vga_timing/ps2_rx
       coverage returns with the video milestone. info.yaml now 8x2 —
       the GDS action attempt gives the first honest area datapoint.
       Open: 3-port arbiter + video priority with worst-case latency
       proof (video milestone).
6. [~] csr.sv M-mode DONE with 3 instruction-level tests green (CSR
       RMW forms + forwarding, ECALL->handler->MRET resume, async mtip
       interrupting a spin loop — 7/7 in test/run_cpu.py). Open: wire
       CLINT's mtip/msip to the core in the SoC top; official riscv
       privilege tests once the XIP harness exists.
7. [~] Software track started (2026-07-18): `sw/` — crt0 (flash XIP,
       .data copy to PSRAM, bss zero, EBREAK on return), link.ld,
       koti.h MMIO map, console.c (80x30 VGA console: cursor/newline/
       scroll — the future SBI console), build.py (xpack gcc,
       rv32ima_zicsr). hello.c (601 B) proven pin-level: UART banner
       decoded bit-by-bit at uo[0], then the VGA console brings the
       pins up and "KOTI-1 / hello, visible world" lands in the
       charbuf. hello.bin committed so CI runs it.
       **SBI firmware DONE (2026-07-19, sw/sbi/)**: boot + delegation
       (mideleg 0x222, medeleg 0xB151 — illegal stays in M for rdtime
       emulation, ecall-from-S is the SBI), full-frame trap shim with
       mscratch stack swap, legacy SBI set_timer/putchar/getchar,
       M-timer -> STIP injection, and **rdtime/rdtimeh emulated via
       the illegal-instruction trap** (mtval decodes the CSR read).
       Console mirrors to UART (on the blue LSB, uo[6]) + the VGA
       charbuf. Proven pin-level: the S-mode payload prints 'S', arms
       the timer via rdtime, takes the delegated S-timer irq ('T'),
       finishes ('K') — decoded off uo[6], mirrored in the charbuf.
       mcycle/minstret CSRs added (retire counted at W advance).
       Datasheet (docs/info.md) written for real. This is the exact
       runtime contract xv6/Linux sit on. Next: xv6 (kernel rungs
       need a Linux build env).
8. [~] S/U privilege plumbing DONE (2026-07-18): `src/csr.sv` rewrote
       with M/S/U modes, full mstatus (MPP/SPP/xPIE/xIE stack),
       S-mode CSR set (sstatus/sie/sip/stvec/sepc/scause/stval/
       sscratch/satp), medeleg/mideleg, sret, S-irq injection via
       M-writes to mip (STIP/SSIP/SEIP), spec-correct interrupt
       take/delegation rules. satp is a plain register until the
       walker lands. core/csr.sv stays the frozen M-only ancestor.
       3 new tests: delegated ecall-from-S handled in S + sret;
       ecall-from-U to M with MPP=U; and the Linux timer flow — M
       takes MTI, masks, injects STIP, delegated S-timer trap lands
       at stvec.
       **sv32 MMU DONE (same day)**: `src/tlb.sv` (4-entry fully-assoc
       I and D TLBs, FAULT-caching entries, uniform 4K fills — mega-
       pages fill as the resolved 4K entry); i-walker embedded in the
       fetch FSM (PTE reads ride the fetch port; walks complete even
       across redirects — fills are path-independent); d-walker at EX
       borrowing the data port while M is quiet, so ALL traps stay at
       the one precise EX commit point and stval gets the faulting VA
       (Linux do_page_fault needs it). SUM + MXR in mstatus; A=0 or
       D=0-on-store fault (spec-allowed, kernels cope); page-crossing
       pair fetches drop the skid word; sfence.vma flushes both TLBs
       and serializes the pipe; satp writes flush too. Fetch faults
       poison one NOP that traps at EX (cause 12); load/store faults
       are causes 13/15 with tval. End-to-end test: M builds real
       tables, S runs translated, RW 4K page round-trips to its PA,
       RO store + unmapped load + unmapped fetch fault in order with
       correct mtval, RO page physically untouched. 13/13 directed +
       58/58 official + pin-level green. Open: xv6 boot (software),
       MPRV gap logged.
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
