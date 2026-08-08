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
| ✅ **The SDRAM, including `RD_ADV` and the address decode** | 2026-08-08: `sw/memtest.bin`, **eight clean passes over the full 32 MB** with an address-derived pattern, plus the byte-lane/DQM path and the `addrbits` walking-1 phase. (2026-08-07's four passes covered 16 MB, which was all the address path could then reach.) |
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

## ~~⛔ `fujprog -j flash` DOES NOT WORK ON THIS BOARD~~ — ✅ **IT DOES. SUPERSEDED SAME DAY.**

⭐ **`fujprog -j flash <bit>` WORKS, ~142 s, one command** — used twice on
2026-08-08 and again for the 32 MB build. **The only thing ever wrong with it
was SPI flash BLOCK PROTECTION** (`BP=6`, covering exactly the 2 MB a bitstream
needs); clear it once and the original command simply succeeds. See the
write-protect section below for the fix.

⇒ **The ESP32-contention theory below is WRONG and is kept only as history.**
So are the MicroPython-version and `ecp5.py`-version theories. Do not take the
ESP32 detour on the strength of this section — it was written before the cause
was found, and a bring-up document that says a working command does not work
costs a session.

<details><summary>The original (disproven) diagnosis, kept for the record</summary>

This README used to carry `fujprog -j flash … # persistent` as if it were a
working alternative. **It was documented and never run.** It was run on
2026-08-08 and it failed, and the reason was thought to be the board's
architecture rather than anything in koti:

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
in 58.94 s afterwards and koti printed immediately. The board had never booted
from its own flash at that point, so a partially-erased flash cost nothing.

⛔ **Every symptom above has a simpler cause: the flash was write-protected.**
The ESP32 was never the reason. Table and prose kept only so the wrong theory is
recognisable if it comes back.

</details>

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

### ⭐ The ESP32 CAN drive this FPGA's JTAG — and the STOCK FIRMWARE CANNOT (2026-08-08)

Measured, in this order, against the real board:

| step | result |
| --- | --- |
| upload `ecp5.py` + `jtagpin.py` over the raw REPL, hash-checked on the device | ✅ 941 and 19010 bytes, sha256 matched |
| `ecp5.idcode()` from the ESP32 | ✅ **`0x41113043` = LFE5U-85F** |
| anything reaching `spi_jtag_on()` (`flash_open`, and therefore `prog`/`flash`) | ❌ one `0x00` byte on the UART, then a **dead line** |
| recover with a port-open (DTR/RTS) reset | ❌ not enough |
| recover with `esptool --after hard-reset` | ✅ the first time, ❌ the second (`No serial data received`) |
| recover by SRAM-loading `console.bit` with fujprog | ✅ 62.05 s, so **host JTAG was never damaged** |

⭐ **The ESP32's JTAG works.** A correct IDCODE needs all four of TMS/TCK/TDI/TDO
right, so this also settles the pinout question below.

⛔ **`fujprog -i` IS NOT A WORKING DIAGNOSTIC ON THIS BOARD. Stop quoting it.**
Freshly power-cycled with the ESP32 untouched it still reports `FFFFFFFF`, while
`fujprog` SRAM-programming succeeds in that very state (`console.bit`, 62 s). An
earlier run gave `00000005`. Two different garbage answers and a tool that works
anyway ⇒ the read path is broken, not the chain.

### ⛔ Why `fujprog -j flash` really fails — and it is NOT the ESP32 (2026-08-08)

**Tested, not argued.** The ESP32 was put into `machine.deepsleep(600000)` — GPIOs
floating, provably silent — and `fujprog -j flash` failed **identically**:
`TDO: 4000 Expected: 0000 mask: C100`, `Line 37: Operation not permitted`.
⇒ The JTAG-contention theory is **refuted**. Do not re-run this experiment.

`fujprog -s FILE` dumps the SVF it plays, so the failing line is readable
offline. Line 37 sits right after this:

```
SDR 32 TDI(0000001B);            # 0x1B bit-reversed = 0xD8 = 64K BLOCK ERASE
RUNTEST DRPAUSE 5.50E-01 SEC;    # a FIXED 0.55 s wait
SDR 16 TDI(00A0) TDO(00FF) MASK(C100);   # 0x A0 reversed = 0x05 = READ STATUS
```
It erases, waits a fixed 0.55 s, then requires the masked status bits to be
clear — and finds `0x4000` still set. So the flash is **still busy or still
write-enabled** when fujprog gives up. Two candidates, both untested:
1. the erase is slower than the hard-coded 0.55 s, or
2. the flash is **write-protected** — upstream ships a whole module for this,
   `ecp5wp.py`, "ECP5 JTAG FLASH protection tool".

⚠️ `fujprog -z` "completing in 141 s" is consistent with this and means nothing —
it forces past exactly these status checks.

### 🔴 THE ANSWER: THE CONFIG FLASH IS WRITE-PROTECTED (measured 2026-08-08)

```
status_reg = 0x18      func_reg = 0x03
BP=6  QE=0  WEL=0  WIP=0  TBS=1  IRL=0
PROTECTED RANGE: 0x000000 - 0x1FFFFF   (2097152 bytes, bottom)
```

**The low 2 MB of the SPI flash is block-protected, and that is exactly where the
FPGA bitstream lives** — koti's is 1,976,403 bytes, entirely inside the range.
Chip confirmed by JEDEC ID `9D 60 18` = **ISSI IS25LP128**.

⇒ This single fact explains every failure in this file, and they were never
separate problems:
- `fujprog -j flash` dying on the post-erase status check — the erase is refused
- `ecp5.flash()` returning **False** after its 3 retries
- both tools failing at the same wall with the ESP32 asleep
- **and why this board has never once booted from its own flash**

⛔ **STOP DIAGNOSING THE TOOLS.** It was not fujprog, not `ecp5.py`, not the
MicroPython version, not JTAG contention and not the ESP32. Three of those were
actively investigated and all three were wrong.

**Unprotect = write status register 1 with BP=0** (`0x06` WREN, then `0x01 0x00`).
**Reversible**: send `0x01 0x18` to restore BP=6.

⛔ **DO NOT CALL `ecp5wp.is25lp128_protect()`, INCLUDING AS `protect(0)`.** It
also writes the function register (`0x42 0x02`), and upstream's own comment on
that line is *"OTP warning: once set, can't be reset!"*. On this chip **TBS is
already 1**, so that write buys nothing and risks a one-way change. Touch status
register 1 only.

⭐ **AND THE ESP32 NEVER CRASHED.** `/flashlog.txt` on its filesystem shows the
script running to completion — `idcode`, `flash() returned False`, `--- done` —
while the UART was dead the whole time. **The FTDI serial line is shared with the
FPGA, so it goes dark the instant `common_open()` erases the FPGA's
configuration.** One stray `0x00` byte, then silence, recoverable only by a power
cycle. Upstream never sees this because upstream drives esp32ecp5 over
WiFi/WebREPL, not over the wired UART.

⇒ **When driving JTAG from the ESP32, LOG TO A FILE ON THE ESP32.** Reading the
UART during the operation is not merely useless, it destroys the evidence and
costs a power cycle per attempt. This is the instrument that ended the
investigation after several hours of dead-line guessing.

⚠️ **`import ecp5wp` RUNS `detect()`.** Upstream's file ends with a bare
`detect()` call at module level, so importing it does a full JTAG flash probe as
a side effect — which kills the shared UART and killed one attempt before it
reached its own `open()`. Strip that last line (`ecp5wpq.py`) and **open the log
before any import that can touch JTAG**.

### 🏆 THE FLASH WRITE SUCCEEDED — koti runs from its own flash (2026-08-08)

Sequence that worked, all from the ESP32:
1. `flash_open()`; `0x06` (WREN); `0x01 0x00` (status register = 0, BP=0)
2. confirm `BP == 0` by re-reading `0x05` **before** writing anything
3. `ecp5.flash("koti-bram.bit.gz", close=False)`, then `ecp5.flash_close()`

Result on COM3, unprompted, with nothing driving the board:
```
Koti-1: hello from my own SoC #507 0123456789 abcdefghijklmnopqrstuvwxyz
   ... 62 banner lines in a 45 s listen, counter at #580 and climbing
```
⭐ The counter was already at **507** when the listen began — koti had been
running since `LSC_REFRESH`, unattended. And the follow-up REPL read **failed**,
which is the confirming detail rather than a problem: **koti holds the ESP32 in
reset via `wifi_en = 0`**, so the ESP32 goes quiet exactly when the FPGA is
alive. The two are mutually exclusive on this board, by design.

### 🏆🔌 COLD BOOT CONFIRMED — koti IS STANDALONE (2026-08-08)

Power pulled and restored, **no bitstream loaded, nothing attached but 5 V**:
```
bytes: 1169   banner lines: 16   non-printable: 0
counter range: #51 -> #66        (gapless)
```
⭐ **The counter restarts low.** The pre-power-cycle run was at **#580**, so #51
is a fresh boot rather than a session that never stopped — that is the check
that makes this a cold-boot proof and not a restatement of the `LSC_REFRESH`
result. **The ECP5 configured itself from its own flash at power-on.**

⇒ **The ~60 s `fujprog` on every power-up is GONE.** Reflashing is now only
needed to change the bitstream.

### ⭐⭐ `fujprog -j flash` WORKS NOW — the ESP32 was only ever the diagnosis

With `BP=0` the original command simply succeeds:
```
fujprog.exe -j flash koti-bram.bit     ->  Completed in 142.09 seconds.
```
No `TDO ... Expected`, no `Operation not permitted`, no `Failed.` **Block
protection was the only thing ever wrong with it.**

⇒ **THE STANDARD WAY TO UPDATE koti PERSISTENTLY IS NOW ONE COMMAND:**
```
~/opt/oss-cad-suite/bin/fujprog.exe -j flash <bitstream>.bit   # ~142 s
```
The entire ESP32/`ecp5.py`/MicroPython apparatus was scaffolding to find one
status-register bit. It is not needed for routine work — keep it only as the
tool that can read and change flash protection.

⚠️ **BUT THE ESP32 IS NOW LOCKED OUT AT POWER-ON.** koti self-configures from
flash in ~1 s and drives `wifi_en = 0`, so the ESP32 never boots. To reach it
again you must SRAM-load something that leaves `wifi_en` alone — and note
`console.bit` releases the ESP32 but **drives the FTDI line itself**, so the
ESP32 is *running but inaudible*. Reaching the MicroPython REPL again needs a
**passthru bitstream**, not console.bit. Budget for that before planning any
future ESP32 work.

### 🏆🐧🔌 STANDALONE LINUX — cold boot to a login prompt (2026-08-08)

`image: sbi` bitstream in the config flash (written by `fujprog -j flash`), DIP
**SW3 ON**, microSD in, power pulled and restored, **nothing loaded**:
```
[  41.392758] koti-sd 50000.mmc: 61067264 sectors (29818 MiB), read-only
[  44.773161] Run /init as init process
Linux buildroot 6.12.0 #1 Fri Aug  7 21:04:58 UTC 2026 riscv32 GNU/Linux
koti: userspace is alive
Welcome to Buildroot
buildroot login:
```
⇒ The board configures itself from its own flash, the SBI firmware transports
the kernel off the microSD, sv32 Linux comes up on the 32 MB SDRAM and reaches
userspace — **with no PC in the loop except as a power supply and a terminal.**

Two observations from that boot, neither blocking:
- `Starting network: ip: socket: Function not implemented … FAIL` — **expected**,
  there is no `CONFIG_NET`. Ladder item 11.
- ✅ **`MemTotal: 8796 kB` — FIXED 2026-08-08, in simulation. Now 25004 kB.**
  It was architectural, not a devicetree typo: `d_addr = byte_addr[24:2]` with
  **`addr[22]` spent as the flash/RAM device select**, so only `addr[21:0]` —
  4M words = 16 MB — ever reached the SDRAM, and `koti.dts` was CORRECT for the
  hardware as built.
  The word address is 24 bits now (PA[25:2]) and the select is `a[23:22] != 00`,
  so RAM spans 0x0100_0000..0x02FF_FFFF. **RAM's base did not move**: it is
  exactly half the window size, which makes the offset `a - 0x400000` collapse
  to `{a[23], a[21:0]}` — a bit selection, no adder — so both linker scripts,
  `KERNEL_ADDR`, `sdboot.c`, `sdkernel.py`, `ktrace.py` and `tb_boot`'s
  `+ramoff` were all left alone. Only the DTS length changed.
  `Memory: 23996K/28672K available`, MemFree 3296 → 19452 kB, userspace still
  reached; `sw/memtest.bin` walks all 32 MB with 0 errors under Verilator.
  🏆 **CONFIRMED ON THE BOARD 2026-08-08.** `image: memtest` (SW3 **off** — it
  never touches video, so its console is `uo[0]`): **eight consecutive clean
  passes** over the full 32 MB, `addrbits: OK` / `16M: OK` / `upper: OK` /
  `pass N CLEAN, errors: 0`, 0 non-printable bytes. Then `image: sbi` (SW3
  **on**): `MemTotal: 25020 kB`, `MemFree: 19412 kB`, `buildroot login:`.
  📌 Boot cost ~0.65% — `Run /init` at 45.02 s against 44.73 s at 16 MB, the
  kernel initialising twice the page structs.
  🔌 **AND IT IS THE STANDALONE MACHINE**: `fujprog -j flash` (142.72 s), power
  pulled and restored, nothing loaded over JTAG ⇒ `MemTotal: 25020 kB`,
  `MemFree: 19424 kB`, `buildroot login:`.
  🪤 **A power cycle REMOVES COM3.** The FT231X is bus-powered from the same
  USB, so a capture holding the port open across one dies with
  `PermissionError: ClearCommError failed` — which reads as a crashed tool and
  is nothing of the sort. `fpga/ulx3s/waitboot.py` waits for the port to
  re-enumerate and then captures; use it for cold boots, and `boottime.py` for
  SRAM loads.
- ✅ `koti-sd … read-only` — **COSMETIC, and already fixed in git. The card is
  writable.** The kernel on the card was built **21:04:58 UTC**, which is 2m26s
  *after* the write half landed (`a235672`, 21:02:32) and 17 min *before* the
  stale log line was deleted (`3b1dd30`, 21:22:11, "koti can save a file, and
  the log line should not say otherwise"). So that image has working writes and
  an obsolete `dev_info`. Re-transport a current kernel and the line goes away.
  ⛔ **A microSD has NO write-protect slider** — only full-size SD cards do, so
  never explain this one with card hardware.

⚠️ **UPSTREAM `jtagpin.py` IS WRONG FOR THIS BOARD.** emard/esp32ecp5 ships the
v3.0.x block uncommented; this is a **v3.1.8**, where `tms` moves 21 -> 5 and
`tdo` moves 19 -> 34. Wrong pins give a garbage IDCODE, which reads exactly like
a dead JTAG chain. Use the v3.1.x block.

⛔ **CORRECTION, same day: "the blocker is the factory firmware" was WRONG, and
so was the plan to reflash it.** Upstream's own README heads its install section
**"# micropython 1.14 (recommended)"** — the stock image is the *recommended*
version, and 1.25 is the one where "flashing doesn't work". What differs is
**which `ecp5.py`**: for 1.14 upstream installs `upip.install("esp32ecp5")`,
i.e. the **PyPI release (1.0.12)**, not git master. The relevant diff is in
`flash_read_block`:

| | 1.0.12 (pairs with 1.14) | git master |
| --- | --- | --- |
| flash reads | `swspi` — **SoftSPI** | `hwspi` + `hwspi.init(sck=...)` re-init |

⇒ master added hardware-SPI acceleration on the exact path that killed this
board. **Use PyPI 1.0.12 on MicroPython 1.14.** Do not reflash the ESP32 for
this; that step was proposed on a wrong diagnosis and is not needed.

✅ **The v3.1.x pinout is confirmed by upstream's README**, not just inferred:
`tms=5, tck=18, tcknc=21, tdi=23, tdo=34, led=19`. `tcknc` is a deliberately
unconnected pin that `tck` is parked on while switching between bitbanging and
hardware SPI, because that switch can glitch the clock line.

✅ **Nothing on the board was written.** Only reads were attempted; both flash
chips are untouched. The ESP32's filesystem gained `ecp5.py` and `jtagpin.py`,
which are two deletable files.

✅ **`console.bit` IS THE RECOVERY BITSTREAM, and it is now proven.** It drives
`wifi_gpio0 = 1'b1` ("keep the ESP32 booted") and **never assigns `wifi_en`**,
where koti drives `wifi_en = 0` on J5 and holds the ESP32 in reset. So a koti in
the config flash can always be displaced. ⚠️ It does not make the ESP32
*audible* — console drives the FTDI line itself. To hear the ESP32 the FPGA must
be **unconfigured**, i.e. power-cycled with no bitstream loaded.

✅ **The two flash chips are SEPARATE, so writing the FPGA's config flash cannot
brick the ESP32.** The ESP32's flash reports manufacturer `a1` and carries its
bootloader at `0x1000` and its partition table at `0x8000`; the board's FPGA
config flash is the `IS25LP128F` (ISSI, `9d`). Decisively: `ecp5.flash()` runs
*out of* the ESP32's own flash while writing the FPGA's, which would be suicide
on one shared chip.

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
