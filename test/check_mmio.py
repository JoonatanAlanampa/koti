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
    return 0


if __name__ == "__main__":
    sys.exit(main())
