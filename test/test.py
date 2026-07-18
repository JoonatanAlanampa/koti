# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Koti-1 bring-up stub tests. GL-safe: assertions use top-level pins
# only. The checkerboard's cell-0 colors are ~last_scancode[5:0], so a
# received scancode is observable on the VGA color pins.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

H_SYNC, H_TOT = 96, 800

PS2_BIT_HALF = 30  # sys clocks per PS/2 half-bit (fast but legal-ish)


async def reset(dut):
    dut.ena.value = 1
    dut.ui_in.value = 0b11  # PS/2 clk + dat idle high
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1


def hs(dut):
    return (int(dut.uo_out.value) >> 7) & 1


async def wait_hs(dut, level, timeout=3000):
    for _ in range(timeout):
        await ClockCycles(dut.clk, 1)
        if hs(dut) == level:
            return
    raise AssertionError(f"hsync never reached {level}")


async def sample_cell0_pixel(dut):
    """Return uo_out at an active pixel with checker cell 0.

    hsync rises at x=752; 53 cycles later x~5, and for the first
    visible lines (y < 64) cell = x[6]^y[6] = 0.
    """
    await wait_hs(dut, 0)
    await wait_hs(dut, 1)
    await ClockCycles(dut.clk, 53)
    return int(dut.uo_out.value)


async def ps2_send(dut, byte):
    """Clock one device-to-host frame: start, 8 data LSB-first,
    odd parity, stop."""
    parity = 1 ^ (bin(byte).count("1") & 1)
    bits = [0] + [(byte >> i) & 1 for i in range(8)] + [parity, 1]
    for b in bits:
        dut.ui_in.value = (b << 1) | 1  # data valid, clock high
        await ClockCycles(dut.clk, PS2_BIT_HALF)
        dut.ui_in.value = (b << 1) | 0  # falling edge: receiver samples
        await ClockCycles(dut.clk, PS2_BIT_HALF)
    dut.ui_in.value = 0b11              # back to idle
    await ClockCycles(dut.clk, 10)


@cocotb.test()
async def test_reset_pattern(dut):
    cocotb.start_soon(Clock(dut.clk, 40, unit="ns").start())  # 25 MHz
    await reset(dut)
    await ClockCycles(dut.clk, 5)
    # x~5, y=0: cell 0, default scancode 0x55 -> rgb = 0b101010,
    # both syncs high -> uo_out = 0x8F
    assert int(dut.uo_out.value) == 0x8F


@cocotb.test()
async def test_hsync_timing(dut):
    cocotb.start_soon(Clock(dut.clk, 40, unit="ns").start())
    await reset(dut)
    await wait_hs(dut, 1)
    await wait_hs(dut, 0)           # first cycle of sync pulse
    low = 1
    while True:
        await ClockCycles(dut.clk, 1)
        if hs(dut):
            break
        low += 1
        assert low <= H_SYNC, "hsync pulse too long"
    assert low == H_SYNC, f"hsync width {low} != {H_SYNC}"
    period = low + 1  # the break above landed on the first high cycle
    while True:
        await ClockCycles(dut.clk, 1)
        if not hs(dut):
            break
        period += 1
        assert period <= H_TOT, "hsync period too long"
    assert period == H_TOT, f"hsync period {period} != {H_TOT}"


@cocotb.test()
async def test_ps2_scancode_sets_colors(dut):
    cocotb.start_soon(Clock(dut.clk, 40, unit="ns").start())
    await reset(dut)

    # scancode 0x3F: cell-0 colors = ~0x3F[5:0] = 0 -> only syncs high
    await ps2_send(dut, 0x3F)
    assert await sample_cell0_pixel(dut) == 0x88

    # scancode 0x00: cell-0 colors = 0x3F -> everything high
    await ps2_send(dut, 0x00)
    assert await sample_cell0_pixel(dut) == 0xFF

    # bad parity is dropped: colors stay at 0x00's
    parity_ok = 1 ^ (bin(0xA5).count("1") & 1)
    bits = [0] + [(0xA5 >> i) & 1 for i in range(8)] + [1 - parity_ok, 1]
    for b in bits:
        dut.ui_in.value = (b << 1) | 1
        await ClockCycles(dut.clk, PS2_BIT_HALF)
        dut.ui_in.value = (b << 1) | 0
        await ClockCycles(dut.clk, PS2_BIT_HALF)
    dut.ui_in.value = 0b11
    await ClockCycles(dut.clk, 10)
    assert await sample_cell0_pixel(dut) == 0xFF
