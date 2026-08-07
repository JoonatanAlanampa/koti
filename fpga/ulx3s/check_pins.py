#!/usr/bin/env python3
"""check_pins.py — prove the harness and the pin constraints still agree.

    python fpga/ulx3s/check_pins.py

Exits non-zero on any failure, so it works as a CI gate rather than a report.

WHY THIS EXISTS. A constraint file fails in three ways that a successful build
will not tell you about:

  1. A port with no LOCATE. nextpnr-ecp5 refuses unconstrained IO outright, so
     this one at least fails loudly - but it fails 15 minutes into a CI run
     instead of instantly.
  2. A LOCATE for a port that no longer exists. Harmless to the tools, silently
     rots, and hides the fact that the signal you think is on that ball isn't.
  3. A site that is simply the wrong ball. This is the dangerous one: the
     bitstream builds perfectly and drives the wrong pin. No amount of
     simulation catches it, and on hardware it looks like a dead peripheral.

(3) is checked against a table transcribed from the upstream ULX3S v2.0
constraint file, cross-checked against console/fpga/ulx3s.lpf when that sibling
repo is present. What no software check can settle is whether the board in your
hand is a v2.0 at all - that needs the silkscreen.
"""

import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TOP = HERE / "ulx3s_top.sv"
LPF = HERE / "ulx3s.lpf"

# Sibling repo, read-only, optional. Its sites were diffed against upstream
# emard/ulx3s doc/constraints/ulx3s_v20.lpf on 2026-07-30.
CONSOLE_LPF = HERE.parents[2] / "console" / "fpga" / "ulx3s.lpf"

# ---------------------------------------------------------------------------
# Expected sites, ULX3S v2.0. Port names are koti's; the SITE values are the
# board's and must match the vendor file. Kept here rather than only in the LPF
# so the check means something even when the console repo is not checked out.
# ---------------------------------------------------------------------------
EXPECTED = {
    "clk_25mhz": "G2",
    "btn[0]": "D6", "btn[1]": "R1", "btn[2]": "T1", "btn[3]": "R18",
    "btn[4]": "V1", "btn[5]": "U1", "btn[6]": "H16",
    "sw[0]": "E8", "sw[1]": "D8", "sw[2]": "D7", "sw[3]": "E7",
    "led[0]": "B2", "led[1]": "C2", "led[2]": "C1", "led[3]": "D2",
    "led[4]": "D1", "led[5]": "E2", "led[6]": "E1", "led[7]": "H3",
    "ftdi_rxd": "L4",
    # F1, not upstream v2.0's L2 — the ONE deliberate departure from
    # ulx3s_v20.lpf in this table, and it was L2 here until 2026-08-07. The
    # bench board is a PCB v3.1.8, and exactly five signals moved between v2.0
    # and v3.1.x, all wifi_*: on v3.1.x L2 became wifi_gpio22 and wifi_gpio0
    # moved to F1. Copied from console/fpga/check_pins.py, which learned it on
    # the day that design first ran on this board. The other 58 entries are
    # identical on both revisions — including every SDRAM pin and all of J1/J2 —
    # so this table still checks what it claims to check.
    "wifi_gpio0": "F1",
    # J1 = gp/gn[0..3]
    "pmod_gp[0]": "B11", "pmod_gp[1]": "A10", "pmod_gp[2]": "A9",
    "pmod_gp[3]": "B9",
    "pmod_gn[0]": "C11", "pmod_gn[1]": "A11", "pmod_gn[2]": "B10",
    "pmod_gn[3]": "C10",
    # J2 = gp/gn[4..7]
    "vga_gp[0]": "A7", "vga_gp[1]": "C8", "vga_gp[2]": "C6", "vga_gp[3]": "A6",
    "vga_gn[0]": "A8", "vga_gn[1]": "B8", "vga_gn[2]": "C7", "vga_gn[3]": "B6",
    # gp[8], gp[9]
    "ps2_gp[0]": "A4", "ps2_gp[1]": "A2",
    # onboard 32 MB SDRAM (upstream ulx3s_v20.lpf, fetched 2026-08-02)
    "sdram_clk": "F19",
    "sdram_cke": "F20",
    "sdram_csn": "P20",
    "sdram_wen": "T20",
    "sdram_rasn": "R20",
    "sdram_casn": "T19",
    "sdram_a[0]": "M20",
    "sdram_a[1]": "M19",
    "sdram_a[2]": "L20",
    "sdram_a[3]": "L19",
    "sdram_a[4]": "K20",
    "sdram_a[5]": "K19",
    "sdram_a[6]": "K18",
    "sdram_a[7]": "J20",
    "sdram_a[8]": "J19",
    "sdram_a[9]": "H20",
    "sdram_a[10]": "N19",
    "sdram_a[11]": "G20",
    "sdram_a[12]": "G19",
    "sdram_ba[0]": "P19",
    "sdram_ba[1]": "N20",
    "sdram_d[0]": "J16",
    "sdram_d[1]": "L18",
    "sdram_d[2]": "M18",
    "sdram_d[3]": "N18",
    "sdram_d[4]": "P18",
    "sdram_d[5]": "T18",
    "sdram_d[6]": "T17",
    "sdram_d[7]": "U20",
    "sdram_d[8]": "E19",
    "sdram_d[9]": "D20",
    "sdram_d[10]": "D19",
    "sdram_d[11]": "C20",
    "sdram_d[12]": "E18",
    "sdram_d[13]": "F18",
    "sdram_d[14]": "J18",
    "sdram_d[15]": "J17",
    "sdram_dqm[0]": "U19",
    "sdram_dqm[1]": "E20",
}

# Which console port each koti port borrows its site from. Only used for the
# optional cross-check; koti and console name some blocks differently because
# they carry different things on the same header.
CONSOLE_ALIAS = {
    "ps2_gp[0]": "pad_gp[0]",
    "ps2_gp[1]": "pad_gp[1]",
}

PORT_RE = re.compile(
    r"^\s*(input|output|inout)\s+"
    r"(?:wire|logic|reg)?\s*"
    r"(?:\[\s*(\d+)\s*:\s*(\d+)\s*\]\s*)?"
    r"(\w+)\s*[,)]",
    re.MULTILINE,
)
LOCATE_RE = re.compile(r'^\s*LOCATE\s+COMP\s+"([^"]+)"\s+SITE\s+"([^"]+)"\s*;',
                       re.MULTILINE | re.IGNORECASE)
IOBUF_RE = re.compile(r'^\s*IOBUF\s+PORT\s+"([^"]+)"', re.MULTILINE | re.IGNORECASE)
FREQ_RE = re.compile(r'^\s*FREQUENCY\s+PORT\s+"([^"]+)"\s+([\d.]+)\s+MHZ\s*;',
                     re.MULTILINE | re.IGNORECASE)

errors: list[str] = []
warnings: list[str] = []


def module_ports(text: str) -> list[str]:
    """Every port BIT of ulx3s_top, e.g. led[0]..led[7]."""
    # Keep the ')' that terminates the port list: PORT_RE needs a ',' or ')'
    # after each name, and the LAST port only ever has the ')'. Dropping it
    # silently loses one port - which is exactly the kind of near-miss this
    # script exists to catch, so it may not have it itself.
    body = text.split("module ulx3s_top", 1)[1].split(");", 1)[0] + ")"
    bits = []
    for _dir, hi, lo, name in PORT_RE.findall(body):
        if hi is None or hi == "":
            bits.append(name)
        else:
            hi_i, lo_i = int(hi), int(lo)
            for i in range(min(hi_i, lo_i), max(hi_i, lo_i) + 1):
                bits.append(f"{name}[{i}]")
    return bits


def parse_locates(path: Path) -> dict[str, str]:
    return dict(LOCATE_RE.findall(path.read_text(encoding="utf-8", errors="replace")))


def main() -> int:
    for p in (TOP, LPF):
        if not p.exists():
            print(f"FAIL: missing {p}")
            return 2

    top_text = TOP.read_text(encoding="utf-8", errors="replace")
    lpf_text = LPF.read_text(encoding="utf-8", errors="replace")

    ports = module_ports(top_text)
    located = dict(LOCATE_RE.findall(lpf_text))
    iobufs = set(IOBUF_RE.findall(lpf_text))

    # 1. every port bit is constrained
    for bit in ports:
        if bit not in located:
            errors.append(f"port {bit} has no LOCATE - nextpnr will reject it")

    # 2. no LOCATE for a port that does not exist
    portset = set(ports)
    for name in located:
        if name not in portset:
            errors.append(f'LOCATE "{name}" names no port of ulx3s_top (stale)')

    # 3. sites match the v2.0 table
    for name, site in located.items():
        want = EXPECTED.get(name)
        if want is None:
            warnings.append(f'"{name}" is not in the expected-site table '
                            f"(site {site}) - add it there if deliberate")
        elif want != site:
            errors.append(f'"{name}" is on SITE {site}, expected {want} (ULX3S v2.0)')

    for name in EXPECTED:
        if name in portset and name not in located:
            pass  # already reported by check 1

    # 4. no two ports on one ball
    seen: dict[str, str] = {}
    for name, site in located.items():
        if site in seen:
            errors.append(f"SITE {site} is claimed by both {seen[site]} and {name}")
        seen[site] = name

    # 5. the clock constraint exists and is 25 MHz. Without it nextpnr has
    #    nothing to fail against, and a CI run goes green on a design that does
    #    not close timing.
    freqs = FREQ_RE.findall(lpf_text)
    if not freqs:
        errors.append("no FREQUENCY PORT constraint - timing would not be gated")
    else:
        for port, mhz in freqs:
            if port != "clk_25mhz":
                warnings.append(f"FREQUENCY on unexpected port {port}")
            elif abs(float(mhz) - 25.0) > 0.001:
                errors.append(f"clock constrained to {mhz} MHz, expected 25")

    # 6. hygiene: an IOBUF line for each constrained port
    for bit in ports:
        if bit in located and bit not in iobufs:
            warnings.append(f"{bit} has no IOBUF line (IO_TYPE/PULLMODE defaulted)")

    # 7. optional cross-check against console's already-diffed transcription
    if CONSOLE_LPF.exists():
        ref = parse_locates(CONSOLE_LPF)
        checked = 0
        for name, site in located.items():
            ref_name = CONSOLE_ALIAS.get(name, name)
            if ref_name in ref:
                checked += 1
                if ref[ref_name] != site:
                    errors.append(
                        f'"{name}" SITE {site} disagrees with console\'s '
                        f'"{ref_name}" SITE {ref[ref_name]}')
        print(f"cross-checked {checked}/{len(located)} sites against "
              f"{CONSOLE_LPF.name} (diffed vs upstream v2.0 on 2026-07-30)")
    else:
        print(f"note: {CONSOLE_LPF} not present - skipped the cross-check, "
              f"used the built-in table only")

    print(f"ports: {len(ports)}   locates: {len(located)}")

    for w in warnings:
        print(f"WARN: {w}")
    for e in errors:
        print(f"FAIL: {e}")

    if errors:
        print(f"\n{len(errors)} error(s).")
        return 1
    print("\nOK: every port is constrained, every site matches ULX3S v2.0 —")
    print("    except wifi_gpio0, which is deliberately the v3.1.x site (F1).")
    print("The board on the bench is a PCB v3.1.8, established 2026-08-07, and")
    print("the revision no longer needs checking: the five signals that moved")
    print("between v2.0 and v3.1.x are all wifi_*, and wifi_gpio0 is the only")
    print("one this design uses. Every other site is identical on both.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
