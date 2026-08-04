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
    dtb = SBI / ".." / "linux" / "koti.dtb"
    if not dtb.exists():
        raise SystemExit(
            f"missing {dtb.resolve()}.\n"
            "dtb.S embeds it at flash 0x6000, which is where sbi.c looks for\n"
            "the machine description before entering a kernel. There is no dtc\n"
            "on this host: run the `linux` workflow and commit the koti-dtb\n"
            "artifact as sw/linux/koti.dtb.")

    run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
         "-ffreestanding", "-nostdlib", "-nostartfiles", "-static",
         "-I", "..", "-T", "link.ld", "-o", "sbi_test.elf",
         "sbi.S", "sbi.c", "payload.c", "../console.c", "../ps2kbd.c",
         "dtb.S"])
    run([OBJCOPY, "-O", "binary", "sbi_test.elf", "sbi_test.bin"])
    size = (SBI / "sbi_test.bin").stat().st_size
    print(f"sbi_test.bin: {size} bytes")

    # The blob has to land exactly where sbi.c reads it. objcopy pads the gap
    # between .payload and .dtb with zeros, so an off-by-one here is invisible
    # in the file size and fatal at boot: the firmware would fail its magic
    # test and hand a kernel a1 = 0.
    img = (SBI / "sbi_test.bin").read_bytes()
    got = img[0x6000:0x6004]
    if got != b"\xd0\x0d\xfe\xed":
        raise SystemExit(f"no FDT magic at flash 0x6000, found {got!r}")
    print(f"  .dtb at 0x6000: {dtb.stat().st_size} bytes, magic ok")


if __name__ == "__main__":
    main()
