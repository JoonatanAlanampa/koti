# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# sdram_ctrl tests.
#
# The point of an SDRAM controller is not that it stores bytes — it is that it
# obeys a protocol whose violations are invisible in simulation and destructive
# on hardware. So the strictness lives in sdram_model.sv (which kills the run on
# a read with no open row, an access before the mode register, or a refresh with
# a bank open) and these tests concentrate on what the model cannot judge: that
# the right address was driven, that byte enables mask what they should, and
# that a burst returns the two words the SoC asked for in the order it expects.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

CLK_NS = 40          # 25 MHz


async def setup(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_NS, unit="ns").start())
    dut.req.value = 0
    dut.we.value = 0
    dut.burst.value = 0
    dut.addr.value = 0
    dut.wdata.value = 0
    dut.be.value = 0
    dut.rst.value = 1
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    # T_INIT_US=2 in the bench, plus precharge, two refreshes and the mode
    # register. 200 clocks is comfortably past all of it.
    await ClockCycles(dut.clk, 200)


async def do(dut, addr, we=0, wdata=0, be=0xF, burst=0, timeout=200):
    """One request, held until ack, exactly as the SoC drives it."""
    dut.addr.value = addr
    dut.we.value = we
    dut.wdata.value = wdata
    dut.be.value = be
    dut.burst.value = burst
    dut.req.value = 1
    for _ in range(timeout):
        await RisingEdge(dut.clk)
        if dut.ack.value == 1:
            lo = int(dut.rdata.value)
            hi = int(dut.rdata2.value)
            dut.req.value = 0
            await RisingEdge(dut.clk)
            return lo, hi
    dut.req.value = 0
    raise AssertionError(f"no ack for addr=0x{addr:x} we={we} after {timeout} clocks")


def model_idx(addr, half):
    """Where sdram_model stores a given 32-bit word's half.

    Mirrors the controller's map deliberately — bank addr[22:21],
    row addr[20:8], col {addr[7:0], half} — so that a disagreement between the
    two shows up as a failed lookup rather than as silently reading someone
    else's data. Model index is {ba[1:0], row[6:0], col[8:0]}.
    """
    bank = (addr >> 21) & 0x3
    row = (addr >> 8) & 0x1FFF
    col = ((addr & 0xFF) << 1) | half
    return (bank << 16) | ((row & 0x7F) << 9) | col


@cocotb.test()
async def test_write_then_read(dut):
    """The base case, and the one that proves the address map round-trips.

    On failure it separates the two halves of the question, because "read
    returned zero" does not say whether the write never landed or the read
    never captured. Peeking into the part's array answers that in one line.
    """
    await setup(dut)
    await do(dut, 0x00010, we=1, wdata=0xDEADBEEF)

    stored = (int(dut.part.mem[model_idx(0x00010, 0)].value)
              | int(dut.part.mem[model_idx(0x00010, 1)].value) << 16)
    assert stored == 0xDEADBEEF, \
        f"the WRITE never reached the part: it holds 0x{stored:08x}"

    lo, _ = await do(dut, 0x00010)
    assert lo == 0xDEADBEEF, \
        f"write landed but the READ captured 0x{lo:08x}"


@cocotb.test()
async def test_word_order_within_a_word(dut):
    """The low 16 bits must land in the low column.

    Getting this backwards is invisible until a byte-enabled store or a
    half-word load, at which point it corrupts silently rather than obviously.
    """
    await setup(dut)
    await do(dut, 0x00020, we=1, wdata=0x11223344)
    lo, _ = await do(dut, 0x00020)
    assert lo == 0x11223344, f"got 0x{lo:08x}"
    # neighbours untouched: a 32-bit access must not spill into the next word
    await do(dut, 0x00021, we=1, wdata=0xAAAABBBB)
    lo, _ = await do(dut, 0x00020)
    assert lo == 0x11223344, f"neighbour write corrupted it: 0x{lo:08x}"


@cocotb.test()
async def test_distinct_banks_and_rows(dut):
    """Addresses that differ only in bank or only in row must not alias.

    bank = addr[22:21], row = addr[20:8], col = addr[7:0]. A mapping bug here
    is the classic one: everything works while a test stays inside one row, and
    memory scrambles the moment a program is larger than 1 KB.
    """
    await setup(dut)
    cases = {
        0x000000: 0x00000001,   # bank 0, row 0
        0x000100: 0x00000002,   # bank 0, row 1        (addr[8])
        0x001000: 0x00000003,   # bank 0, row 16
        0x200000: 0x00000004,   # bank 1               (addr[21])
        0x400000: 0x00000005,   # bank 2               (addr[22])
        0x600000: 0x00000006,   # bank 3
        0x2000FF: 0x00000007,   # bank 1, row 0, last column of the row
    }
    for a, v in cases.items():
        await do(dut, a, we=1, wdata=v)
    for a, v in cases.items():
        lo, _ = await do(dut, a)
        assert lo == v, f"addr 0x{a:06x}: got 0x{lo:08x}, want 0x{v:08x}"


@cocotb.test()
async def test_byte_enables(dut):
    """be masks bytes on a write. DQM is active high, so this is where an
    accidentally un-inverted be turns every byte store into a word store."""
    await setup(dut)
    await do(dut, 0x00030, we=1, wdata=0xFFFFFFFF)

    await do(dut, 0x00030, we=1, wdata=0x000000AA, be=0b0001)
    lo, _ = await do(dut, 0x00030)
    assert lo == 0xFFFFFFAA, f"byte 0: 0x{lo:08x}"

    await do(dut, 0x00030, we=1, wdata=0x00BB0000, be=0b0100)
    lo, _ = await do(dut, 0x00030)
    assert lo == 0xFFBBFFAA, f"byte 2: 0x{lo:08x}"

    await do(dut, 0x00030, we=1, wdata=0xCCDD0000, be=0b1100)
    lo, _ = await do(dut, 0x00030)
    assert lo == 0xCCDDFFAA, f"halfword high: 0x{lo:08x}"


@cocotb.test()
async def test_burst_returns_both_words(dut):
    """burst=1 must give word@addr in rdata and word@addr+1 in rdata2."""
    await setup(dut)
    await do(dut, 0x00040, we=1, wdata=0xCAFEBABE)
    await do(dut, 0x00041, we=1, wdata=0x8BADF00D)
    lo, hi = await do(dut, 0x00040, burst=1)
    assert lo == 0xCAFEBABE, f"rdata 0x{lo:08x}"
    assert hi == 0x8BADF00D, f"rdata2 0x{hi:08x}"


@cocotb.test()
async def test_burst_across_a_row_boundary(dut):
    """The second word of a burst may live in a different row, or bank.

    addr[7:0] is the column, so 0x0000FF -> 0x000100 crosses into the next row.
    A controller that reuses the first word's ACTIVE reads the wrong place, and
    only ever on the last word of a row — which is exactly the sort of bug that
    survives a test suite and corrupts one instruction in 256.
    """
    await setup(dut)
    await do(dut, 0x0000FF, we=1, wdata=0x0F0F0F0F)
    await do(dut, 0x000100, we=1, wdata=0xF0F0F0F0)
    lo, hi = await do(dut, 0x0000FF, burst=1)
    assert lo == 0x0F0F0F0F, f"rdata 0x{lo:08x}"
    assert hi == 0xF0F0F0F0, f"rdata2 0x{hi:08x}"


@cocotb.test()
async def test_survives_refresh(dut):
    """Data written before a refresh interval must still be there after it.

    The model kills the run if a refresh arrives with a bank open, so this also
    proves auto-precharge is really closing the row rather than the controller
    getting away with it because nothing checked.
    """
    await setup(dut)
    await do(dut, 0x00050, we=1, wdata=0x5A5A5A5A)
    await ClockCycles(dut.clk, 900)      # several 7.8 us intervals at 25 MHz
    lo, _ = await do(dut, 0x00050)
    assert lo == 0x5A5A5A5A, f"got 0x{lo:08x}"


@cocotb.test()
async def test_back_to_back_requests(dut):
    """No gap between ack and the next req. Anything that needed idle time to
    recover would fail here rather than under a real CPU months later."""
    await setup(dut)
    for i in range(16):
        await do(dut, 0x00100 + i, we=1, wdata=0xA0000000 + i)
    for i in range(16):
        lo, _ = await do(dut, 0x00100 + i)
        assert lo == 0xA0000000 + i, f"word {i}: 0x{lo:08x}"


@cocotb.test()
async def test_access_time_is_worth_the_trouble(dut):
    """Measure it. The entire reason for this module is that QSPI is slow, and
    a controller that is not actually faster would be worth knowing about."""
    await setup(dut)
    await do(dut, 0x00060, we=1, wdata=0x12345678)

    dut.addr.value = 0x00060
    dut.we.value = 0
    dut.burst.value = 0
    dut.req.value = 1
    n = 0
    while True:
        await RisingEdge(dut.clk)
        n += 1
        if dut.ack.value == 1:
            break
    dut.req.value = 0

    dut._log.info(f"single 32-bit read: {n} clocks "
                  f"(QSPI serial is ~130 for a 64-bit burst)")
    assert n < 20, f"a random read took {n} clocks — that is not a speedup"
