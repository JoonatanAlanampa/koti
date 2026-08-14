#!/usr/bin/env python3
"""check_tristate.py — every bidirectional pin must still have a real driver.

    python fpga/ulx3s/check_tristate.py fpga/ulx3s/build/koti.json

⛔ WHY THIS EXISTS, AND IT IS THE ONE GATE ulx3s_top.sv SAYS DOES NOT EXIST.

On 2026-08-07 the microSD read as "no card" for a day. The cause was one line:

    assign sd_d[0] = 1'bz;

With a bare `1'bz` and no other driver, yosys has nothing to build a tristate
out of, so the port collapses — and the LPF's `PULLMODE=UP` then does not take
effect, because a pull-up needs an IO buffer to live in. The pin floated LOW,
every byte clocked off the card read 0x00, and `sdtest` reported
`init: FAILED, status 00000004`, which reads exactly like a dead card. The card
was healthy the whole time.

The comment that records this ends: "⚠️ Nothing in CI can catch a regression
here — the simulation model supplies its own pull-up, so a bench stays green
while the board goes deaf. The check is the nextpnr log line." This is that
check, moved one stage earlier and made mechanical.

WHAT IT LOOKS AT. yosys's JSON netlist gives every top-level port its bit
numbers. A port with a real driver has integer bit ids; a port whose driver was
optimised away has the literal string "z" in its place. That is the exact
signature, confirmed on a minimal case in yosys 2026-08-14:

    assign good = oe ? 1'b0 : 1'bz;   ->  $_TBUF_ (A=0, E=oe),  bits [4]
    assign bad  = 1'bz;               ->  no cell at all,       bits ["z"]

⚠️ "0" AND "1" ARE NOT FAILURES, AND THE FIRST VERSION OF THIS FILE SAID THEY
WERE. sd_d[2:1] are deliberately tied HIGH — a card in SPI mode wants its
unused data lines idle-high — and a constant IS a driver: the tools build an
output buffer for it and the pin is driven, not floating. Only the literal "z"
means "nothing drives this at all", which is the failure. A checker that
cried wolf about two intentional pins would have been switched off, which is
worse than not having one.

⚠️ WHAT IT CANNOT SAY: that the pin is wired to the right ball (check_pins.py),
that the enable is ever asserted, or that anything is plugged in. It says the
pin is still bidirectional, which is the property that silently disappears.

⭐ IT ENUMERATES THE PORTS FROM THE NETLIST rather than from a list kept here.
A list would be one more thing to forget when a bidirectional pin is added —
which is the same class of mistake as the one it is guarding against.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import json
import sys
from pathlib import Path

TOP = "ulx3s_top"


def main(argv) -> int:
    if len(argv) != 2:
        print(__doc__.strip().splitlines()[2].strip())
        return 2
    path = Path(argv[1])
    if not path.exists():
        print(f"FAIL: {path} does not exist — did synthesis run?")
        return 2

    netlist = json.loads(path.read_text(encoding="utf-8"))
    mods = netlist.get("modules", {})
    if TOP not in mods:
        print(f"FAIL: no module `{TOP}` in {path}. Modules: "
              f"{' '.join(sorted(mods)[:10])}")
        print("      The top level was renamed, and this check is now blind.")
        return 1

    ports = mods[TOP].get("ports", {})
    inouts = {n: p for n, p in ports.items() if p.get("direction") == "inout"}
    if not inouts:
        print(f"FAIL: `{TOP}` has no inout ports at all. koti has at least "
              f"sd_d, pmod_gp/gn, usb_fpga_bd_* and the RTC's I2C pair, so")
        print("      either the netlist is wrong or the harness lost them.")
        return 1

    bad = []
    print(f"{TOP}: {len(inouts)} bidirectional port(s)")
    for name in sorted(inouts):
        bits = inouts[name]["bits"]
        dead = [i for i, b in enumerate(bits) if b == "z"]
        tied = [i for i, b in enumerate(bits) if b in ("0", "1")]
        if dead:
            bad.append((name, dead))
            print(f"  FAIL {name}: bit(s) {dead} have NO DRIVER "
                  f"(the netlist says {bits})")
        elif tied:
            # Deliberate on this board — sd_d[2:1] are held high for the card.
            # Reported so it is a decision somebody can see, not a silence.
            print(f"  ok   {name}[{len(bits)}]  (bit(s) {tied} tied to a "
                  f"constant, driven not floating)")
        else:
            print(f"  ok   {name}[{len(bits)}]")

    if bad:
        print()
        print(f"FAIL: {len(bad)} bidirectional port(s) lost their tristate.")
        print("      A port with no driver is not merely undriven — the ECP5")
        print("      builds no IO buffer for it, so PULLMODE in ulx3s.lpf")
        print("      stops applying and the pin FLOATS. The last time this")
        print("      happened the microSD read as absent for a day.")
        print("      Write `assign pin = oe ? value : 1'bz;` with a real")
        print("      enable, never a bare `1'bz`.")
        return 1

    print("\nOK: every bidirectional pin still has a driver, so its pull-up "
          "still applies")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
