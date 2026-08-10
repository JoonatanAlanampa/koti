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
SEPC, SCAUSE, SIP = 0x141, 0x142, 0x144
MTVAL, STVAL, SATP = 0x343, 0x143, 0x180

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
                      ram_zero=(), stop_on_brk=True, flash_poke=()):
    """Run until the program stops.

    ⛔ CALL THIS EXACTLY ONCE PER @cocotb.test(). Every test in this file did,
    and on 2026-08-10 the first one written with two calls hung at max_cycles —
    reported as "program never halted", which reads exactly like a decode or
    memory-decode bug in the core and is not one. Two short programs that each
    pass alone will not reliably both pass in one test. If a test needs two
    programs, it needs to be two tests.

    `stop_on_brk` is what an S/U EBREAK means
    to THIS test: True (the default) treats it as the terminator every S/U
    section here uses it as, False leaves it to the test's own handler — which
    is the only way to exercise a breakpoint that is supposed to be RESUMED,
    since a terminator and a handled trap are the same signal."""
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
    # Words placed in flash as DATA, past the program. Last, so a poke always
    # wins over the EBREAK padding rather than depending on program length.
    for i, w in flash_poke:
        dut.mem.flash[i].value = w
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0
    for cyc in range(max_cycles):
        await ClockCycles(dut.clk, 1)
        if mtip_at is not None and cyc == mtip_at:
            dut.mtip.value = 1
        if dut.halted.value:
            return
        # EBREAK ends a program here, and that is privilege-agnostic INTENT:
        # every S/U section below finishes with one. Since 2026-08-05 the core
        # only halts on an M-mode EBREAK — in S/U it raises a Breakpoint
        # exception instead, because that is what the ISA says and what Linux
        # needs (WARN_ON and BUG_ON are EBREAKs it expects to survive). So the
        # harness has to recognise the trap as well as the halt; without this
        # the S/U EBREAK vectors to whatever mtvec happens to hold and the test
        # spins to max_cycles, which is exactly what five of them did.
        #
        # Watching brk_take rather than rewriting the tests is deliberate: it
        # keeps every existing assertion untouched, including the one guarding
        # the straddling-fetch-pair defect, which is not a test to go editing
        # in service of an unrelated change.
        if stop_on_brk and dut.c0.brk_take.value:
            # Drain before reading the regfile. brk_take is an EX-stage signal,
            # whereas the `halted` above arrives at W — halt_m -> halt_w ->
            # halted is three stages of latency that the old path got for free.
            # Returning the moment brk_take fires samples the registers while
            # the instruction JUST BEFORE the EBREAK is still in M and has not
            # written back, which is not a subtle wrongness: it read x10 as 0
            # instead of 100 in four tests, at exactly the right PC.
            #
            # Three clocks is the pipeline latency, not a guess, and it is also
            # the safe upper bound: the breakpoint redirects to mtvec, and the
            # first instruction fetched there needs all five stages before it
            # can write a register, so nothing from the trap handler can clobber
            # what the test is about to assert on.
            await ClockCycles(dut.clk, 3)
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
    # misa must advertise A (bit0) — LR/SC/AMO are implemented (F9)
    assert reg(dut, 10) == 0x4014_1101


@cocotb.test()
async def test_sie_sip_masked_by_mideleg(dut):
    """F6: sie/sip are mideleg-masked aliases of mie/mip. A supervisor
    interrupt bit that M has NOT delegated must read 0 through sie/sip
    and be unwritable through them."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (
        # mideleg = 0: nothing delegated
        [csrrw(0, MIDELEG, 0)]
        + li(1, 0x2) + [csrrs(0, SIE, 1)]     # try to set sie.SSIE (bit1)
        + [csrrs(11, SIE, 0)]                 # x11 = sie  (must stay 0)
        + [csrrs(12, MIE, 0)]                 # x12 = mie  (ssie must stay 0)
        + li(2, 0x2) + [csrrs(0, SIP, 2)]     # try to set sip.SSIP (bit1)
        + [csrrs(13, SIP, 0)]                 # x13 = sip  (must stay 0)
        # now delegate SSI (bit1); the alias becomes writable/visible
        + li(3, 0x2) + [csrrw(0, MIDELEG, 3)]
        + li(4, 0x2) + [csrrs(0, SIE, 4)]     # set sie.SSIE, now delegated
        + [csrrs(14, SIE, 0)]                 # x14 = sie -> 0x2
        + [csrrs(15, MIE, 0)]                 # x15 = mie -> ssie set (bit1)
        + [EBREAK])
    await run_program(dut, prog)
    assert reg(dut, 11) == 0, "sie exposed a non-delegated SSIE"
    assert reg(dut, 12) & 0x2 == 0, "sie write set a non-delegated mie.SSIE"
    assert reg(dut, 13) == 0, "sip exposed a non-delegated SSIP"
    assert reg(dut, 14) == 0x2, "sie.SSIE not visible once delegated"
    assert reg(dut, 15) & 0x2 == 0x2, "sie write did not reach mie once delegated"


@cocotb.test()
async def test_mixed_delegation_reports_eligible_cause(dut):
    """F5: with SEI delegated but SSI not, both pending in S mode, the
    non-delegated SSI drives take_m; M must record the eligible SSI cause
    (0x80000001), not the delegated SEI (0x80000009)."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    S_ENTRY = 80
    main = (li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, 0x200) + [csrrw(0, MIDELEG, 2)]   # delegate SEI (bit9) only
            + li(3, 0x202) + [csrrw(0, MIE, 3)]       # enable seie + ssie
            + li(4, 0x202) + [csrrw(0, MIP, 4)]       # pend seip + ssip
            + li(5, S_ENTRY * 4) + [csrrw(0, MEPC, 5)]
            + li(6, 0x800) + [csrrs(0, MSTATUS, 6),   # MPP = S
                              MRET])                  # enter S -> take_m fires
    s_entry = [addi(20, 0, 1), EBREAK]                # must not retire before the trap
    m_handler = [csrrs(21, MCAUSE, 0), EBREAK]
    await run_program(dut, layout(main, {HANDLER: m_handler, S_ENTRY: s_entry}))
    assert reg(dut, 21) == 0x8000_0001, \
        f"M reported {reg(dut, 21):#x}, expected eligible SSI 0x80000001 (F5)"


@cocotb.test()
async def test_vectored_or_warl_direct_tvec(dut):
    """F7: mtvec/stvec are Direct-only here; a vectored-mode write must
    read back with mode 0 (WARL), consistent with trap_vec always using
    BASE."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, (HANDLER * 4) | 3) + [csrrw(0, MTVEC, 1)]   # write base|3
            + [csrrs(2, MTVEC, 0)]                            # readback
            + li(3, (0x400) | 1) + [csrrw(0, STVEC, 3)]       # stvec base|1
            + [csrrs(4, STVEC, 0)]                            # readback
            + [ECALL])                                        # trap -> mtvec BASE
    m_handler = [csrrs(5, MCAUSE, 0), EBREAK]
    await run_program(dut, with_handler(main, m_handler))
    assert reg(dut, 2) == HANDLER * 4, "mtvec kept a vectored/reserved mode (F7)"
    assert reg(dut, 4) == 0x400, "stvec kept a vectored mode (F7)"
    assert reg(dut, 5) == 11, "ECALL-from-M did not vector to BASE"


@cocotb.test()
async def test_mstatus_mpp_warl(dut):
    """F8: mstatus.MPP is WARL — the reserved value 2'b10 must be coerced
    (to U), never loaded into the live privilege by MRET."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    prog = (li(1, 1 << 12) + [csrrs(0, MSTATUS, 1)]   # attempt MPP = 2'b10
            + [csrrs(2, MSTATUS, 0),                   # readback
               EBREAK])
    await run_program(dut, prog)
    assert (reg(dut, 2) >> 11) & 3 == 0, \
        f"MPP={(reg(dut, 2) >> 11) & 3} — reserved 2'b10 not WARL-coerced (F8)"


@cocotb.test()
async def test_flash_lrsc_store_access_fault(dut):
    """F4: flash is read-only. LR reads fine, but SC and plain stores to
    flash must raise a store/AMO access fault (cause 7), not a silent
    no-op 'success' that reports the store as completed."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    FLASH_RO = 0x0000_2000        # a flash data word (RO), above the code
    main = ([addi(24, 0, 0), addi(11, 0, 0x5A)]      # cause acc, SC-rd sentinel
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, FLASH_RO) + [
                amo(LR, 10, 2, 0),        # LR from flash: reads, no fault
                amo(SC, 11, 2, 0)]        # SC to flash: cause 7, x11 untouched
            + li(6, 0x1234) + [
                sw(6, 2, 0),              # plain store to flash: cause 7
                EBREAK])
    m_handler = [
        csrrs(20, MCAUSE, 0),
        slli(24, 24, 4), andi(22, 20, 15), or_(24, 24, 22),
        csrrs(23, MEPC, 0), addi(23, 23, 4), csrrw(0, MEPC, 23),
        MRET,
    ]
    await run_program(dut, with_handler(main, m_handler))
    assert reg(dut, 24) == 0x77, \
        f"cause seq {reg(dut, 24):#x} != 7,7 (SC + store to flash access-fault)"
    assert reg(dut, 11) == 0x5A, "SC to flash reported success (rd was written)"


@cocotb.test()
async def test_ram_top_quarter_access_fault(dut):
    """The RAM window ends at 0x02FF_FFFF and PA[25:24] == 11 is past the end
    of the part, so 0x0300_0000+ must access-fault (store cause 7, load cause
    5) rather than alias silently onto real RAM.

    ⚠️ THIS TEST PINS BOTH SIDES ON PURPOSE, and the legal side is the half
    that would catch a careless fix. PLAN item 12 made RAM span TWO quarters,
    PA[25:24] ∈ {01, 10}; a bound written as "anything above 16 MB faults"
    passes the illegal case below and silently amputates the upper 16 MB the
    whole item existed to reach. koti_core.sv's own comment says the same
    thing from the other direction.

    (Until 2026-08-08 this was test_psram_upper_bound_access_fault and it
    asserted the ASIC build's 8 MiB APS6404 high mirror at 0x0180_0000 —
    which item 12 turned into ordinary, legal RAM. The test then failed on
    every run for two days without reddening a single job, because no runner
    checked cocotb's results; see test/gate.py.)"""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    RAM_TOP = 0x02FF_FFFC     # last word of real RAM: must NOT fault
    PAST_END = 0x0300_0000    # first word past it:    must fault
    main = ([addi(24, 0, 0)]
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(4, RAM_TOP) + li(3, 0xABCD) + [
                sw(3, 4, 0),              # legal: no trap, appends no nibble
                lw(11, 4, 0),             # legal: no trap
            ]
            + li(2, PAST_END) + [
                sw(3, 2, 0),              # past the end: cause 7
                lw(10, 2, 0),             # past the end: cause 5
                EBREAK])
    m_handler = [
        csrrs(20, MCAUSE, 0),
        slli(24, 24, 4), andi(22, 20, 15), or_(24, 24, 22),
        csrrs(23, MEPC, 0), addi(23, 23, 4), csrrw(0, MEPC, 23),
        MRET,
    ]
    await run_program(dut, with_handler(main, m_handler),
                      ram_zero=[(0, 4)])
    # Exactly two nibbles: 7 then 5. A third would mean a legal RAM access
    # faulted; a shorter one means the out-of-range access went through.
    assert reg(dut, 24) == 0x75, \
        f"cause seq {reg(dut, 24):#x} != 7,5 — expected the two accesses past " \
        f"the end of RAM to fault and the two at the top of RAM not to"
    # ⚠️ The alias check is what makes the fault meaningful rather than
    # decorative. tb_cpu wires 23 of the core's 24 address bits (see the
    # `Padding 1 high bits` warning at elaboration), so an unfaulted store to
    # 0x0300_0000 lands on xipmem's ram[0] — precisely the silent aliasing the
    # bound exists to prevent, and visible here as a non-zero word.
    assert int(dut.mem.ram[0].value) == 0, \
        "the store past the end of RAM aliased onto real RAM"


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
async def test_smode_ebreak_traps_and_resumes(dut):
    """An S-mode EBREAK raises cause 3 and is RESUMABLE — it does not halt.

    This is the exact shape Linux depends on and koti did not provide until
    2026-08-05. RISC-V Linux compiles every WARN_ON() and BUG_ON() into an
    EBREAK plus a __bug_table entry (2812 of them in the 6.12 image koti
    boots); do_trap_break() looks the PC up in that table, prints, and for a
    WARN steps past the EBREAK and carries on. Halting instead turned every
    warning the kernel was designed to survive into a silent death — and
    because the firmware's clean shutdown is also an EBREAK, test/tb_boot.v
    reported that death as a PASS.

    So the assertions here are deliberately about RESUMPTION, not just about
    the cause: x10 == 100 is the whole point, and it is what fails if the core
    ever goes back to halting. M-mode is unchanged and this test proves that
    too, by ending the run the way every other test does — an EBREAK in M,
    which still halts.
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    main = (li(1, S_HANDLER * 4) + [csrrw(0, STVEC, 1)]
            + li(5, HANDLER * 4) + [csrrw(0, MTVEC, 5)]
            + li(2, 1 << 3) + [csrrs(0, MEDELEG, 2)]     # breakpoint -> S
            + li(3, S_ENTRY * 4) + [csrrw(0, MEPC, 3)]
            + li(4, 0x800) + [csrrs(0, MSTATUS, 4),      # MPP = 01 (S)
                              MRET])
    s_entry = [
        addi(10, 0, 0),
        EBREAK,                     # cause 3 -> S handler. NOT a halt.
        addi(10, 10, 100),          # only runs if the breakpoint was resumed
        ECALL,                      # undelegated: back to M to end the run
    ]
    s_handler = [
        csrrs(11, SCAUSE, 0),
        csrrs(12, SEPC, 0),
        csrrs(14, STVAL, 0),
        addi(13, 12, 4),            # step past it, exactly as do_trap_break
        csrrw(0, SEPC, 13),         # does for a WARN
        SRET,
    ]
    m_handler = [EBREAK]            # M-mode EBREAK still halts: that is the end
    await run_program(dut, layout(main, {HANDLER: m_handler,
                                         S_HANDLER: s_handler,
                                         S_ENTRY: s_entry}),
                      stop_on_brk=False)
    assert reg(dut, 11) == 3, "scause != 3 (breakpoint)"
    assert reg(dut, 12) == S_ENTRY * 4 + 4, "sepc != the EBREAK's own address"
    assert reg(dut, 14) == S_ENTRY * 4 + 4, "stval != the EBREAK's own address"
    assert reg(dut, 10) == 100, \
        "execution did not resume past the breakpoint — an S-mode EBREAK " \
        "halted the core instead of trapping, which is what kills a WARN_ON"


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
async def test_satp_commit_squashes_old_fetch(dut):
    """F2 regression: a committed `satp` write must serialize fetch like
    sfence.vma. S code fetched under root A runs `csrw satp,B`; the marker
    instruction right after it — already prefetched under root A — must
    NOT retire. It has to be squashed and refetched under root B, which
    leaves the code VA unmapped, so the fix faults (cause 12) before the
    marker runs. The old RTL kept the stale fetch and ran the marker
    (x20=1) under the switched-in root B."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    ROOT_A, L0_A, ROOT_B = 0x0100_2000, 0x0100_3000, 0x0100_5000
    PA_X = 0x0000_1000                  # flash frame that holds the S code
    VA = 0x4000_0000                    # S-code VA (VPN1=0x100, VPN0=0)
    SATP_A = 0x8000_0000 | (ROOT_A >> 12)
    SATP_B = 0x8000_0000 | (ROOT_B >> 12)
    S_CODE = PA_X >> 2                   # flash word index of the S code

    # M builds root A: root[0x100] -> L0_A, L0_A[0] -> PA_X (RWX+A+D, S).
    # Root B is a zeroed page, so VA is unmapped under B (=> cause 12).
    main = ([addi(20, 0, 0), addi(21, 0, 0)]          # known-zero marker/cause
            + li(5, ROOT_A)
            + li(6, (L0_A >> 12) << 10 | 1) + [sw(6, 5, 0x400)]
            + li(7, L0_A)
            + li(6, (PA_X >> 12) << 10 | 0xCF) + [sw(6, 7, 0)]
            + li(1, HANDLER * 4) + [csrrw(0, MTVEC, 1)]
            + li(2, SATP_A) + [csrrw(0, SATP, 2), SFENCE]
            + li(3, VA) + [csrrw(0, MEPC, 3)]
            + li(4, 0x800) + [csrrs(0, MSTATUS, 4), MRET])   # MPP=S, enter S

    s_code = (li(2, SATP_B) + [
        csrrw(0, SATP, 2),     # switch A->B: must serialize / squash fetch
        addi(20, 0, 1),        # marker: retires only if the fetch wasn't squashed
        EBREAK,                # buggy path halts here after running the marker
    ])
    m_handler = [csrrs(21, MCAUSE, 0), EBREAK]        # cause 12 -> halt

    await run_program(dut,
                      layout(main, {HANDLER: m_handler, S_CODE: s_code}),
                      ram_zero=[(0x0800, 4096)])       # zero rootA/L0/rootB pages

    assert reg(dut, 20) == 0, \
        "marker after `csrw satp` retired — fetch was not serialized (F2)"
    assert reg(dut, 21) == 12, \
        f"expected instruction page fault (cause 12), got {reg(dut, 21):#x}"


@cocotb.test()
async def test_fetch_pair_straddling_a_page_is_not_skipped(dut):
    """Regression for the defect that stopped Linux booting (2026-08-04).

    The fetch port delivers a PAIR {fpc, fpc+4}. When that pair straddles a
    page boundary the second word must be dropped — its translation belongs
    to the next page, and the hardware has not looked it up. That part was
    right. What was wrong is that `npc` still advanced by 8, so the dropped
    instruction was never re-fetched: the core executed fpc and then fpc+8,
    silently skipping one instruction.

    It needs the MMU on, so `satp = 0` suites cannot reach it — which is why
    all 58 official tests were green while `kfree` spun forever.

    The two pages are deliberately NOT contiguous in physical memory
    (VA 0x40000000 -> PA 0x1000, VA 0x40001000 -> PA 0x3000), so this test
    pins BOTH halves of the required behaviour independently:
      x20  the instruction at the page's last word ran
      x21  the instruction at the next page's first word ran, from the PA
           its own translation names  -> fails if npc skipped it
      x22  the physically-adjacent word at PA 0x2000 did NOT run
           -> fails if the pair were delivered without the drop
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    ROOT, L0 = 0x0100_2000, 0x0100_3000
    VA = 0x4000_0000                      # VPN1 = 0x100, VPN0 = 0
    PA0, PA1 = 0x0000_1000, 0x0000_3000   # flash frames 1 and 3
    W_END = (PA0 + 0xFFC) >> 2            # VA+0xFFC : page's LAST word
    W_ADJ = (PA0 + 0x1000) >> 2           # PA 0x2000: physically next, wrong
    W_NEXT = PA1 >> 2                     # VA+0x1000: correctly translated

    # M builds: root[0] identity 4 MiB megapage (its own code + the flash it
    # runs from), root[0x100] -> L0, L0[0] -> PA0, L0[1] -> PA1. All RWX+A+D.
    # Zero the three markers first: the register file is not reset, so an
    # untouched x22 reads as leftover garbage and would fail the "did NOT
    # run" check for the wrong reason.
    main = ([addi(20, 0, 0), addi(21, 0, 0), addi(22, 0, 0)]
            + li(5, ROOT)
            + li(6, 0x0000_00CF) + [sw(6, 5, 0)]
            + li(6, (L0 >> 12) << 10 | 1) + [sw(6, 5, 0x400)]
            + li(7, L0)
            + li(6, (PA0 >> 12) << 10 | 0xCF) + [sw(6, 7, 0)]
            + li(6, (PA1 >> 12) << 10 | 0xCF) + [sw(6, 7, 4)]
            + li(2, 0x8000_0000 | (ROOT >> 12)) + [csrrw(0, SATP, 2), SFENCE]
            + li(3, VA) + [csrrw(0, MEPC, 3)]
            + li(4, 0x800) + [csrrs(0, MSTATUS, 4), MRET])   # MPP=S, enter S

    # Jump INTO the last word of the page. The landing address is what makes
    # the pair straddle: a sequential run would step npc by 8 and never put
    # fpc on 0xFFC unless the stream is odd-word aligned, which is exactly
    # why this went unseen for so long.
    s_entry = li(5, VA + 0xFFC) + [jalr(0, 5, 0)]

    await run_program(dut, layout(main, {
        (PA0 >> 2): s_entry,
        W_END:  [addi(20, 0, 1)],     # last word of the page
        W_ADJ:  [addi(22, 0, 1), EBREAK],   # PA-adjacent: must NOT run
        W_NEXT: [addi(21, 0, 1), EBREAK],   # VA-next: must run
    }), ram_zero=[((ROOT - 0x0100_0000) >> 2, 2048)])

    got = f"x20={reg(dut, 20)} x21={reg(dut, 21)} x22={reg(dut, 22)}"
    assert reg(dut, 20) == 1, f"page's last word never ran: {got}"
    assert reg(dut, 22) == 0, \
        f"ran the physically-adjacent word — pair not dropped: {got}"
    assert reg(dut, 21) == 1, \
        f"next page's first word SKIPPED — npc stepped by 8 over a dropped " \
        f"pair half instead of by 4: {got}"


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


@cocotb.test()
async def test_mmio_window_is_readable(dut):
    """Half one of the F1 pair: the core's MMIO window works at all.

    Without this, the alias test below would pass on an RTL that had simply
    deleted the MMIO decode — every address would read memory, including the
    one that must not."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await run_program(dut, li(1, 0x0001_000C) + li(2, 3) + [sw(2, 1, 0)]
                      + [lw(10, 1, 0)] + [EBREAK])
    assert reg(dut, 10) == 3,         f"QSPI_CFG at 0x0001_000C read back {reg(dut, 10):#x}, not 3"


@cocotb.test()
async def test_flash_does_not_alias_into_the_mmio_window(dut):
    """F1 regression: the core's MMIO window is 0x0001_0000..0x0001_FFFF and
    the compare that recognises it must use the WHOLE upper half-word.

    The original defect compared only the low bits of the page number, so the
    window repeated every 512 KB: a load from 0x0009_080C read a CORE REGISTER
    instead of the flash word living there, and every 0x80000 above it did the
    same. Flash is where all bare-metal code and the SBI firmware live, so the
    failure is silent, data-dependent corruption of the boot path.

    ⚠️ THE PAIRED HALF IS test_mmio_window_is_readable, and it is a SEPARATE
    test on purpose: this harness supports exactly ONE run_program per cocotb
    test. Every other test here obeys that; the one written with two calls hung
    at max_cycles with nothing wrong in the RTL, which reads exactly like a
    decode bug and is not one.

    0x0009_080C is 0x0001_000C + 0x80000, its low bits [3:2] select QSPI_CFG,
    and its word address lands on flash word 0x203 in xip_model — which is
    where the sentinel goes."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    ALIAS = 0x0009_080C
    SENTINEL = 0xF1A5_F1A5
    await run_program(dut, li(4, ALIAS) + [lw(11, 4, 0)] + [EBREAK],
                      flash_poke=[((ALIAS >> 2) & 0x3FFF, SENTINEL)])
    assert reg(dut, 11) == SENTINEL,         f"load from {ALIAS:#x} returned {reg(dut, 11):#x}, want {SENTINEL:#x} "         f"— flash aliased into the MMIO window (it read a core register)"


async def send_serial_byte(dut, byte, div=4, after=40):
    """Shift `byte` into uart_rxd the way an FTDI would: 8N1, LSB first.

    `div` must match the core's UART_DIV (4 in this bench, not the 217 the
    board uses at 115200). `after` holds off until reset is well clear — a
    start bit arriving during reset is absorbed by the synchroniser's 3'b111
    reset state and the byte is simply lost, which looks like a receiver bug.
    """
    await ClockCycles(dut.clk, after)
    for bit in [0] + [(byte >> i) & 1 for i in range(8)] + [1]:  # start, data, stop
        dut.uart_rxd_r.value = bit
        await ClockCycles(dut.clk, div)
    dut.uart_rxd_r.value = 1


@cocotb.test()
async def test_uart_rx_reaches_the_cpu(dut):
    """A byte sent at the pin must be readable at UART_RX (MMIO +0x10).

    This is the path SBI console_getchar uses to make hvc0 two-way: until
    2026-08-10 koti had no receiver at all and the serial console could not be
    typed at. test/tb_uart_rx.v covers the receiver as a module; this covers
    the part it cannot — that the CPU can actually GET the byte, through the
    io_hi decode added alongside it.

    ⚠️ The polling read is safe to repeat: reading +0x10 pops only when
    UART_RX_AVAIL is set, so a loop that spins on an empty register cannot eat
    the byte it is waiting for. That is the whole reason the receiver is at its
    own address instead of folded into the transmitter's status word, which
    uart_putc polls in a tight loop."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    UART_RX = 0x0001_0010
    AVAIL = 0x100
    BYTE = 0x6B  # 'k'

    cocotb.start_soon(send_serial_byte(dut, BYTE))

    # poll: x10 = [UART_RX]; loop while (x10 & AVAIL) == 0
    prog = (li(1, UART_RX)
            + [lw(10, 1, 0),
               andi(11, 10, AVAIL),
               beq(11, 0, -8),          # back to the lw
               EBREAK])
    await run_program(dut, prog, max_cycles=3000)

    got = reg(dut, 10)
    assert got & AVAIL, f"UART_RX read {got:#x} with no AVAIL bit"
    assert got & 0xFF == BYTE, \
        f"UART_RX delivered {got & 0xFF:#04x}, sent {BYTE:#04x}"
