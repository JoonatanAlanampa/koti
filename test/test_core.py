# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# muldiv unit tests: every RV32M op against a Python golden model —
# directed edge cases plus seeded random vectors.

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU = range(8)

M32 = 0xFFFF_FFFF
INT_MIN = 0x8000_0000


def s32(x):
    x &= M32
    return x - (1 << 32) if x & INT_MIN else x


def golden(f3, a, b):
    a &= M32
    b &= M32
    if f3 == MUL:
        return (a * b) & M32
    if f3 == MULH:
        return ((s32(a) * s32(b)) >> 32) & M32
    if f3 == MULHSU:
        return ((s32(a) * b) >> 32) & M32
    if f3 == MULHU:
        return ((a * b) >> 32) & M32
    if f3 in (DIV, REM):
        sa, sb = s32(a), s32(b)
        if sb == 0:
            return M32 if f3 == DIV else a
        if sa == -(1 << 31) and sb == -1:
            return INT_MIN if f3 == DIV else 0
        q = abs(sa) // abs(sb)
        r = abs(sa) % abs(sb)
        if f3 == DIV:
            return (-q if (sa < 0) != (sb < 0) else q) & M32
        return (-r if sa < 0 else r) & M32
    if b == 0:
        return M32 if f3 == DIVU else a
    return (a // b if f3 == DIVU else a % b) & M32


async def run_op(dut, f3, a, b):
    dut.funct3.value = f3
    dut.a.value = a
    dut.b.value = b
    dut.start.value = 1
    for _ in range(64):
        await ClockCycles(dut.clk, 1)
        if dut.done.value:
            break
    else:
        raise AssertionError(f"muldiv timeout f3={f3} a={a:#x} b={b:#x}")
    dut.start.value = 0
    got = int(dut.result.value)
    exp = golden(f3, a, b)
    assert got == exp, (
        f"f3={f3} a={a:#010x} b={b:#010x}: got {got:#010x} exp {exp:#010x}"
    )
    dut.ack.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ack.value = 0
    await ClockCycles(dut.clk, 1)


EDGES = [0, 1, 2, 3, 0xFFFF_FFFF, 0xFFFF_FFFE, INT_MIN,
         0x7FFF_FFFF, 0x0000_FFFF, 0xFFFF_0000, 5, 7]


@cocotb.test()
async def test_muldiv(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    dut.start.value = 0
    dut.ack.value = 0
    dut.rst.value = 1
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 2)

    # directed: all ops over the edge-value cross product
    for f3 in range(8):
        for a in EDGES:
            for b in EDGES:
                await run_op(dut, f3, a, b)

    # random vectors, reproducible
    rng = random.Random(0xC0DE)
    for _ in range(100):
        f3 = rng.randrange(8)
        a = rng.randrange(1 << 32)
        b = rng.randrange(1 << 32)
        await run_op(dut, f3, a, b)
