#!/usr/bin/env python3
"""Turn a flat binary into the $readmemh file fpga/ulx3s/bram_flash.sv loads.

    python3 fpga/ulx3s/mkflashhex.py <in.bin> <out.hex> [--size N]

ONE BYTE PER LINE, which is not what test/mkhex.py produces and is the reason
this is a second script rather than a flag on that one. `bram_flash` models a
byte-addressed SPI part: 03h streams bytes MSB-first with the address
incrementing per byte, so a byte-wide array is the shape that makes the model
simple. test/mkhex.py writes 32-bit little-endian words for sim_mem.sv, whose
arrays are word-shaped. Feeding either file to the other consumer produces a
memory that is byte-swapped in groups of four — which boots, briefly, and then
executes garbage. Two names, no flag, no chance of picking the wrong one.

PADS TO THE FULL ARRAY, and that is not cosmetic. $readmemh fills only as many
entries as the file has lines and leaves the rest at their initial value, which
in simulation is X. koti fetches a PAIR of words per transaction, so a fetch
near the end of the image reads past it, and an X on MISO propagates into the
instruction register — a failure that looks like a broken CPU. Zeroed tail
means an over-read decodes as an illegal instruction and traps, which is
diagnosable. On hardware the ECP5's block RAM powers up zeroed anyway, so the
padding costs nothing there; it buys the simulation.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import sys
from pathlib import Path

# Must match bram_flash.sv's FLASH_BYTES. Stated in both places on purpose: a
# short file is silently padded by $readmemh with X, so the check below is the
# only thing that turns "the image does not fit" into a message.
DEFAULT_SIZE = 32768


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("--")]
    size = DEFAULT_SIZE
    for a in argv[1:]:
        if a.startswith("--size="):
            size = int(a.split("=", 1)[1], 0)
    if len(args) != 2:
        print(__doc__)
        return 2

    src = Path(args[0]).read_bytes()
    if len(src) > size:
        print(f"ERROR: {args[0]} is {len(src)} bytes, which does not fit the "
              f"{size}-byte fabric flash.")
        print("Raise FLASH_BYTES in fpga/ulx3s/bram_flash.sv AND DEFAULT_SIZE "
              "here, or use a smaller image. Every 2 KB is one more DP16KD.")
        return 1

    with open(args[1], "w") as f:
        f.writelines(f"{b:02x}\n" for b in src)
        f.writelines("00\n" for _ in range(size - len(src)))

    print(f"{args[0]}: {len(src)} bytes -> {args[1]} "
          f"({size} lines, {size - len(src)} zero-padded)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
