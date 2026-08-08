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

    python fpga/ulx3s/boottime.py --port COM3 --out cached.log
    python fpga/ulx3s/boottime.py --port COM3 --out plain.log --compare cached.log

⚠️ The board must be power-cycled (or reconfigured) AFTER this starts listening,
or the boot it is timing has already happened. It waits for the first byte, so
starting it first and then applying power is the correct order.

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
    args = ap.parse_args()

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
