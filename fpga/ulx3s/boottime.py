#!/usr/bin/env python3
"""boottime.py — time a koti Linux boot on the real board, twice over.

WHY THIS EXISTS. The D-cache was predicted to be 8.9% faster from a SIMULATION
whose memory model is a FLAT latency (`+memlat=9` in test/sim_mem.sv). The real
sdram_ctrl is nothing of the sort — it is cheaper on a row hit and dearer on a
row miss — so the prediction is a hypothesis about hardware, not a measurement
of it. A stopwatch cannot settle an 8.9% difference on a ~49 s boot; this can.

IT REPORTS TWO INDEPENDENT NUMBERS, and they fail in different ways:

  host wall-clock   first received byte -> the login prompt, timed on this PC.
                    Measures the whole machine, including the UART. It does NOT
                    include reset-to-first-byte, because with an SRAM load the
                    design starts the instant configuration ends and the serial
                    port cannot be open across the flash (one FT231X, shared
                    with JTAG). That start point is arbitrary but IDENTICAL for
                    both arms, and everything the cache affects is inside it.

  kernel timestamp  the last `[   12.345678]` printk before the prompt, which
                    the kernel derives from the CLINT timebase ON THE BOARD.
                    Immune to host scheduling, to USB latency and to when the
                    port was opened. If the two disagree by much, believe this
                    one and suspect the serial path.

⚠️ IT ALSO COUNTS BYTES AND NON-PRINTABLES. A boot that got FASTER because it
dropped half its output is not a faster boot, and that is exactly what a memory
bug looks like from a distance. Compare `chars` across arms before believing any
timing: they should match closely, and `bad` should be 0 on both.

    py -3.12 fpga/ulx3s/boottime.py --port COM3 --out cached.log
    py -3.12 fpga/ulx3s/boottime.py --port COM3 --out plain.log --compare cached.log

⚠️ `py -3.12`, not a bare `python`: the `python` first on PATH on this machine
is an agent venv with no pip and no pyserial, and it fails with a bare
ModuleNotFoundError that looks like pyserial was never installed. It is
installed — for 3.12.

⚠️ The board must be power-cycled (or reconfigured) AFTER this starts listening,
or the boot it is timing has already happened. It waits for the first byte, so
starting it first and then applying power is the correct order. `--flash` does
the reconfiguring itself and is the repeatable way to run an A/B:

    py -3.12 fpga/ulx3s/boottime.py --port COM3 --flash cached/koti-bram.bit \
        --out cached.log --label "D-cache"
    py -3.12 fpga/ulx3s/boottime.py --port COM3 --flash plain/koti-bram.bit \
        --out plain.log --label "no cache" --compare cached.log

⚠️ ONE VARIABLE ONLY. Both .bit files must come from the same commit with the
same `image:`, differing solely in `-DKOTI_NO_DCACHE`. The BUILDINFO.txt inside
each fpga-ulx3s artifact is there to be read before trusting a comparison.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import argparse
import re
import sys
import time

PROMPT = b"login:"
# The kernel stamps every printk with seconds since boot. The LAST one before
# the prompt is the kernel's own answer to "how long did this take".
TS = re.compile(rb"\[\s*(\d+\.\d+)\]")


def sram_load(bitfile, fujprog):
    """Configure the FPGA volatilely, then get out of the way of the UART.

    SRAM, deliberately, NOT `-j flash`: the config flash keeps the known-good
    standalone image, so a power cycle is the undo for anything this loads. It
    also costs ~10 s instead of ~142 s per arm.

    ⚠️ The FT231X is ONE device shared by JTAG and the UART, so the serial port
    cannot already be open here — which is why this runs before the capture
    rather than alongside it, and why the first few hundred ms of the SBI banner
    are always lost. That is what the kernel-timestamp metric is for.
    """
    import subprocess
    print(f"fujprog SRAM load: {bitfile}", flush=True)
    r = subprocess.run([fujprog, bitfile], capture_output=True, text=True)
    tail = (r.stdout + r.stderr).strip().splitlines()
    for line in tail[-4:]:
        print(f"  | {line}")
    if r.returncode != 0:
        sys.exit(f"fujprog failed ({r.returncode}) — is the board on and is the "
                 f"serial port closed?")


def capture(port, baud, timeout, out):
    try:
        import serial
    except ImportError:
        sys.exit("pyserial is not installed: python -m pip install pyserial")

    with serial.Serial(port, baud, timeout=0.2) as ser:
        ser.reset_input_buffer()
        print(f"listening on {port} at {baud} — power-cycle the board now", flush=True)
        buf = bytearray()
        t0 = None
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            chunk = ser.read(4096)
            if not chunk:
                continue
            if t0 is None:
                # The clock starts at the FIRST BYTE, not at open().
                t0 = time.monotonic()
                print("first byte — timing from here", flush=True)
            buf += chunk
            if PROMPT in buf:
                # Let the prompt finish arriving rather than cutting mid-line.
                time.sleep(0.3)
                buf += ser.read(4096)
                break
        else:
            print(f"TIMEOUT after {timeout}s — no login prompt", file=sys.stderr)

    elapsed = (time.monotonic() - t0) if t0 else float("nan")
    if out:
        with open(out, "wb") as f:
            f.write(buf)
    return buf, elapsed


def report(buf, elapsed, label):
    stamps = [float(m.group(1)) for m in TS.finditer(buf)]
    printable = sum(1 for b in buf if 32 <= b < 127 or b in (10, 13, 9))
    bad = len(buf) - printable
    got = PROMPT in buf
    print(f"\n=== {label} ===")
    print(f"  login prompt reached : {'yes' if got else 'NO'}")
    print(f"  host wall-clock      : {elapsed:.2f} s  (first byte -> prompt)")
    if stamps:
        print(f"  last kernel timestamp: {stamps[-1]:.6f} s  ({len(stamps)} printks)")
    else:
        print("  last kernel timestamp: none seen — did the kernel run at all?")
    print(f"  chars                : {len(buf)}   non-printable: {bad}")
    return {
        "ok": got,
        "wall": elapsed,
        "kernel": stamps[-1] if stamps else None,
        "chars": len(buf),
        "bad": bad,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", default="COM3")
    ap.add_argument("--baud", type=int, default=115200)
    ap.add_argument("--timeout", type=float, default=180.0)
    ap.add_argument("--out", help="write the raw boot log here")
    ap.add_argument("--label", default="this boot")
    ap.add_argument("--compare", help="a previous --out log to compare against")
    ap.add_argument("--flash", help="SRAM-load this .bit with fujprog first, "
                                    "then time the boot it starts")
    ap.add_argument("--fujprog",
                    default=r"C:\Users\Joonatan Alanampa\opt\oss-cad-suite\bin\fujprog.exe")
    args = ap.parse_args()

    if args.flash:
        sram_load(args.flash, args.fujprog)

    buf, elapsed = capture(args.port, args.baud, args.timeout, args.out)
    now = report(buf, elapsed, args.label)

    if args.compare:
        with open(args.compare, "rb") as f:
            old = f.read()
        prev = report(old, float("nan"), f"{args.compare} (kernel timestamp only)")
        if prev["kernel"] and now["kernel"]:
            d = 100.0 * (prev["kernel"] - now["kernel"]) / prev["kernel"]
            print(f"\n  kernel-time delta: {d:+.2f}% "
                  f"({prev['kernel']:.3f} s -> {now['kernel']:.3f} s)")
        # The check that stops a shorter boot log from reading as a faster boot.
        if abs(now["chars"] - prev["chars"]) > 0.02 * max(prev["chars"], 1):
            print("  ⚠️ THE TWO BOOTS DID NOT PRINT THE SAME AMOUNT — "
                  "compare the logs before believing the timing.")

    sys.exit(0 if now["ok"] else 1)


if __name__ == "__main__":
    main()
