# Koti-1 on the ULX3S 85F — first power-up

This is the bring-up procedure. **Steps 0-2b HAVE now run on hardware
(2026-08-07) and koti works**; steps 3-7 still have not, because they need Pmods
that have not arrived. The checklist keeps its order for the reason it was
written: each step is chosen so that the *next* step's failure has only one
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
| ✅ **The board, end to end** | 2026-08-07: `sw/bringup.bin` printed 31 gapless lines over the real UART out of a fabric boot flash — see step 2b |
| ✅ **`sw/bringup.S`, the ASSEMBLY rewrite** | 2026-08-08: first contact. 296 bytes, **0 non-printable**, counter monotonic #257-260. Proves the SDRAM stack round-trip (so `RD_ADV` still holds), `remu`/`divu`, and — since this bitstream carries it — the **core ack-routing fix** of the same day |
| ✅ **The SDRAM, including `RD_ADV` and the address decode** | 2026-08-07: `sw/memtest.bin`, four clean passes over the full 16 MB with an address-derived pattern, plus the byte-lane/DQM path |
| ✅ **The board revision** | it is a **PCB v3.1.8**, and only `wifi_gpio0` differs from v2.0 — see step 1 |
| **NOT proven: the font glyphs look right** | needs the Tiny VGA Pmod — step 6, and PLAN.md item 9 |
| **NOT proven: anything on J1/J2** | both headers are still unpopulated |

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

## ✅ 1. The board revision — SETTLED 2026-08-07

**It is a PCB v3.1.8, and it does not matter.** Exactly five signals moved
between v2.0 and v3.1.x and **all five are `wifi_*`**: on v3.1.x, L2 became
`wifi_gpio22` and `wifi_gpio0` moved to **F1**. `ulx3s.lpf` and `check_pins.py`
carry F1 for that one pin and the upstream v2.0 site for the other 58 — every
SDRAM pin and all of J1/J2 are identical on both revisions.

⛔ **Do not read the USB descriptor as the revision.** `fujprog` prints
`ULX3S FPGA 85K v3.0.8`; that is stale factory EEPROM data, not the PCB.

For a different board, `check_pins.py` fails on the mismatch before yosys runs —
which is how the L2/F1 drift was caught in the first place.

## 2. Power the board alone — no Pmods

Load the bitstream with nothing plugged into J1 or J2:

```
fujprog fpga/ulx3s/build/koti-bram.bit        # SRAM, volatile, ~60 s  ✅ WORKS
```

**The volatile load is gone at power-off**, which is what you want while
iterating. Do the whole checklist with it.

## ⛔ `fujprog -j flash` DOES NOT WORK ON THIS BOARD — tried 2026-08-08

This README used to carry `fujprog -j flash … # persistent` as if it were a
working alternative. **It was documented and never run.** It was run on
2026-08-08 and it fails, and the reason is the board's architecture rather than
anything in koti:

⭐ **THE ESP32 OWNS BOTH THE SPI FLASH AND THE UART AT POWER-ON.** Proof, not
inference: after a power cycle the serial port produced the ESP32's boot ROM log
and a **MicroPython v1.14 prompt**, not koti —

```
rst:0x1 (POWERON_RESET),boot:0x1f (SPI_FAST_FLASH_BOOT)
MicroPython v1.14 on 2021-02-02; ESP32 module (spiram) with ESP32
>>>
```

That single observation explains every symptom of the attempt:
| symptom | cause |
| --- | --- |
| `TDO: 4000 Expected: 0000 mask: C100`, then `Line 37: Operation not permitted` | the ESP32 contending for the flash during the JTAG write |
| `fujprog -i` → `FPGA IDCODE: FFFFFFFF`, `SIZE: 0` | an all-ones JTAG chain — not communicating |
| `-z` (force) reported `Completed in 141.22 seconds` | it forced past the verify failures; the write still did not take |
| after a power cycle: LEDs static, no banner | the FPGA never configured from flash |

⚠️ **koti's `wifi_en = 0` does not help here, and cannot.** It only takes effect
once the FPGA is CONFIGURED — and at power-on, before any bitstream loads, the
ESP32 is unrestrained. That is an ordering problem, not a bug. (Confirmed from
the other side: as soon as koti was reloaded over SRAM, the ESP32 released the
serial line and the banner came back.)

✅ **Nothing was damaged.** The SRAM path was unaffected throughout — reflashed
in 58.94 s afterwards and koti printed immediately. The board has never booted
from its own flash, so a partially-erased flash cost nothing.

### ⭐ The ESP32 route is CHEAPER THAN IT LOOKS — prerequisites established 2026-08-08

The objection to using the ESP32 was that flashing it needs a **passthru
bitstream** so the FPGA can bridge the FT231X to the ESP32's UART and drive its
EN/GPIO0. **That is not true on this board.** Measured:

```
esptool --port COM3 chip-id      # with the FPGA UNCONFIGURED
  Chip type: ESP32-D0WD-V3 (revision v3.1)   MAC: c8:85:41:c9:ce:f0
  Uploading stub flasher... Running stub flasher... Stub flasher running.
```
Download-mode control reaches the ESP32 through the FT231X with no help from the
FPGA. Power-cycle the board, do NOT load a bitstream, and esptool just works.
⚠️ The FPGA must be unconfigured — koti drives `wifi_en` low, which disables the
ESP32 entirely.

**Also established:**
- The ESP32's flash is **16 MB** (`Manufacturer a1, Device 4018`), not 4 MB.
  Room is not a constraint.
- The stock image is plain **MicroPython 1.14** with **no FPGA loader**:
  `import ecp5` -> ImportError, and `help('modules')` lists nothing ULX3S-
  specific. Its filesystem holds only `boot.py`, 2,084,864 bytes free.
- ⭐ **A full factory backup exists**: `Documents/ulx3s-backup/` holds
  `esp32-factory-16MB-2026-08-08.bin` (16,777,216 bytes, sha256
  `8e8df9bc…e323`, 0xE9 magic verified) plus a README with the one-line restore
  command. Overwriting the ESP32 is now reversible, which is the only reason it
  should be attempted at all.
- **The bitstream gzips to 16%**: 1,976,403 -> 308,806 bytes, ~25 s to upload at
  115200, against 1.78 MB of headroom. `uzlib` is on the stock image already.

⇒ What remains for a standalone board: flash EMARD's ULX3S MicroPython build
(which ships `ecp5.py`), put the gzipped bitstream in its filesystem, and add a
`main.py` that configures the FPGA at boot. ⚠️ **NOT YET DONE.** The remaining
risk is picking the wrong firmware image, and the backup above is the answer to
it.

**Routes to a genuinely standalone koti:**
1. **Stop the ESP32 booting.** Its MicroPython is factory firmware koti does not
   want. ⚠️ Erasing it is destructive and irreversible without re-flashing
   MicroPython — the owner's call, not a casual step.
2. **Use the ESP32 as designed.** On this board it is the intended FPGA loader:
   put the bitstream in its filesystem and let it configure the FPGA at power-on.
   That reaches "5 V and nothing else" without fighting the hardware.
3. Hold the ESP32 in reset for the duration of the JTAG flash write, if a way to
   do that from the host exists.

⛔ **`fujprog`, NOT `openFPGALoader`, on this board.** fujprog drives the FTDI
through its stock driver. openFPGALoader wants a WinUSB bind (Zadig), and that
bind **destroys the COM port koti's console is** — so the tool that flashes the
design would take away the only way to hear from it. ⚠️ The FT231X is ONE device
shared by JTAG and the UART, so the serial port must be closed while flashing.

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

⭐ **It is the one image written in assembly** (`sw/bringup.S`, 2026-08-08), and
it is its own startup — no `crt0.S`, no `.data`, no `.bss`. This is the image
you flash when you do not yet trust the board, so every instruction it runs
should be one you can read:

```sh
python tools/rvdis.py sw/bringup.bin --base 0 --count 40   # the whole program
```

⛔ **The stack traffic in it is load-bearing.** A printed line proves the SDRAM
works because `ra` is pushed to and popped from the SDRAM stack on every call
and the line counter is stored and reloaded across them — the `RD_ADV` read
window is silent on writes and corrupts every read, so a wrong window means no
second line. An "optimisation" that kept the counter in a register would still
print, still look right, and no longer test the thing this image exists for.

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

## ✅ 2c. The onboard microSD — **DONE ON HARDWARE 2026-08-07**

Flash the `bram` variant built with `image: sdtest` and open the console:

```
init: OK
block 0 tail: 00 00 00 00 00 00 55 aa
55 aa PRESENT — genuinely the card's data
reread: identical / block 12345: differs from block 0 / pass CLEAN
```

That is koti's own CPU reading 512-byte blocks through `src/sd_ctrl.sv` and the
vendored `sd_spi`, returning the card's **MBR signature**. Repeatable and
address-dependent, so it is not a stuck bus. **No Pmod and no soldering** — the
card slot is onboard, on the underside.

### 🪤 If it says `init: FAILED, status 00000004`, read this before touching anything

That message says `SD_ERR` and *looks* exactly like "no card". On 2026-08-07 it
was neither the card, nor the seating, nor the ESP32 — it was **one character of
Verilog**:

```systemverilog
assign sd_d[0] = 1'bz;          // ⛔ this is the bug
```

A bare `1'bz` with no other driver gives yosys nothing to build a tristate from,
so the port collapses to a **plain input — and on a plain input the LPF's
`PULLMODE=UP` does not take effect.** MISO then floats **LOW**, every byte
clocked off the card reads `0x00`, and `sd_spi` never sees a response. The check
is the nextpnr log:

```
bad:   Info: pin 'sd_d[0]$tr_io' constrained to Bel ...     (no $iobuf_i line)
good:  Info: $sd_d[0]$iobuf_i: sd_d_$_TBUF__Y.Y             (a real tristate)
```

⛔ **The tristate mux in `ulx3s_top.sv` is load-bearing.** Its enable is always 0
in normal operation, so it looks like dead code — deleting it silently breaks the
card. ⚠️ **CI cannot catch that**: `test/sd_card_model.sv` supplies its own
pull-up, so every bench stays green while the board goes deaf.

**The instrument for this class of fault is `image: sdraw`.** It muxes `sd_spi`
off the pins, hand-clocks CMD0 from software and prints the raw bytes, and it can
**drive** the MISO pin to test continuity (slot must be empty). One run splits
the problem: `ff` everywhere = the card never drove the line; `00` everywhere =
something holds it low; any byte with the top bit clear = the card is alive and
the fault is koti's.

## ✅ 2d. Linux, off the microSD, on HDMI — **DONE ON HARDWARE 2026-08-07**

The whole machine. Write the kernel to the card, flash the firmware, watch it
boot on the serial console *and* the monitor:

```
python tools/sdkernel.py write arch/riscv/boot/Image --disk N --yes   # NEEDS ADMIN
gh workflow run fpga-ulx3s.yaml -f image=sbi
fujprog koti-bram.bit
```
```
[   49.491302] Run /init as init process
Linux buildroot 6.12.0 #1 riscv32 GNU/Linux    MemTotal: 8868 kB
koti: userspace is alive
Welcome to Buildroot
buildroot login:
```

⚠️ **DIP SWITCH 3 MUST BE ON.** This firmware enables VGA, which gives uo[0] to
the raster and mirrors the UART on uo[6]; SW3 points the FTDI at uo[6]. With SW3
off the console is mojibake and the board looks dead.

⚠️ **Flash, THEN open the port, THEN press BTN0.** The early boot is gone
otherwise — that is how the `sd: loading kernel` line got missed the first time.

⭐ **The boot log appears on the HDMI monitor with no framebuffer driver**, and
that is not an accident worth being confused by later: SBI `console_putchar`
calls `putc_both()`, which writes the UART *and* the 40x30 VGA text buffer, and
Linux's console is `hvc0` over SBI. **Nothing in Linux knows the video hardware
exists.** A real framebuffer is separate, later work.

⛔ **You cannot type at that login prompt.** koti's UART is `uart_tx.sv` —
transmit only — and SBI `console_getchar` reads the PS/2 block, for which there
is no keyboard. Logging in needs the USB HID host, ladder item 8, unbuilt.

### If the card is not found
The firmware falls back to its built-in flash payload and prints `STK` — a
missing card is not a brick. `image: sdtest` checks the card path on its own,
and `image: sdraw` is the layer below that.

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
`ui` is input-only on the chip, which is why the keyboard that replaced
PS/2 is a USB host on US2 rather than anything on `ui`. A
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
