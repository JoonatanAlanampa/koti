# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Instruction-level tests: hand-assembled RV32IM programs poked into
# imem by backdoor, run on the real 5-stage pipeline to ECALL, results
# read back from the regfile. Targets what the muldiv unit tests can't
# see: forwarding of M results, load-use + muldiv interaction, branch
# flushes around muldiv, and the full 32-register file.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

M32 = 0xFFFF_FFFF

# ---- tiny assembler ----------------------------------------------------


def _r(f7, rs2, rs1, f3, rd, op):
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def addi(rd, rs1, imm):
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x13


def lui(rd, imm):
    return (imm & 0xFFFF_F000) | (rd << 7) | 0x37


def li(rd, val):
    """Materialize any 32-bit value in rd (1-2 instructions)."""
    val &= M32
    lo = val & 0xFFF
    hi = (val - (lo - 0x1000 if lo >= 0x800 else lo)) & M32
    if hi == 0:
        return [addi(rd, 0, lo)]
    out = [lui(rd, hi)]
    if lo:
        out.append(addi(rd, rd, lo))
    return out


def add(rd, rs1, rs2):
    return _r(0x00, rs2, rs1, 0, rd, 0x33)


def sub(rd, rs1, rs2):
    return _r(0x20, rs2, rs1, 0, rd, 0x33)


def mop(f3, rd, rs1, rs2):          # MUL..REMU via funct3 0..7
    return _r(0x01, rs2, rs1, f3, rd, 0x33)


def lw(rd, rs1, imm):
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03


def sw(rs2, rs1, imm):
    imm &= 0xFFF
    return ((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | \
        ((imm & 0x1F) << 7) | 0x23


def beq(rs1, rs2, off):
    off &= 0x1FFF
    return ((off >> 12) << 31) | (((off >> 5) & 0x3F) << 25) | (rs2 << 20) | \
        (rs1 << 15) | (0 << 12) | (((off >> 1) & 0xF) << 8) | \
        (((off >> 11) & 1) << 7) | 0x63


ECALL = 0x0000_0073

# ---- harness -----------------------------------------------------------


async def run_program(dut, words, max_cycles=20000):
    dut.rst.value = 1
    await ClockCycles(dut.clk, 5)
    for i, w in enumerate(words):
        dut.c0.im.mem[i].value = w
    # pad with ECALL so runaway fetch halts instead of executing X
    for i in range(len(words), len(words) + 16):
        dut.c0.im.mem[i].value = ECALL
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0
    for _ in range(max_cycles):
        await ClockCycles(dut.clk, 1)
        if dut.halted.value:
            return
    raise AssertionError("program never halted")


def reg(dut, n):
    assert n != 0
    return int(dut.c0.rf.regs[n].value)


GOLD = {  # (a, b) -> per-op expected, mirrors test_core golden cases
    (0xFFFF_FFF9, 3): {0: 0xFFFF_FFEB, 1: M32, 3: 2,
                       4: 0xFFFF_FFFE, 6: 0xFFFF_FFFF},   # a = -7
    (0x8000_0000, M32): {4: 0x8000_0000, 6: 0},           # overflow
    (7, 0): {4: M32, 5: M32, 6: 7, 7: 7},                 # div by zero
}


@cocotb.test()
async def test_regs_and_arith(dut):
    """All 32 registers hold distinct values through add/sub."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = []
    for n in range(1, 32):
        prog += li(n, 0x1000_0000 + n * 0x0101)
    prog += [add(1, 30, 31), sub(2, 31, 30), ECALL]
    await run_program(dut, prog)
    for n in range(3, 32):
        assert reg(dut, n) == 0x1000_0000 + n * 0x0101, f"x{n}"
    assert reg(dut, 1) == ((0x1000_0000 + 30 * 0x0101)
                           + (0x1000_0000 + 31 * 0x0101)) & M32
    assert reg(dut, 2) == 0x0101


@cocotb.test()
async def test_muldiv_instructions(dut):
    """M ops through the pipeline against precomputed results."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    for (a, b), cases in GOLD.items():
        prog = li(1, a) + li(2, b)
        rds = []
        for i, f3 in enumerate(sorted(cases)):
            rd = 10 + i
            prog.append(mop(f3, rd, 1, 2))
            rds.append((rd, cases[f3]))
        prog.append(ECALL)
        await run_program(dut, prog)
        for rd, exp in rds:
            assert reg(dut, rd) == exp, f"a={a:#x} b={b:#x} x{rd}"


@cocotb.test()
async def test_muldiv_forwarding(dut):
    """Results forward into dependent ALU/M ops with no dead cycles."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 7) + li(2, 3) + [
        mop(0, 3, 1, 2),      # x3 = 21
        add(4, 3, 3),         # forwards from M:      x4 = 42
        mop(0, 5, 3, 4),      # both operands young:  x5 = 882
        mop(4, 6, 5, 2),      # div on fresh result:  x6 = 294
        addi(7, 6, 1),        # forwards from M:      x7 = 295
        ECALL,
    ])
    await run_program(dut, prog)
    assert reg(dut, 3) == 21
    assert reg(dut, 4) == 42
    assert reg(dut, 5) == 882
    assert reg(dut, 6) == 294
    assert reg(dut, 7) == 295


@cocotb.test()
async def test_loaduse_and_branch_with_muldiv(dut):
    """Load-use stall feeding muldiv; taken branch must kill a mul."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 6) + li(2, 0x100) + li(9, 99) + [
        sw(1, 2, 0),          # mem[0x100] = 6
        lw(3, 2, 0),          # x3 = 6
        mop(0, 4, 3, 3),      # load-use into muldiv: x4 = 36
        beq(1, 1, 8),         # taken: skip the next mul
        mop(0, 9, 4, 4),      # must be flushed, x9 stays 99
        sub(5, 4, 3),         # x5 = 30
        ECALL,
    ])
    await run_program(dut, prog)
    assert reg(dut, 4) == 36
    assert reg(dut, 9) == 99, "flushed mul wrote its register"
    assert reg(dut, 5) == 30
