# Build the official rv32ui + rv32um + rv32ua riscv-tests for the
# Koti-1 memory map:
#   python build_riscv_tests.py
# Uses Koti's own env (test/env: EBREAK halt — ECALL traps here) and
# link_asic.ld (code in flash at 0, .data in PSRAM at 0x0100_0000).
# Splits each ELF into <name>.text.bin + <name>.data.bin.
#
# Requires the CPU repo checkout (vendored riscv-tests) and the xpack
# riscv-none-elf-gcc toolchain; override via CPU_REPO / XPACK.

import os
import subprocess
from pathlib import Path

HOME = Path.home()
CPU_REPO = Path(os.environ.get("CPU_REPO", HOME / "Documents" / "CPU"))
XPACK = Path(os.environ.get(
    "XPACK", HOME / "opt" / "xpack-riscv-none-elf-gcc-15.2.0-1" / "bin"))

GCC = XPACK / "riscv-none-elf-gcc.exe"
OBJCOPY = XPACK / "riscv-none-elf-objcopy.exe"
ISA = CPU_REPO / "rv32" / "third_party" / "riscv-tests" / "isa"
TEST_DIR = Path(__file__).parent
ENV = TEST_DIR / "env"
OUT = TEST_DIR / "riscv_bins"

SUITES = ["rv32ui", "rv32um", "rv32ua"]
SKIP = {
    "fence_i",   # XIP from flash: code is ROM
    "ma_data",   # no misaligned-access support (PLAN.md compliance gap)
}


def run(cmd):
    subprocess.run([str(c) for c in cmd], check=True)


def main():
    OUT.mkdir(exist_ok=True)
    built = 0
    for suite in SUITES:
        for src in sorted((ISA / suite).glob("*.S")):
            name = src.stem
            if name in SKIP:
                continue
            elf = OUT / f"{name}.elf"
            run([GCC, "-march=rv32ima", "-mabi=ilp32", "-nostdlib",
                 "-nostartfiles", "-static",
                 "-I", ENV, "-I", ISA / "macros" / "scalar",
                 "-T", TEST_DIR / "link_asic.ld", "-o", elf, src])
            run([OBJCOPY, "-O", "binary", "--only-section=.text",
                 elf, OUT / f"{name}.text.bin"])
            run([OBJCOPY, "-O", "binary", "--only-section=.data",
                 elf, OUT / f"{name}.data.bin"])
            elf.unlink()
            built += 1
    print(f"built {built} tests -> {OUT}")


if __name__ == "__main__":
    main()
