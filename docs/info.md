## How it works

Koti-1 (fi. *koti*, "home" — from *kotitietokone*, home computer) is a
single-chip computer: an **RV32IMA + Zicsr** RISC-V CPU with **M/S/U
privilege modes** and an **sv32 MMU**, executing in place from an
external QSPI Pmod (W25Q128 flash + APS6404 PSRAM), with a **40x30
VGA text console**. It ships with an M-mode
SBI firmware (`sw/sbi/`) providing the console, timer, and rdtime
emulation that supervisor-mode kernels expect.

### CPU

5-stage pipeline (F/D/E/M/W) with full forwarding, load-use
interlock, and predict-not-taken branches. Non-blocking pair fetch
with a skid buffer; the whole pipe freezes on data-port waits.
Iterative 32-cycle multiply/divide. AMOs execute as a 2-phase
read-modify-write in M; LR/SC via a reservation that dies on any
store, SC, RMW, or trap. The register file is sync-read (its output
register is the operand pipeline register), matching the planned
32x32 RF macro.

Precise exceptions, all taken at EX: ECALL (8/9/11), illegal
instruction (2, mtval = instruction), misaligned load/store/AMO
(4/6, mtval = address), misaligned fetch target (0), and sv32 page
faults (12/13/15, xtval = VA). Interrupts: M/S timer, software,
external, with mideleg/medeleg delegation. **EBREAK halts the core**
(raises the HALTED pin) instead of trapping — the chip's debug-stop.

### MMU

sv32, 2-entry fully-associative I and D TLBs with fault-caching
entries; two hardware page walkers (I-side rides the fetch port,
D-side borrows the data port at EX). SUM and MXR implemented; A=0 or
D=0-on-store PTEs fault (kernels pre-set these bits). sfence.vma
flushes both TLBs and serializes; satp writes flush as well.

### Memory map

| Range | What |
|---|---|
| 0x0000_0000+ | flash XIP: code + rodata (boots serial 03h; quad opt-in) |
| 0x0001_0000 | core MMIO: +0 LED (w), +4 UART tx/busy, +8 GPIO in, +C QSPI_CFG |
| 0x0002_0000 | CLINT: +0 MSIP, +8/+C MTIMECMP, +10/+14 MTIME |
| 0x0004_0000 | VGA: +0 CTRL, +4 charbuf base, +8 colors (+C reads 0) |
| 0x0100_0000+ | PSRAM 8 MiB: data, stack, page tables, charbuf |

VGA registers: CTRL bit0 = VGA_EN (switches the uo pins from the
headless personality to the Tiny VGA Pmod), bit1 = UART on the blue
LSB (uo[6]). Colors: {bg[13:8], fg[5:0]}. +C was the PS/2 scancode
word until PS/2 was removed on 2026-08-08; it now reads zero, which
to any surviving driver means "no key waiting". A pending byte
drives the external interrupt (meip). There is no FIFO: ovf means a
byte arrived on top of an unread one and was lost, so a driver
holding E0/F0 prefix state must discard it and resynchronise.

### Video

640x480@60 from the 25 MHz system clock. 40x30 characters in 16x16
cells (8x8 font, pixels doubled both ways; lowercase folds to
uppercase — 64 glyphs, C64 style). The character buffer lives in
PSRAM; the controller prefetches one text row ahead into ping-pong
line buffers through a 3-port memory arbiter (video > data > fetch).

## How to test

Attach the QSPI Pmod (uio), program `sw/sbi/sbi_test.bin` (or
`sw/hello.bin`) into flash, select 25 MHz, release reset. The chip
boots headless: UART on uo[0] at 115200 8N1, HALTED on uo[1], LEDs
on uo[7:2]. Software that enables VGA_EN switches uo to the Tiny VGA
Pmod (attach it and a monitor); the SBI firmware mirrors its console
to both UART (moved to uo[6]) and the screen. There is no keyboard
on this tile: PS/2 was removed on 2026-08-08 and its replacement, a
USB HID host, needs the FPGA-only pins on US2. ui[7:0] are all plain
GPIO.

The repo carries four simulation suites (muldiv unit vectors,
15 directed instruction tests, all 58 official rv32ui/um/ua
riscv-tests, and pin-level SoC tests including a GCC-compiled C
hello and the full SBI boot) — `test/run*.py`.

## External hardware

- **TinyTapeout QSPI Pmod** (W25Q128 flash + 2x APS6404 PSRAM) — required
- **Tiny VGA Pmod** + monitor for the console
- USB-serial adapter (uo[0] headless, uo[6] in VGA mode) for the UART
