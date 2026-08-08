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
    # Two images, and the second is not a variant of the first.
    #
    # hello.bin  the demo: banner, then con_init() -> VGA_EN, which MOVES the
    #            UART to uo[6] and turns uo[0] into an RGB bit.
    # bringup.bin  the diagnostic: prints forever, never touches video. The
    #            banner is 5 ms after reset and programming the FPGA takes 60
    #            seconds, so hello.bin's banner cannot be read without a human
    #            pressing BTN0 at the right instant. This one needs no window.
    #
    # ⭐ bringup is the ONE image written in ASSEMBLY (sw/bringup.S, 2026-08-08),
    #            and it is its own startup — no crt0.S, because it has no .data
    #            to copy and no .bss to zero. It is the image you flash when you
    #            do not yet trust the board, so every instruction in it should be
    #            one you can read; and the SDRAM stack traffic that makes a
    #            printed line MEAN something is written down there rather than
    #            left to a register allocator. Its UART output is byte-identical
    #            to the C version it replaced, so test/tb_fpga_bram.v +mark=0
    #            still proves it with no new bench. (The C version is one
    #            `git show <commit>^:sw/bringup.c` away if it is ever wanted.)
    #            The other instruments stay in C on purpose: they encode
    #            protocols, and C represents those better.
    # memtest.bin is the third: a full walk of the 16 MB RAM window with an
    # ADDRESS-DERIVED pattern, which is what catches aliasing. bringup.bin proves
    # the SDRAM's read timing; only this proves its address decode.
    for name, srcs in (("hello", ["crt0.S", "console.c", "hello.c"]),
                       ("bringup", ["bringup.S"]),
                       ("memtest", ["crt0.S", "memtest.c"]),
                       ("sdtest",  ["crt0.S", "sdtest.c"]),
                       # sdraw.bin is the layer BELOW sdtest: it bypasses the
                       # sd_spi engine entirely and hand-clocks CMD0 through the
                       # SD_RAW escape hatch, so a silent card and a broken
                       # engine stop producing the same message.
                       ("sdraw",   ["crt0.S", "sdraw.c"]),
                       # usbtest.bin: plug a keyboard into US2 and see
                       # whether it enumerates. The bring-up instrument
                       # for the keyboard rung, and the layer below any
                       # Linux plumbing that depends on it.
                       ("usbtest", ["crt0.S", "usbtest.c"])):
        run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
             "-nostdlib", "-nostartfiles", "-static",
             "-T", "link.ld", "-o", f"{name}.elf", *srcs])
        run([OBJCOPY, "-O", "binary", f"{name}.elf", f"{name}.bin"])
        size = (SW / f"{name}.bin").stat().st_size
        print(f"{name}.bin: {size} bytes")


if __name__ == "__main__":
    main()
