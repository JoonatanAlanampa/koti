#!/usr/bin/env python3
"""board_overlay.py — draw the ULX3S's own PCB geometry onto a photo of it.

    python tools/board_overlay.py --pcb ulx3s.kicad_pcb \
        --photo ULX3S_front.jpeg --side top --out docs/img/ds3231-top.jpg

⭐ WHY THIS EXISTS RATHER THAN A DRAWING PROGRAM. "Solder the header here" is
an instruction about twenty specific holes among fifty-six along one edge, and
a picture with the box in roughly the right place is worse than no picture: it
looks authoritative and it is off by a row. So nothing here is placed by hand.
Every ring is a pad position out of the ULX3S KiCad PCB (emard/ulx3s,
`ulx3s.kicad_pcb`, where J1 is a Socket_Strip_Angled_2x20 whose pads carry
their net names), projected onto the photograph.

THE METHOD, and each step exists because the one before it was not enough:

  1. Parse the PCB for the J1/J2 pads, the four M3 mounting holes and the
     board outline. This is the ground truth and it is in millimetres.
  2. Find the four mounting holes in the photo by CIRCULAR HOUGH VOTING. They
     are the only large concentric annuli on the board, so the drill wall, the
     pad's inner edge and its outer edge all vote for the same centre. Reading
     them by eye was tried first and was 10-40 px out, which is most of a hole.
  3. Fit a homography from those four. Four points determine one exactly,
     which is also the problem: any error is absorbed as distortion instead of
     showing up as a residual.
  4. ⭐ So then RE-FIT ON ALL 80 HEADER HOLES, found by the same Hough vote in
     a small window around where step 3 predicted them. That is a heavily
     over-determined fit whose residual is worth reading: 74/80 matched at
     0.087 mm mean on the top photo, 77/80 at 0.123 mm on the bottom one.
  5. Draw.

⚠️ WHAT IT CANNOT DO. It knows nothing about the board in front of you — only
about the PCB design and the photograph you hand it. If the photo is of a
different revision, or the seeds pick out the wrong circles, the output will be
confidently wrong. The residual printed at step 4 is the check: if it is not a
fraction of a millimetre, do not trust the picture.

⚠️ THE SEEDS ARE PER-PHOTOGRAPH. They only need to be within ~50 px of the
mounting holes; the defaults are for the two photographs in docs/img. For a new
photo, pass --seed four times, in the order top-left, top-right, bottom-left,
bottom-right AS THE PHOTO SHOWS THEM.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import argparse
import math
import re
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

# ---------------------------------------------------------------------------
# The wiring this draws. Pin numbers are J1's, as the PCB numbers them (which
# is the numbering for a FEMALE ANGLED header — the PCB says so itself; for a
# male vertical one the odd and even numbers swap. That is why nothing below
# ever tells a human to count pins: the drawing points at holes).
# ---------------------------------------------------------------------------
WIRES = [
    (20, 'VCC', (255, 59, 48),    '3.3 V row, outer hole'),
    (22, 'GND', (245, 245, 245),  'GND row, outer hole'),
    (26, 'SCL', (255, 214, 10),   'row 8, outer hole — gp8, ball A4'),
    (28, 'SDA', (10, 220, 255),   'row 9, outer hole — gp9, ball A2'),
    (25, 'SQW', (199, 125, 255),  'row 8, INNER hole (gn8) — optional'),
]
OPTIONAL_PIN = 25
BLOCK = range(19, 39)          # the 20 holes one 2x10 socket covers
BODY_MM = (94.10, 84.28, 99.18, 109.68)   # its plastic body, x0 y0 x1 y1

# The mounting holes, and which corner of each PHOTO they are. The bottom view
# mirrors x; both photos put the high-y edge (GP13) at the top.
HOLES_MM = {'H1': (102.99, 108.41), 'H2': (179.19, 108.41),
            'H3': (179.19, 65.23), 'H4': (102.99, 65.23)}
CORNERS = {
    'top':    ['H2', 'H1', 'H3', 'H4'],   # photo TL, TR, BL, BR
    'bottom': ['H1', 'H2', 'H4', 'H3'],
}
DEFAULT_SEEDS = {
    'top':    [(288, 370), (1892, 282), (347, 1248), (1925, 1190)],
    'bottom': [(244, 322), (1853, 233), (273, 1224), (1885, 1159)],
}

TITLE = {
    'top': ('ULX3S — TOP SIDE: where the 2×10 socket goes, and which holes the DS3231 uses',
            ['The orange box is one 2×10 female header on J1, covering the 20 holes ringed inside it.',
             'It starts at the 3.3 V row just below the row marked 7, and ends at the GND row below the top 3.3 V pair.',
             'All four wires land in the OUTER column — the one nearest the board edge, marked + on the silkscreen (that column is gp[n]).',
             'Rows 10-13 stay free. Row 7 is inside the header but is used by koti’s video — do not wire to it.',
             'The module does NOT plug straight in: its pin order is its own. Four female-female jumper wires, module → these holes.']),
    'bottom': ('ULX3S — BOTTOM SIDE: the same 20 holes, seen from the side you solder',
               ['Mirror image of the top view: the header goes in from the top and is soldered here.',
                'The silkscreen row numbers are printed on this side too — check them before you heat anything.',
                'Same four wires, same rows. The outer column is still the one nearest the board edge.',
                'Power the module from 3.3 V, never 5 V: the ECP5 is not 5 V tolerant.',
                'At 3.3 V the ZS-042 module’s battery-charging resistor is harmless with a plain CR2032; at 5 V it is not.']),
}


# ---------------------------------------------------------------------------
# 1. the PCB
# ---------------------------------------------------------------------------
def read_pads(pcb_path, ref):
    """(pin -> (x, y, net)) for one footprint, in board millimetres."""
    text = open(pcb_path, encoding='utf-8', errors='replace').read()
    # Find the footprint whose reference is `ref`, then walk its pads. The file
    # is s-expressions; a full parser is overkill for two connectors, but the
    # BLOCK has to be delimited properly or a later footprint's pads leak in.
    for m in re.finditer(r'\(footprint\s+"[^"]*"', text):
        start = m.start()
        depth, i = 0, start
        while True:
            if text[i] == '(':
                depth += 1
            elif text[i] == ')':
                depth -= 1
                if depth == 0:
                    break
            i += 1
        body = text[start:i + 1]
        if not re.search(r'\(fp_text\s+reference\s+"%s"' % re.escape(ref), body):
            continue
        at = re.search(r'\(at\s+([\d.-]+)\s+([\d.-]+)(?:\s+([\d.-]+))?\)', body)
        fx, fy = float(at.group(1)), float(at.group(2))
        fa = math.radians(-float(at.group(3) or 0))
        pads = {}
        for p in re.finditer(
                r'\(pad\s+"([^"]+)"[^()]*\w+\s+\w+\s+\(at\s+([\d.-]+)\s+([\d.-]+)'
                r'[^)]*\)(.*?)(?=\(pad\s|\Z)', body, re.S):
            px, py = float(p.group(2)), float(p.group(3))
            gx = px * math.cos(fa) - py * math.sin(fa)
            gy = px * math.sin(fa) + py * math.cos(fa)
            net = re.search(r'\(net\s+\d+\s+"([^"]*)"\)', p.group(4))
            pads[p.group(1)] = (fx + gx, fy + gy, net.group(1) if net else None)
        return pads
    raise SystemExit(f'no footprint {ref} in {pcb_path}')


# ---------------------------------------------------------------------------
# 2. finding circles
# ---------------------------------------------------------------------------
def sobel(g):
    kx = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], float)
    gx = np.zeros_like(g)
    gy = np.zeros_like(g)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            w = g[1 + dy:g.shape[0] - 1 + dy, 1 + dx:g.shape[1] - 1 + dx]
            gx[1:-1, 1:-1] += kx[dy + 1, dx + 1] * w
            gy[1:-1, 1:-1] += kx.T[dy + 1, dx + 1] * w
    return gx, gy


def find_circle(img, cx, cy, win, rmin, rmax):
    """Centre of the strongest concentric-circle response near (cx, cy)."""
    x0, y0 = int(cx - win), int(cy - win)
    x0, y0 = max(x0, 0), max(y0, 0)
    sub = img[y0:y0 + 2 * win, x0:x0 + 2 * win].astype(float)
    if sub.size == 0:
        return cx, cy, 0.0
    g = sub.mean(axis=2)
    gx, gy = sobel(g)
    mag = np.hypot(gx, gy)
    ys, xs = np.nonzero(mag > np.percentile(mag, 92))
    if len(xs) < 20:
        return cx, cy, 0.0
    ux, uy = gx[ys, xs] / mag[ys, xs], gy[ys, xs] / mag[ys, xs]
    acc = np.zeros_like(g)
    h, w = g.shape
    for r in range(rmin, rmax + 1):
        for s in (1, -1):
            vx = np.rint(xs + s * r * ux).astype(int)
            vy = np.rint(ys + s * r * uy).astype(int)
            ok = (vx >= 0) & (vx < w) & (vy >= 0) & (vy < h)
            np.add.at(acc, (vy[ok], vx[ok]), 1.0)
    k = 5
    c = np.cumsum(np.cumsum(np.pad(acc, k), axis=0), axis=1)
    sm = (c[2 * k:, 2 * k:] - c[:-2 * k, 2 * k:]
          - c[2 * k:, :-2 * k] + c[:-2 * k, :-2 * k])
    py, px = np.unravel_index(np.argmax(sm), sm.shape)
    yy, xx = np.mgrid[0:h, 0:w]
    near = (np.hypot(xx - px, yy - py) < 6) & (acc > 0)
    if near.sum():
        px = (xx[near] * acc[near]).sum() / acc[near].sum()
        py = (yy[near] * acc[near]).sum() / acc[near].sum()
    return x0 + px, y0 + py, float(sm.max())


# ---------------------------------------------------------------------------
# 3-4. the homography
# ---------------------------------------------------------------------------
def homography(src, dst):
    A = []
    for (x, y), (u, v) in zip(src, dst):
        A.append([x, y, 1, 0, 0, 0, -u * x, -u * y, -u])
        A.append([0, 0, 0, x, y, 1, -v * x, -v * y, -v])
    _, _, Vt = np.linalg.svd(np.asarray(A, float))
    H = Vt[-1].reshape(3, 3)
    return H / H[2, 2]


def project(H, pts):
    p = np.asarray(pts, float).reshape(-1, 2)
    q = np.c_[p, np.ones(len(p))] @ H.T
    return q[:, :2] / q[:, 2:3]


def px_per_mm(H):
    a = project(H, [(140.0, 85.0), (150.0, 85.0)])
    return float(np.hypot(*(a[1] - a[0])) / 10.0)


def refit(img, H, pads, search=14):
    src, dst, missed = [], [], 0
    for (x, y, _net) in pads:
        u, v = project(H, [(x, y)])[0]
        px, py, _ = find_circle(img, u, v, search + 22, 5, 18)
        if np.hypot(px - u, py - v) <= search:
            src.append((x, y))
            dst.append((px, py))
        else:
            missed += 1
    H2 = homography(src, dst)
    err = np.hypot(*(project(H2, src) - np.asarray(dst)).T)
    print(f'  matched {len(src)}/{len(src) + missed} header holes   '
          f'residual mean {err.mean():.2f} px = '
          f'{err.mean() / px_per_mm(H2):.3f} mm, max {err.max():.2f} px')
    return H2, err.mean() / px_per_mm(H2)


# ---------------------------------------------------------------------------
# 5. drawing
# ---------------------------------------------------------------------------
def font(sz, bold=True):
    for name in (('arialbd.ttf', 'DejaVuSans-Bold.ttf') if bold
                 else ('arial.ttf', 'DejaVuSans.ttf')):
        try:
            return ImageFont.truetype(name, sz)
        except OSError:
            pass
    return ImageFont.load_default()


def draw(photo, H, j1, side, out):
    ORANGE, DIM, FG, BG = (255, 149, 0), (150, 150, 155), (238, 238, 238), (18, 18, 20)
    im = Image.open(photo).convert('RGB')
    W, Ht = im.size
    ppmm = px_per_mm(H)
    right = (side == 'top')          # which side of the photo J1 is on
    MARG, BOT = 560, 350
    canvas = Image.new('RGB', (W + MARG, Ht + BOT), BG)
    ox = 0 if right else MARG
    canvas.paste(im, (ox, 0))
    d = ImageDraw.Draw(canvas, 'RGBA')

    def p(mm):
        u, v = project(H, [mm])[0]
        return (u + ox, v)

    x0, y0, x1, y1 = BODY_MM
    body = [p((x0, y0)), p((x1, y0)), p((x1, y1)), p((x0, y1))]
    d.polygon(body, fill=(255, 149, 0, 38))
    d.line(body + [body[0]], fill=ORANGE, width=7)
    for pin in BLOCK:
        c = p(j1[str(pin)][:2])
        d.ellipse([c[0] - 8, c[1] - 8, c[0] + 8, c[1] + 8], outline=ORANGE, width=3)

    f_lab, f_note = font(int(ppmm * 2.4)), font(int(ppmm * 1.18), bold=False)
    f_blk = font(int(ppmm * 1.9))
    r = int(ppmm * 1.5)

    top = p((96.6, 111.9))
    txt = '2×10 socket · 20 holes'
    tw = d.textlength(txt, font=f_blk)
    bx = [top[0] - tw / 2 - 14, top[1] - int(ppmm * 1.6),
          top[0] + tw / 2 + 14, top[1] + int(ppmm * 1.6)]
    d.rounded_rectangle(bx, radius=8, fill=(0, 0, 0, 190), outline=ORANGE, width=3)
    d.text((bx[0] + 14, top[1] - int(ppmm * 1.1)), txt, fill=ORANGE, font=f_blk)

    # Orthogonal leaders on staggered gutters: parallel lines that turn once
    # cannot cross, which straight hole-to-label lines repeatedly did.
    lab_x = (W + ox + 40) if right else 40
    order = sorted(WIRES, key=lambda it: (-j1[str(it[0])][1], it[0] == OPTIONAL_PIN))
    step = int(ppmm * 6.6)
    ly0 = p(j1[str(order[0][0])][:2])[1] - step * 0.6
    gut0 = (W + ox - int(ppmm * 1.0)) if right else (ox + int(ppmm * 1.0))
    boxw = int(ppmm * 21)

    for i, (pin, name, colour, note) in enumerate(order):
        xy = p(j1[str(pin)][:2])
        d.ellipse([xy[0] - r - 5, xy[1] - r - 5, xy[0] + r + 5, xy[1] + r + 5],
                  outline=(0, 0, 0), width=7)
        d.ellipse([xy[0] - r, xy[1] - r, xy[0] + r, xy[1] + r],
                  outline=colour, width=5)
        ly = ly0 + i * step
        gut = gut0 + (i * int(ppmm * 1.6)) * (1 if right else -1)
        d.line([xy, (gut, xy[1]), (gut, ly + r),
                (lab_x if right else lab_x + boxw, ly + r)], fill=colour, width=5)
        box = [lab_x, ly - int(ppmm * 1.4), lab_x + boxw, ly + int(ppmm * 3.4)]
        d.rounded_rectangle(box, radius=10, fill=(0, 0, 0, 190),
                            outline=colour, width=3)
        d.text((lab_x + 16, ly - int(ppmm * 1.0)), name, fill=colour, font=f_lab)
        d.text((lab_x + 16, ly + int(ppmm * 1.5)), note, fill=DIM, font=f_note)

    title, notes = TITLE[side]
    d.text((40, Ht + 26), title, fill=FG, font=font(int(ppmm * 3.0)))
    fs = font(int(ppmm * 1.6), bold=False)
    for i, line in enumerate(notes):
        d.text((40, Ht + 26 + int(ppmm * 4.2) + i * int(ppmm * 2.3)), line,
               fill=DIM, font=fs)

    if out.lower().endswith(('.jpg', '.jpeg')):
        w = 1800
        canvas = canvas.resize((w, round(w * canvas.size[1] / canvas.size[0])),
                               Image.LANCZOS)
        canvas.save(out, quality=88, optimize=True, progressive=True)
    else:
        canvas.save(out)
    print(f'  wrote {out}  ({ppmm:.2f} px/mm)')


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--pcb', required=True, help='ULX3S ulx3s.kicad_pcb')
    ap.add_argument('--photo', required=True)
    ap.add_argument('--side', required=True, choices=('top', 'bottom'))
    ap.add_argument('--out', required=True)
    ap.add_argument('--seed', action='append', metavar='X,Y',
                    help='mounting-hole guess, four of them: TL TR BL BR')
    ap.add_argument('--max-mm', type=float, default=0.30,
                    help='refuse to draw above this fit residual (mm)')
    a = ap.parse_args()

    seeds = ([tuple(float(v) for v in s.split(',')) for s in a.seed]
             if a.seed else DEFAULT_SEEDS[a.side])
    if len(seeds) != 4:
        raise SystemExit('need exactly four --seed values (TL TR BL BR)')

    j1 = read_pads(a.pcb, 'J1')
    j2 = read_pads(a.pcb, 'J2')
    print(f'{a.side}: J1 has {len(j1)} pads, J2 has {len(j2)}')

    img = np.asarray(Image.open(a.photo).convert('RGB'))
    dst = []
    for name, (sx, sy) in zip(CORNERS[a.side], seeds):
        x, y, _ = find_circle(img, sx, sy, 110, 22, 55)
        x, y, _ = find_circle(img, x, y, 110, 22, 55)
        print(f'  {name}: ({x:8.2f}, {y:8.2f})  '
              f'{np.hypot(x - sx, y - sy):5.1f} px from the seed')
        dst.append((x, y))
    H = homography([HOLES_MM[n] for n in CORNERS[a.side]], dst)

    pads = list(j1.values()) + list(j2.values())
    H, mm = refit(img, H, pads)
    H, mm = refit(img, H, pads)
    if mm > a.max_mm:
        raise SystemExit(f'FAIL: fit residual {mm:.3f} mm exceeds {a.max_mm} mm.'
                         '\n      The seeds probably picked out the wrong circles;'
                         '\n      a drawing on a bad fit is worse than none.')
    draw(a.photo, H, j1, a.side, a.out)


if __name__ == '__main__':
    sys.exit(main())
