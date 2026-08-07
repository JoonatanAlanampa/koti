# sdkernel.py — put a kernel image on a microSD card the way sw/sbi/sdboot.c
# expects to find it, or produce the same bytes as a file for simulation.
#
#   python tools/sdkernel.py build  <kernel> --img boot.img [--hex boot.hex]
#   python tools/sdkernel.py write  <kernel> --disk 3            (NEEDS ADMIN)
#   python tools/sdkernel.py inspect --disk 3                    (NEEDS ADMIN)
#
# THE LAYOUT, which sdboot.c reads back:
#
#   LBA 2048      header, 512 bytes
#   LBA 2049..    the kernel, zero-padded to a whole number of blocks
#
#   word 0  magic 0x49544F4B  ('K','O','T','I' little-endian)
#   word 1  version, 1
#   word 2  blocks that follow
#   word 3  load address, 0x0140_0000
#   word 4  sum — 32-bit additive sum over every loaded word
#
# ⚠️ `write` DESTROYS DATA. LBA 2048 is where Windows puts the first partition,
# so writing there overwrites the start of any filesystem on the card. That is
# deliberate for a boot card and fatal for a card holding anything else, which
# is why --disk demands --yes and prints the disk it matched first. `build`
# touches no device and is what CI uses.
#
# WHY 2048 rather than 1: the MBR gap (LBA 1..2047) is only ~1 MB and a kernel
# is ~4 MB, so it does not fit there however tidy that would have been.
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
import argparse
import struct
import sys
from pathlib import Path

MAGIC = 0x49544F4B
VERSION = 1
HDR_LBA = 2048
LOAD_ADDR = 0x01400000
BLOCK = 512
MAX_BLOCKS = 32768          # must match SDBOOT_MAX_BLOCKS in sdboot.c


def build_payload(kernel: bytes):
    """Return (header_block, padded_kernel). The pad is part of the checksum."""
    pad = (-len(kernel)) % BLOCK
    data = kernel + b"\x00" * pad
    blocks = len(data) // BLOCK
    if blocks == 0:
        raise SystemExit("kernel is empty")
    if blocks > MAX_BLOCKS:
        raise SystemExit(
            f"{blocks} blocks exceeds SDBOOT_MAX_BLOCKS ({MAX_BLOCKS}); "
            "the firmware would refuse this image")

    # Word-wise so the firmware can verify it without a byte loop over 4 MB —
    # at 25 MHz that difference is about a second of boot time.
    words = struct.unpack(f"<{len(data)//4}I", data)
    total = sum(words) & 0xFFFFFFFF

    hdr = struct.pack("<5I", MAGIC, VERSION, blocks, LOAD_ADDR, total)
    hdr += b"\x00" * (BLOCK - len(hdr))
    return hdr, data


def cmd_build(args):
    kernel = Path(args.kernel).read_bytes()
    hdr, data = build_payload(kernel)
    blocks = len(data) // BLOCK

    if args.img:
        # A sparse-ish image starting at the header: callers that want a whole
        # card image can pad the front themselves. Keeping the file small is
        # what makes it usable as a simulation overlay.
        Path(args.img).write_bytes(hdr + data)
        print(f"{args.img}: {len(hdr) + len(data)} bytes "
              f"(header + {blocks} blocks)")

    if args.hex:
        # $readmemh format, one byte per line, for test/sd_card_model.sv's
        # overlay. The model is told the starting LBA separately.
        out = []
        for b in hdr + data:
            out.append(f"{b:02x}")
        Path(args.hex).write_text("\n".join(out) + "\n")
        print(f"{args.hex}: {len(hdr) + len(data)} bytes as hex")

    print(f"  kernel   {len(kernel)} bytes -> {blocks} blocks "
          f"(padded {len(data) - len(kernel)})")
    print(f"  load     0x{LOAD_ADDR:08x}")
    print(f"  sum      0x{struct.unpack('<5I', hdr[:20])[4]:08x}")
    print(f"  header at LBA {HDR_LBA}, image at LBA {HDR_LBA + 1}")


# The card layout, once it carries a filesystem as well as a kernel.
#
#   LBA 0                MBR
#   LBA 2048   .. 18431   p1, type 0xDA (non-FS data) — the raw kernel area
#                         that sw/sbi/sdboot.c reads. 8 MiB, against a 3.95 MB
#                         kernel, so it can grow without moving p2.
#   LBA 18432  .. end     p2, type 0x83 (Linux) — the filesystem
#
# ⚠️ p1 IS NOT A FILESYSTEM AND MUST NEVER BE MOUNTED. Type 0xDA says so, which
# is what stops a helpful desktop OS from offering to format it. The firmware
# reads it by absolute LBA and knows nothing about partitions; the table exists
# so that LINUX can find p2 and so that nothing else claims those sectors.
KERNEL_PART_LBA = 2048
KERNEL_PART_SECTORS = 16384          # 8 MiB
ROOTFS_PART_LBA = KERNEL_PART_LBA + KERNEL_PART_SECTORS


def chs_max():
    """The 'too big for CHS' sentinel, which every modern tool writes."""
    return bytes([0xFE, 0xFF, 0xFF])


def mbr_entry(boot, ptype, start, count):
    return (bytes([0x80 if boot else 0x00]) + chs_max()
            + bytes([ptype]) + chs_max()
            + struct.pack("<II", start, count))


def cmd_partition(args):
    with open_disk(args.disk, write=False) as f:
        f.seek(0)
        old = f.read(BLOCK)
    total = args.sectors

    if not args.yes:
        raise SystemExit(
            f"refusing to write a partition table to disk {args.disk} without "
            "--yes.\nThis REPLACES the partition table; run `inspect` first.")

    # Bootstrap area left as zeros: nothing BIOS-boots this card, and a
    # nonzero one would be code nobody wrote.
    mbr = bytearray(BLOCK)
    mbr[446:462] = mbr_entry(False, 0xDA, KERNEL_PART_LBA, KERNEL_PART_SECTORS)
    mbr[462:478] = mbr_entry(False, 0x83, ROOTFS_PART_LBA,
                             total - ROOTFS_PART_LBA)
    mbr[510:512] = b"\x55\xaa"

    with open_disk(args.disk, write=True) as f:
        f.seek(0)
        f.write(bytes(mbr))
        f.flush()
        f.seek(0)
        back = f.read(BLOCK)
    if back != bytes(mbr):
        raise SystemExit("READ-BACK MISMATCH writing the MBR — do not trust "
                         "this card.")

    print(f"disk {args.disk}: partition table written and verified")
    print(f"  p1 type 0xDA  LBA {KERNEL_PART_LBA} .. "
          f"{KERNEL_PART_LBA + KERNEL_PART_SECTORS - 1}  (raw kernel, 8 MiB)")
    print(f"  p2 type 0x83  LBA {ROOTFS_PART_LBA} .. {total - 1}  "
          f"({(total - ROOTFS_PART_LBA) * BLOCK / 1e9:.2f} GB, filesystem)")
    if old[510:512] == b"\x55\xaa":
        print("  (replaced an existing table)")


def cmd_writefs(args):
    """Write a filesystem image into p2."""
    img = Path(args.image).read_bytes()
    if len(img) % BLOCK:
        raise SystemExit(f"{args.image} is not a multiple of {BLOCK} bytes")
    if not args.yes:
        raise SystemExit("refusing to write without --yes")

    with open_disk(args.disk, write=True) as f:
        f.seek(ROOTFS_PART_LBA * BLOCK)
        f.write(img)
        f.flush()
        f.seek(ROOTFS_PART_LBA * BLOCK)
        back = f.read(len(img))
    if back != img:
        raise SystemExit("READ-BACK MISMATCH writing the filesystem.")
    print(f"wrote and verified {len(img)//BLOCK} blocks at LBA "
          f"{ROOTFS_PART_LBA} (p2) on disk {args.disk}")


def cmd_fake(args):
    """A deterministic stand-in kernel, so CI can exercise the transport.

    Not random: the same bytes every run means a checksum mismatch in the
    firmware is a transport bug and never a fixture that moved. Not constant
    either — a block of zeros or a counter would pass a checksum that a
    byte-swapped or block-shifted read could also pass by accident.
    """
    data = bytearray()
    x = 0x12345678
    for _ in range(args.blocks * BLOCK):
        x = (x * 1103515245 + 12345) & 0xFFFFFFFF
        data.append((x >> 16) & 0xFF)
    Path(args.out).write_bytes(bytes(data))
    print(f"{args.out}: {len(data)} bytes ({args.blocks} blocks)")


def open_disk(n, write):
    if sys.platform != "win32":
        path = f"/dev/sd{chr(ord('a') + n)}"
    else:
        path = rf"\\.\PhysicalDrive{n}"
    try:
        return open(path, "r+b" if write else "rb", buffering=0)
    except PermissionError:
        raise SystemExit(
            f"permission denied opening {path}.\n"
            "Raw block access needs an ELEVATED shell on Windows — run this "
            "from an Administrator terminal. (The mounted FAT32 volume is "
            "readable without elevation, but the kernel does not live in a "
            "file.)")
    except OSError as e:
        raise SystemExit(f"cannot open {path}: {e}")


def cmd_inspect(args):
    with open_disk(args.disk, write=False) as f:
        f.seek(0)
        mbr = f.read(BLOCK)
        # Kept out of the f-string: a backslash escape inside an f-string
        # expression is a SyntaxError before Python 3.12.
        sig_ok = mbr[510:512] == b"\x55\xaa"
        print(f"MBR signature: {mbr[510]:02x} {mbr[511]:02x}"
              f"{'  (valid)' if sig_ok else '  (none)'}")
        for i in range(4):
            e = mbr[446 + i * 16: 446 + (i + 1) * 16]
            if e[4] == 0:
                continue
            start, count = struct.unpack("<II", e[8:16])
            print(f"  partition {i + 1}: type 0x{e[4]:02x} "
                  f"start LBA {start}, {count} sectors "
                  f"({count * BLOCK / 1e9:.2f} GB)")
        f.seek(HDR_LBA * BLOCK)
        hdr = f.read(BLOCK)
        magic, ver, blocks, load, total = struct.unpack("<5I", hdr[:20])
        if magic == MAGIC:
            print(f"koti boot header at LBA {HDR_LBA}: version {ver}, "
                  f"{blocks} blocks, load 0x{load:08x}, sum 0x{total:08x}")
        else:
            print(f"no koti boot header at LBA {HDR_LBA} "
                  f"(magic 0x{magic:08x}) — this is not a boot card yet")


def cmd_write(args):
    kernel = Path(args.kernel).read_bytes()
    hdr, data = build_payload(kernel)
    blocks = len(data) // BLOCK

    if not args.yes:
        raise SystemExit(
            f"refusing to write {blocks + 1} blocks at LBA {HDR_LBA} of "
            f"disk {args.disk} without --yes.\n"
            "This OVERWRITES whatever is there, including the start of any "
            "filesystem. Run `inspect` first.")

    with open_disk(args.disk, write=True) as f:
        f.seek(HDR_LBA * BLOCK)
        f.write(hdr)
        f.write(data)
        f.flush()

        # Read it back through a fresh seek rather than trusting the write:
        # a card that silently drops writes is a real failure mode, and it is
        # the one that would otherwise show up as a checksum error on the board
        # with no way to tell which end was wrong.
        f.seek(HDR_LBA * BLOCK)
        back = f.read(BLOCK + len(data))

    if back != hdr + data:
        first = next(i for i in range(len(back)) if back[i] != (hdr + data)[i])
        raise SystemExit(
            f"READ-BACK MISMATCH at byte {first} (LBA "
            f"{HDR_LBA + first // BLOCK}). The card did not store what was "
            "written — do not trust it.")

    print(f"wrote and verified {blocks + 1} blocks at LBA {HDR_LBA} "
          f"on disk {args.disk}")
    print(f"  kernel {len(kernel)} bytes, sum "
          f"0x{struct.unpack('<5I', hdr[:20])[4]:08x}")


def main():
    p = argparse.ArgumentParser(
        description="Put a kernel image where sw/sbi/sdboot.c looks for it.")
    sub = p.add_subparsers(dest="cmd", required=True)

    b = sub.add_parser("build", help="make the on-card bytes as a file")
    b.add_argument("kernel")
    b.add_argument("--img")
    b.add_argument("--hex")
    b.set_defaults(func=cmd_build)

    w = sub.add_parser("write", help="write to a real card (NEEDS ADMIN)")
    w.add_argument("kernel")
    w.add_argument("--disk", type=int, required=True)
    w.add_argument("--yes", action="store_true")
    w.set_defaults(func=cmd_write)

    pt = sub.add_parser("partition", help="write the MBR (NEEDS ADMIN)")
    pt.add_argument("--disk", type=int, required=True)
    pt.add_argument("--sectors", type=int, required=True,
                    help="total sectors on the card; must match koti,sectors "
                         "in koti.dts")
    pt.add_argument("--yes", action="store_true")
    pt.set_defaults(func=cmd_partition)

    wf = sub.add_parser("writefs", help="write a filesystem into p2 (NEEDS ADMIN)")
    wf.add_argument("image")
    wf.add_argument("--disk", type=int, required=True)
    wf.add_argument("--yes", action="store_true")
    wf.set_defaults(func=cmd_writefs)

    fk = sub.add_parser("fake", help="generate a deterministic test kernel")
    fk.add_argument("--blocks", type=int, default=8)
    fk.add_argument("--out", required=True)
    fk.set_defaults(func=cmd_fake)

    i = sub.add_parser("inspect", help="show a card's partitions and header")
    i.add_argument("--disk", type=int, required=True)
    i.set_defaults(func=cmd_inspect)

    args = p.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
