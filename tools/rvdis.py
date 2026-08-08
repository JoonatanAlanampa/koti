#!/usr/bin/env python3
"""rvdis.py — an RV32IMA_Zicsr disassembler for koti.

WHY THIS EXISTS. `test/run_cpu.py` has carried a tiny assembler since the day
the directed tests were written, and nothing in this repo ever went the other
way. That asymmetry has a cost, and this project has paid it three times: every
CPU defect found so far — the AMO/page-walk livelock, the arbiter's dropped
request, and the straddling fetch pair — was diagnosed by staring at addresses
and asking what instruction lived there. `tools/ktrace.py` could answer *which
symbol*. It could not answer *which instruction*, which is the question that
actually ends the search.

WHY LINEAR DISASSEMBLY IS EXACT HERE, and what would break it. koti cannot
decode compressed instructions, and `sw/linux/check_config.py` keeps
`CONFIG_RISCV_ISA_C` off precisely because `config EFI` would otherwise
`select` it back on. So every instruction is exactly four bytes on a four-byte
boundary, there is no alignment ambiguity, and walking a buffer four bytes at a
time cannot desynchronise. On a target WITH the C extension this whole approach
is wrong — you must follow the length bits from a known entry point — and it is
wrong silently, producing plausible instructions from misaligned halfwords.
⚠️ If koti ever gains the C extension, this file has to be rewritten, not
tweaked. `is_uncompressed()` is here so a caller can assert the assumption
rather than inherit it.

⚠️ WHAT THIS IS NOT. It decodes; it does not know what is code. Point it at
`.rodata`, at the kernel's appended initramfs, or at the 64-byte Image header
and it will cheerfully print instructions, because every 32-bit value decodes as
something or as `.word`. The caller decides what is text. `ktrace.py` sidesteps
this by only ever disassembling addresses the CPU actually fetched.

Standalone:
    python tools/rvdis.py <file> --base 0xc0000000 --at 0xc00b8ffc --count 8
    python tools/rvdis.py --word 0x00150513

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import argparse
import sys

# ABI names, not x0..x31. The trace of a kernel is read against a calling
# convention — "a0" says argument/return, "sp" says stack — and x10 says
# nothing. objdump defaults to these for the same reason.
REGS = [
    "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
    "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
    "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
    "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6",
]

CSRS = {
    0x100: "sstatus", 0x104: "sie", 0x105: "stvec", 0x106: "scounteren",
    0x140: "sscratch", 0x141: "sepc", 0x142: "scause", 0x143: "stval",
    0x144: "sip", 0x180: "satp",
    0x300: "mstatus", 0x301: "misa", 0x302: "medeleg", 0x303: "mideleg",
    0x304: "mie", 0x305: "mtvec", 0x306: "mcounteren", 0x30A: "menvcfg",
    0x310: "mstatush",
    0x340: "mscratch", 0x341: "mepc", 0x342: "mcause", 0x343: "mtval",
    0x344: "mip",
    0xB00: "mcycle", 0xB02: "minstret", 0xB80: "mcycleh", 0xB82: "minstreth",
    0xC00: "cycle", 0xC01: "time", 0xC02: "instret",
    0xC80: "cycleh", 0xC81: "timeh", 0xC82: "instreth",
    0xF11: "mvendorid", 0xF12: "marchid", 0xF13: "mimpid", 0xF14: "mhartid",
}

BRANCH = {0: "beq", 1: "bne", 4: "blt", 5: "bge", 6: "bltu", 7: "bgeu"}
LOAD = {0: "lb", 1: "lh", 2: "lw", 4: "lbu", 5: "lhu"}
STORE = {0: "sb", 1: "sh", 2: "sw"}
OPIMM = {0: "addi", 2: "slti", 3: "sltiu", 4: "xori", 6: "ori", 7: "andi"}
OP = {0: "add", 1: "sll", 2: "slt", 3: "sltu", 4: "xor", 5: "srl",
      6: "or", 7: "and"}
OP_M = {0: "mul", 1: "mulh", 2: "mulhsu", 3: "mulhu",
        4: "div", 5: "divu", 6: "rem", 7: "remu"}
AMO = {0x00: "amoadd.w", 0x01: "amoswap.w", 0x02: "lr.w", 0x03: "sc.w",
       0x04: "amoxor.w", 0x08: "amoor.w", 0x0C: "amoand.w",
       0x10: "amomin.w", 0x14: "amomax.w", 0x18: "amominu.w",
       0x1C: "amomaxu.w"}


def safe_console():
    """Stop a decorative character from killing a diagnostic run.

    This host's console is cp1252 and Python RAISES UnicodeEncodeError on a
    character it cannot encode rather than dropping it, so one symbol anywhere
    in the output destroys the whole run — typically after the useful part has
    already been printed. ktrace.py carried a comment about this and was
    nonetheless broken by it: measured 2026-08-08, `ktrace.py --help` had been
    crashing on its own module docstring since the day it was written, because
    argparse prints the description and the description had a warning sign in
    it. Keeping every string ASCII is a rule someone has to remember; this is
    not. Called by both tools at startup.
    """
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(errors="replace")
        except (AttributeError, ValueError):     # already wrapped, or a pipe
            pass


def _sext(value, bits):
    sign = 1 << (bits - 1)
    return (value ^ sign) - sign


def is_uncompressed(word):
    """True if `word` is a 32-bit instruction rather than a compressed pair.

    Exported so a caller can ASSERT koti's no-C-extension assumption on a real
    artifact instead of trusting the Kconfig that was supposed to produce it —
    the same move as auditing the netlist that ships rather than the config that
    describes it. `check_config.py` proves the symbol is off; this proves the
    bytes are.
    """
    return (word & 3) == 3


class Insn:
    """One decoded instruction. `target` is set only for PC-relative control
    flow, which is what a symbol resolver can usefully annotate."""

    __slots__ = ("pc", "word", "text", "target")

    def __init__(self, pc, word, text, target=None):
        self.pc = pc
        self.word = word
        self.text = text
        self.target = target

    def __str__(self):
        return self.text


def decode(word, pc=0):
    """Decode one 32-bit instruction word. Never raises: an undecodable word
    becomes `.word 0x…`, because a disassembler that stops at the first
    surprise is useless on exactly the logs worth reading."""
    word &= 0xFFFFFFFF
    op = word & 0x7F
    rd = (word >> 7) & 0x1F
    rs1 = (word >> 15) & 0x1F
    rs2 = (word >> 20) & 0x1F
    f3 = (word >> 12) & 7
    f7 = (word >> 25) & 0x7F
    d, s1, s2 = REGS[rd], REGS[rs1], REGS[rs2]

    def bad():
        return Insn(pc, word, f".word 0x{word:08x}")

    if not is_uncompressed(word):
        # Not an error here — koti simply cannot execute it. Say so rather than
        # inventing a mnemonic, because a compressed pair rendered as a 32-bit
        # instruction is the exact silent failure this file's header warns about.
        return Insn(pc, word, f".word 0x{word:08x}  # not a 32-bit insn")

    if op == 0x37:
        return Insn(pc, word, f"lui {d},0x{(word >> 12) & 0xFFFFF:x}")
    if op == 0x17:
        return Insn(pc, word, f"auipc {d},0x{(word >> 12) & 0xFFFFF:x}")

    if op == 0x6F:                                                    # JAL
        imm = _sext(((word >> 31) & 1) << 20 | ((word >> 12) & 0xFF) << 12
                    | ((word >> 20) & 1) << 11 | ((word >> 21) & 0x3FF) << 1, 21)
        tgt = (pc + imm) & 0xFFFFFFFF
        if rd == 0:
            return Insn(pc, word, f"j {tgt:x}", tgt)
        if rd == 1:
            return Insn(pc, word, f"jal {tgt:x}", tgt)
        return Insn(pc, word, f"jal {d},{tgt:x}", tgt)

    if op == 0x67 and f3 == 0:                                        # JALR
        imm = _sext(word >> 20, 12)
        if rd == 0 and rs1 == 1 and imm == 0:
            return Insn(pc, word, "ret")
        if rd == 0:
            return Insn(pc, word, f"jr {s1}" if imm == 0 else f"jr {imm}({s1})")
        if rd == 1 and imm == 0:
            return Insn(pc, word, f"jalr {s1}")
        return Insn(pc, word, f"jalr {d},{imm}({s1})")

    if op == 0x63:                                                    # BRANCH
        if f3 not in BRANCH:
            return bad()
        imm = _sext(((word >> 31) & 1) << 12 | ((word >> 7) & 1) << 11
                    | ((word >> 25) & 0x3F) << 5 | ((word >> 8) & 0xF) << 1, 13)
        tgt = (pc + imm) & 0xFFFFFFFF
        m = BRANCH[f3]
        if rs2 == 0 and m in ("beq", "bne", "blt", "bge"):
            return Insn(pc, word, f"{m}z {s1},{tgt:x}", tgt)
        return Insn(pc, word, f"{m} {s1},{s2},{tgt:x}", tgt)

    if op == 0x03:                                                    # LOAD
        if f3 not in LOAD:
            return bad()
        return Insn(pc, word, f"{LOAD[f3]} {d},{_sext(word >> 20, 12)}({s1})")

    if op == 0x23:                                                    # STORE
        if f3 not in STORE:
            return bad()
        imm = _sext(((word >> 25) & 0x7F) << 5 | ((word >> 7) & 0x1F), 12)
        return Insn(pc, word, f"{STORE[f3]} {s2},{imm}({s1})")

    if op == 0x13:                                                    # OP-IMM
        if f3 == 1 and f7 == 0x00:
            return Insn(pc, word, f"slli {d},{s1},0x{rs2:x}")
        if f3 == 5 and f7 in (0x00, 0x20):
            return Insn(pc, word,
                        f"{'srai' if f7 == 0x20 else 'srli'} {d},{s1},0x{rs2:x}")
        if f3 not in OPIMM:
            return bad()
        imm = _sext(word >> 20, 12)
        if f3 == 0:
            if rd == 0 and rs1 == 0 and imm == 0:
                return Insn(pc, word, "nop")
            # Order matters and it is objdump's, not an arbitrary choice:
            # `addi rd,zero,0` is both `li rd,0` and `mv rd,zero`, and picking
            # the other one makes every diff against a reference disassembly
            # noisy for no reason.
            if rs1 == 0:
                return Insn(pc, word, f"li {d},{imm}")
            if imm == 0:
                return Insn(pc, word, f"mv {d},{s1}")
        if f3 == 4 and imm == -1:
            return Insn(pc, word, f"not {d},{s1}")
        if f3 == 3 and imm == 1:
            return Insn(pc, word, f"seqz {d},{s1}")
        if f3 == 7 and imm == 255:
            return Insn(pc, word, f"zext.b {d},{s1}")
        return Insn(pc, word, f"{OPIMM[f3]} {d},{s1},{imm}")

    if op == 0x33:                                                    # OP
        if f7 == 0x01:
            return Insn(pc, word, f"{OP_M[f3]} {d},{s1},{s2}")
        if f7 == 0x20 and f3 in (0, 5):
            if f3 == 0 and rs1 == 0:
                return Insn(pc, word, f"neg {d},{s2}")
            return Insn(pc, word, f"{'sub' if f3 == 0 else 'sra'} {d},{s1},{s2}")
        if f7 != 0x00:
            return bad()
        if f3 == 3 and rs1 == 0:
            return Insn(pc, word, f"snez {d},{s2}")
        return Insn(pc, word, f"{OP[f3]} {d},{s1},{s2}")

    if op == 0x0F:                                                    # MISC-MEM
        if f3 == 1:
            return Insn(pc, word, "fence.i")
        if f3 == 0:
            return Insn(pc, word, "fence")
        return bad()

    if op == 0x2F:                                                    # AMO
        if f3 != 2:
            return bad()
        name = AMO.get(f7 >> 2)
        if name is None:
            return bad()
        suffix = ".aq" * ((f7 >> 1) & 1) + ".rl" * (f7 & 1)
        if name == "lr.w":
            return Insn(pc, word, f"lr.w{suffix} {d},({s1})")
        return Insn(pc, word, f"{name}{suffix} {d},{s2},({s1})")

    if op == 0x73:                                                    # SYSTEM
        csr = (word >> 20) & 0xFFF
        if f3 == 0:
            if f7 == 0x09:
                return Insn(pc, word, f"sfence.vma {s1},{s2}")
            return Insn(pc, word, {
                0x000: "ecall", 0x001: "ebreak",
                0x102: "sret", 0x302: "mret", 0x105: "wfi",
            }.get(csr, f".word 0x{word:08x}"))
        name = CSRS.get(csr, f"0x{csr:x}")
        if f3 in (1, 2, 3):
            if f3 == 2 and rs1 == 0:
                # rdtime is not cosmetic on koti: the core does NOT implement
                # the counter, the firmware EMULATES it out of the
                # illegal-instruction trap (sw/sbi). Seeing `rdtime` rather
                # than `csrr a0,time` in a trace is the difference between
                # "reads a register" and "takes a trap here".
                pseudo = {0xC01: "rdtime", 0xC81: "rdtimeh",
                          0xC00: "rdcycle", 0xC02: "rdinstret"}.get(csr)
                if pseudo:
                    return Insn(pc, word, f"{pseudo} {d}")
                return Insn(pc, word, f"csrr {d},{name}")       # read, no write
            if rd == 0:
                short = {1: "csrw", 2: "csrs", 3: "csrc"}[f3]   # write, no read
                return Insn(pc, word, f"{short} {name},{s1}")
            m = {1: "csrrw", 2: "csrrs", 3: "csrrc"}[f3]
            return Insn(pc, word, f"{m} {d},{name},{s1}")
        if f3 in (5, 6, 7):
            if rd == 0:
                short = {5: "csrwi", 6: "csrsi", 7: "csrci"}[f3]
                return Insn(pc, word, f"{short} {name},{rs1}")
            m = {5: "csrrwi", 6: "csrrsi", 7: "csrrci"}[f3]
            return Insn(pc, word, f"{m} {d},{name},{rs1}")
        return bad()

    return bad()


def disasm(word, pc=0, symfn=None):
    """One instruction as a string, with `<symbol+off>` on control flow."""
    ins = decode(word, pc)
    if ins.target is not None and symfn is not None:
        return f"{ins.text} <{symfn(ins.target)}>"
    return ins.text


def walk(data, base, start=None, count=None, symfn=None):
    """Yield Insn for a byte buffer laid out at virtual address `base`."""
    off = 0 if start is None else start - base
    if off < 0 or off >= len(data):
        return
    n = 0
    while off + 4 <= len(data) and (count is None or n < count):
        word = int.from_bytes(data[off:off + 4], "little")
        ins = decode(word, base + off)
        if ins.target is not None and symfn is not None:
            ins.text = f"{ins.text} <{symfn(ins.target)}>"
        yield ins
        off += 4
        n += 1


def main():
    safe_console()
    ap = argparse.ArgumentParser(description="disassemble RV32IMA_Zicsr")
    ap.add_argument("file", nargs="?", help="flat binary (e.g. the kernel Image)")
    ap.add_argument("--base", type=lambda s: int(s, 0), default=0xC0000000,
                    help="virtual address of byte 0 (default 0xc0000000)")
    ap.add_argument("--at", type=lambda s: int(s, 0), default=None,
                    help="start address (default: the base)")
    ap.add_argument("--count", type=int, default=16, help="instructions")
    ap.add_argument("--word", type=lambda s: int(s, 0), default=None,
                    help="decode a single literal word and exit")
    args = ap.parse_args()

    if args.word is not None:
        print(disasm(args.word, args.at or 0))
        return
    if not args.file:
        sys.exit("give a file, or --word 0x…")
    with open(args.file, "rb") as fh:
        data = fh.read()
    for ins in walk(data, args.base, args.at, args.count):
        print(f"{ins.pc:08x}:  {ins.word:08x}  {ins.text}")


if __name__ == "__main__":
    main()
