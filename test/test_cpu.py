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
MSCRATCH, MEPC, MCAUSE, MIP = 0x340, 0x341, 0x342, 0x344
MEDELEG, MIDELEG = 0x302, 0x303
SSTATUS, SIE, STVEC = 0x100, 0x104, 0x105
SEPC, SCAUSE = 0x141, 0x142
MTVAL, SATP = 0x343, 0x180

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


def jalr(rd, rs1, imm):
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x67


def slli(rd, rs1, sh):
    return ((sh & 0x1F) << 20) | (rs1 << 15) | (1 << 12) | (rd << 7) | 0x13


def andi(rd, rs1, imm):
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (7 << 12) | (rd << 7) | 0x13


def or_(rd, rs1, rs2):
    return _r(0x00, rs2, rs1, 6, rd, 0x33)


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
SRET = 0x1020_0073
SFENCE = 0x1200_0073  # sfence.vma x0, x0

HANDLER = 48  # word index of trap handlers in trap tests


def layout(main, sections):
    """Place code sections at fixed word indices, EBREAK-padded."""
    prog = list(main)
    for idx in sorted(sections):
        assert len(prog) <= idx, f"section at {idx} overlaps"
        prog += [EBREAK] * (idx - len(prog)) + sections[idx]
    return prog

# ---- harness -----------------------------------------------------------


async def run_program(dut, words, max_cycles=20000, mtip_at=None,
                      ram_zero=()):
    dut.rst.value = 1
    dut.mtip.value = 0
    dut.msip.value = 0
    dut.meip.value = 0
    await ClockCycles(dut.clk, 5)
    for i, w in enumerate(words):
        dut.mem.flash[i].value = w
    for start, count in ram_zero:      # e.g. page-table pages: a real
        for i in range(start, start + count):  # kernel zeroes them too
            dut.mem.ram[i].value = 0
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
        csrrs(10, MISA, 0),       # x10 = RV32IMA+SU misa
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
    assert reg(dut, 10) == 0x4014_1100


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


S_HANDLER, S_ENTRY = 64, 80


@cocotb.test()
async def test_smode_ecall_delegated(dut):
    """MRET drops to S; a delegated ECALL lands in the S handler;
    SRET resumes."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, S_HANDLER * 4) + [csrrw(0, STVEC, 1)]
            + li(2, 1 << 9) + [csrrs(0, MEDELEG, 2)]     # ecall-from-S -> S
            + li(3, S_ENTRY * 4) + [csrrw(0, MEPC, 3)]
            + li(4, 0x800) + [csrrs(0, MSTATUS, 4),      # MPP = 01 (S)
                              MRET])
    s_entry = [
        addi(10, 0, 0),
        ECALL,                      # delegated: S handler, scause 9
        addi(10, 10, 100),
        EBREAK,
    ]
    s_handler = [
        csrrs(11, SCAUSE, 0),
        csrrs(12, SEPC, 0),
        csrrs(17, SSTATUS, 0),      # SPP (bit 8) = came from S
        addi(13, 12, 4),
        csrrw(0, SEPC, 13),
        SRET,
    ]
    await run_program(dut, layout(main, {S_HANDLER: s_handler,
                                         S_ENTRY: s_entry}))
    assert reg(dut, 10) == 100, "SRET did not resume after the ECALL"
    assert reg(dut, 11) == 9, "scause != ecall-from-S"
    assert reg(dut, 12) == S_ENTRY * 4 + 4
    assert reg(dut, 17) & 0x100, "sstatus.SPP should say 'came from S'"


@cocotb.test()
async def test_umode_ecall_to_m(dut):
    """MRET drops to U (reset MPP=00); ECALL from U traps to M with
    cause 8 and MPP recording U."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(3, S_ENTRY * 4) + [csrrw(0, MEPC, 3),
                                    MRET])              # MPP reset = U
    u_entry = [
        addi(10, 0, 0),
        ECALL,                      # not delegated: M handler, cause 8
        addi(10, 10, 50),
        EBREAK,
    ]
    m_handler = [
        csrrs(11, MCAUSE, 0),
        csrrs(17, MSTATUS, 0),      # MPP (12:11) must be 00
        csrrs(12, MEPC, 0),
        addi(13, 12, 4),
        csrrw(0, MEPC, 13),
        MRET,
    ]
    await run_program(dut, layout(main, {HANDLER: m_handler,
                                         S_ENTRY: u_entry}))
    assert reg(dut, 10) == 50, "MRET did not resume U after the ECALL"
    assert reg(dut, 11) == 8, "mcause != ecall-from-U"
    assert reg(dut, 17) & 0x1800 == 0, "mstatus.MPP should record U"


@cocotb.test()
async def test_sbi_timer_path(dut):
    """The Linux timer flow: M takes MTI, masks it, injects STIP;
    the delegated S-timer interrupt lands in the S handler."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, S_HANDLER * 4) + [csrrw(0, STVEC, 2)]
            + li(3, 1 << 5) + [csrrs(0, MIDELEG, 3)]     # delegate STI
            + [addi(4, 0, 0x80), csrrs(0, MIE, 4)]       # MTIE
            + li(5, S_ENTRY * 4) + [csrrw(0, MEPC, 5)]
            + li(6, 0x800) + [csrrs(0, MSTATUS, 6),      # MPP = S
                              MRET])
    s_entry = [
        addi(2, 0, 1 << 5),
        csrrs(0, SIE, 2),           # sie.STIE
        csrrsi(0, SSTATUS, 2),      # sstatus.SIE
        beq(0, 0, 0),               # spin until the S-timer trap
    ]
    m_handler = [                   # "SBI firmware"
        csrrs(14, MCAUSE, 0),       # 0x80000007: machine timer
        addi(4, 0, 0x80),
        csrrc(0, MIE, 4),           # mask MTIE
        addi(4, 0, 1 << 5),
        csrrs(0, MIP, 4),           # inject STIP
        MRET,                       # back to S...
    ]
    s_handler = [
        csrrs(16, SCAUSE, 0),       # ...which takes 0x80000005
        EBREAK,
    ]
    await run_program(dut, layout(main, {HANDLER: m_handler,
                                         S_HANDLER: s_handler,
                                         S_ENTRY: s_entry}),
                      mtip_at=200)
    assert reg(dut, 14) == 0x8000_0007, "M did not take the MTI"
    assert reg(dut, 16) == 0x8000_0005, "S did not take the injected STI"


@cocotb.test()
async def test_sv32_translation_and_faults(dut):
    """M builds page tables, S runs translated: 4K RW page works, RO
    store / unmapped load / unmapped fetch raise causes 15/13/12 with
    correct mtval, and the RO page stays unmodified."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    ROOT, L0 = 0x0100_2000, 0x0100_3000
    # PTEs: root[0] identity 4MB megapage (code+MMIO, RWXAD);
    # root[0x100] -> L0; L0[0]: VA 0x40000000 -> PA 0x01001000 RW+AD;
    # L0[1]: VA 0x40001000 -> PA 0x01004000 RO+A
    main = ([addi(24, 0, 0), addi(26, 0, 0)]   # fault accumulators
            + li(5, ROOT)
            + li(6, 0x0000_00CF) + [sw(6, 5, 0)]
            + li(6, (L0 >> 12) << 10 | 1) + [sw(6, 5, 0x400)]
            + li(7, L0)
            + li(6, 0x1001 << 10 | 0xC7) + [sw(6, 7, 0)]
            + li(6, 0x1004 << 10 | 0x43) + [sw(6, 7, 4)]
            + li(8, 0x0100_4000) + li(9, 0x1234) + [sw(9, 8, 0)]
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, 0x8000_0000 | (ROOT >> 12)) + [csrrw(0, SATP, 2),
                                                   SFENCE]
            + li(3, S_ENTRY * 4) + [csrrw(0, MEPC, 3)]
            + li(4, 0x800) + [csrrs(0, MSTATUS, 4),      # MPP = S
                              MRET])
    s_entry = (li(10, 0x4000_0000) + li(11, 0xBEEF) + [
        sw(11, 10, 0),              # translated store
        lw(12, 10, 0),              # x12 = 0xBEEF back through the TLB
    ] + li(13, 0x4000_1000) + [
        lw(14, 13, 0),              # RO page read: x14 = 0x1234
        sw(11, 13, 0),              # RO store -> cause 15, skipped
    ] + li(15, 0x5000_0000) + [
        lw(16, 15, 0),              # unmapped load -> cause 13, skipped
        jalr(17, 15, 0),            # unmapped fetch -> cause 12, halt
    ])
    m_handler = [
        csrrs(20, MCAUSE, 0),
        slli(24, 24, 4),            # accumulate cause nibbles in x24
        andi(22, 20, 15),
        or_(24, 24, 22),
        csrrs(21, MTVAL, 0),
        add(25, 0, 26),             # x25/x26: last two tvals
        add(26, 0, 21),
        addi(22, 0, 12),
        beq(20, 22, 20),            # instruction fault: stop
        csrrs(23, MEPC, 0),         # else skip the faulting instr
        addi(23, 23, 4),
        csrrw(0, MEPC, 23),
        MRET,
        EBREAK,
    ]
    # zero the two page-table pages (root + L0), as a kernel would
    await run_program(dut, layout(main, {HANDLER: m_handler,
                                         S_ENTRY: s_entry}),
                      ram_zero=[((ROOT - 0x0100_0000) >> 2, 2048)])
    assert reg(dut, 12) == 0xBEEF, "translated store/load round-trip"
    assert reg(dut, 14) == 0x1234, "RO page read through the TLB"
    assert reg(dut, 24) == 0xFDC, \
        f"fault sequence {reg(dut, 24):#x} != store/load/fetch (F,D,C)"
    assert reg(dut, 25) == 0x5000_0000, "mtval of the load fault"
    assert reg(dut, 26) == 0x5000_0000, "mtval of the fetch fault"
    # physical effects: RW page written at its PA, RO page untouched
    assert int(dut.mem.ram[(0x0100_1000 - 0x0100_0000) >> 2].value) == 0xBEEF
    assert int(dut.mem.ram[(0x0100_4000 - 0x0100_0000) >> 2].value) == 0x1234


@cocotb.test()
async def test_illegal_and_misaligned(dut):
    """Causes 4/6/0/2 with correct mtval: misaligned loads/stores/
    fetch targets/AMOs, then unknown-encoding and unknown-CSR
    illegals (mtval = instruction bits)."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    bad_csr = csrrs(10, 0xCC0, 0)
    main = ([addi(24, 0, 0), addi(26, 0, 0)]
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, DATA) + li(3, DATA + 2) + [
        lw(11, 2, 2),           # cause 4, tval DATA+2
        sw(11, 2, 1),           # cause 6, tval DATA+1
        ((1 << 20) | (2 << 15) | (1 << 12) | (12 << 7) | 0x03),
                                # lh x12, 1(x2): cause 4
        jalr(13, 2, 2),         # target DATA+2: cause 0, tval DATA+2
        amo(AADD, 14, 3, 1),    # misaligned AMO: cause 6, tval DATA+2
        0x0000_0000,            # illegal encoding: cause 2, tval 0
        bad_csr,                # unknown CSR: cause 2, tval = instr
        EBREAK,
    ])
    m_handler = [
        csrrs(20, MCAUSE, 0),
        slli(24, 24, 4),
        andi(22, 20, 15),
        or_(24, 24, 22),
        csrrs(21, MTVAL, 0),
        add(25, 0, 26),
        add(26, 0, 21),
        csrrs(23, MEPC, 0),
        addi(23, 23, 4),
        csrrw(0, MEPC, 23),
        MRET,
    ]
    await run_program(dut, layout(main, {HANDLER: m_handler}))
    assert reg(dut, 24) == 0x4640622, \
        f"cause sequence {reg(dut, 24):#x} != 4,6,4,0,6,2,2"
    assert reg(dut, 25) == 0, "mtval of the all-zeros illegal"
    assert reg(dut, 26) == bad_csr, "mtval must hold the instr bits"


@cocotb.test()
async def test_umode_csr_privilege(dut):
    """U-mode touching S/M CSRs and executing SRET raises illegal."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = ([addi(24, 0, 0)]
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(3, S_ENTRY * 4) + [csrrw(0, MEPC, 3),
                                    MRET])           # MPP reset = U
    u_entry = [
        csrrs(5, MSCRATCH, 0),   # M CSR from U: illegal
        csrrs(6, SSTATUS, 0),    # S CSR from U: illegal
        SRET,                    # SRET in U: illegal
        EBREAK,
    ]
    m_handler = [
        csrrs(20, MCAUSE, 0),
        slli(24, 24, 4),
        andi(22, 20, 15),
        or_(24, 24, 22),
        csrrs(23, MEPC, 0),
        addi(23, 23, 4),
        csrrw(0, MEPC, 23),
        MRET,
    ]
    await run_program(dut, layout(main, {HANDLER: m_handler,
                                         S_ENTRY: u_entry}))
    assert reg(dut, 24) == 0x222, \
        f"three illegals expected, got {reg(dut, 24):#x}"


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
