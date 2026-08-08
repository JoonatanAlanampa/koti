#!/usr/bin/env python3
"""test_font.py — the font ROM the hardware scans out is the font we think it is.

WHY THIS EXISTS. `src/font_rom.svh` is GENERATED, committed, and read by two
independent consumers that must agree: `src/vga_text.sv` scans it out through
the font ROM in fabric, and `tools/screenshot.py` parses it to reconstruct what
the monitor shows for the README. Nothing checked either of them.

That mattered on 2026-08-08, when lowercase was added. The glyph art had been in
`tools/genfont.py`'s table the whole time — all 96 glyphs of 0x20..0x7F — and
the GENERATOR was dropping everything from 0x60 up, because `vga_text.sv` folded
lowercase onto uppercase to save die area on an 8x2 TinyTapeout tile. Removing
the fold without regenerating the ROM, or regenerating without removing the
fold, both produce a machine that renders the wrong thing and no test fails.

WHAT IT CHECKS, and each is a way that has actually been possible to get wrong:

  1. The committed ROM matches what genfont.py would emit today. A ROM edited by
     hand, or left stale after a table change, is otherwise invisible.
  2. Lowercase is present and DISTINCT from uppercase. `a` rendering as `A` was
     the old behaviour, and it is not detectable from a glyph count alone.
  3. screenshot.py's reconstruction applies the same character mapping as the
     RTL. It models the fold deliberately, so a fold removed in one place and
     not the other makes the README show a screen the board never displays.

    python test/test_font.py

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import screenshot                                    # noqa: E402
from genfont import FONT, render                     # noqa: E402

fails = []


def check(ok, what, detail=""):
    if ok:
        print(f"  ok   {what}")
    else:
        print(f"  FAIL {what}{(': ' + detail) if detail else ''}")
        fails.append(what + ((": " + detail) if detail else ""))


def main():
    print("test_font:")

    svh = (ROOT / "src" / "font_rom.svh").read_text(encoding="utf-8",
                                                    errors="replace")

    # ---- 1. the committed ROM is what the generator produces now ------------
    # Compared as the parsed glyph table rather than as text, so that a comment
    # or formatting change is not a failure while a changed BITMAP always is.
    rom = screenshot.load_font()
    check(len(rom) == len(FONT),
          f"ROM holds every glyph in the table ({len(rom)} of {len(FONT)})")
    wrong = [f"0x{c:02X}" for c, rows in FONT.items() if rom.get(c) != rows]
    check(not wrong, "every ROM glyph matches genfont.py's table",
          f"differs at {', '.join(wrong[:8])} - regenerate with "
          f"`python tools/genfont.py`" if wrong else "")

    # ---- 2. lowercase exists and is not uppercase --------------------------
    missing = [chr(c) for c in range(0x61, 0x7B)
               if not rom.get(c) or not any(rom[c])]
    check(not missing, "all 26 lowercase letters are drawn",
          f"blank or absent: {''.join(missing)}" if missing else "")
    same = [chr(c) for c in range(0x61, 0x7B) if rom.get(c) == rom.get(c - 0x20)]
    check(not same, "lowercase glyphs differ from their uppercase",
          f"identical bitmaps for {''.join(same)} - the uppercase fold is back"
          if same else "")

    # ---- 3. the reconstruction models the same hardware --------------------
    # screenshot.py exists to show what the MONITOR shows. If the RTL maps a
    # character and it does not (or the reverse), the README shows a screen the
    # board never displayed.
    rtl = (ROOT / "src" / "vga_text.sv").read_text(encoding="utf-8",
                                                   errors="replace")
    m = re.search(r"wire\s*\[7:0\]\s*chf\s*=\s*(.+?);", rtl, re.S)
    check(m is not None, "vga_text.sv still has a `chf` mapping to compare against")
    if m:
        rtl_identity = m.group(1).strip() == "ch"
        py_identity = all(screenshot.fold(c) == c for c in range(0x20, 0x80))
        check(rtl_identity == py_identity,
              "screenshot.py's fold() agrees with vga_text.sv's chf",
              f"RTL maps characters: {not rtl_identity}; "
              f"screenshot.py maps characters: {not py_identity}")

    # ---- 4. the generator is reproducible ----------------------------------
    # `render()` is what wrote the file; if it no longer produces it, the
    # committed ROM came from a version of the generator that no longer exists.
    check(render().strip() == svh.strip(),
          "genfont.py reproduces the committed font_rom.svh byte for byte")

    print()
    if fails:
        print(f"test_font: FAIL ({len(fails)})")
        for f in fails:
            print(f"  - {f}")
        return 1
    print("test_font: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
