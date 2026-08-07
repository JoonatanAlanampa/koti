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
| The design fits and closes timing | CI `fpga-ulx3s` workflow, run 30945077186: **31.04 MHz post-route, PASS at 25 MHz**, 13 % of the 85F (11578 COMB, 3637 FF, 79 IO, 3/208 BRAM). Older figures still in circulation — 27.48, 30.90, 31.69, 31.83, 34.8 — are all dead |
| RAM is the onboard 32 MB SDRAM, not the Pmod's PSRAM | `-DKOTI_FPGA` is on in all three build files; `python test/run_fpga.py` boots through it, 4/4 |
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

## ✅ 2b. Boot with NO Pmod at all — the fabric flash. **DONE ON HARDWARE 2026-08-07**

```
Koti-1: hello from my own SoC #4 0123456789 abcdefghijklmnopqrstuvwxyz
   ... through #34
```

31 lines, 31 exact matches, 0 malformed, counter monotonic and gapless, 0
non-printable bytes, 2257 bytes on COM3. **This is the first koti that has run on
real hardware.** What it settles, in the order the table at the top of this file
listed as unproven:

| was "NOT proven" | now |
| --- | --- |
| any wire, connector or signal integrity | ✅ the whole flash+SDRAM+UART path, on the board |
| that this board is a v2.0 | ✅ it is a **PCB v3.1.8**, and it does not matter: the five signals that moved are all `wifi_*` |
| **`RD_ADV`** (the top bring-up risk in the project) | ✅ **correct as built.** `uart_puts` is a call, so `ra` goes to the SDRAM stack and comes back on every line; a read window off by one clock is *silent on writes and corrupts every read*, so there would have been no second line |
| the SDRAM's **address decode** | ✅ **`sw/memtest.bin`, four consecutive clean passes**: a 16 MB walk with an address-derived pattern, plus a byte/halfword lane test for the `be`/DQM path. All 4M words hold what was written, so nothing in the row/bank/column decode aliases |
| the font glyphs | ❌ still needs the Tiny VGA Pmod (step 6) |



**This is the path that works today, and steps 3-5 below are the Pmod path that
cannot be walked until the Cartridge Pmod arrives.** J1 is bare holes; koti boots
by XIP from flash address 0; so without a memory Pmod the CPU cannot fetch one
instruction and step 2 above is as far as the board can be taken.

`fpga/ulx3s/bram_flash.sv` is a QSPI *device* in fabric on the same eight `uio`
wires the Pmod would use, backed by the 85F's own block RAM. `qspi_ctrl`,
`arbiter3` and `icache` are untouched and all still run — and the RAM half of the
map still goes to the **real SDRAM controller**, so this boot exercises the
onboard part, `RD_ADV` included.

```
gh run download <id> -n koti-fpga-bram        # the matrix builds pmod AND bram
fujprog fpga/ulx3s/build/koti-bram.bit        # SRAM, volatile
```

⛔ **`fujprog`, not `openFPGALoader`.** fujprog drives the FTDI through its stock
driver; openFPGALoader wants a WinUSB bind (Zadig), and that bind **destroys the
COM port koti's console is**. Do not run Zadig on this board.

The image baked in is **`sw/bringup.bin`**, which prints **forever** — and that
is the point. With **SW3 off** (UART on `uo[0]`), open the port whenever and
expect:

```
Koti-1: hello from my own SoC #0 0123456789 abcdefghijklmnopqrstuvwxyz
Koti-1: hello from my own SoC #1 0123456789 abcdefghijklmnopqrstuvwxyz
```

about every 0.4 s, with LED0..LED5 counting the lines so there is a liveness
signal that needs no serial port at all.

⚠️ **Why not `sw/hello.bin` — a trap this cost an evening to learn.** hello.c
prints its banner ~5.4 ms after reset and then calls `con_init()`, which sets
VGA_EN, which **moves the UART to `uo[6]` and turns `uo[0]` into an RGB bit**.
Programming the FPGA takes ~60 s, so no host process can open the port in time
to read that banner: reading it needs a human pressing **BTN0** at the right
instant. And what the port *does* see afterwards is the **video raster decoded as
serial noise** — measured 2026-08-07, **219,995 bytes of mojibake in five
minutes**, from a machine that was working perfectly. If you see a flood of
garbage on this board, suspect VGA_EN before suspecting the UART.

`bringup.bin` never touches video, so the three outcomes stay distinguishable:
silence = the CPU is not running, mojibake = the divisor or the pin is wrong,
clean lines = the whole path works.

The port must be closed while flashing — the FT231X is one device shared by JTAG
and the UART. ⚠️ `fujprog -t`'s terminal output does not survive stdout
redirection, so it is no use to a script.

- **SW1 does nothing in this build.** It is the J1 seating strap and there is no
  seating to be wrong about. Not broken.
- **`led[7]` is the flash's `bad_cmd`**, not `uo[7]`, in this variant only. Lit
  means the model saw an opcode it does not implement (it does 03h; nothing in
  `sw/` ever enables quad) — that is "the memory refused a command", which is a
  very different bug from "the SoC is broken".
- The image is baked in at build time by `fpga/ulx3s/mkflashhex.py`, so changing
  it is a one-word edit in the builders plus a rebuild. 32 KB of fabric flash, so
  `sw/hello.bin` (597 B) and `sw/sbi/sbi_test.bin` (26012 B) both fit — the
  latter is what step 6 wants.
- ⚠️ **It cannot hold a kernel.** 32 KB against a 3.95 MB `Image`. Linux on
  hardware needs a real transport — see the note under step 4.

Simulated end to end before it was ever flashed, and it runs on the development
host in seconds: `test/tb_fpga_bram.v` (plain Verilog, no cocotb) boots this
exact configuration through `ulx3s_top` with `sdram_model` on the SDRAM pins and
asserts the banner. CI runs it in `test.yaml`.

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

> **A second candidate, found 2026-08-07: the board's OWN SPI flash.**
> `fujprog -j flash -f ADDR -T img <file>` writes a raw image at an arbitrary
> flash offset, so the onboard part could hold both the firmware and a 3.95 MB
> kernel with no Pmod and no SD controller. It needs two things this repo does
> not have yet: the flash pins in `ulx3s.lpf` (they are not among the current 79),
> and something to add the offset to the address `qspi_ctrl` shifts out, since
> the FPGA bitstream itself occupies the bottom ~2 MB. The address is serial and
> MSB-first, so "force one bit high as it passes" is a small FSM rather than an
> adder. Unverified: whether the ECP5 releases the config-flash pins to fabric on
> this board, and the flash's size.

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

> ⚠ **Power the keyboard from 3.3 V, not 5 V.** PS/2 is nominally a 5 V bus and
> **ECP5 IO is not 5 V tolerant** — a 5 V-powered keyboard wired straight to
> gp[8]/gp[9] can damage the FPGA. Running it from the board's 3.3 V rail puts
> its pull-ups on 3.3 V and every level in spec. Most PS/2 keyboards work fine
> undervolted, and one that does not simply stays quiet: an undervolt fails
> safe, an overvolt does not.

Wiring, four wires from the mini-DIN: **pin 4 → 3.3 V, pin 3 → GND, pin 5
(clock) → gp[8], pin 1 (data) → gp[9]**, plus **~4.7 kΩ from each of clock and
data up to that same 3.3 V**. PS/2 is open-collector — the keyboard only pulls
low, so something has to pull high, and the FPGA's internal pull-up (~10-50 kΩ)
is far too weak to be it. `PULLMODE=UP` in the LPF stops the lines floating; it
does not terminate the bus.

Nothing here needs the keyboard to be driven, which is why this works at all:
`ui` is input-only on the chip, so `ps2_rx` is receive-only by design. A
keyboard completes its power-on self-test and starts sending scancodes on its
own, without any host command.

If a keyboard refuses to run at 3.3 V, use a **BSS138-type level-shifter
module** (sold as an "I2C level converter", ~€2) and power it at 5 V. Do *not*
substitute a plain resistor divider: the keyboard's own pull-up to 5 V and a
divider to ground fight each other and the high level lands around 1.6 V, below
the LVCMOS33 input threshold. That combination looks reasonable and does not
work.

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
