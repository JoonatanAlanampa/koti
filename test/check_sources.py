#!/usr/bin/env python3
"""check_sources.py — the source lists and src/ must agree.

WHY THIS EXISTS, and it is not hypothetical. This repo keeps FOUR independent
lists of RTL files, and on 2026-08-08 two separate CI failures came from the
same shape of mistake in one session:

  * PS/2 was deleted and `fpga/ulx3s/sources.txt` + `test/Makefile` still named
    `src/ps2_rx.sv`. `fpga-ulx3s` and `test` both died on "File not found".
  * `src/dcache.sv` was added and `test/run_fpga.py` was not told, so the ULX3S
    harness died on "Unknown module type: dcache".

Both were found by CI rather than before a push, and the second happened after
the first had already been diagnosed — the lesson did not stick because there
was nothing to make it stick. This is that something.

⚠️ THE SEARCH THAT MISSED THEM IS WORTH RECORDING TOO. A `grep -r --include=*.sv
--include=*.py ...` is readable and fast and CANNOT SEE `test/Makefile`, which
has no extension. The files whose whole job is to list sources are exactly the
ones an extension filter hides.

Two directions, and both have bitten:
  MISSING  a file in src/ that a list should name but does not  -> "Unknown
           module type" at elaboration.
  STALE    a name in a list with no file behind it              -> "File not
           found", and the build stops before anything runs.

Not every list names every file, and that is legitimate: `test/Makefile` and
`test/run.py` build the ASIC variant, which has no block RAM and therefore none
of the KOTI_FPGA-only modules. So FPGA-only files are checked against the FPGA
lists only. That exception is data below, not a special case in the code.

    python test/check_sources.py

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"

# Kept for the record: these five were once compiled only into the ULX3S build,
# behind `ifdef KOTI_FPGA`, because a TinyTapeout tile had no block RAM and no
# pins for a card or a keyboard. koti became FPGA-only on 2026-08-08, the second
# configuration was deleted, and every list must now name every module — so this
# set no longer excludes anything. It is left here because the NEXT question
# about a source list is usually "why would a file be missing from one?".
FPGA_ONLY = {"sdram_ctrl.sv", "icache.sv", "dcache.sv", "sd_ctrl.sv",
             "usb_kbd.sv"}

# Files that are not modules the SoC instantiates.
NOT_A_MODULE = {"font_rom.svh"}


def names_in(path, pattern):
    text = path.read_text(encoding="utf-8", errors="replace")
    return set(re.findall(pattern, text))


def main():
    on_disk = {p.name for p in SRC.glob("*.sv")} - NOT_A_MODULE

    lists = {
        "fpga/ulx3s/sources.txt": (
            names_in(ROOT / "fpga/ulx3s/sources.txt", r"src/(\w+\.sv)"), True),
        "test/run_fpga.py": (
            names_in(ROOT / "test/run_fpga.py", r'SRC_DIR / "(\w+\.sv)"'), True),
    }

    bad = []
    print(f"src/ holds {len(on_disk)} modules "
          f"({len(FPGA_ONLY)} of them FPGA-only)")

    for name, (listed, is_fpga) in lists.items():
        # STALE: named but not present. Always wrong, in every list.
        stale = sorted(listed - on_disk)
        # MISSING: present but not named. Only meaningful for the FPGA lists,
        # which are the ones that must be complete.
        want = on_disk if is_fpga else on_disk - FPGA_ONLY
        missing = sorted(want - listed)

        flag = "FAIL" if (stale or missing) else "ok  "
        print(f"  {flag} {name}: {len(listed)} listed")
        for f in stale:
            print(f"         STALE  {f} is named here but is not in src/")
            bad.append(f"{name} names {f}, which does not exist")
        for f in missing:
            print(f"         MISSING {f} is in src/ but not named here")
            bad.append(f"{name} does not name {f}")

    if bad:
        print(f"\ncheck_sources: FAIL ({len(bad)})")
        for b in bad:
            print(f"  - {b}")
        sys.exit(1)
    print("\ncheck_sources: PASS")


if __name__ == "__main__":
    main()
