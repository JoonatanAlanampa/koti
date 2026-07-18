## How it works

Koti-1 is a single-chip home computer: an RV32IMA RISC-V CPU with
M/S/U privilege modes and an sv32 MMU, booting mainline Linux from
QSPI flash/PSRAM with the console rendered as 80x30 VGA text and a
PS/2 keyboard for input.

*(Datasheet to be written as the design solidifies — see PLAN.md.
Sections to cover: memory map, boot flow, pinout, video timing,
SBI firmware interface, how to build the kernel + rootfs.)*

## How to test

Headless v1: attach the QSPI Pmod (uio), program the flash, select
25 MHz, release reset. The CPU boots in plain SPI, executes in place,
and software may switch to quad via QSPI_CFG (MMIO 0x1000C). UART TX
on uo[0] (115200 8N1), HALTED (EBREAK) on uo[1], LED[5:0] on uo[7:2],
GPIO in on ui. CLINT (mtime/mtimecmp/msip) at 0x0002_0000.

The video milestone replaces uo with the Tiny VGA Pmod and puts a
PS/2 keyboard on ui[1:0] — see PLAN.md.

## External hardware

- TinyTapeout QSPI Pmod (flash + 2x PSRAM) — required
- USB-serial adapter on uo[0], LEDs optional
- Later: Tiny VGA Pmod + monitor, PS/2 keyboard
