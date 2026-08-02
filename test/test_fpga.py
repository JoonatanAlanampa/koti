# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# ULX3S harness tests — the layer between the proven chip and the pins.
#
# The four existing suites all drive tt_um_koti directly. Nothing has ever
# exercised ulx3s_top, so the header permutation, the orientation straps, the
# UART source mux and the tristates were unverified logic sitting between a
# working SoC and the connectors. That gap is exactly the kind that survives
# every simulation and then looks like dead gateware on the bench.
#
# The SPI memory model is reused verbatim from test.py (itself vendored from
# tt-riscv), so what is under test here is the harness and only the harness.

import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge

sys.path.append(str(Path(__file__).parent))
from test import CS0, CS1, SCK, SD_BITS, UART_DIV, SpiMem  # noqa: E402

SW_ROOT = Path(__file__).parent.parent / "sw"


def _bits(sig):
    """The four wires of one header row, LSB-first.

    z reads as 1: every J1 line carries PULLMODE=UP in ulx3s.lpf, so an
    undriven wire really is high on the board. x also reads as 1 rather than
    raising — a mid-reset x on a chip select would otherwise abort the test
    before the design has had a chance to come out of reset.
    """
    s = str(sig.value)
    return [1 if s[len(s) - 1 - i] in "1hHzZxX" else 0 for i in range(4)]


def uio_from_pins(gp, gn, seat_flip):
    """Rebuild uio[7:0] from the header wires, using the PHYSICAL seating.

    This is the Pmod's view, not the gateware's: it depends on how the board
    is plugged in (`seat_flip`), never on what sw[0] claims. That separation is
    what lets a test set the strap wrong and watch the boot fail.
    """
    lo, hi = (gp, gn) if not seat_flip else (gn, gp)
    v = 0
    for b in range(4):
        v |= lo[3 - b] << b
    for b in range(4, 8):
        v |= hi[7 - b] << b
    return v


async def spi_bus_fpga(dut, flash, ram, seat_flip):
    """Pin-level bus glue, through the J1 header instead of uio directly."""
    try:
        await _spi_bus_fpga(dut, flash, ram, seat_flip)
    except Exception as e:
        # A background coroutine that dies takes the flash model with it, and
        # the only symptom is qspi_ctrl sitting in its read state forever while
        # the CPU waits for a fetch that will never be answered. That reads as
        # a hardware hang and is not one, so say so loudly.
        dut._log.error(f"SPI BUS MODEL DIED: {type(e).__name__}: {e}")
        raise


async def _spi_bus_fpga(dut, flash, ram, seat_flip):
    prev_sck = 0
    dut.mem_dq1_oe.value = 0
    dut.mem_dq1.value = 1
    while True:
        await FallingEdge(dut.clk)
        uio = uio_from_pins(_bits(dut.pmod_gp), _bits(dut.pmod_gn), seat_flip)

        sck = (uio >> SCK) & 1
        io = 0
        for i, b in enumerate(SD_BITS):
            io |= ((uio >> b) & 1) << i

        if not (uio >> CS0) & 1:
            sel = flash
        elif not (uio >> CS1) & 1:
            sel = ram
        else:
            sel = None
        for dev in (flash, ram):
            if dev is not sel:
                dev.deselect()

        if sel is not None:
            if sck and not prev_sck:
                sel.on_rise(io)
            elif prev_sck and not sck:
                sel.on_fall()
            # 1-bit mode: SD1 is the only line the memory drives back.
            if (sel.out_mask >> 1) & 1:
                dut.mem_dq1.value = (sel.out_val >> 1) & 1
                dut.mem_dq1_oe.value = 1
            else:
                dut.mem_dq1_oe.value = 0
        else:
            dut.mem_dq1_oe.value = 0

        prev_sck = sck


def sdram_bytes(dut, byte_addr, n):
    """Read bytes out of the SDRAM part model, by CPU byte address.

    Since the RAM half of the map moved off the QSPI Pmod, anything the program
    stores — stack, page tables, the VGA charbuf — lands in the SDRAM model
    instead of in `ram`. Reading it back means walking the same address map the
    controller uses, which is deliberate: if the SoC and this helper ever
    disagree about where a word lives, the test fails rather than quietly
    reading someone else's data.

    CPU word address -> {1'b0, addr[21:0]} at the SoC boundary -> bank
    addr[22:21], row addr[20:8], col {addr[7:0], half} in the controller ->
    {ba, row[6:0], col} in the model's reduced array.
    """
    out = bytearray()
    for i in range(n):
        b = byte_addr + i
        waddr = (b >> 2) & 0x3FFFFF
        half = (b >> 1) & 1
        bank = (waddr >> 21) & 0x3
        row = (waddr >> 8) & 0x1FFF
        col = ((waddr & 0xFF) << 1) | half
        idx = (bank << 16) | ((row & 0x7F) << 9) | col
        out.append((int(dut.part.mem[idx].value) >> (8 * (b & 1))) & 0xFF)
    return bytes(out)


async def uart_rx_pin(dut, nbytes, timeout=2_000_000):
    """Decode 8N1 off ftdi_rxd — the actual board pin, after the SW3 mux."""
    got = bytearray()
    waited = 0
    while len(got) < nbytes:
        while True:
            await RisingEdge(dut.clk)
            waited += 1
            assert waited < timeout, f"UART stalled after {bytes(got)!r}"
            if not int(dut.ftdi_rxd.value):
                break
        await ClockCycles(dut.clk, UART_DIV + UART_DIV // 2)
        b = 0
        for i in range(8):
            b |= int(dut.ftdi_rxd.value) << i
            await ClockCycles(dut.clk, UART_DIV)
        assert int(dut.ftdi_rxd.value), "missing stop bit"
        got.append(b)
        waited += 10 * UART_DIV
    return bytes(got)


async def _bring_up(dut, image, seat_flip, strap, uart_strap=0):
    """Common setup: clock, memories, straps, release reset."""
    cocotb.start_soon(Clock(dut.clk, 40, unit="ns").start())   # 25 MHz

    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)
    flash.mem[:len(image)] = image

    dut.seat_flip.value = seat_flip
    dut.ps2_gp.value = 0b11                # PS/2 idle high (external pull-ups)
    dut.sw.value = (strap & 1) | ((uart_strap & 1) << 2)
    dut.btn.value = 0b0000000              # btn[0] low = held in reset
    await ClockCycles(dut.clk, 5)

    cocotb.start_soon(spi_bus_fpga(dut, flash, ram, seat_flip))

    dut.btn.value = 0b0000001              # BTN0 released; POR still counting
    return flash, ram


@cocotb.test()
async def test_harness_boot_mapping_a(dut):
    """Pmod seated unflipped, SW1 off: hello.bin boots and the banner comes
    out of ftdi_rxd — through the header permutation in both directions."""
    hello = (SW_ROOT / "hello.bin").read_bytes()
    _flash, ram = await _bring_up(dut, hello, seat_flip=0, strap=0)

    banner = b"Koti-1: hello from my own SoC\r\n"
    assert await uart_rx_pin(dut, len(banner)) == banner

    # SW4 off routes the chip's raw uo to the LEDs, which is the view the
    # bring-up checklist tells you to read.
    assert int(dut.led.value) == int(dut.chip_uo.value)

    # And the program really ran: its console text reached the charbuf — which
    # now lives in the onboard SDRAM rather than the Pmod's PSRAM. This is the
    # end-to-end proof that the memory swap worked, because the charbuf is
    # written by the CPU through the arbiter and read back by the video DMA.
    row1 = b"hello, visible world"
    for _ in range(200):
        await ClockCycles(dut.clk, 10_000)
        if sdram_bytes(dut, 0x01008028, len(row1)) == row1:
            break
    else:
        raise AssertionError(
            f"charbuf in SDRAM: {sdram_bytes(dut, 0x01008028, 40)!r}")


@cocotb.test()
async def test_harness_boot_mapping_b(dut):
    """Pmod seated the other way round, SW1 on: identical result. This is the
    strap earning its keep — a flipped Pmod is a switch flip, not a rebuild."""
    hello = (SW_ROOT / "hello.bin").read_bytes()
    await _bring_up(dut, hello, seat_flip=1, strap=1)

    banner = b"Koti-1: hello from my own SoC\r\n"
    assert await uart_rx_pin(dut, len(banner)) == banner


@cocotb.test()
async def test_harness_wrong_strap_stays_silent(dut):
    """Seating and strap disagree: the design must fail CLEANLY.

    Without this the two mapping tests prove much less than they look like
    they prove — a permutation that was wrong in the same way on both sides
    would pass both. Here the two sides are deliberately inconsistent, so a
    banner appearing would mean the strap does nothing and the rows are being
    guessed somewhere.
    """
    hello = (SW_ROOT / "hello.bin").read_bytes()
    await _bring_up(dut, hello, seat_flip=0, strap=1)

    saw_start_bit = False
    for _ in range(300_000):
        await RisingEdge(dut.clk)
        if not int(dut.ftdi_rxd.value):
            saw_start_bit = True
            break
    assert not saw_start_bit, \
        "UART traffic with the strap set wrong — the mapping is not strap-controlled"


@cocotb.test()
async def test_harness_uart_strap_follows_vga_mode(dut):
    """SBI firmware moves the UART to uo[6] when it enables VGA; SW3 is how
    the harness follows it. Same image as test_sbi_firmware, read off the
    board pin instead of off uo[6] directly."""
    img = (SW_ROOT / "sbi" / "sbi_test.bin").read_bytes()
    await _bring_up(dut, img, seat_flip=0, strap=0, uart_strap=1)

    # uo[6] is LED4 (low) until the firmware flips to VGA + UART-on-blue-LSB,
    # so wait for the line to idle high before trying to decode.
    for _ in range(400_000):
        await RisingEdge(dut.clk)
        if int(dut.ftdi_rxd.value):
            break
    else:
        raise AssertionError("UART idle never appeared on ftdi_rxd via SW3")

    assert await uart_rx_pin(dut, 3) == b"STK"
