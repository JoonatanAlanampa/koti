#!/usr/bin/env python3
"""test_rvdis.py — the gate for tools/rvdis.py and ktrace.py's --audit-straddle.

    python test/test_rvdis.py

Pure Python: no cocotb, no iverilog, no RISC-V toolchain. It runs on the
development host in under a second, which is the point — a diagnostic tool that
needs a CI round trip to check is a diagnostic tool nobody checks.

⭐ WHERE THE EXPECTED STRINGS COME FROM, because it is the only reason to
believe them: EVERY entry in GOLDEN was produced by GNU binutils
(riscv-none-elf-as + riscv-none-elf-objdump, 2026-08-08), not written out by
hand. Hand-computing an instruction encoding to test a decoder means testing
the decoder against the same understanding that produced it, which proves
nothing. The wider check behind this table was the same tool over every ELF in
sw/: 3873 instructions, zero mnemonic differences, and all 12 residual
formatting differences were .rodata STRINGS being decoded as instructions by
both tools.

⚠️ The straddle controls below are the important half of this file. An audit
that can never fire prints "0 sites" and reads exactly like "all clear" — this
project has caught that shape of defect nine times. So the positive control
crafts an image that MUST produce a hit, and fails if it does not.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import os
import struct
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, os.pardir, "tools"))
import rvdis    # noqa: E402
import ktrace   # noqa: E402

# (word, pc, expected text) — all three columns from binutils. pc matters only
# for PC-relative control flow; it is 0 elsewhere.
GOLDEN = [
    (0x1005A52F, 0, "lr.w a0,(a1)"),
    (0x1405A52F, 0, "lr.w.aq a0,(a1)"),
    (0x1AC5A52F, 0, "sc.w.rl a0,a2,(a1)"),
    (0x00B6252F, 0, "amoadd.w a0,a1,(a2)"),
    (0x08E7A6AF, 0, "amoswap.w a3,a4,(a5)"),
    (0x4063A2AF, 0, "amoor.w t0,t1,(t2)"),
    (0xE13A292F, 0, "amomaxu.w s2,s3,(s4)"),
    (0x30200073, 0, "mret"),
    (0x10200073, 0, "sret"),
    (0x10500073, 0, "wfi"),
    (0x00000073, 0, "ecall"),
    (0x00100073, 0, "ebreak"),
    (0x0FF0000F, 0, "fence"),
    (0x0000100F, 0, "fence.i"),
    (0x12B50073, 0, "sfence.vma a0,a1"),
    (0x18079073, 0, "csrw satp,a5"),
    (0xF1402573, 0, "csrr a0,mhartid"),
    (0x300312F3, 0, "csrrw t0,mstatus,t1"),
    (0x10016073, 0, "csrsi sstatus,2"),
    (0xC0102573, 0, "rdtime a0"),
    (0x02C58533, 0, "mul a0,a1,a2"),
    (0x02F756B3, 0, "divu a3,a4,a5"),
    (0x0324F433, 0, "remu s0,s1,s2"),
    (0x407302B3, 0, "sub t0,t1,t2"),
    (0x407352B3, 0, "sra t0,t1,t2"),
    (0x4075D513, 0, "srai a0,a1,0x7"),
    (0x00359513, 0, "slli a0,a1,0x3"),
    (0x40B00533, 0, "neg a0,a1"),
    (0xFFF5C513, 0, "not a0,a1"),
    (0x0015B513, 0, "seqz a0,a1"),
    (0x00B03533, 0, "snez a0,a1"),
    (0x0FF5F513, 0, "zext.b a0,a1"),
    (0xFFD5C503, 0, "lbu a0,-3(a1)"),
    (0x00C69323, 0, "sh a2,6(a3)"),
    (0x12345537, 0, "lui a0,0x12345"),
    (0x00100597, 0, "auipc a1,0x100"),
    # Control flow, where the pc column earns its place: the printed target is
    # pc + imm, so a decoder that ignores pc still passes an operand-free check.
    (0x00C5FC63, 0x1C, "bgeu a1,a2,34"),
    (0x7FD0006F, 0x00, "j ffc"),
    (0x00008067, 0, "ret"),
    (0x00010113, 0, "mv sp,sp"),
    (0x00000313, 0, "li t1,0"),
    (0x00000013, 0, "nop"),
]

fails = []


def check(cond, what):
    if not cond:
        fails.append(what)
    return cond


def test_golden():
    for word, pc, want in GOLDEN:
        got = rvdis.decode(word, pc).text
        check(got == want,
              f"decode(0x{word:08x}, pc=0x{pc:x}) = {got!r}, want {want!r}")
    print(f"  golden table: {len(GOLDEN)} instructions from binutils")


def test_compressed_guard():
    """koti cannot execute compressed instructions, and a linear disassembler is
    only exact because of it. Saying so out loud beats a decoder that invents a
    32-bit mnemonic from a 16-bit halfword."""
    check(rvdis.is_uncompressed(0x00000013), "addi should be uncompressed")
    check(not rvdis.is_uncompressed(0x00004501), "c.li should be compressed")
    check(".word" in rvdis.decode(0x00004501, 0).text,
          "a compressed word must decode to .word, not to a mnemonic")
    print("  compressed guard: a 16-bit encoding is refused, not guessed")


def _jal(rd, imm):
    return ((((imm >> 20) & 1) << 31) | (((imm >> 1) & 0x3FF) << 21)
            | (((imm >> 11) & 1) << 20) | (((imm >> 12) & 0xFF) << 12)
            | (rd << 7) | 0x6F)


def test_straddle_controls():
    """POSITIVE first. The whole value of an audit is that it can fail."""
    buf = bytearray(0x1004)
    struct.pack_into("<I", buf, 0, _jal(0, 0xFFC))       # j 0xffc
    struct.pack_into("<I", buf, 0xFFC, 0x00E6A683)       # lw a3,14(a3)
    with tempfile.TemporaryDirectory() as d:
        pos = os.path.join(d, "pos.bin")
        with open(pos, "wb") as fh:
            fh.write(bytes(buf))
        img = ktrace.Image(pos, 0)
        hits = ktrace.audit_straddle(img, None)
        check(len(hits) == 1,
              f"positive control: expected exactly 1 straddle site, got {len(hits)}")
        if hits:
            check(hits[0][1].target == 0xFFC,
                  f"positive control: target should be 0xffc, got {hits[0][1].target:#x}")

        # NEGATIVE: the same jump one word earlier is entirely inside the page.
        struct.pack_into("<I", buf, 0, _jal(0, 0xFF8))
        neg = os.path.join(d, "neg.bin")
        with open(neg, "wb") as fh:
            fh.write(bytes(buf))
        hits = ktrace.audit_straddle(ktrace.Image(neg, 0), None)
        check(len(hits) == 0,
              f"negative control: a jump to 0xff8 must NOT be flagged, got {len(hits)}")
    print("  straddle audit: fires on a crafted site, silent one word earlier")


def test_image_addressing():
    """The Image maps byte 0 to the load address and nothing else. Getting this
    wrong resolves to a plausible WRONG instruction, which is the same class of
    silent error as mixing physical and virtual addresses in ktrace itself."""
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "i.bin")
        with open(p, "wb") as fh:
            fh.write(struct.pack("<III", 0x00000013, 0x00100073, 0x00008067))
        img = ktrace.Image(p, 0xC0000000)
        check(img.word(0xC0000000) == 0x00000013, "byte 0 must be the load address")
        check(img.word(0xC0000008) == 0x00008067, "third word should be ret")
        check(img.word(0xBFFFFFFC) is None, "below the image must be None")
        check(img.word(0xC0000100) is None, "past the end must be None")
        check("ebreak" in img.show(0xC0000004), "show() should disassemble")
    print("  image addressing: in-range, out-of-range and both edges")


def main():
    print("test_rvdis:")
    test_golden()
    test_compressed_guard()
    test_straddle_controls()
    test_image_addressing()
    if fails:
        print(f"\ntest_rvdis: FAIL ({len(fails)})")
        for f in fails:
            print(f"  {f}")
        sys.exit(1)
    print("\ntest_rvdis: PASS")


if __name__ == "__main__":
    main()
