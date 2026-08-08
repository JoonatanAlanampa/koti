# Make koti standalone — resume here

**On "proceed", execute this file.** Everything below is established fact,
measured on 2026-08-08, not plan.

## The goal

koti boots from 5 V alone: plug in USB power, no PC, no `fujprog`. Today it
needs a ~60 s SRAM flash on every power-up.

## ⭐ THE PLAN CHANGED — DO NOT FLASH THE ESP32's FIRMWARE

The earlier plan was "replace the factory MicroPython with EMARD's ULX3S build,
which ships `ecp5.py`". **That is more risk than the job needs.**

`ecp5.py` is **pure MicroPython** — it bit-bangs the ECP5 config protocol over
`machine.Pin`/`SPI`. It does not need a special firmware; it needs to be a file
on the filesystem. So:

1. Upload **`ecp5.py`** (a few KB) to the ESP32's filesystem.
2. Upload **`koti-bram.bit.gz`** (308,806 bytes — the bitstream gzips to 16%).
   `uzlib` is already on the stock image.
3. Write **`main.py`** that imports `ecp5` and configures the FPGA at boot.
4. Power-cycle. koti should come up on its own.

⇒ **No firmware overwrite, so nothing irreversible.** If it does not work, delete
three files. The factory backup (below) stays the safety net but should not be
needed.

## Established facts — do not re-derive

- **esptool reaches the ESP32 directly. NO passthru bitstream is needed.**
  Measured: `esptool --port COM3 chip-id` -> `ESP32-D0WD-V3 (rev v3.1)`,
  MAC `c8:85:41:c9:ce:f0`, stub flasher uploaded and ran. This was the
  blocker that made the ESP32 route look expensive; it is not real.
- ⚠️ **The FPGA must be UNCONFIGURED to reach the ESP32.** koti drives
  `wifi_en` low, which disables it. Power-cycle and load NO bitstream. That is
  also why the serial port shows MicroPython after a power cycle and koti after
  an SRAM load — the two take turns on one FT231X.
- The ESP32's flash is **16 MB** (`a1`/`4018`). Filesystem holds only
  `boot.py`, **2,084,864 bytes free**. Stock **MicroPython 1.14**, and
  `import ecp5` -> ImportError, so the module must be supplied.
- Bitstream: **1,976,403 bytes raw, 308,806 gzipped (16%)**, ~25 s to upload at
  115200. Source: `koti-fpga-bram` artifact of a green `fpga-ulx3s` run
  (31253084532 at `2bd7183` is known good).
- ⭐ **Factory backup exists**: `Documents/ulx3s-backup/` —
  `esp32-factory-16MB-2026-08-08.bin`, 16,777,216 bytes, sha256
  `8e8df9bc3e3bf4f4564271964db0952f9ede91a59f05afe9f8e587eee03ee323`, `0xE9`
  magic verified, with a README carrying the restore command.
- Tools: `esptool.exe` at
  `C:/Users/JOONAT~1/AppData/Local/Temp/esptool/esptool-windows-amd64/esptool.exe`
  (v5.3.1; re-download if temp was swept). `fujprog.exe` at
  `~/opt/oss-cad-suite/bin/`.

## Steps

1. **Get `ecp5.py`.** It lives in EMARD's ULX3S MicroPython work (search
   `emard ulx3s micropython ecp5.py`). ⚠️ Verify the PIN NUMBERS in it match
   this board — a v3.1.8 — before trusting it. If no usable copy is findable,
   say so rather than writing an ECP5 config protocol from scratch unasked.
2. **Talk to MicroPython**: power-cycle (ask the user — only they can), then
   COM3 at 115200. Ctrl-C twice first; the REPL auto-indents and a mangled
   multi-line paste leaves it stuck at `...`.
3. **Upload.** Do NOT paste 300 KB through the REPL line by line. Use
   MicroPython's **raw-paste mode** or write a small chunked base64 uploader.
   Verify by size and hash on the device, not by "it seemed to work".
4. **`main.py`** -> configure the FPGA from the gzipped bitstream.
5. **Power-cycle and prove it.** ⚠️ The ESP32 owns the UART until the FPGA is
   configured, so the serial port may show MicroPython first and koti after.
   **The LEDs are the honest check** and the user must read them: with SW4 off
   they show raw `uo`, so LED0 = UART idling high, LED1 = HALTED (dark is good),
   LED2..LED7 = the line counter advancing. In the FLASH_BRAM variant `led[7]`
   is the fabric flash's `bad_cmd`, so a dark LED7 is a PASS.
   Then read COM3 for `Koti-1: hello from my own SoC #<n>`.

## Rules for this work

- ⛔ **NEVER `git add -A` in this repo.** Another session is working the D-cache
  in `src/dcache.sv`; on 2026-08-08 an `add -A` swept its in-progress `DCDBG`
  debug block into an unrelated commit (`877f833`). Stage explicit paths only.
- Claim **the physical ULX3S** on the session board. The repo itself does not
  need claiming for this work — it is ESP32-side.
- The user must do every power cycle and every LED reading. Ask, do not guess.
- If `ecp5.py` cannot be obtained or its pins do not match, STOP and report.
  koti needing a 60 s flash is a perfectly acceptable state; a half-programmed
  ESP32 is not.

## Board state as of 2026-08-08

COM3, SW3 **off**, SW4 off, **FPGA unconfigured**, ESP32 running factory
MicroPython. Reload koti any time:
`~/opt/oss-cad-suite/bin/fujprog.exe <koti-bram.bit>` (~60 s).
⛔ `fujprog -j flash` does NOT work on this board — see `fpga/ulx3s/README.md`.
