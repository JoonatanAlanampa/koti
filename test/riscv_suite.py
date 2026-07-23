# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
#
# Official rv32ui + rv32um + rv32ua riscv-tests on koti_core through
# the XIP memory model (build them first: python build_riscv_tests.py).
# Fast path: .text/.data are backdoor-loaded into the model arrays —
# the wire-protocol QSPI path is covered by test.py and by tt-riscv's
# pin-level suite, which uses the identical controller.
#
# Pass/fail: EBREAK halts with a0 == 1 on pass, (testnum<<1)|1 on fail.
#
# Run:  python run_riscv.py            (all tests)
#       RISCV_GLOB=amo* python run_riscv.py

import fnmatch
import os
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

BINS = Path(__file__).parent / "riscv_bins"


def load_words(arr, blob):
    for i in range(0, len(blob), 4):
        arr[i // 4].value = int.from_bytes(blob[i:i + 4], "little")


@cocotb.test()
async def test_riscv_suite(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    pattern = os.environ.get("RISCV_GLOB", "*")
    tests = sorted(p.stem[:-5] for p in BINS.glob("*.text.bin")
                   if fnmatch.fnmatch(p.stem[:-5], pattern))
    assert tests, f"no tests match {pattern!r} in {BINS} — build them first"

    failures = []
    for name in tests:
        text = (BINS / f"{name}.text.bin").read_bytes()
        data = (BINS / f"{name}.data.bin").read_bytes()

        dut.rst.value = 1
        dut.mtip.value = 0
        dut.msip.value = 0
        dut.meip.value = 0
        await ClockCycles(dut.clk, 5)
        load_words(dut.mem.flash, text)
        load_words(dut.mem.ram, data)
        await ClockCycles(dut.clk, 2)
        dut.rst.value = 0

        verdict = "TIMEOUT"
        for _ in range(400_000):
            await ClockCycles(dut.clk, 16)
            if dut.halted.value:
                # behavioural regfile keeps the array at rf.regs; the
                # USE_MACRO wrapper nests it at rf.u_rf.regs.
                try:
                    regs = dut.c0.rf.regs
                except AttributeError:
                    regs = dut.c0.rf.u_rf.regs
                a0 = int(regs[10].value)
                verdict = "PASS" if a0 == 1 else f"FAIL (test #{a0 >> 1})"
                break

        dut._log.info("%-12s %s", name, verdict)
        if verdict != "PASS":
            failures.append(f"{name}: {verdict}")

    assert not failures, f"{len(failures)}/{len(tests)} failed: {failures}"
    dut._log.info("=== rv32ui+um+ua: ALL %d PASS ===", len(tests))
