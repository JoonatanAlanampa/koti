# Make koti standalone — ✅ DONE 2026-08-08

**This work order is COMPLETE. Nothing here is a task any more.** Kept only so
that a session arriving from a stale pointer stops rather than re-runs it.

## What was achieved

**koti boots from 5 V alone.** Phone charger, HDMI monitor, USB keyboard in US2,
microSD in the slot — power on, ~45 s, log in as root. No PC in the loop.

| | proof |
| --- | --- |
| standalone boot | cold power-cycle, nothing loaded, banner counter `#51 -> #66` |
| standalone **Linux** | `Run /init` / `koti: userspace is alive` / `buildroot login:` |
| HDMI | full boot log on a real monitor, 40x30, no framebuffer driver |
| USB keyboard | typed `root` and logged in, on charger power |

## The one fact that mattered

🔴 **The ECP5's config flash was WRITE-PROTECTED.** `status_reg = 0x18` ⇒
**BP=6, TBS=1**, protecting `0x000000-0x1FFFFF` on the ISSI **IS25LP128** — and
koti's bitstream is 1.88 MB, entirely inside it. Clearing `BP` was the whole
fix.

⛔ **Four tool-level theories were investigated and ALL FOUR WERE WRONG**: that
fujprog was at fault, that the ESP32 contended for JTAG (refuted by measurement
— identical failure with the ESP32 in `deepsleep`), that MicroPython 1.14 was
too old (upstream *recommends* 1.14), and that `ecp5.py` needed a different
version. When two independent tools fail identically at the same operation, the
thing they share is the hardware. **Ask the chip why it is refusing before
blaming the tools** — `ecp5wp.py` reads that register and took ninety seconds.

## How to update koti now — one command

```
~/opt/oss-cad-suite/bin/fujprog.exe -j flash <bitstream>.bit    # ~142 s
```
Works because `BP=0` now. ⛔ `fujprog`, never `openFPGALoader`.
The whole ESP32 / `ecp5.py` / MicroPython apparatus was scaffolding to find one
status-register bit. Keep it **only** as the tool that can read and change flash
protection; it is not needed for routine work.

## Traps this left behind

- ⚠️ **The ESP32 is LOCKED OUT at power-on** — koti self-configures in ~1 s and
  drives `wifi_en = 0`. `console.bit` releases it but **drives the FTDI line
  itself**, so the ESP32 comes up *running but inaudible*. Reaching the
  MicroPython REPL again needs a **passthru bitstream**.
- ⚠️ **Connect HDMI BEFORE applying power** — there is no hotplug detect.
- ⚠️ The `sbi` image needs **DIP SW3 ON**.
- ⛔ **Never call `ecp5wp.is25lp128_protect()`, not even as `protect(0)`** — it
  writes the function register, whose upstream comment is *"OTP warning: once
  set, can't be reset!"*. Unprotect via status register 1 only (`0x06`, then
  `0x01 0x00`); reversible with `0x01 0x18`.
- ⚠️ **`import ecp5wp` runs `detect()`** as a module-level side effect, which
  kills the shared UART. Strip that last line before importing it.
- ⭐ **When driving JTAG from the ESP32, LOG TO A FILE ON THE ESP32.** The FTDI
  line is shared with the FPGA and goes dark the instant `common_open()` erases
  the FPGA's configuration. Listening on the UART destroys the evidence and
  costs a power cycle per attempt. The ESP32 never once crashed.

The measurements behind it are in the commit history.
