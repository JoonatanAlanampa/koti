#!/usr/bin/env python3
"""check_mmio.py — the MMIO windows project.sv decodes must be windows
koti_core.sv lets software WRITE to.

WHY THIS EXISTS, AND IT IS NOT A STYLE CHECK. Adding a peripheral to koti takes
two edits in two files:

    src/project.sv     wire xxx_range = d_addr[23:14] == 10'h0NN;   <- decode
    src/koti_core.sv   wire pa_dev = ... d_pa[23:16] <= 8'hNN ...   <- may write

With only the first, READS work perfectly and the first WRITE takes a store
access fault. On a machine whose mtvec is still zero that restarts the program,
so the symptom is "the board resets when I touch the new peripheral" — a reset
bug, a clock bug, a power bug, anything but a missing comparison in a different
file. It has bitten three times on this project: the PLIC, then the microSD,
then the ESP32 link. Each time it was found on hardware.

The comment in koti_core.sv has said so since the second occurrence. It was
read, and the third one happened anyway, which is the argument for a gate
rather than a louder comment.

⚠️ WHAT THIS CANNOT DO: it compares two decodes, not two behaviours. It cannot
tell you the window is wired to anything, that the peripheral answers, or that
the ack arrives — only that a window software can read is one software can also
write. That is exactly the gap the three defects fell into.

⛔ SECOND CHECK, ADDED 2026-08-14: EVERY WINDOW MUST BE UNCACHEABLE.
project.sv's `dc_req` is the request that reaches the D-cache, and it is
`d_req` minus every device window. A window missing from that term is NOT
"the register gets cached" — it is a second, unwanted memory transaction that
completes ~130 clocks later and raises a SECOND d_ack, which can complete an
unrelated load with flash data in it. The damage lands nowhere near the
peripheral that caused it.

That is not hypothetical either: the sound window (0x008) was added to the
decode on 2026-08-14 and not to the exclusion list, which at the time was a
hand-written copy of the window names. project.sv now builds ONE `mmio_range`
term and `dc_req` uses it; this check asserts that every `*_range` in the file
is in that term, so the list cannot be forgotten a second time.

Run:  python test/check_mmio.py
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
PROJECT = ROOT / "src" / "project.sv"
CORE = ROOT / "src" / "koti_core.sv"

# `wire foo_range = d_addr[23:14] == 10'h004;`
WINDOW = re.compile(r"wire\s+(\w+_range)\s*=\s*d_addr\[23:14\]\s*==\s*10'h([0-9a-fA-F]+)\s*;")
# `d_pa[23:16] >= 8'h01 && d_pa[23:16] <= 8'h08`
BOUNDS = re.compile(r"d_pa\[23:16\]\s*>=\s*8'h([0-9a-fA-F]+)\s*"
                    r"&&\s*d_pa\[23:16\]\s*<=\s*8'h([0-9a-fA-F]+)")
# Any window wire, whatever shape its comparison has. `plic_range` is not a
# 64 KB window (the SiFive layout needs 4 MB) and so does not match WINDOW
# above — but it is just as uncacheable, which is why the second check
# enumerates from here instead.
ANY_RANGE = re.compile(r"^\s*wire\s+(\w+_range)\s*=", re.MULTILINE)
# `wire mmio_range = a || b || ...;` — the term, up to its semicolon.
MMIO_TERM = re.compile(r"wire\s+mmio_range\s*=(.*?);", re.DOTALL)
# `wire dc_req = ...;`
DC_REQ = re.compile(r"wire\s+dc_req\s*=(.*?);", re.DOTALL)


def main() -> int:
    project = PROJECT.read_text(encoding="utf-8", errors="replace")
    core = CORE.read_text(encoding="utf-8", errors="replace")

    windows = [(m.group(1), int(m.group(2), 16)) for m in WINDOW.finditer(project)]
    if not windows:
        print("FAIL: no `d_addr[23:14] == 10'hNNN` windows found in src/project.sv.")
        print("      The decode moved; this check is now blind and must be updated.")
        return 1

    m = BOUNDS.search(core)
    if not m:
        print("FAIL: no `d_pa[23:16] >= 8'hNN && <= 8'hNN` bound found in src/koti_core.sv.")
        print("      pa_dev moved; this check is now blind and must be updated.")
        return 1
    lo, hi = int(m.group(1), 16), int(m.group(2), 16)

    print(f"pa_dev writable window range: 0x{lo:02x}..0x{hi:02x}")
    bad = []
    for name, win in sorted(windows, key=lambda w: w[1]):
        # The window number is d_addr[23:14]'s value; its top 8 bits are what
        # pa_dev compares, i.e. the same hex digits for a 64 KB-aligned window.
        page = win
        ok = lo <= page <= hi
        print(f"  {'ok  ' if ok else 'FAIL'} {name:<12} 0x{page:03x}"
              f"{'' if ok else '   <- decoded but NOT writable'}")
        if not ok:
            bad.append((name, page))

    if bad:
        print()
        print("FAIL: %d MMIO window(s) software can read but cannot write."
              % len(bad))
        print("      Widen the bound in src/koti_core.sv's pa_dev, or the first")
        print("      store to that peripheral takes an access fault and the")
        print("      machine appears to reset.")
        return 1

    print("\nevery decoded MMIO window is writable")
    return check_uncacheable(project)


def check_uncacheable(project: str) -> int:
    """Every `*_range` must be in `mmio_range`, and `dc_req` must use it."""
    print()
    ranges = {m.group(1) for m in ANY_RANGE.finditer(project)} - {"mmio_range"}
    if not ranges:
        print("FAIL: no `wire *_range =` declarations in src/project.sv.")
        print("      The decode moved; this check is now blind.")
        return 1

    term = MMIO_TERM.search(project)
    if not term:
        print("FAIL: src/project.sv has no `wire mmio_range = ...;`.")
        print("      That term is the single list of device windows, and")
        print("      test and design both depend on it existing by that name.")
        return 1

    named = set(re.findall(r"\w+_range", term.group(1)))
    print(f"mmio_range names {len(named)} of {len(ranges)} window wires")
    missing = sorted(ranges - named)
    for r in sorted(ranges):
        print(f"  {'ok  ' if r in named else 'FAIL'} {r}"
              f"{'' if r in named else '   <- NOT excluded from the D-cache'}")

    dc = DC_REQ.search(project)
    if not dc:
        print("FAIL: src/project.sv has no `wire dc_req = ...;` to check.")
        return 1
    dc_body = dc.group(1)
    strays = sorted(set(re.findall(r"\w+_range", dc_body)) - {"mmio_range"})

    if missing or strays or "mmio_range" not in dc_body:
        print()
        if missing:
            print(f"FAIL: {len(missing)} window(s) missing from mmio_range: "
                  f"{' '.join(missing)}")
        if "mmio_range" not in dc_body:
            print("FAIL: dc_req does not use mmio_range. It must, or the two")
            print("      lists drift — which is how the sound window became")
            print("      cacheable on 2026-08-14.")
        if strays:
            print(f"FAIL: dc_req names windows directly: {' '.join(strays)}. "
                  f"Use mmio_range only.")
        print()
        print("      A cacheable device window means the D-cache ALSO accepts")
        print("      the access, runs a transaction to flash, and raises a")
        print("      second d_ack ~130 clocks later. That stray ack can")
        print("      complete an unrelated load with the wrong data.")
        return 1

    print("\nevery decoded MMIO window is excluded from the D-cache")
    return 0


if __name__ == "__main__":
    sys.exit(main())
