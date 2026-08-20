#!/usr/bin/env python3
"""check_image_initramfs.py — is the fix actually INSIDE the kernel that ships?

    python3 sw/linux/check_image_initramfs.py <Image> [--overlay DIR]

WHY THIS EXISTS, AND WHY IT IS NOT check_initramfs.py.

check_initramfs.py compares sw/linux/rootfs-overlay against the committed
sw/linux/rootfs.cpio. That is a check on an INPUT. Nothing checked the OUTPUT:
the kernel Image is what goes on the microSD, the initramfs is linked into it
by kbuild from CONFIG_INITRAMFS_SOURCE, and between those two facts sat an
unguarded step that no suite could reach.

⭐ AND THE STEP IS NOT HYPOTHETICAL. linux.yaml can be dispatched with
`initramfs: init`, which embeds the ~20-instruction stand-in instead; a
misdirected CONFIG_INITRAMFS_SOURCE builds a kernel with an EMPTY initramfs and
says nothing; and both produce an Image that passes every other gate in the
workflow — header magic, size, System.map — because none of them looks inside.
The failure lands on the bench, as "the fix you spent a day on is not on the
machine", one microSD round trip later.

⛔ THE COST OF THE GAP IS PAID IN THE ONE CURRENCY THIS PROJECT CANNOT MINT:
the user's physical acts. A card write is a person carrying a microSD to a PC
reader and back. This check costs a second and removes a whole class of reasons
to do that twice.

HOW. CONFIG_INITRAMFS_COMPRESSION_GZIP=y, so the cpio is a gzip member sitting
in the flat Image. Scan for gzip magic, try to inflate each candidate, and keep
the one whose output starts with the newc magic `070701`. Trying to decompress
is the discriminator rather than the magic alone: three bytes match by accident
in six megabytes of kernel, and a stream that inflates to a cpio does not.

⚠️ It compares the overlay BYTE FOR BYTE, like check_initramfs.py, rather than
looking for a marker string. A check that greps for `extract_page` passes on a
file that also carries yesterday's bug, and the whole point here is to know
which build is on the card.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import argparse
import hashlib
import sys
import zlib
from pathlib import Path

HERE = Path(__file__).resolve().parent
CPIO_MAGIC = b"070701"
GZIP_MAGIC = b"\x1f\x8b\x08"


def find_initramfs(blob):
    """Return the inflated cpio embedded in a flat kernel Image."""
    at = blob.find(GZIP_MAGIC)
    while at != -1:
        d = zlib.decompressobj(16 + zlib.MAX_WBITS)
        try:
            out = d.decompress(blob[at:])
        except zlib.error:
            out = b""
        if out.startswith(CPIO_MAGIC):
            return out, at
        at = blob.find(GZIP_MAGIC, at + 1)
    return None, -1


def walk_cpio(blob):
    """{name: bytes} for a newc archive. The format is 110 hex bytes then the
    name then the data, each padded to 4."""
    out, off = {}, 0
    while off + 110 <= len(blob):
        if blob[off:off + 6] != CPIO_MAGIC:
            break
        hdr = blob[off:off + 110]

        def field(i):
            return int(hdr[6 + i * 8:6 + (i + 1) * 8], 16)

        size, namesize = field(6), field(11)
        name = blob[off + 110:off + 110 + namesize - 1].decode("utf-8", "replace")
        start = (off + 110 + namesize + 3) & ~3
        if name == "TRAILER!!!":
            break
        out[name] = blob[start:start + size]
        off = (start + size + 3) & ~3
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("image")
    ap.add_argument("--overlay", default=str(HERE / "rootfs-overlay"))
    args = ap.parse_args()

    blob = Path(args.image).read_bytes()
    cpio, at = find_initramfs(blob)
    if cpio is None:
        print("FAIL: no gzipped cpio anywhere in the Image.")
        print("      The kernel was built with an empty or non-gzip initramfs,")
        print("      so the machine that boots it has no userspace of ours.")
        return 1
    files = walk_cpio(cpio)
    print(f"initramfs at 0x{at:x}: {len(cpio)} bytes, {len(files)} entries")

    overlay = Path(args.overlay)
    want = sorted(p for p in overlay.rglob("*") if p.is_file())
    if not want:
        print(f"FAIL: no overlay files under {overlay}")
        return 1

    bad = []
    for p in want:
        rel = p.relative_to(overlay).as_posix()
        # The overlay is checked out on Windows in the development tree, where
        # git may have handed back CRLF. The cpio holds what the build used, so
        # compare against the bytes git tracks, not the working copy's line
        # endings — otherwise this reports a difference nobody made.
        mine = p.read_bytes().replace(b"\r\n", b"\n")
        theirs = files.get(rel)
        if theirs is None:
            print(f"  FAIL {rel} is not in the Image's initramfs at all")
            bad.append(rel)
        elif hashlib.sha256(theirs).digest() != hashlib.sha256(mine).digest():
            print(f"  FAIL {rel} in the Image differs from the overlay")
            print(f"       image  {hashlib.sha256(theirs).hexdigest()[:16]}"
                  f"  {len(theirs)} bytes")
            print(f"       overlay{hashlib.sha256(mine).hexdigest()[:16]}"
                  f"  {len(mine)} bytes")
            bad.append(rel)
        else:
            print(f"  ok   {rel} matches the overlay byte for byte")

    if bad:
        print(f"FAIL: {len(bad)} overlay file(s) are not what this Image carries.")
        print("      Rebuild the rootfs (`userspace`), commit the new cpio, and")
        print("      rebuild the kernel. Do NOT write this Image to the card:")
        print("      it does not contain the change you are trying to deploy.")
        return 1
    print(f"PASS: all {len(want)} overlay files are in the Image, byte for byte.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
