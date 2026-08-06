#!/usr/bin/env python3
"""Assert that the COMMITTED initramfs is the one koti is about to boot.

    python3 sw/linux/check_initramfs.py sw/linux/rootfs.cpio
    python3 sw/linux/check_initramfs.py sw/linux/rootfs.cpio --write-provenance

sw/linux/check_rootfs.py checks the rootfs at the moment Buildroot builds it,
inside the `userspace` workflow, against Buildroot's .config and the files in
output/target. This checks the artifact that actually ships — the cpio committed
in this repo, which `linux` embeds in the Image and koti unpacks — and it runs in
the workflow that consumes it. Those are different claims about different bytes,
and only the second one is what boots.

WHY A SEPARATE CHECK AT ALL. rootfs.cpio is a build product committed to the
repo, like sw/linux/koti.dtb and sw/sbi/sbi_test.bin, because the tool that
makes it (Buildroot, ~40 minutes and a whole toolchain from source) cannot sit
in front of every push. Every committed build product has the same failure mode:
the source moves and the product does not, and nothing says a word. koti.dtb is
guarded by rebuilding it in the `dtb` job and diffing. A cpio cannot be rebuilt
cheaply, so freshness is established the other two ways available:

  THE OVERLAY IS COMPARED BYTE FOR BYTE. Everything under sw/linux/rootfs-overlay
  is copied verbatim into the rootfs, so the copy inside the cpio must equal the
  file in the working tree. This is the dtb check's exact shape, and it covers
  the file that matters most: /etc/init.d/S99koti carries the marker the boot
  bench waits for. Edit the overlay, forget to rebuild, and without this every
  boot would report INCOMPLETE with nothing to trace it to.

  THE FRAGMENT IS COMPARED BY HASH. buildroot_koti.fragment decides which
  packages exist at all, and its effect cannot be re-derived from the cpio
  without running Buildroot. So the `userspace` workflow records its hash beside
  the cpio it produced, and this asserts the recorded hash still matches. That
  turns "somebody changed the userspace config six commits ago and never
  rebuilt" from invisible into a failing job.

⚠️ THE MARKER CHECK IS THE ONE WITH TEETH, and it is deliberately not a hash.
test/tb_boot.v waits for one exact string, and the ONLY thing that can print it
is a shell script running in user mode on this machine. If that string is not in
this file, no boot can ever pass, and the symptom is a timeout rather than an
error — which reads as a broken CPU. So the string is extracted from tb_boot.v
itself and looked for in the cpio's own bytes. A correct symbol with a wrong path
proves nothing; this reads the artifact.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import argparse
import hashlib
import json
import re
import stat
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent

sys.path.insert(0, str(HERE))
from check_rootfs import (  # noqa: E402  (path set above)
    EM_RISCV, MAX_CPIO_BYTES, describe_flags,
)

OVERLAY = HERE / "rootfs-overlay"
FRAGMENT = HERE / "buildroot_koti.fragment"
PROVENANCE = HERE / "rootfs.provenance"
TB_BOOT = ROOT / "test" / "tb_boot.v"

# Members without which the boot cannot work: name -> (what it is for, must it
# be executable). The flag is not decoration — /etc/inittab is data that busybox
# init READS and is mode 644 in every correct rootfs, while /etc/init.d/S99koti
# is a script busybox init RUNS and is silently skipped if its mode bits are
# wrong. Requiring the wrong thing of either one is a checker that fails on
# healthy input, which is how checks get deleted.
#
# /dev/console earns its place: the kernel opens it as fd 0/1/2 for the init
# process, and if the node is missing init runs with NO file descriptors and
# every line it prints goes nowhere. The machine looks hung. That is the same
# silent-timeout failure the marker check exists for, arriving by another road.
REQUIRED_MEMBERS = {
    "init":               ("Buildroot's /init — what the kernel execve's", True),
    "sbin/init":          ("busybox init, which /init hands over to", False),
    "bin/busybox":        ("every program in this userspace, in one binary", True),
    "etc/inittab":        ("what busybox init runs, including the getty", False),
    "etc/init.d/S99koti": ("prints the marker test/tb_boot.v waits for", True),
    "dev/console":        ("init's stdin/stdout/stderr; without it init is mute",
                           False),
}


class Member:
    __slots__ = ("name", "mode", "data")

    def __init__(self, name, mode, data):
        self.name, self.mode, self.data = name, mode, data

    @property
    def kind(self):
        return stat.S_IFMT(self.mode)


def read_cpio(path):
    """Parse a newc/SVR4 cpio into Members, or die saying where it went wrong.

    Written out rather than shelled out to `cpio` on purpose: this has to run on
    the development host as well as in CI, and Windows has no cpio. A truncated
    or corrupt archive is itself a finding — the kernel would unpack what it
    could and run whatever survived — so every structural assumption below
    raises instead of being tolerated.
    """
    data = Path(path).read_bytes()
    members, off = [], 0
    while True:
        if off + 110 > len(data):
            sys.exit(f"{path}: ran off the end at {off} with no TRAILER — "
                     f"the archive is truncated.")
        magic = data[off:off + 6]
        if magic not in (b"070701", b"070702"):
            sys.exit(f"{path}: bad cpio magic {magic!r} at offset {off}. "
                     f"Expected newc (070701). Is this really a cpio?")
        try:
            fields = [int(data[off + 6 + i * 8: off + 14 + i * 8], 16)
                      for i in range(13)]
        except ValueError:
            sys.exit(f"{path}: unreadable cpio header at offset {off}")
        mode, fsize, nsize = fields[1], fields[6], fields[11]
        name = data[off + 110: off + 110 + nsize - 1].decode("utf-8", "replace")
        body = off + 110 + nsize
        body += (-body) % 4
        if name == "TRAILER!!!":
            break
        if body + fsize > len(data):
            sys.exit(f"{path}: member {name!r} claims {fsize} bytes but the "
                     f"archive ends first — truncated.")
        members.append(Member(name, mode, data[body:body + fsize]))
        off = body + fsize
        off += (-off) % 4
    return members, data


def elf_facts_bytes(blob):
    """(ei_class, e_machine, e_flags), or None if this is not an ELF."""
    if len(blob) < 52 or blob[:4] != b"\x7fELF":
        return None
    ei_class = blob[4]
    e_machine = struct.unpack_from("<H", blob, 18)[0]
    e_flags = struct.unpack_from("<I", blob, 0x24 if ei_class == 1 else 0x30)[0]
    return ei_class, e_machine, e_flags


def marker_from_tb():
    """The exact string the boot bench waits for, read out of the bench."""
    if not TB_BOOT.exists():
        sys.exit(f"{TB_BOOT}: missing — cannot learn what the bench waits for")
    m = re.search(r'localparam\s+\[8\*MARKLEN-1:0\]\s+MARKER\s*=\s*"([^"]*)"',
                  TB_BOOT.read_text(encoding="utf-8", errors="replace"))
    if not m:
        sys.exit(f"{TB_BOOT}: could not find the MARKER localparam. If the "
                 f"bench changed shape, change this regex with it — a marker "
                 f"check that cannot find the marker would pass everything.")
    return m.group(1)


def overlay_files():
    if not OVERLAY.is_dir():
        sys.exit(f"{OVERLAY}: missing — the marker lives here")
    return sorted(p for p in OVERLAY.rglob("*") if p.is_file())


def sha(b):
    return hashlib.sha256(b).hexdigest()


def write_provenance(cpio_path, blob):
    rec = {
        "cpio_sha256": sha(blob),
        "cpio_bytes": len(blob),
        "fragment_sha256": sha(FRAGMENT.read_bytes()),
        "overlay_sha256": {
            str(p.relative_to(OVERLAY)).replace("\\", "/"): sha(p.read_bytes())
            for p in overlay_files()
        },
    }
    PROVENANCE.write_text(json.dumps(rec, indent=2, sort_keys=True) + "\n",
                          encoding="utf-8")
    print(f"wrote {PROVENANCE.relative_to(ROOT)}")
    for k, v in rec.items():
        print(f"  {k}: {v if not isinstance(v, dict) else ''}")
        if isinstance(v, dict):
            for kk, vv in v.items():
                print(f"      {kk}  {vv[:16]}...")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cpio", nargs="?", default=str(HERE / "rootfs.cpio"))
    ap.add_argument("--write-provenance", action="store_true",
                    help="record the hashes beside the cpio (use after a rebuild)")
    args = ap.parse_args()

    if not Path(args.cpio).exists():
        sys.exit(f"{args.cpio}: missing. Build it with the `userspace` workflow "
                 f"and commit the koti-rootfs artifact.")

    members, blob = read_cpio(args.cpio)
    if args.write_provenance:
        return write_provenance(args.cpio, blob)

    by_name = {m.name: m for m in members}
    bad = []

    print(f"{args.cpio}: {len(members)} members, {len(blob)} bytes "
          f"({len(blob) / 2**20:.3f} MiB)")

    # ---- 1. it fits in the machine -------------------------------------------
    ok = len(blob) <= MAX_CPIO_BYTES
    print(f"  {'ok  ' if ok else 'FAIL'} size {len(blob) / 2**20:.3f} MiB "
          f"<= {MAX_CPIO_BYTES / 2**20:.2f} MiB budget")
    if not ok:
        bad.append(f"the cpio is {len(blob) / 2**20:.2f} MiB, over the "
                   f"{MAX_CPIO_BYTES / 2**20:.2f} MiB budget. An initramfs "
                   f"costs its size TWICE at peak. The honest fixes are more "
                   f"RAM or microSD, not a bigger constant.")

    # ---- 2. the members the boot cannot do without ---------------------------
    for name, (why, must_exec) in sorted(REQUIRED_MEMBERS.items()):
        m = by_name.get(name)
        if m is None:
            print(f"  FAIL /{name} missing — {why}")
            bad.append(f"/{name} is not in the rootfs ({why})")
            continue
        note = ""
        if name == "dev/console" and m.kind != stat.S_IFCHR:
            bad.append("/dev/console is not a character device, so init would "
                       "run with no stdin/stdout/stderr and print nothing at "
                       "all")
            note = "  NOT A CHAR DEVICE"
        elif must_exec and m.kind == stat.S_IFREG and not (m.mode & 0o111):
            bad.append(f"/{name} is not executable, so it would be skipped in "
                       f"silence ({why})")
            note = "  NOT EXECUTABLE"
        print(f"  {'FAIL' if note else 'ok  '} /{name}{note}")

    # ---- 3. the marker, which is the only thing that can end a boot PASS -----
    marker = marker_from_tb()
    s99 = by_name.get("etc/init.d/S99koti")
    print(f"  ---- the bench waits for: {marker!r}")
    if s99 is not None:
        if marker.encode() in s99.data:
            print(f"  ok   /etc/init.d/S99koti prints it")
        else:
            print(f"  FAIL /etc/init.d/S99koti does NOT contain that string")
            bad.append(f"/etc/init.d/S99koti does not contain {marker!r}, the "
                       f"string test/tb_boot.v waits for. No boot could ever "
                       f"pass, and the symptom would be a timeout rather than "
                       f"an error.")

    # ---- 4. koti can actually execute what is in here ------------------------
    elves = [m for m in members
             if m.kind == stat.S_IFREG and elf_facts_bytes(m.data)]
    nbad = 0
    for m in elves:
        ei_class, e_machine, e_flags = elf_facts_bytes(m.data)
        why = []
        if ei_class != 1:
            why.append("not ELF32")
        if e_machine != EM_RISCV:
            why.append(f"machine {e_machine:#x}, not RISC-V")
        if e_flags != 0:
            why.append(f"e_flags {e_flags:#x}: {describe_flags(e_flags)}")
        if why:
            nbad += 1
            print(f"  FAIL /{m.name}: {'; '.join(why)}")
            bad.append(f"/{m.name}: {'; '.join(why)}")
    print(f"  {'FAIL' if nbad else 'ok  '} {len(elves)} ELF members, "
          f"{nbad} koti cannot execute")

    # ---- 4b. nothing may block the boot waiting for absent hardware ----------
    # /etc/network/interfaces is generated from BR2_SYSTEM_DHCP, and the base
    # defconfig (qemu_riscv32_virt) sets it to eth0 because QEMU has a virtio
    # NIC. koti has no network interface at all. Buildroot pairs that stanza
    # with /etc/network/if-pre-up.d/wait_iface, which loops `sleep 1` for
    # `wait-delay` seconds when the interface is missing — 15 seconds, which at
    # koti's 25 MHz timebase is 375 MILLION clocks, spent by S40network before
    # S99koti ever runs and against a full-boot budget of 250M.
    #
    # It is checked here, on the generated file, rather than on the Buildroot
    # symbol: the symbol is one way to produce this stanza and not the only one,
    # and it is the FILE that stalls the boot. Same reason the marker is looked
    # for in the cpio instead of in the fragment.
    #
    # ⚠️ The failure this prevents is a nasty one to debug, because the wait
    # PRINTS. "Waiting for interface eth0 to appear...." reads like progress,
    # the quiet-window heuristic never trips, and the run just ends INCOMPLETE
    # having done everything right.
    ifaces = by_name.get("etc/network/interfaces")
    if ifaces is not None:
        configured = re.findall(r"^\s*iface\s+(\S+)",
                                ifaces.data.decode("utf-8", "replace"),
                                re.MULTILINE)
        extra = [i for i in configured if i != "lo"]
        if extra:
            print(f"  FAIL /etc/network/interfaces configures {extra}")
            bad.append(
                f"/etc/network/interfaces configures {', '.join(extra)}, but "
                f"koti has no network interface. if-pre-up.d/wait_iface will "
                f"`sleep 1` once per second of `wait-delay` waiting for a "
                f"device that cannot appear - 15 s is 375M clocks at 25 MHz, "
                f"more than a whole full-boot budget, and it prints while it "
                f"does it so nothing looks wrong. Set BR2_SYSTEM_DHCP=\"\" in "
                f"sw/linux/buildroot_koti.fragment and rebuild the rootfs.")
        else:
            print(f"  ok   /etc/network/interfaces configures only lo")

    # ---- 5. freshness: the overlay, byte for byte ----------------------------
    for p in overlay_files():
        rel = str(p.relative_to(OVERLAY)).replace("\\", "/")
        m = by_name.get(rel)
        if m is None:
            print(f"  FAIL overlay {rel} never reached the rootfs")
            bad.append(f"sw/linux/rootfs-overlay/{rel} is not in the cpio — "
                       f"did BR2_ROOTFS_OVERLAY apply?")
        elif m.data != p.read_bytes():
            print(f"  FAIL overlay {rel} differs from the copy in the cpio")
            bad.append(f"sw/linux/rootfs-overlay/{rel} has changed since "
                       f"rootfs.cpio was built. Re-run the `userspace` "
                       f"workflow and commit the new cpio.")
        else:
            print(f"  ok   overlay {rel} matches the cpio byte for byte")

    # ---- 6. freshness: the fragment, by recorded hash ------------------------
    if not PROVENANCE.exists():
        print(f"  FAIL {PROVENANCE.name} missing")
        bad.append(f"sw/linux/{PROVENANCE.name} is missing. It records which "
                   f"sources built this cpio; without it the fragment could "
                   f"drift with nothing to notice.")
    else:
        rec = json.loads(PROVENANCE.read_text(encoding="utf-8"))
        pairs = [("cpio_sha256", sha(blob), "rootfs.cpio itself"),
                 ("fragment_sha256", sha(FRAGMENT.read_bytes()),
                  "sw/linux/buildroot_koti.fragment")]
        for key, actual, what in pairs:
            want = rec.get(key)
            if want != actual:
                print(f"  FAIL {key}: recorded {str(want)[:16]}..., "
                      f"actual {actual[:16]}...")
                bad.append(f"{what} does not match what "
                           f"sw/linux/{PROVENANCE.name} recorded. Re-run the "
                           f"`userspace` workflow, commit the new cpio, and "
                           f"regenerate the record with "
                           f"`--write-provenance`.")
            else:
                print(f"  ok   {key} matches ({what})")

    if bad:
        print(f"\nFAIL: {len(bad)} problem(s) with the committed initramfs\n")
        for b in bad:
            print(f"  - {b}")
        return 1
    print("\nthe committed initramfs is one koti can boot")
    return 0


if __name__ == "__main__":
    sys.exit(main())
