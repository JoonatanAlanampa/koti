# Koti-1 on the ULX3S 85F — pre-tapeout validation build

**Status: untested scaffold** — written before the board is in hand.

The wrapper instantiates the *exact* TT top (`tt_um_koti`), so the
FPGA runs what gets hardened. Toolchain is the open flow (Yosys +
nextpnr-ecp5), the same Yosys front end LibreLane uses.

## Before first use

1. **Verify every pin site** in `ulx3s.lpf` against the official
   constraint file for your board revision:
   https://github.com/emard/ulx3s/blob/master/doc/constraints/
   The gp/gn sites in particular are placeholders.
2. Wire the **TT QSPI Pmod** to the gp[0..7] header positions
   (CS0, SD0, SD1, SCK, SD2, SD3, CS1, CS2 in uio order), a VGA
   breakout (resistor DAC) to gn[0..7], PS/2 to gp[8..9] with
   pull-ups.
3. Program the flash on the Pmod with `sw/sbi/sbi_test.bin` or
   `sw/hello.bin` (bit-bang via the ESP32 or an external programmer).

## Build (OSS CAD Suite)

```sh
yosys -p "read_verilog -sv ulx3s_top.sv ../../src/*.sv; \
          synth_ecp5 -top ulx3s_top -json koti.json"
nextpnr-ecp5 --85k --package CABGA381 --json koti.json \
             --lpf ulx3s.lpf --textcfg koti.config
ecppack koti.config koti.bit
fujprog koti.bit          # or openFPGALoader
```

(Note: `src/*.sv` also pulls in `font_rom.svh` via include — run
yosys from this directory so the relative include resolves, or add
`-I ../../src`.)

## What to expect

Serial banner on the USB port (115200) from `hello.bin`, then the
console on the monitor once VGA_EN is set — this is where the font
glyphs get their visual verification (PLAN.md action item).
