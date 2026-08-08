#!/usr/bin/env python3
"""ktrace.py — turn a tb_boot trace into kernel symbols.

Every one of the three CPU defects this project has found was diagnosed the
same way: run the boot bench with a trace on, take the program counters it
prints, and ask the kernel's System.map what code they belong to. That step was
done with a throwaway script each time, and each time the script went away with
the session that wrote it. This is that script, kept.

    python tools/ktrace.py System.map boot.log
    python tools/ktrace.py System.map boot.log --from 27000000
    python tools/ktrace.py System.map boot.log --timeline --image Image
    python tools/ktrace.py System.map --image Image --disasm 0xc00b8ff0
    python tools/ktrace.py System.map --image Image --audit-straddle

⭐ WITH --image, EVERY LINE GAINS ITS INSTRUCTION. This tool could always say
which *symbol* an address belonged to; until 2026-08-08 it could not say which
*instruction*, and that is the question that ends the search. All three CPU
defects found so far came down to reading one instruction and asking what
should have run next — the straddling fetch pair was literally "this `jal`
lands on the last word of a page, and the `lw` after it never executed".
The Image is a flat binary whose byte 0 IS the load address, so a virtual
address indexes it directly with the same conversion the traces already use.

WHAT IT READS. tb_boot.v prints two different traces and they do NOT carry the
same kind of address:

  +trace=<n>   "[clk] fetch <hex> if(rq. ak.) d <hex> ... satp <hex>"
               `fetch` is the FETCH PORT's address, which is PHYSICAL — it is
               what comes out of the MMU. It has to be converted before it
               means anything in System.map.

  +tfrom= +tlen=
               "[clk] pc_d <hex> pc_e <hex> | d <hex> ..."
               `pc_d`/`pc_e` are pipeline program counters, which are VIRTUAL.
               They are used as-is.

⚠️ Mixing those two up is silent: a physical fetch address run through no
conversion lands in some unrelated function and resolves to a real symbol with
a plausible name, so the output looks like an answer. That is the single most
expensive mistake available here, which is why the conversion is attached to
the line format rather than left to the caller.

THE CONVERSION. The kernel is loaded at 0x0140_0000 physical (`ramoff` in the
`boot` job, and the `text_offset` the Image header asks for) and links at
0xC000_0000 virtual, so virtual = physical - 0x0140_0000 + 0xC000_0000. Both
are options because both are properties of how koti boots, not laws.

⚠️ THE System.map MUST COME FROM THE SAME BUILD AS THE LOG. Symbols move by
hundreds of bytes between builds, and a mismatched map produces neighbours of
the right answer — which reads as a diagnosis. Download both from the SAME CI
run (`gh run download <id> -n koti-boot-log -n koti-linux-Image`).

READING THE OUTPUT. The histogram answers "what is it doing"; the timeline
answers "is it still moving". A boot that is stuck in a loop shows one symbol
taking nearly every sample AND a small set of repeating addresses. A boot that
is merely slow shows one symbol with many DIFFERENT addresses under it — which
is what a long unrolled function like blake2s_compress_generic looks like, and
is why the histogram alone cannot tell those two apart.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import argparse
import bisect
import collections
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import rvdis  # noqa: E402  — tools/rvdis.py, next to this file

# "[12345678] fetch 1590ce0 if(rq1 ak0) d 02fff48 (rq0 we0 ak0) m ... satp ..."
RE_FETCH = re.compile(
    r"^\[(\d+)\] fetch ([0-9a-fA-F]+) if\(rq(\d) ak(\d)\)"
    r" d ([0-9a-fA-F]+) \(rq(\d) we\d ak(\d)\)"
)
# "[12345678] pc_d c00b8ffc pc_e c00b8ff8 | d ... rq1 we0 ak0 rd ..."
RE_PC = re.compile(
    r"^\[(\d+)\] pc_d ([0-9a-fA-F]+) pc_e ([0-9a-fA-F]+) \| d ([0-9a-fA-F]+)"
    r" rq(\d) we\d ak(\d)"
)


def load_symbols(path):
    """System.map -> a sorted (address, name) table for bisect lookup."""
    syms = []
    with open(path) as fh:
        for line in fh:
            parts = line.split(None, 2)
            if len(parts) == 3:
                try:
                    syms.append((int(parts[0], 16), parts[2].strip()))
                except ValueError:
                    continue
    if not syms:
        sys.exit(f"{path}: no symbols parsed — is this a System.map?")
    syms.sort()
    return syms


class Resolver:
    def __init__(self, syms):
        self.syms = syms
        self.addrs = [s[0] for s in syms]

    def name(self, va):
        i = bisect.bisect_right(self.addrs, va) - 1
        if i < 0:
            return "?"
        return self.syms[i][1]

    def offset(self, va):
        i = bisect.bisect_right(self.addrs, va) - 1
        if i < 0:
            return "?"
        addr, name = self.syms[i]
        return name if va == addr else f"{name}+0x{va - addr:x}"


class Image:
    """The kernel Image, addressed by VIRTUAL address.

    A RISC-V `Image` is a flat binary whose byte 0 is both the load address and
    the first instruction — the 64-byte header opens with two executable words
    and carries "RSC\\x05" at offset 0x38, which is exactly what `sbi.S` looks
    for before entering a kernel. So virtual -> file offset is one subtraction,
    using the same --load-va the traces are already converted with. Pass the
    `koti-linux-Image` artifact from the SAME CI run as the log and the map.

    ⚠️ NOT EVERYTHING IN AN IMAGE IS CODE. It also carries .rodata, the
    built-in initramfs and the header, and every 32-bit value decodes as
    something. Measured 2026-08-08: rvdis vs riscv-none-elf-objdump over 3873
    instructions in sw/*.elf agreed on every one, and all 12 residual
    differences were STRING BYTES being decoded as instructions — by both
    tools. So trust a disassembly at an address the CPU actually fetched, and
    be suspicious of one you picked by hand.
    """

    def __init__(self, path, load_va):
        with open(path, "rb") as fh:
            self.data = fh.read()
        self.load_va = load_va

    def word(self, va):
        off = va - self.load_va
        if off < 0 or off + 4 > len(self.data):
            return None
        return int.from_bytes(self.data[off:off + 4], "little")

    def show(self, va, symfn=None):
        """'00e6a683  lw a3,14(a3)', or '' if the address is outside the image."""
        w = self.word(va)
        if w is None:
            return ""
        return f"{w:08x}  {rvdis.disasm(w, va, symfn)}"


def audit_straddle(img, res, page=0x1000):
    """Every control-flow target that lands on the LAST word of a page.

    WHY THIS IS THE INTERESTING SET. koti's fetch port delivers a PAIR
    {fpc, fpc+4}. A pair whose second word is in the next page must drop that
    word — its translation was never looked up — and defect #3 was that `npc`
    stepped by 8 anyway, so the dropped instruction was never re-fetched.
    A pair straddles exactly when fpc & 0xFFF == 0xFFC, and note that
    0xFFC & 7 == 4: the straddle is only reachable when the fetch stream is in
    the ODD (4-mod-8) phase, which is why ordinary 8-aligned code never hits it
    and why 58 official tests, 1252 muldiv vectors and six green suites all
    missed it. A branch or jump whose TARGET is 0x…FFC starts execution in that
    phase at that address, so its very first fetch pair straddles. `kfree`'s
    retry edge, `jal zero,c00b8ffc`, is precisely this shape.

    ⚠️ WHAT IT DOES NOT FIND: straight-line code that drifts into the odd phase
    and only later reaches a page end. That needs reachability analysis, not a
    scan. This is a cheap sentinel over the sites of the known shape, not a
    proof of absence — and the defect it watches for is FIXED, so a hit here is
    a site to re-check, not a bug report.
    """
    hits = []
    for off in range(0, len(img.data) - 3, 4):
        va = img.load_va + off
        word = int.from_bytes(img.data[off:off + 4], "little")
        ins = rvdis.decode(word, va)
        if ins.target is not None and (ins.target & (page - 1)) == page - 4:
            hits.append((va, ins, img.word(ins.target)))
    return hits


def parse(log_path, load_pa, load_va):
    """Yield (clock, virtual_pc, tag, stalled) for every trace line in the log.

    `stalled` is the one piece of non-PC evidence worth carrying through: a data
    request that is up with no acknowledgement is what a bus that never answers
    looks like, and it is the difference between "the software is looping" and
    "the machine is wedged". Those need completely different fixes, and the PC
    alone cannot tell them apart — a core waiting on d_ack sits on one PC
    exactly like a spin loop does.
    """
    rows = []
    with open(log_path, errors="replace") as fh:
        for line in fh:
            m = RE_FETCH.match(line)
            if m:
                clk = int(m.group(1))
                pa = int(m.group(2), 16)
                va = pa - load_pa + load_va
                stalled = m.group(6) == "1" and m.group(7) == "0"
                rows.append((clk, va, "fetch", stalled))
                continue
            m = RE_PC.match(line)
            if m:
                clk = int(m.group(1))
                va = int(m.group(2), 16)      # pc_d, already virtual
                stalled = m.group(5) == "1" and m.group(6) == "0"
                rows.append((clk, va, "pc_d", stalled))
    return rows


def main():
    rvdis.safe_console()          # see its docstring: --help used to crash here
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("system_map", help="System.map from the SAME build as the log")
    ap.add_argument("log", nargs="?",
                    help="boot.log containing +trace or +tfrom output "
                         "(not needed with --disasm or --audit-straddle)")
    ap.add_argument("--image", help="kernel Image from the SAME build — adds "
                                    "the instruction to every line")
    ap.add_argument("--disasm", type=lambda s: int(s, 0), default=None,
                    help="dump instructions from this virtual address and exit")
    ap.add_argument("--count", type=int, default=16,
                    help="instructions for --disasm (default 16)")
    ap.add_argument("--audit-straddle", action="store_true",
                    help="scan the image for branch/jump targets on the last "
                         "word of a page (the fetch-pair straddle shape)")
    ap.add_argument("--load-pa", type=lambda s: int(s, 0), default=0x01400000,
                    help="physical load address of the Image (default 0x01400000)")
    ap.add_argument("--load-va", type=lambda s: int(s, 0), default=0xC0000000,
                    help="virtual link address of the Image (default 0xc0000000)")
    ap.add_argument("--from", dest="start", type=lambda s: int(s, 0), default=0,
                    help="ignore samples before this clock")
    ap.add_argument("--to", dest="end", type=lambda s: int(s, 0), default=None,
                    help="ignore samples after this clock")
    ap.add_argument("--top", type=int, default=15, help="histogram rows (default 15)")
    ap.add_argument("--timeline", action="store_true",
                    help="print every sample, not just the histogram")
    args = ap.parse_args()

    res = Resolver(load_symbols(args.system_map))

    img = None
    if args.image:
        img = Image(args.image, args.load_va)

    # ---- modes that read the image and no log ------------------------------
    if args.disasm is not None or args.audit_straddle:
        if img is None:
            sys.exit("--disasm and --audit-straddle need --image <Image>")

    if args.disasm is not None:
        for ins in rvdis.walk(img.data, args.load_va, args.disasm,
                              args.count, res.offset):
            mark = " <-- last word of a page" if (ins.pc & 0xFFF) == 0xFFC else ""
            print(f"{ins.pc:08x}  {res.offset(ins.pc):<28} "
                  f"{ins.word:08x}  {ins.text}{mark}")
        return

    if args.audit_straddle:
        hits = audit_straddle(img, res)
        print(f"{len(hits)} control-flow targets land on the last word of a "
              f"4 KiB page\n")
        for va, ins, tword in hits:
            tgt = ins.target
            after = f"{tword:08x}" if tword is not None else "????????"
            print(f"{va:08x}  {res.offset(va):<28} {ins.text}")
            print(f"{'':>10}target {tgt:08x} {res.offset(tgt):<21} "
                  f"first word there: {after} "
                  f"({rvdis.disasm(tword, tgt) if tword is not None else '?'})")
        if hits:
            print("\nThese are the sites where a fetch pair straddles a page "
                  "on the FIRST fetch after the jump.\nDefect #3 (npc stepping "
                  "by 8 across a dropped word) is fixed; this is a sentinel.")
        return

    if not args.log:
        sys.exit("give a log, or use --disasm/--audit-straddle with --image")
    rows = parse(args.log, args.load_pa, args.load_va)
    if not rows:
        sys.exit(f"{args.log}: no trace lines found. Was the run given "
                 f"+trace=<n> or +tfrom=/+tlen=? (a plain boot log has none)")

    window = [r for r in rows
              if r[0] >= args.start and (args.end is None or r[0] <= args.end)]
    if not window:
        sys.exit(f"no samples in [{args.start}, {args.end}] — the log covers "
                 f"clocks {rows[0][0]} to {rows[-1][0]}")

    print(f"{len(rows)} trace samples, clocks {rows[0][0]}..{rows[-1][0]}")
    if args.start or args.end is not None:
        print(f"window: {len(window)} samples in "
              f"[{args.start}, {args.end if args.end is not None else 'end'}]")
    print()

    if args.timeline:
        for clk, va, tag, stalled in window:
            flag = "  <-- d_req with no ack" if stalled else ""
            insn = f"  {img.show(va, res.offset)}" if img else ""
            print(f"{clk:>12}  {va:08x}  {res.offset(va):<26}{insn}{flag}")
        print()

    hist = collections.Counter(res.name(va) for _, va, _, _ in window)
    # Distinct addresses per symbol is what separates "looping inside one
    # function" from "walking through a long one". Without it a big unrolled
    # routine is indistinguishable from a hang, which is exactly the mistake
    # that cost this project a session.
    seen = collections.defaultdict(set)
    for _, va, _, _ in window:
        seen[res.name(va)].add(va)

    total = len(window)
    print(f"{'samples':>8} {'%':>6} {'addrs':>6}  symbol")
    for name, count in hist.most_common(args.top):
        print(f"{count:>8} {100.0 * count / total:>5.1f}% {len(seen[name]):>6}  {name}")

    # Plain ASCII from here down, deliberately: on a cp1252 console a
    # decorative symbol in a warning does not degrade the message, it destroys
    # the whole run — right where the tool was about to say something urgent.
    # ⚠️ That rule was not enough on its own. It is a thing someone has to
    # remember, and the docstring above broke it, which is why `--help` crashed
    # from the day this file was written until 2026-08-08. rvdis.safe_console()
    # in main() is now the actual guarantee; this stays as the local habit.
    stalls = sum(1 for _, _, _, s in window if s)
    if stalls:
        print(f"\n[!] {stalls}/{total} samples ({100.0 * stalls / total:.1f}%) show a "
              f"data request up with no acknowledgement.")
        print("    A high share means the core is waiting on the bus, not looping "
              "in software.")

    top_name, top_count = hist.most_common(1)[0]
    if total >= 10 and top_count / total > 0.9 and len(seen[top_name]) <= 3:
        print(f"\n[!] {top_count}/{total} samples are in {top_name} at only "
              f"{len(seen[top_name])} distinct addresses.")
        print("    That is a spin, not slow progress.")
        # With an image this is the whole answer rather than the next step: a
        # spin at three addresses IS the loop, so print it instead of telling
        # the reader to go and re-run the bench with +tfrom=.
        if img:
            print("    The loop:")
            for va in sorted(seen[top_name]):
                print(f"      {va:08x}  {res.offset(va):<26}"
                      f"  {img.show(va, res.offset)}")
        else:
            print("    Re-run with --image <Image> to see the instructions, or "
                  "trace the window with +tfrom=/+tlen=.")


if __name__ == "__main__":
    main()
