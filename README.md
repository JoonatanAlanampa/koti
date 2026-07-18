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

Status 2026-07-18: the SoC is real — `tt_um_koti` = RV32IMA + Zicsr +
M-mode traps core, QSPI XIP memory (serial boot, quad opt-in), CLINT
timer. Boots pin-level from a behavioral flash model, takes a timer
interrupt, halts on EBREAK. Suites: `test/run.py` (SoC pin-level),
`test/run_cpu.py` (9 instruction-level tests over XIP),
`test/run_core.py` (1252 muldiv vectors). Next: S-mode + sv32 MMU,
VGA text console.
