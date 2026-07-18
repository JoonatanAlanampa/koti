# build.py — build sw/sbi/sbi_test.bin (firmware + S-mode payload):
#   python build.py

import os
import subprocess
from pathlib import Path

HOME = Path.home()
XPACK = Path(os.environ.get(
    "XPACK", HOME / "opt" / "xpack-riscv-none-elf-gcc-15.2.0-1" / "bin"))
GCC = XPACK / "riscv-none-elf-gcc.exe"
OBJCOPY = XPACK / "riscv-none-elf-objcopy.exe"
SBI = Path(__file__).parent


def run(cmd):
    subprocess.run([str(c) for c in cmd], check=True, cwd=SBI)


def main():
    run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
         "-ffreestanding", "-nostdlib", "-nostartfiles", "-static",
         "-I", "..", "-T", "link.ld", "-o", "sbi_test.elf",
         "sbi.S", "sbi.c", "payload.c", "../console.c"])
    run([OBJCOPY, "-O", "binary", "sbi_test.elf", "sbi_test.bin"])
    size = (SBI / "sbi_test.bin").stat().st_size
    print(f"sbi_test.bin: {size} bytes")


if __name__ == "__main__":
    main()
