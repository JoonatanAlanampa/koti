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

Status 2026-07-18: scaffolded from ttsky-verilog-template; bring-up
top (`tt_um_koti`: VGA checkerboard, PS/2 picks the colors) passes its
3-test cocotb suite (`cd test && python run.py`, or `make`).
