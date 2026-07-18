## How it works

Koti-1 is a single-chip home computer: an RV32IMA RISC-V CPU with
M/S/U privilege modes and an sv32 MMU, booting mainline Linux from
QSPI flash/PSRAM with the console rendered as 80x30 VGA text and a
PS/2 keyboard for input.

*(Datasheet to be written as the design solidifies — see PLAN.md.
Sections to cover: memory map, boot flow, pinout, video timing,
SBI firmware interface, how to build the kernel + rootfs.)*

## How to test

Attach the QSPI Pmod (uio), the Tiny VGA Pmod (uo), and a PS/2
keyboard (ui). Flash the firmware+kernel image, select 50 MHz, release
reset: Linux boots to a login shell on the monitor.

## External hardware

- TinyTapeout QSPI Pmod (flash + 2x PSRAM) — required
- Tiny VGA Pmod + monitor
- PS/2 keyboard (or USB keyboard in PS/2 fallback mode) on ui pins
- Optional UART on the muxed pin for headless bring-up
