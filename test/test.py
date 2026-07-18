# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Koti-1 SoC pin-level test. The CPU boots in place from a behavioral
# SPI flash model, drives LED/PSRAM traffic, flips to QUAD mid-program,
# arms the CLINT timer, takes the interrupt, and halts via EBREAK.
# SpiMem/spi_bus are the pin-level models proven in tt-riscv.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge

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
