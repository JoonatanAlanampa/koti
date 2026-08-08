# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Koti-1 SoC pin-level test. The CPU boots in place from a behavioral
# SPI flash model, drives LED/PSRAM traffic, flips to QUAD mid-program,
# arms the CLINT timer, takes the interrupt, and halts via EBREAK.
# SpiMem/spi_bus are the pin-level models proven in tt-riscv.

import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge

sys.path.append(str(Path(__file__).parent.parent / "tools"))
from genfont import FONT  # noqa: E402  (RTL font ROM comes from here)

# uio bit positions (QSPI Pmod): SD0..SD3 on uio[1,2,4,5]
CS0 = 0   # flash, active low
SD_BITS = (1, 2, 4, 5)
SCK = 3
CS1 = 6   # PSRAM, active low

# ---------------------------------------------------------------- mini assembler


def r_type(f7, rs2, rs1, f3, rd, op):
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def i_type(imm, rs1, f3, rd, op):
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def s_type(imm, rs2, rs1, f3):
    return (((imm >> 5) & 0x7F) << 25) | (rs2 << 20) | (rs1 << 15) | \
        (f3 << 12) | ((imm & 0x1F) << 7) | 0x23


def b_type(imm, rs2, rs1, f3):
    return (((imm >> 12) & 1) << 31) | (((imm >> 5) & 0x3F) << 25) | \
        (rs2 << 20) | (rs1 << 15) | (f3 << 12) | \
        (((imm >> 1) & 0xF) << 8) | (((imm >> 11) & 1) << 7) | 0x63


def lui(rd, imm20):
    return ((imm20 & 0xFFFFF) << 12) | (rd << 7) | 0x37


def addi(rd, rs1, imm):
    return i_type(imm, rs1, 0, rd, 0x13)


def lw(rd, off, rs1):
    return i_type(off, rs1, 2, rd, 0x03)


def sw(rs2, off, rs1):
    return s_type(off, rs2, rs1, 2)


def beq(rs1, rs2, off):
    return b_type(off, rs2, rs1, 0)


def srli(rd, rs1, sh):
    return i_type(sh, rs1, 5, rd, 0x13)


def andi(rd, rs1, imm):
    return i_type(imm, rs1, 7, rd, 0x13)


def csrrw(rd, csr, rs1):
    return (csr << 20) | (rs1 << 15) | (1 << 12) | (rd << 7) | 0x73


def csrrs(rd, csr, rs1):
    return (csr << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x73


def csrrsi(rd, csr, z):
    return (csr << 20) | (z << 15) | (6 << 12) | (rd << 7) | 0x73


EBREAK = 0x0010_0073

# ---------------------------------------------------------------- SPI/QSPI models


class SpiMem:
    """Behavioral SPI/QSPI slave, mode 0 (vendored from tt-riscv).

    Serial: 03h read, 02h write (24-bit address).
    Quad:   6Bh fast-read-quad-output, EBh quad read, 38h quad write.
    """

    def __init__(self, size, writable):
        self.mem = bytearray(size)
        self.writable = writable
        self.deselect()

    def deselect(self):
        self.phase = "cmd"
        self.sh = 0
        self.n = 0
        self.cmd = None
        self.addr = 0
        self.dummy_left = 0
        self.nib_idx = 0
        self.cur = 0
        self.out_mask = 0
        self.out_val = 0

    def _begin_read(self, quad):
        self.phase = "rd_q" if quad else "rd_s"
        self.nib_idx = 2
        self.bit_idx = 8

    def on_rise(self, io):
        bit = io & 1
        if self.phase == "cmd":
            self.sh = ((self.sh << 1) | bit) & 0xFF
            self.n += 1
            if self.n == 8:
                self.cmd = self.sh
                self.sh = 0
                self.n = 0
                if self.cmd in (0x03, 0x02, 0x6B):
                    self.phase = "addr_s"
                elif self.cmd in (0xEB, 0x38):
                    self.phase = "addr_q"
                else:
                    self.phase = "ignore"
        elif self.phase == "addr_s":
            self.sh = ((self.sh << 1) | bit) & 0xFFFFFF
            self.n += 1
            if self.n == 24:
                self.addr = self.sh
                self.sh = 0
                self.n = 0
                if self.cmd == 0x03:
                    self._begin_read(False)
                elif self.cmd == 0x02:
                    self.phase = "wr_s"
                else:
                    self.phase = "dummy"
                    self.dummy_left = 8
        elif self.phase == "addr_q":
            self.sh = ((self.sh << 4) | io) & 0xFFFFFF
            self.n += 1
            if self.n == 6:
                self.addr = self.sh
                self.sh = 0
                self.n = 0
                if self.cmd == 0xEB:
                    self.phase = "dummy"
                    self.dummy_left = 6
                else:
                    self.phase = "wr_q"
        elif self.phase == "dummy":
            self.dummy_left -= 1
            if self.dummy_left == 0:
                self._begin_read(True)
        elif self.phase == "wr_s":
            self.sh = ((self.sh << 1) | bit) & 0xFF
            self.n += 1
            if self.n == 8:
                if self.writable:
                    self.mem[self.addr % len(self.mem)] = self.sh
                self.addr += 1
                self.sh = 0
                self.n = 0
        elif self.phase == "wr_q":
            self.sh = ((self.sh << 4) | io) & 0xFF
            self.n += 1
            if self.n == 2:
                if self.writable:
                    self.mem[self.addr % len(self.mem)] = self.sh
                self.addr += 1
                self.sh = 0
                self.n = 0

    def on_fall(self):
        if self.phase == "rd_s":
            if self.bit_idx == 8:
                self.cur = self.mem[self.addr % len(self.mem)]
                self.addr += 1
                self.bit_idx = 0
            self.out_mask = 0b0010
            self.out_val = (((self.cur >> (7 - self.bit_idx)) & 1) << 1)
            self.bit_idx += 1
        elif self.phase == "rd_q":
            if self.nib_idx == 2:
                self.cur = self.mem[self.addr % len(self.mem)]
                self.addr += 1
                self.nib_idx = 0
            nib = (self.cur >> 4) & 0xF if self.nib_idx == 0 else self.cur & 0xF
            self.out_mask = 0b1111
            self.out_val = nib
            self.nib_idx += 1
        else:
            self.out_mask = 0
            self.out_val = 0


async def spi_bus(dut, flash, ram):
    """Pin-level bus glue, sampled on the falling clk edge."""
    prev_sck = 0
    while True:
        await FallingEdge(dut.clk)
        v = dut.uio_out.value
        oe = dut.uio_oe.value
        if not (v.is_resolvable and oe.is_resolvable):
            continue
        out = int(v)
        oem = int(oe)
        sck = (out >> SCK) & 1
        io = 0
        for i, b in enumerate(SD_BITS):
            io |= (((out >> b) & 1) if (oem >> b) & 1 else 1) << i
        sel = None
        if not (out >> CS0) & 1:
            sel = flash
        elif not (out >> CS1) & 1:
            sel = ram
        for dev in (flash, ram):
            if dev is not sel:
                dev.deselect()
        uin = 0
        for i, b in enumerate(SD_BITS):
            uin |= 1 << b
        if sel is not None:
            if sck and not prev_sck:
                sel.on_rise(io)
            elif prev_sck and not sck:
                sel.on_fall()
            uin = 0
            for i, b in enumerate(SD_BITS):
                bit = (sel.out_val >> i) & 1 if (sel.out_mask >> i) & 1 else 1
                uin |= bit << b
        dut.uio_in.value = uin
        prev_sck = sck


# ---------------------------------------------------------------- the test

MMIO_HI = 0x10        # lui value: 0x0001_0000
RAM_HI = 0x1000       # lui value: 0x0100_0000 (PSRAM)
CLINT_HI = 0x20 >> 4  # lui value for 0x0002_0000 is 0x20
MTVEC, MIE, MSTATUS = 0x305, 0x304, 0x300

HANDLER = 28          # word index of the trap handler


def koti_program():
    x0 = 0
    x1, x2, x5, x6, x7, x8, x9, x15 = 1, 2, 5, 6, 7, 8, 9, 15
    main = [
        lui(x5, MMIO_HI),          # x5 = MMIO base
        lui(x7, RAM_HI),           # x7 = PSRAM base
        addi(x6, x0, 0x2A),
        sw(x6, 0, x5),             # LED <= 0x2A
        addi(x8, x0, -3),          # x8 = 0xFFFF_FFFD
        sw(x8, 4, x7),             # PSRAM serial write
        lw(x9, 4, x7),             # serial read back
        sw(x9, 0, x5),             # LED <= 0xFD (visible 0x3D)
        addi(x6, x0, 3),
        sw(x6, 12, x5),            # QSPI_CFG <= 3: everything quad now
        sw(x8, 8, x7),             # PSRAM quad write (38h)
        sw(x6, 0, x5),             # LED <= 3, fetched in quad
        lui(x15, 0x20),            # x15 = CLINT base 0x0002_0000
        lw(x9, 0x10, x15),         # mtime lo
        addi(x9, x9, 1800),
        sw(x9, 0x08, x15),         # mtimecmp = mtime + 1800
        addi(x1, x0, HANDLER * 4),
        csrrw(x0, MTVEC, x1),
        addi(x2, x0, 0x80),
        csrrs(x0, MIE, x2),        # mie.MTIE
        csrrsi(x0, MSTATUS, 8),    # mstatus.MIE
        beq(x0, x0, 0),            # spin here until the timer fires
    ]
    handler = [
        addi(x6, x0, 0x11),
        sw(x6, 0, x5),             # LED <= 0x11: irq observed
        EBREAK,
    ]
    assert len(main) <= HANDLER
    return main + [EBREAK] * (HANDLER - len(main)) + handler


@cocotb.test()
async def test_koti_boot_and_timer(dut):
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)

    for i, insn in enumerate(koti_program()):
        flash.mem[4 * i:4 * i + 4] = insn.to_bytes(4, "little")

    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    led_seq = []
    halted = False
    for _ in range(60000):
        await RisingEdge(dut.clk)
        uo = int(dut.uo_out.value)
        led = uo >> 2
        if not led_seq or led != led_seq[-1]:
            led_seq.append(led)
        if (uo >> 1) & 1:
            halted = True
            break

    assert halted, f"CPU never halted; LED history: {[hex(v) for v in led_seq]}"

    # 0x00 reset, 0x2A serial, 0x3D PSRAM readback, 0x03 in quad mode,
    # 0x11 from the timer-interrupt handler
    expected = [0x00, 0x2A, 0xFD & 0x3F, 0x03, 0x11]
    assert led_seq == expected, \
        f"LED sequence {[hex(v) for v in led_seq]} != {[hex(v) for v in expected]}"

    # PSRAM: serial-written word at +4, quad-written word at +8
    assert ram.mem[4:8] == bytes([0xFD, 0xFF, 0xFF, 0xFF]), ram.mem[0:12].hex()
    assert ram.mem[8:12] == bytes([0xFD, 0xFF, 0xFF, 0xFF]), ram.mem[0:12].hex()


# ---------------------------------------------------------------- F1 aperture

# Flash byte addresses that the OLD 3-bit MMIO decode aliased into device
# registers (every 512 KiB): 0x0011_0000 -> core MMIO (io_m),
# 0x0012_0000 -> CLINT, 0x0014_0000 -> VGA. Each sentinel low byte is
# distinct and != 0/1, so a misdecoded register read (uart_busy=0,
# CLINT/VGA regs) cannot masquerade as the flash value.
APERTURES = [(0x0011_0000, 0x15),   # core-MMIO alias
             (0x0012_0000, 0x2A),   # CLINT alias
             (0x0014_0000, 0x33)]   # VGA alias


@cocotb.test()
async def test_flash_data_aperture_no_mmio_alias(dut):
    """F1 regression: a flash *data* load past the first 64 KiB of a
    512 KiB span must return flash contents, not an aliased MMIO
    register. Seed a sentinel at each aliasing flash address, echo each
    to the LEDs, and require the real flash byte back."""
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    x0, x5, x6, x7 = 0, 5, 6, 7
    prog = [lui(x5, MMIO_HI)]                     # x5 = LED MMIO base
    for baddr, _ in APERTURES:
        prog += [lui(x6, baddr >> 12),           # x6 = flash aperture addr
                 lw(x7, 0, x6),                   # load the flash word
                 sw(x7, 0, x5)]                   # echo low byte to the LEDs
    prog += [EBREAK]

    flash = SpiMem(1 << 21, writable=False)       # 2 MiB: covers the aliases
    ram = SpiMem(1 << 16, writable=True)
    for i, insn in enumerate(prog):
        flash.mem[4 * i:4 * i + 4] = insn.to_bytes(4, "little")
    for baddr, val in APERTURES:
        flash.mem[baddr:baddr + 4] = val.to_bytes(4, "little")
    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    led_seq = []
    halted = False
    for _ in range(60000):
        await RisingEdge(dut.clk)
        led = int(dut.uo_out.value) >> 2
        if not led_seq or led != led_seq[-1]:
            led_seq.append(led)
        if (int(dut.uo_out.value) >> 1) & 1:
            halted = True
            break

    assert halted, f"CPU never halted; LED history: {[hex(v) for v in led_seq]}"
    expected = [0x00] + [val for _, val in APERTURES]
    assert led_seq == expected, \
        f"aperture LED seq {[hex(v) for v in led_seq]} != " \
        f"{[hex(v) for v in expected]} — flash data aliased into MMIO"


# ---------------------------------------------------------------- F3 arbiter


@cocotb.test()
async def test_vga_disable_does_not_park_grant(dut):
    """F3 regression: an in-flight row refill must keep its request
    asserted even after software clears VGA_EN, so an already-granted
    transaction still reaches ACK and the arbiter releases the grant. The
    old RTL tied v_req = f_busy && en, so clearing en mid-refill withdrew
    a granted request and parked the arbiter forever (blocking all CPU
    fetch/data). Halt the CPU so only video drives the bus, enable video,
    then withdraw VGA_EN once a refill is in flight and require v_req to
    stay asserted until the refill completes."""
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)
    flash.mem[0:4] = EBREAK.to_bytes(4, "little")   # CPU halts, frees the bus
    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    for _ in range(3000):                           # wait for EBREAK halt
        await RisingEdge(dut.clk)
        if (int(dut.uo_out.value) >> 1) & 1:
            break
    else:
        raise AssertionError("CPU never halted")

    # enable video by hand — vga_en/vga_base only change on an MMIO write
    # or reset, so a deposit sticks with the CPU halted.
    dut.user_project.vga_base.value = 0x40_2000     # charbuf in PSRAM
    dut.user_project.vga_en.value = 1

    vt = dut.user_project.vt
    for _ in range(50000):                          # wait for a refill to start
        await RisingEdge(dut.clk)
        if int(vt.f_busy.value):
            break
    else:
        raise AssertionError("no row refill started")

    # the race: clear VGA_EN with the refill in flight
    dut.user_project.vga_en.value = 0
    for _ in range(4000):
        await RisingEdge(dut.clk)
        if not int(vt.f_busy.value):                # refill finished -> not parked
            return
        assert int(vt.v_req.value) == 1, \
            "v_req dropped mid-refill after VGA_EN cleared — the arbiter's " \
            "granted video transaction can never ACK (F3)"
    raise AssertionError("row refill never completed after VGA_EN cleared (F3)")


# ---------------------------------------------------------------------- VGA



def vga_program():
    x0, x5, x6, x7, x8, x9, x10, x11 = 0, 5, 6, 7, 8, 9, 10, 11
    return [
        lui(x5, MMIO_HI),          # LED MMIO
        lui(x6, 0x40),             # VGA block 0x0004_0000
        # write "KOTI" into the charbuf and switch the pins to VGA
        lui(x7, 0x1008),           # charbuf at 0x0100_8000
        lui(x8, 0x49545),
        addi(x8, x8, 0xF4B),       # x8 = 0x49544F4B = "KOTI" LE
        sw(x8, 0, x7),
        sw(x7, 4, x6),             # charbuf base
        addi(x9, x0, 1),
        sw(x9, 0, x6),             # ctrl: VGA_EN
        beq(x0, x0, 0),            # spin
    ]


@cocotb.test()
async def test_vga_text(dut):
    """VGA mode renders the first glyph row of 'K' pixel-exactly on the uo
    pins.

    This used to drive a PS/2 frame first and check the scancode reached the
    LEDs. PS/2 was removed on 2026-08-08; the VGA half is untouched and is the
    part that was always doing the work — it is the only test in the suite that
    checks the font ROM, the line buffers and the pixel doubling against
    actual pin values."""
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)
    for i, insn in enumerate(vga_program()):
        flash.mem[4 * i:4 * i + 4] = insn.to_bytes(4, "little")
    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 200)

    # VGA mode: catch a full vsync pulse (uo[3] low for 2 lines), then
    # line up on y=0 x=0: 33 hsync falls after the vsync rise, +142 clk
    async def wait_bit(bit, level, timeout):
        for _ in range(timeout):
            await RisingEdge(dut.clk)
            if (int(dut.uo_out.value) >> bit) & 1 == level:
                return
        raise AssertionError(f"uo[{bit}] never reached {level}")

    await wait_bit(3, 0, 900_000)          # vsync fall (VGA mode is on)
    await wait_bit(3, 1, 10_000)           # vsync rise: line 492

    # ⚠️ SAMPLE THE SECOND FRAME, NOT THE FIRST. Row 0's charbuf burst is
    # prefetched during vblank (line 508). If VGA_EN is set after that point in
    # a frame, row 0's line buffer was never filled and every pixel of it reads
    # as background — which is exactly what this test then sees, 0x88 all the
    # way across, with the video timing otherwise perfect.
    # This did not use to matter: the PS/2 exchange this test performed first
    # delayed VGA_EN by thousands of clocks and happened to land past the
    # window. Removing PS/2 on 2026-08-08 removed that accidental delay and the
    # test failed — on a change that touched no video logic at all. Waiting a
    # whole frame makes the alignment depend on the raster rather than on how
    # long the setup code happened to take.
    await wait_bit(3, 0, 900_000)
    await wait_bit(3, 1, 10_000)
    for _ in range(33):                    # falls at x=656 of each line
        await wait_bit(7, 0, 2_000)
        await wait_bit(7, 1, 2_000)
    await ClockCycles(dut.clk, 46)         # rise was x=752; land at x=-2

    samples = []
    for _ in range(28):
        await RisingEdge(dut.clk)
        samples.append(int(dut.uo_out.value))

    krow = FONT[ord("K")][0]
    want = []
    for i in range(8):                      # pixels doubled horizontally
        v = 0xFF if (krow >> i) & 1 else 0x88
        want += [v, v]
    ok = any(samples[i:i + 16] == want for i in range(len(samples) - 15))
    assert ok, f"'K' row not on the wire: {[hex(s) for s in samples]}"


# ---------------------------------------------------------------- C hello

UART_DIV = 217  # 115200 8N1 @ 25 MHz


async def uart_rx(dut, nbytes, timeout=1_500_000, bit=0):
    """Decode nbytes of 8N1 from uo[bit] (bit 0 headless, 6 in VGA
    mode with the UART-on-blue-LSB mux)."""
    got = bytearray()
    waited = 0
    while len(got) < nbytes:
        # start bit: falling edge
        while True:
            await RisingEdge(dut.clk)
            waited += 1
            assert waited < timeout, f"UART stalled after {bytes(got)!r}"
            if not (int(dut.uo_out.value) >> bit) & 1:
                break
        await ClockCycles(dut.clk, UART_DIV + UART_DIV // 2)
        b = 0
        for i in range(8):
            b |= ((int(dut.uo_out.value) >> bit) & 1) << i
            await ClockCycles(dut.clk, UART_DIV)
        assert (int(dut.uo_out.value) >> bit) & 1, "missing stop bit"
        got.append(b)
        waited += 10 * UART_DIV
    return bytes(got)


@cocotb.test()
async def test_hello_c(dut):
    """sw/hello.bin (GCC C): UART banner decoded from the pin, then
    the VGA console text lands in the PSRAM charbuf."""
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    hello = (Path(__file__).parent.parent / "sw" / "hello.bin").read_bytes()
    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)
    flash.mem[:len(hello)] = hello
    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    banner = b"Koti-1: hello from my own SoC\r\n"
    assert await uart_rx(dut, len(banner)) == banner

    # console text appears in the charbuf (0x8000, 40-byte rows)
    row1_want = b"hello, visible world"
    for _ in range(200):
        await ClockCycles(dut.clk, 10_000)
        if ram.mem[0x8028:0x8028 + len(row1_want)] == row1_want:
            break
    else:
        raise AssertionError(
            f"charbuf row1: {bytes(ram.mem[0x8028:0x8050])!r}")
    assert ram.mem[0x8000:0x8006] == b"KOTI-1"
    assert all(c == 0x20 for c in ram.mem[0x8006:0x8028]), "row 0 tail"


@cocotb.test()
async def test_sbi_firmware(dut):
    """The SBI stack end to end on the pins: M firmware boots, drops
    to the S-mode payload; 'S' via SBI console, timer armed via
    rdtime (illegal-trap emulation in M), delegated S-timer interrupt
    prints 'T', 'K' after — decoded from the UART-on-blue-LSB pin,
    and mirrored on the VGA console charbuf."""
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    img = (Path(__file__).parent.parent / "sw" / "sbi"
           / "sbi_test.bin").read_bytes()
    flash = SpiMem(1 << 16, writable=False)
    ram = SpiMem(1 << 16, writable=True)
    flash.mem[:len(img)] = img
    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0b11
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # uo[6] is LED4 (low) until the firmware flips the pins to VGA
    # with UART-on-blue-LSB; wait for the idle-high UART line first
    for _ in range(400_000):
        await RisingEdge(dut.clk)
        if (int(dut.uo_out.value) >> 6) & 1:
            break
    else:
        raise AssertionError("UART idle never appeared on uo[6]")

    assert await uart_rx(dut, 3, bit=6) == b"STK"
    await ClockCycles(dut.clk, 20_000)   # let the last charbuf write land
    assert ram.mem[0x8000:0x8003] == b"STK", \
        f"VGA console mirror: {bytes(ram.mem[0x8000:0x8010])!r}"

# --------------------------------------------------------- Linux boot handoff

# The Linux entry contract, and where each number comes from:
#   entry     0x0140_0000  the first 4 MiB boundary clear of the firmware's own
#                          RAM. RV32 Linux maps itself with sv32 megapages, so
#                          it must load 4 MiB-aligned.
#   a0        hartid, 0    koti is uniprocessor.
#   a1        0x013F_0000  where the firmware copies the DTB, just below the
#                          kernel and inside ordinary mappable memory.
#   magic     0x0543_5352  "RSC\x05" at byte 0x38 of a RISC-V Image header,
#                          per arch/riscv/kernel/head.S. This is what the
#                          firmware tests to decide there is a kernel at all.
KERNEL_ADDR = 0x0140_0000
DTB_DST = 0x013F_0000
DTB_SRC_FLASH = 0x6000
RISCV_IMAGE_MAGIC2 = 0x0543_5352


def ecall():
    return i_type(0, 0, 0, 0, 0x73)


def fake_kernel():
    """A stand-in kernel that reports what it was handed.

    It talks through `ecall` deliberately rather than by poking the UART MMIO
    directly. An ecall from S-mode raises cause 9, which the firmware handles;
    the same instruction from M-mode raises cause 11, which it does not — the
    handler prints '!' and halts. So the three characters arriving at all is
    itself the proof that the handoff landed in SUPERVISOR mode, which is the
    part of the contract that would otherwise need a privileged CSR read to
    check (and a wrong answer there halts the machine instead of failing).

    a7 is loaded once and not reloaded: the trap shim saves and restores the
    whole caller-saved set and the legacy console call writes back only a0, so
    a7 survives. That is worth relying on here because it keeps the program
    short enough to fit under the header magic at 0x38.

    Emits: 'L' (it ran), '0'+hartid, and 'D' if a1 is the DTB address else '?'.
    """
    x0, t0, s0, s1, a0, a1, a7 = 0, 5, 8, 9, 10, 11, 17
    words = [
        addi(s0, a0, 0),           # 0x00 save hartid
        addi(s1, a1, 0),           # 0x04 save dtb pointer
        addi(a7, x0, 1),           # 0x08 SBI legacy console_putchar
        addi(a0, x0, ord("L")),    # 0x0c
        ecall(),                   # 0x10
        addi(a0, s0, ord("0")),    # 0x14 '0' + hartid
        ecall(),                   # 0x18
        lui(t0, 0x13F0),           # 0x1c t0 = 0x013F_0000
        addi(a0, x0, ord("D")),    # 0x20
        beq(s1, t0, 8),            # 0x24 skip the '?' when a1 is right
        addi(a0, x0, ord("?")),    # 0x28
        ecall(),                   # 0x2c
        beq(x0, x0, 0),            # 0x30 spin here forever
        addi(x0, x0, 0),           # 0x34 nop, padding up to the magic
    ]
    assert len(words) * 4 == 0x38, f"header magic must land at 0x38, not {len(words) * 4:#x}"
    words.append(RISCV_IMAGE_MAGIC2)
    return words


@cocotb.test()
async def test_boots_a_kernel_image_with_the_linux_handoff(dut):
    """A kernel image in RAM is booted instead of the flash payload, with
    a0 = hartid, a1 = DTB and the DTB copied out of flash into RAM.

    The fallback direction — no kernel present, so the flash payload runs and
    prints STK — is already covered by test_sbi_firmware and the three keyboard
    tests, which is why this one only asserts the kernel direction.
    """
    clock = Clock(dut.clk, 40, unit="ns")  # 25 MHz
    cocotb.start_soon(clock.start())

    img = (Path(__file__).parent.parent / "sw" / "sbi"
           / "sbi_test.bin").read_bytes()
    flash = SpiMem(1 << 16, writable=False)
    # 8 MiB, not the usual 64 KiB: the kernel sits 4 MiB into RAM and SpiMem
    # models the APS6404 by WRAPPING (`addr % len(mem)`), so a short model would
    # not error — it would alias the kernel on top of the firmware's own .bss
    # and the test would pass or fail for entirely the wrong reason.
    ram = SpiMem(1 << 23, writable=True)
    flash.mem[:len(img)] = img

    # The devicetree is NOT injected here: sw/sbi/dtb.S embeds the real
    # koti.dtb in the firmware image at flash 0x6000, so loading sbi_test.bin
    # above already placed it. Reading the expected bytes from the same file
    # the firmware was built from makes this an end-to-end check of the blob
    # that actually ships — a fake header would pass just as happily against a
    # .dtb section that was never filled.
    dtb = (Path(__file__).parent.parent / "sw" / "linux"
           / "koti.dtb").read_bytes()
    assert flash.mem[DTB_SRC_FLASH:DTB_SRC_FLASH + 4] == b"\xd0\x0d\xfe\xed", (
        "sbi_test.bin carries no FDT magic at flash 0x6000 — rebuild it with "
        "python sw/sbi/build.py")

    kimg = b"".join(w.to_bytes(4, "little") for w in fake_kernel())
    # NB: one slice, not `ram.mem[off:][:n] = ...` — slicing a bytearray builds
    # a copy, so the two-step form writes the kernel into a temporary and
    # leaves RAM untouched.
    koff = KERNEL_ADDR - 0x0100_0000
    ram.mem[koff:koff + len(kimg)] = kimg

    cocotb.start_soon(spi_bus(dut, flash, ram))

    dut.ena.value = 1
    dut.ui_in.value = 0b11
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # uo[6] carries the UART once sbi_init flips the pins to VGA mode
    for _ in range(400_000):
        await RisingEdge(dut.clk)
        if (int(dut.uo_out.value) >> 6) & 1:
            break
    else:
        raise AssertionError("UART idle never appeared on uo[6]")

    got = await uart_rx(dut, 3, bit=6, timeout=8_000_000)
    assert got == b"L0D", (
        f"kernel handoff reported {got!r}, expected b'L0D' — "
        "'L' missing means the firmware never jumped to the kernel; "
        "'?' in the third position means a1 was not the DTB address"
    )

    # and the whole blob really was copied, not just pointed at. All of it,
    # not a prefix: the firmware reads `totalsize` out of the header to decide
    # how much to move, so a copy that stops early is exactly the bug this
    # catches — and it would leave a kernel parsing a truncated devicetree,
    # which fails much later and somewhere else.
    off = DTB_DST - 0x0100_0000
    got = bytes(ram.mem[off:off + len(dtb)])
    assert got == dtb, (
        f"DTB copy mismatch at +{next(i for i in range(len(dtb)) if got[i] != dtb[i]):#x}"
        f" of {len(dtb)} bytes; head = {got[:16]!r}")
