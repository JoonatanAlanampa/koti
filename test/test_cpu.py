# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Instruction-level tests: hand-assembled RV32IM(+Zicsr) programs poked
# into imem by backdoor, run on the real 5-stage pipeline to EBREAK
# (the halt instruction — ECALL traps, it is the SBI path), results
# read back from the regfile. Covers what unit tests can't see:
# forwarding of M/CSR results, load-use + muldiv interaction, branch
# flushes, precise ECALL traps with MRET, and timer interrupts.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

M32 = 0xFFFF_FFFF

DATA = 0x0100_0100  # scratch word in PSRAM (flash is read-only)

MSTATUS, MISA, MIE, MTVEC = 0x300, 0x301, 0x304, 0x305
MSCRATCH, MEPC, MCAUSE = 0x340, 0x341, 0x342

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


def _csr(f3, rd, csr, rs1_or_z):
    return (csr << 20) | (rs1_or_z << 15) | (f3 << 12) | (rd << 7) | 0x73


def csrrw(rd, csr, rs1):
    return _csr(1, rd, csr, rs1)


def csrrs(rd, csr, rs1):
    return _csr(2, rd, csr, rs1)


def csrrc(rd, csr, rs1):
    return _csr(3, rd, csr, rs1)


def csrrwi(rd, csr, z):
    return _csr(5, rd, csr, z)


def csrrsi(rd, csr, z):
    return _csr(6, rd, csr, z)


def amo(f5, rd, rs1, rs2):          # rd = M[rs1] op= rs2 (word)
    return (f5 << 27) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | \
        (rd << 7) | 0x2F


LR, SC = 0b00010, 0b00011
ASWAP, AADD, AXOR, AOR, AAND = 0b00001, 0b00000, 0b00100, 0b01000, 0b01100
AMIN, AMAX, AMINU, AMAXU = 0b10000, 0b10100, 0b11000, 0b11100

ECALL = 0x0000_0073
EBREAK = 0x0010_0073
MRET = 0x3020_0073

HANDLER = 48  # word index of trap handlers in trap tests

# ---- harness -----------------------------------------------------------


async def run_program(dut, words, max_cycles=20000, mtip_at=None):
    dut.rst.value = 1
    dut.mtip.value = 0
    dut.msip.value = 0
    dut.meip.value = 0
    await ClockCycles(dut.clk, 5)
    for i, w in enumerate(words):
        dut.mem.flash[i].value = w
    # pad with EBREAK so runaway fetch halts instead of executing X
    for i in range(len(words), len(words) + 16):
        dut.mem.flash[i].value = EBREAK
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0
    for cyc in range(max_cycles):
        await ClockCycles(dut.clk, 1)
        if mtip_at is not None and cyc == mtip_at:
            dut.mtip.value = 1
        if dut.halted.value:
            return
    raise AssertionError("program never halted")


def reg(dut, n):
    assert n != 0
    return int(dut.c0.rf.regs[n].value)


def with_handler(main, handler):
    assert len(main) <= HANDLER
    return main + [EBREAK] * (HANDLER - len(main)) + handler


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
    prog += [add(1, 30, 31), sub(2, 31, 30), EBREAK]
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
        prog.append(EBREAK)
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
        EBREAK,
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
    prog = (li(1, 6) + li(2, DATA) + li(9, 99) + [
        sw(1, 2, 0),          # mem[DATA] = 6
        lw(3, 2, 0),          # x3 = 6
        mop(0, 4, 3, 3),      # load-use into muldiv: x4 = 36
        beq(1, 1, 8),         # taken: skip the next mul
        mop(0, 9, 4, 4),      # must be flushed, x9 stays 99
        sub(5, 4, 3),         # x5 = 30
        EBREAK,
    ])
    await run_program(dut, prog)
    assert reg(dut, 4) == 36
    assert reg(dut, 9) == 99, "flushed mul wrote its register"
    assert reg(dut, 5) == 30


@cocotb.test()
async def test_amo_rmw(dut):
    """Every AMO op read-modify-writes memory; old value lands in rd."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 7) + li(2, DATA) + li(3, 0xFF) + li(4, 0x0F)
            + li(5, 0xF0) + li(6, 0xFFFF_FFFB) + li(7, 5) + [   # x6 = -5
        sw(7, 2, 0),                # mem = 5
        amo(AADD, 10, 2, 1),        # x10 = 5,    mem = 12
        amo(ASWAP, 11, 2, 1),       # x11 = 12,   mem = 7
        amo(AXOR, 12, 2, 3),        # x12 = 7,    mem = 0xF8
        amo(AOR, 13, 2, 4),         # x13 = 0xF8, mem = 0xFF
        amo(AAND, 14, 2, 5),        # x14 = 0xFF, mem = 0xF0
        amo(AMIN, 15, 2, 6),        # x15 = 0xF0, mem = -5
        amo(AMAX, 16, 2, 1),        # x16 = -5,   mem = 7
        amo(AMINU, 17, 2, 6),       # x17 = 7,    mem = 7
        amo(AMAXU, 18, 2, 6),       # x18 = 7,    mem = 0xFFFFFFFB
        amo(AADD, 20, 2, 1),        # x20 = -5,   mem = 2
        add(22, 20, 1),             # AMO result hazard: x22 = 2
        lw(19, 2, 0),               # x19 = 2
        EBREAK,
    ])
    await run_program(dut, prog)
    exp = {10: 5, 11: 12, 12: 7, 13: 0xF8, 14: 0xFF, 15: 0xF0,
           16: 0xFFFF_FFFB, 17: 7, 18: 7, 20: 0xFFFF_FFFB,
           22: 2, 19: 2}
    for rd, val in exp.items():
        assert reg(dut, rd) == val, f"x{rd}"


@cocotb.test()
async def test_lr_sc(dut):
    """SC succeeds only under a live reservation; stores kill it."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 42) + li(2, DATA) + li(3, 77) + li(4, 5) + [
        sw(4, 2, 0),                # mem = 5
        amo(LR, 10, 2, 0),          # x10 = 5, reservation armed
        amo(SC, 11, 2, 1),          # x11 = 0 (ok),  mem = 42
        amo(SC, 12, 2, 3),          # x12 = 1 (fail), mem stays 42
        amo(LR, 13, 2, 0),          # x13 = 42, re-arm
        sw(3, 2, 0),                # intervening store kills it
        amo(SC, 14, 2, 1),          # x14 = 1 (fail), mem stays 77
        lw(15, 2, 0),               # x15 = 77
        EBREAK,
    ])
    await run_program(dut, prog)
    assert reg(dut, 10) == 5
    assert reg(dut, 11) == 0, "first SC should succeed"
    assert reg(dut, 12) == 1, "SC without reservation must fail"
    assert reg(dut, 13) == 42
    assert reg(dut, 14) == 1, "SC after intervening store must fail"
    assert reg(dut, 15) == 77


@cocotb.test()
async def test_csr_ops(dut):
    """CSR read/modify/write forms, and CSR results forward like ALU."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 0x1234_5678) + li(3, 0x0F0F) + [
        csrrw(0, MSCRATCH, 1),    # mscratch = 0x12345678
        csrrs(2, MSCRATCH, 0),    # x2 = 0x12345678
        csrrs(4, MSCRATCH, 3),    # x4 = old, mscratch |= 0x0F0F
        csrrc(5, MSCRATCH, 3),    # x5 = 0x12345F7F, then clear bits
        csrrwi(6, MSCRATCH, 21),  # x6 = 0x12345070, mscratch = 21
        csrrsi(7, MSCRATCH, 10),  # x7 = 21, mscratch = 31
        csrrs(8, MSCRATCH, 0),    # x8 = 31
        add(9, 2, 8),             # CSR result forwards: x9 = x2 + 31
        csrrs(10, MISA, 0),       # x10 = RV32IM misa
        EBREAK,
    ])
    await run_program(dut, prog)
    assert reg(dut, 2) == 0x1234_5678
    assert reg(dut, 4) == 0x1234_5678
    assert reg(dut, 5) == 0x1234_5F7F
    assert reg(dut, 6) == 0x1234_5070
    assert reg(dut, 7) == 21
    assert reg(dut, 8) == 31
    assert reg(dut, 9) == (0x1234_5678 + 31) & M32
    assert reg(dut, 10) == 0x4000_1100


@cocotb.test()
async def test_ecall_trap_and_mret(dut):
    """ECALL enters the handler precisely; MRET resumes after it."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, HANDLER * 4) + [
        csrrw(0, MTVEC, 1),
        addi(10, 0, 0),
        ECALL,                    # -> handler, mepc = this address
        addi(10, 10, 100),        # resumes here
        EBREAK,
    ])
    ecall_addr = 4 * main.index(ECALL)
    handler = [
        csrrs(11, MCAUSE, 0),     # 11 = ECALL from M-mode
        csrrs(12, MEPC, 0),
        addi(13, 12, 4),
        csrrw(0, MEPC, 13),
        MRET,
    ]
    await run_program(dut, with_handler(main, handler))
    assert reg(dut, 10) == 100, "MRET did not resume after ECALL"
    assert reg(dut, 11) == 11
    assert reg(dut, 12) == ecall_addr


@cocotb.test()
async def test_timer_interrupt(dut):
    """mtip fires mid-loop; handler runs once, main escapes cleanly."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, HANDLER * 4) + [
        csrrw(0, MTVEC, 1),
        addi(20, 0, 0x80),        # mie.MTIE
        csrrs(0, MIE, 20),
        csrrsi(0, MSTATUS, 8),    # mstatus.MIE
        addi(13, 0, 0),
        addi(21, 0, 0),
        # loop:
        addi(13, 13, 1),
        beq(21, 0, -4),           # spin until the handler sets x21
        EBREAK,
    ])
    handler = [
        csrrs(14, MCAUSE, 0),     # 0x80000007 = machine timer irq
        addi(15, 0, 0x80),
        csrrc(0, MIE, 15),        # mask MTIE (mtip stays high)
        addi(21, 0, 1),
        MRET,
    ]
    await run_program(dut, with_handler(main, handler), mtip_at=150)
    assert reg(dut, 14) == 0x8000_0007
    assert reg(dut, 21) == 1
    assert reg(dut, 13) >= 1, "loop never ran"
