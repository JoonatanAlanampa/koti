#!/usr/bin/env python3
"""Check a built kernel Image against koti's boot contract, at build time.

    python3 sw/linux/check_image.py <path-to-arch/riscv/boot/Image>

Two things go wrong here in ways that only show up as a dead machine four and
a half minutes into a UART upload:

  1. The header magic is not where sw/sbi/sbi.c looks for it. The firmware
     decides there is a kernel at all by reading one word at byte 0x38 and
     comparing it to "RSC\\x05"; anything else and it quietly runs the flash
     payload instead. A kernel that fails this test does not report an error,
     it just does not boot, and the log looks like the firmware's normal one.

  2. The kernel does not fit. koti has a 32 MB RAM window and the kernel loads
     4 MB into it, so `image_size` — text + data + bss + the built-in
     initramfs — has 28 MB to live in, and it has to unpack the initramfs
     inside that too. Image is uncompressed and nothing on this machine
     decompresses anything.

     ⚠️ It was 16 MB until 2026-08-08 (PLAN.md item 12). This number is a
     PROMISE about what the address path reaches, so it moves with
     src/project.sv's select and koti.dts's `reg`, never on its own — a
     headroom check that is larger than the real window passes an image that
     then overwrites nothing in particular, very quietly.

Both are cheap to check against the file and expensive to discover later.
"""
import struct
import sys
from pathlib import Path

RISCV_IMAGE_MAGIC2 = b"RSC\x05"

RAM_BASE = 0x0100_0000
RAM_SIZE = 0x0200_0000          # the 32 MB window koti_core can address
KERNEL_ADDR = 0x0140_0000       # sw/sbi/sbi.c KERNEL_ADDR
HEADROOM = RAM_BASE + RAM_SIZE - KERNEL_ADDR      # 28 MB


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    img = Path(sys.argv[1]).read_bytes()
    if len(img) < 64:
        print(f"FAIL: {sys.argv[1]} is {len(img)} bytes, too short for a header")
        return 1

    # struct riscv_image_header, arch/riscv/include/asm/image.h:
    #   u32 code0; u32 code1; u64 text_offset; u64 image_size; u64 flags;
    #   u32 version; u32 res1; u64 res2; u64 magic; u32 magic2; u32 res3;
    # 64 bytes, and magic2 lands at 0x38 — which is the byte offset sbi.c
    # reads. '<' is not only endianness: it also turns off struct alignment,
    # which would otherwise pad code1 up to the u64.
    (code0, code1, text_offset, image_size, flags,
     version, res1, res2, magic, magic2, res3) = struct.unpack_from(
        "<IIQQQIIQ8sII", img, 0)
    assert struct.calcsize("<IIQQQIIQ8sII") == 64

    ok = True
    print(f"Image          : {sys.argv[1]}  ({len(img)} bytes on disk)")
    print(f"  magic2       : {magic2.to_bytes(4, 'little')!r}"
          f"  (want {RISCV_IMAGE_MAGIC2!r})")
    if magic2.to_bytes(4, "little") != RISCV_IMAGE_MAGIC2:
        print("  FAIL: sw/sbi/sbi.c would not recognise this as a kernel and")
        print("        would boot the flash payload instead, silently.")
        ok = False

    print(f"  magic (old)  : {magic!r}")
    print(f"  version      : {version >> 16}.{version & 0xFFFF}")
    print(f"  text_offset  : {text_offset:#x}")
    print(f"  image_size   : {image_size:#x}  ({image_size / 2**20:.2f} MiB)")
    print(f"  flags        : {flags:#x}"
          f"  ({'big' if flags & 1 else 'little'}-endian)")

    if flags & 1:
        print("  FAIL: big-endian kernel; koti is little-endian.")
        ok = False

    # text_offset is the kernel's own statement of where it wants to be, as an
    # offset from the start of RAM (Documentation/riscv/boot-image-header.rst).
    # RV32 defines it as 4 MiB because sv32 maps the kernel with megapages —
    # which is the same reasoning that put KERNEL_ADDR at 0x0140_0000, arrived
    # at independently. Checking they agree turns "we picked a plausible
    # address" into "the kernel and the firmware name the same one".
    print(f"  wants to load at RAM_BASE + text_offset ="
          f" {RAM_BASE + text_offset:#x}; sbi.c loads it at {KERNEL_ADDR:#x}")
    if RAM_BASE + text_offset != KERNEL_ADDR:
        print("  FAIL: the firmware would place this kernel somewhere it does")
        print("        not expect to be. Change KERNEL_ADDR in sw/sbi/sbi.c,")
        print("        test/test.py and koti.dts, together.")
        ok = False

    print(f"  load address : {KERNEL_ADDR:#x}, headroom to the top of RAM"
          f" = {HEADROOM / 2**20:.2f} MiB")
    if image_size > HEADROOM:
        print(f"  FAIL: image_size {image_size / 2**20:.2f} MiB exceeds the"
              f" {HEADROOM / 2**20:.2f} MiB above the load address.")
        ok = False
    elif image_size > HEADROOM * 3 // 4:
        print("  WARNING: over three quarters of the available RAM is the"
              " kernel itself; there is little left to run anything in.")

    if KERNEL_ADDR % (4 * 1024 * 1024):
        print("  FAIL: load address is not 4 MiB aligned (sv32 megapages).")
        ok = False

    print("\nimage ok" if ok else "\nimage NOT usable on koti")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
