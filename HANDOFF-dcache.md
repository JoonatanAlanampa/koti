# Handoff prompt — finish the D-cache

Copy everything below the line into a fresh session.

---

Work `tt-koti` until the D-cache is working and enabled. Read
`session-board.md` in the auto-memory directory first and claim `tt-koti`
before editing. You do NOT need the physical ULX3S; this is all simulation.

**Goal:** `src/dcache.sv` is written, tested and gated OFF. Get it correct,
enable it, and keep everything that works today working.

## Start here, in this order

1. **`src/dcache.sv`'s header.** It records the design, what has been ruled in
   and out, and a one-minute reproduction. Do not re-derive any of it.
2. `git log --oneline -8` — the last four commits are this investigation.
3. State: `main` = `2bd7183`. `KOTI_DCACHE` is defined **nowhere**, so every
   build takes the bypass in `src/project.sv`.

## The one-minute reproduction (no CI, no board)

```
gh run download <a green `linux` run> -n koti-linux-Image -D kimg
python3 test/mkhex.py sw/sbi/sbi_sd.bin fw.hex
python3 test/mkhex.py kimg/arch/riscv/boot/Image kernel.hex
# in WSL — CI's iverilog is 12, oss-cad-suite's 14-devel rejects vendor/sd_spi.sv
iverilog -g2012 -I src -DKOTI_FPGA -DKOTI_SIMMEM -DKOTI_DCACHE \
  -o b.vvp src/*.sv src/usb_hid_host_rom.v vendor/*.sv vendor/*.v \
  test/sim_prims.v test/sim_mem.sv test/tb_boot.v
vvp b.vvp +flash=fw.hex +ram=kernel.hex +ramoff=1048576 +maxclk=4000000
```
Without `-DKOTI_DCACHE` the banner appears inside 3M clocks. With it: 0
characters. That asymmetry is the whole bug, and it costs about a minute a
turn — use it constantly rather than pushing to CI.

## Already ruled out — do not re-walk these

- **The cache in isolation.** `test/tb_dcache.v` passes,
  and three mutations are caught: never setting `valid`, not writing through,
  and caching page-table reads.
- **The SoC without an MMU.** `tb_fpga_bram` PASSES with the cache enabled, at
  135215 clocks — *faster* than the 135401 without it.
- **The firmware.** `tb_boot` with `+flash` and no kernel prints `STK`
  identically with and without the cache.
- **Timing.** 30.88 MHz post-route with the cache in, PASS at 25 (up from 29.98).
- **"It is just slow."** Still 0 characters at 25,000,000 clocks.
- **The data-ack routing defect** — found and FIXED in `koti_core.sv`
  (`d_inflight`/`d_owner_dw`). It was real and it was necessary. **It was not
  sufficient.** ⚠️ Do not assume the remaining defect has the same shape; that
  assumption already cost one round.

⇒ The failure needs a **kernel**, i.e. it only appears once the MMU is on.

## First move

Trace with the fix in place and see whether the signature MOVED. Before the
core fix it was a trap storm: 100% of samples in `handle_exception` across 66
distinct addresses, 61% with a data request up and no ack. If it is different
now, that is information.

```
vvp b.vvp +flash=fw.hex +ram=kernel.hex +ramoff=1048576 \
  +maxclk=8000000 +quiet=8000000 +tfrom=7900000 +tlen=3000 > late.log
python tools/ktrace.py kimg/System.map late.log --image kimg/arch/riscv/boot/Image
```
`tools/ktrace.py --image` disassembles every line and prints the loop body on a
spin; `tools/rvdis.py` disassembles the Image directly. Both were written for
exactly this and are the reason the last diagnosis took minutes.

## Done means

1. `tb_boot` with `-DKOTI_DCACHE` reaches `koti: userspace is alive` (or at
   minimum boots as far as the uncached build does).
2. `tb_fpga_bram` still passes; note its clock count either way.
3. `KOTI_DCACHE` is actually defined in the FPGA builds — a cache nobody
   compiles is not done.
4. `python test/check_sources.py` passes and CI is green, `fpga-ulx3s`
   included (watch the SECOND "Max frequency" line, the first is
   post-placement).

## Do not break

koti boots Linux to a login prompt on real hardware today, without this cache.
If the cache cannot be made correct, leaving it gated off is a perfectly good
outcome — say so rather than shipping a machine that boots 99% of the time.

## Traps that have already bitten, today

- `test/mkhex.py`, **not** `fpga/ulx3s/mkflashhex.py`. The latter emits one
  BYTE per line for the fabric flash; `sim_mem`'s array is WORDS. It loads
  garbage and produces 0 characters — indistinguishable from the bug.
- **Four source lists**: `fpga/ulx3s/sources.txt`, `test/run_fpga.py`,
  `test/run.py`, `test/Makefile`. `test/check_sources.py` now guards them; run
  it after adding or removing any `src/*.sv`.
- A `grep --include=*.ext` sweep cannot see `test/Makefile` (no extension).
- In a testbench, sample `c_ack` at a **negedge**. `while (!c_ack) @(posedge
  clk)` reads the value from before the edge and can see the PREVIOUS
  transaction's one-cycle ack. That made a correct write look like a write that
  never reached memory.
- WSL clears `/tmp` between tool calls; build `.vvp` files somewhere persistent.
- cocotb is NOT installed on this host — `test/test.py` can only be verified by
  pushing. Plain-Verilog benches all run locally.
