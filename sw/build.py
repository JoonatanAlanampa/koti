# build.py — build sw/hello.bin for Koti-1:
#   python build.py
# Needs the xpack riscv-none-elf-gcc toolchain (override via XPACK).

import os
import subprocess
from pathlib import Path

HOME = Path.home()
XPACK = Path(os.environ.get(
    "XPACK", HOME / "opt" / "xpack-riscv-none-elf-gcc-15.2.0-1" / "bin"))
GCC = XPACK / "riscv-none-elf-gcc.exe"
OBJCOPY = XPACK / "riscv-none-elf-objcopy.exe"
SW = Path(__file__).parent


def run(cmd):
    subprocess.run([str(c) for c in cmd], check=True, cwd=SW)


def main():
    run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
         "-nostdlib", "-nostartfiles", "-static",
         "-T", "link.ld", "-o", "hello.elf",
         "crt0.S", "console.c", "hello.c"])
    run([OBJCOPY, "-O", "binary", "hello.elf", "hello.bin"])
    size = (SW / "hello.bin").stat().st_size
    print(f"hello.bin: {size} bytes")


if __name__ == "__main__":
    main()
