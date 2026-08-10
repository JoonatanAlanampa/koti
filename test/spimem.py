# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
"""spimem.py — the QSPI pin map and the behavioural flash/PSRAM device.

⛔ WHY THIS FILE EXISTS, AND WHY IT IS NOT CALLED `test`. These definitions
lived in `test/test.py` until 603c9c9 (2026-08-08) deleted it with the rest of
the ASIC apparatus. `test_fpga.py` still said `from test import CS0, ...`, and
`test` is a REAL PACKAGE IN THE PYTHON STANDARD LIBRARY — so the import did not
fail with "no module named", it resolved to the stdlib and raised

    ImportError: cannot import name 'CS0' from 'test'
                 (/opt/.../python3.11/test/__init__.py)

⇒ THE ULX3S HARNESS DID NOT RUN AT ALL FROM 2026-08-08 TO 2026-08-10, and the
`test` workflow reported that step GREEN throughout, because its gate was
`! grep failure results_fpga.xml`: the crash is so early that the results file
is never written, grep exits 1 for "no match", and `!` turns that into success.
A missing results file and a clean run were indistinguishable. See test/gate.py,
which now fails on the missing file explicitly.

Contents are verbatim from the deleted file; only the module name is new.
"""

# QSPI Pmod pin positions within uio.
CS0 = 0   # flash, active low
CS1 = 6   # PSRAM, active low
SCK = 3
SD_BITS = (1, 2, 4, 5)
UART_DIV = 217  # 115200 8N1 @ 25 MHz


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
