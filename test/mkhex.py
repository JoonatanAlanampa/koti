#!/usr/bin/env python3
"""Turn a flat binary into the $readmemh file test/sim_mem.sv loads.

    python3 test/mkhex.py <in.bin> <out.hex>

One 32-bit little-endian word per line, which is how sim_mem.sv's arrays are
shaped. A short tail is zero-padded up to a word boundary rather than dropped:
the last partial word of a kernel Image is real content, and losing it would
corrupt exactly one instruction somewhere near the end of .text — the kind of
fault that produces an illegal-instruction trap with no obvious cause.

Deliberately not $readmemb or a packed binary: a hex file is greppable, both
iverilog and Verilator read it without argument, and a 4.5 MB kernel is 1.1M
lines, which costs seconds once against a run measured in minutes.
"""
import sys
from pathlib import Path


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    src = Path(sys.argv[1]).read_bytes()
    if len(src) % 4:
        src += b"\x00" * (4 - len(src) % 4)
    with open(sys.argv[2], "w") as f:
        f.writelines(
            f"{int.from_bytes(src[i:i+4], 'little'):08x}\n"
            for i in range(0, len(src), 4))
    print(f"{sys.argv[1]}: {len(src)} bytes -> {len(src)//4} words")
    return 0


if __name__ == "__main__":
    sys.exit(main())
