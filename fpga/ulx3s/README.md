# Koti-1 on the ULX3S 85F — first power-up

This is the procedure for the day the board arrives. **Nothing in this
directory has ever been on hardware.** Everything below is simulated and
place-and-routed in CI, which is exactly why the checklist is ordered the way
it is: each step is chosen so that the *next* step's failure has only one
plausible cause left.

The wrapper instantiates the *exact* TT top (`tt_um_koti`), so the FPGA runs
what gets hardened; only the pad ring differs. See `ulx3s_top.sv` for what is
harness-only and why, and `ROADMAP.md` for how this got here and what is left.

What is already proven, and what is not:

| Proven | How |
| --- | --- |
| The design fits and closes timing | CI `fpga-ulx3s` workflow: **31.69 MHz post-route, PASS at 25 MHz**, 10 % of the 85F (9102 COMB, 2835 FF, 40 IO) |
| Every pin lands on a real v2.0 site | `python fpga/ulx3s/check_pins.py`, which also runs in CI |
| The header permutation and the straps | `python test/run_fpga.py` — boots `hello.bin` through the J1 wires in both orientations, and stays silent when the strap is wrong |
| The UART follows koti's two personalities | same suite: the SBI image's output arrives via the SW3 mux |
| The flash-writer path | `pmod-cartridge` simulated the whole I/E/P/R chain including read-back, 2026-07-20 |
| **NOT proven: that this board is a v2.0** | needs the board — see step 1 |
| **NOT proven: any wire, connector or signal integrity** | needs the board |
| **NOT proven: the font glyphs look right** | needs a monitor — step 6, and PLAN.md item 9 |

## Straps, all four in one place

| Switch | Off (default) | On |
| --- | --- | --- |
| **SW1** | J1 mapping A | J1 mapping B — flip if the memory Pmod is not found |
| **SW2** | J2 mapping A | J2 mapping B — flip if VGA colours are scrambled |
| **SW3** | UART on `uo[0]` (headless) | UART on `uo[6]` (after software enables VGA) |
| **SW4** | LEDs show the chip's raw `uo` | LEDs show a VSync frame counter |

## 0. Build the bitstream

Do not run place-and-route locally (project compute policy). Either grab the
`koti-fpga` artifact from the `fpga-ulx3s` workflow, or:

```
gh workflow run fpga-ulx3s.yaml && gh run watch
```

`powershell -File fpga\ulx3s\synth.ps1 -SynthOnly` is the local *fast check* —
it stops after yosys and only tells you the design still elaborates.

## 1. Confirm the board revision BEFORE plugging anything in

Every pin site in `ulx3s.lpf` comes from the **v2.0** constraint file. If this
board is a different revision, some sites move, and the ones that move are the
ones nothing has validated.

- Find the revision silkscreen on the PCB.
- If it is not v2.0, diff `ulx3s.lpf` against the constraint file for that
  revision before continuing. Do not skip this because the bitstream builds —
  a wrong site builds perfectly and drives the wrong ball.

## 2. Power the board alone — no Pmods

Load the bitstream with nothing plugged into J1 or J2:

```
openFPGALoader -b ulx3s fpga/ulx3s/build/koti.bit        # SRAM, volatile
```

**This one is gone at power-off.** It configures the FPGA directly and is what
you want while iterating. To make it survive a power cycle:

```
openFPGALoader -b ulx3s -f fpga/ulx3s/build/koti.bit     # persistent
```

Do the volatile load first and get through this checklist with it.

Expected, with SW4 off: the LEDs show the chip's raw `uo` pins, which in the
headless personality means **LED0 flickering with UART traffic** and **LED1 =
HALTED**. With no memory Pmod attached the CPU cannot fetch anything, so what
you are really checking here is that the board configures and nothing is stuck.

**A solid LED1 means the CPU hit EBREAK** — it halted. That is a legitimate
outcome later, but at this step it means the fetch path returned garbage that
decoded to a halt, which is what you would expect with no flash present.

## 3. Memory Pmod on J1, orientation strap

**J1 = gp/gn 0-3.** Either the Cartridge Pmod (`../../../pmod-cartridge`,
board #1 — the one that passed the bench check) or a stock TT QSPI Pmod fits:
koti holds `uio[7]`/CS2 permanently high, and CS2 is precisely the pin the
Cartridge Pmod repurposed for its audio chain, so koti never touches the
difference. Koti uses one PSRAM (CS1), which is what the cartridge carries.

- **SW1 selects the row mapping.** If the design does not boot, flip SW1 and
  re-check before suspecting anything else: the strap exists because the plug
  orientation is ambiguous, and `test/run_fpga.py` proves that exactly one
  setting works and the other is silent.
- Reset is **BTN0 (PWR), active low** — press to restart.

The mapping here is byte-identical to the cartridge bring-up bitstream's, which
is a useful cross-check: two independently written harnesses agreed on which
header wire carries which `uio` bit.

## 4. Put software in flash

The chip boots by XIP from flash address 0, so the flash has to be programmed
before koti can do anything. The cartridge Pmod's own bring-up bitstream
doubles as a UART flash writer, so this needs no programmer and no ESP32
bit-banging:

```
# 1. temporarily load the writer bitstream
openFPGALoader -b ulx3s ../pmod-cartridge/fpga/build/cartridge_bringup.bit

# 2. push the image (erase + write + verify)
python ../pmod-cartridge/fpga/flash_cartridge.py COM7 sw/hello.bin

# 3. put koti back
openFPGALoader -b ulx3s fpga/ulx3s/build/koti.bit
```

`flash_cartridge.py` needs `pyserial`. Its SW1 means the same thing as koti's,
so if you had to flip the strap in step 3, flip it for the writer too.

Start with `sw/hello.bin`. `sw/sbi/sbi_test.bin` is the more interesting image
and step 6 uses it.

> When kernel images outgrow a UART link, console's `sd_loader` is the answer —
> it copies from microSD into cartridge flash while the SoC is held in reset.
> That is a port rather than a write, and it is Linux-ladder work, not bring-up.

## 5. The serial console

Attach a terminal to the ULX3S's USB serial port at **115200 8N1**, with
**SW3 off** (UART on `uo[0]`, the headless default). Press BTN0.

Expected:

```
Koti-1: hello from my own SoC
```

This is the same banner `test/run_fpga.py` decodes off `ftdi_rxd` in
simulation, so if the bitstream is right and the flash is right, this string is
the one thing that must appear.

If nothing arrives: flip SW1 (orientation), then re-check step 4's verify pass.
Silence with a correct strap and a verified flash points at the Pmod wiring.

## 6. Tiny VGA Pmod on J2 — the font check

Only now add video, on **J2 = gp/gn 4-7** — sites that have never been on
hardware. **SW2** flips the VGA row mapping the same way SW1 does for J1.

Flash `sw/sbi/sbi_test.bin` (step 4) and move **SW3 on**, because that firmware
enables VGA and moves the UART to `uo[6]` as it does so. Expect `STK` on the
serial line and the same characters on the monitor, 640x480@60.

**This step is the one that closes PLAN.md item 9**: the 8x8 font ROM has never
been looked at by a human on a real display. Check the glyphs are the right
shapes, not just that something appears — a transposed font ROM produces a
screen full of confident-looking garbage.

With SW4 on, the LEDs become a VSync frame counter; **counting LEDs means video
timing is alive** even if the monitor shows nothing.

## 7. PS/2 keyboard

Clock on **gp[8]**, data on **gp[9]**, into `ui[1:0]`.

**Fit external ~4.7 kΩ pull-ups to 3.3 V on both lines.** PS/2 is an
open-collector bus: the keyboard only ever pulls low, and the FPGA's internal
pull-up (~10-50 kΩ) is far too weak to be the other half. `PULLMODE=UP` in the
LPF stops the lines floating; it does not terminate the bus.

Strictly PS/2 wants 5 V. Most keyboards work at 3.3 V; if yours does not, the
usual ULX3S route is the **US2 port with a passive USB→PS/2 adapter** and a
keyboard that supports PS/2 fallback. That is a two-resistor change plus a pin
move in `ulx3s.lpf`.

## Things that will look like bugs and are not

- **A blank monitor at first power** — correct. koti boots *headless*; nothing
  reaches the VGA pins until software sets VGA_EN.
- **Nothing on the UART after software enables VGA** — SW3. The chip moved the
  UART to `uo[6]`; the harness has to be told.
- **The Pmod not found until SW1 is flipped** — expected; the strap is the
  orientation control, and only one of the two settings can be right.
- **LED0 flickering constantly** — that is UART traffic, not a fault.
- **`uio[7]` sitting high forever** — deliberate. koti holds CS2 high; on the
  Cartridge Pmod that pin feeds the audio chain, so it parks DC into the amp
  and koti is simply a silent machine.
