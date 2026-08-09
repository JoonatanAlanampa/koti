# screenshot.py — render what koti's video output actually shows, from text.
#
#   python tools/screenshot.py session.txt out.png [--title "..."]
#
# ⚠️ THIS IS A RECONSTRUCTION, NOT A PHOTOGRAPH, and the README says so where it
# uses the output. Nobody has a frame grabber on the GPDI link. What makes it
# faithful rather than an artist's impression is that every pixel is decided by
# three things that are all in this repo:
#
#   1. src/font_rom.svh   the ACTUAL glyph bitmaps the hardware scans out,
#                         parsed here rather than redrawn
#   2. src/vga_text.sv    the cell geometry and the character folding
#   3. sw/console.c       the 80x60 wrap and scroll rules
#
# and the TEXT is the real UART capture from the machine, which carries exactly
# the same bytes as the screen because SBI console_putchar calls putc_both().
#
# THREE THINGS THAT WOULD MAKE IT A LIE IF GOT WRONG, all taken from the RTL:
#
#   * LOWERCASE RENDERS AS UPPERCASE. vga_text.sv does
#         chf = ch          (no transformation since 2026-08-08)
#     and the ROM holds all 96 glyphs of 0x20..0x7F. Until then it folded
#     0x60..0x7F onto 0x40..0x5F, for die area on an 8x2 tile.
#     koti's screen genuinely has no lowercase glyphs.
#   * A CELL IS 16x16 SCREEN PIXELS, not 8x8: the scan-out indexes the font with
#     x[2:0] and y[2:0], i.e. every font pixel is 1:1. 80x8 = 640,
#     60x8 = 480. ⚠️ It was 40x30 with pixels DOUBLED until 2026-08-09;
#     a reconstruction still assuming that renders half a screen at twice
#     the size and looks entirely plausible.
#   * BIT 0 IS THE LEFTMOST PIXEL (font_rom.svh says so in its header), and row
#     `fr` is g[fr*8 +: 8].
#
# Colours are the firmware's: VGA_COLOR = 0x3F = white on black (console.c).
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
import argparse
import re
from pathlib import Path

# ⚠️ PIL is imported INSIDE render(), not here. `load_font()` and `fold()` are
# pure parsing of src/font_rom.svh and src/vga_text.sv, and test/test_font.py
# uses exactly those two to check that the committed ROM still matches its
# generator. Importing an imaging library at module scope made that test
# unrunnable anywhere Pillow is not installed — which is the `test` CI job, so
# it went red on a machine that had nothing to do with images.

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / "src" / "font_rom.svh"

COLS, ROWS = 80, 60
CELL = 8            # font pixels
SCALE = 2           # the hardware doubles every pixel: x[3:1], y[3:1]

FG = (255, 255, 255)
BG = (0, 0, 0)


def load_font():
    """Parse the generated font ROM. Not redrawn — the hardware's own bitmaps."""
    text = FONT.read_text(encoding="utf-8", errors="replace")
    glyphs = {}
    for m in re.finditer(r"8'h([0-9A-Fa-f]{2}):\s*g\s*=\s*64'h([0-9A-Fa-f]{16});", text):
        code = int(m.group(1), 16)
        g = int(m.group(2), 16)
        # font_row(ch, fr) = g[fr*8 +: 8]
        glyphs[code] = [(g >> (fr * 8)) & 0xFF for fr in range(CELL)]
    if not glyphs:
        raise SystemExit(f"no glyphs parsed from {FONT}")
    return glyphs


def fold(ch):
    """No fold since 2026-08-08 — vga_text.sv passes the character through.

    It used to be `(ch[6:5] == 2'b11) ? ch - 0x20 : ch`, mapping lowercase onto
    uppercase because the ROM only held 0x20..0x5F. The ROM carries all 96
    glyphs now, so this is the identity and lowercase renders as lowercase.

    ⚠️ Kept as a function rather than deleted at the call site: this file's
    whole claim is that it models the HARDWARE, so the place where the hardware
    once transformed a character is where a future transformation belongs. If
    vga_text.sv ever maps characters again, it goes here.
    """
    return ch


def lay_out(text):
    """sw/console.c's con_putc, exactly: \\n moves down, \\r homes, wrap at 80,
    scroll at 60. Anything else is dropped rather than guessed at."""
    buf = [[0x20] * COLS for _ in range(ROWS)]
    x = y = 0

    def scroll():
        buf.pop(0)
        buf.append([0x20] * COLS)

    for chr_ in text:
        c = ord(chr_)
        if c == 0x0A:
            x, y = 0, y + 1
        elif c == 0x0D:
            x = 0
        elif 0x20 <= c < 0x80:
            buf[y][x] = c
            x += 1
            if x == COLS:
                x, y = 0, y + 1
        else:
            continue            # control bytes never reach the charbuf as glyphs
        if y == ROWS:
            scroll()
            y = ROWS - 1
    return buf


def render(buf, glyphs, zoom):
    from PIL import Image          # see the note at the top of the file

    w, h = COLS * CELL * SCALE, ROWS * CELL * SCALE
    img = Image.new("RGB", (w, h), BG)
    px = img.load()
    for cy in range(ROWS):
        for cx in range(COLS):
            rows = glyphs.get(fold(buf[cy][cx]))
            if not rows:
                continue
            for fr in range(CELL):
                bits = rows[fr]
                if not bits:
                    continue
                for fx in range(CELL):
                    if (bits >> fx) & 1:        # bit 0 = leftmost
                        x0 = (cx * CELL + fx) * SCALE
                        y0 = (cy * CELL + fr) * SCALE
                        for dy in range(SCALE):
                            for dx in range(SCALE):
                                px[x0 + dx, y0 + dy] = FG
    if zoom > 1:
        img = img.resize((w * zoom, h * zoom), Image.NEAREST)
    return img


def main():
    ap = argparse.ArgumentParser(
        description="Render koti's 80x60 text screen from captured console text.")
    ap.add_argument("text", help="a file of console text (a real UART capture)")
    ap.add_argument("out")
    ap.add_argument("--zoom", type=int, default=1,
                    help="integer upscale, NEAREST so pixels stay square")
    args = ap.parse_args()

    glyphs = load_font()
    buf = lay_out(Path(args.text).read_text(encoding="utf-8", errors="replace"))
    img = render(buf, glyphs, args.zoom)
    img.save(args.out)
    print(f"{args.out}: {img.width}x{img.height}, {len(glyphs)} glyphs from "
          f"{FONT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
