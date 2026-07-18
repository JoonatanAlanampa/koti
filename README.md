# Koti-1 — a home computer on a Tiny Tapeout tile

*Koti* (Finnish: "home", from *kotitietokone* — home computer.)

One chip that boots **full sv32 MMU Linux visibly**: monitor on the
Tiny VGA Pmod, keyboard on PS/2, memory on the QSPI Pmod, console on
screen. RV32IMA + M/S/U privilege modes + sv32 MMU, built on the proven
TinyRV32 core (tt-riscv) and its XIP memory subsystem.

Nobody has put full-MMU Linux — or Linux with a video console — on a
Tiny Tapeout shuttle tile yet. Both ingredients exist separately
(KianV's nommu uLinux SoC on TT06; VGA on dozens of TT projects); this
project combines and extends them. Target: the shuttle *after*
TTSKY26c, 8x2 tiles.

- [PLAN.md](PLAN.md) — architecture, milestones, risks
- `core/` — TinyRV32 core vendored from tt-riscv (to be extended:
  32 regs, M, A, CSR/priv, sv32)
- `src/` — new SoC blocks (vga_timing, ps2_rx, clint so far)
- `docs/info.md` — datasheet skeleton

Status: **hardware-complete for the goal.** RV32IMA + Zicsr, M/S/U
with delegation, sv32 MMU (split TLBs + dual walkers, precise faults
with tval), CLINT, illegal/misaligned traps, mcycle/minstret, QSPI
XIP (serial boot, quad opt-in), 40x30 VGA text console, PS/2
keyboard, and an M-mode SBI firmware (`sw/sbi/`) proven pin-level:
S-mode payload, SBI console, rdtime-via-trap emulation, delegated
timer interrupts. GCC C runs (`sw/hello.c`). Suites (all green in
CI): `test/run_core.py` (1252 muldiv vectors), `test/run_cpu.py`
(15 directed), `test/run_riscv.py` (all 58 official rv32ui/um/ua),
`test/run.py` (4 pin-level incl. C hello + SBI boot).

Open: the 8x2 harden needs the TT RF macro (PLAN.md campaign log),
kernel bring-up needs a Linux build env, and `fpga/ulx3s/` holds the
untested pre-tapeout FPGA scaffold. Datasheet: [docs/info.md](docs/info.md).
