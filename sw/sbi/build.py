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
CRLF = bytes((13, 10))
LF = bytes((10,))


# Every SBI image and everything it is built from, lifted out of main() so that
# ../check_firmware.py can hash exactly these files.
#
# ⛔ koti.dtb IS IN THIS LIST AND IT IS THE WHOLE REASON THE LIST EXISTS.
# dtb.S embeds the device tree at flash 0x6000 and sbi.c hands it to the
# kernel, so THE MACHINE DESCRIPTION LINUX SEES LIVES IN THIS FIRMWARE, inside
# the bitstream — not in anything the kernel build produces. On 2026-08-11 the
# `serial@70000` node had been in koti.dts for a day and in koti.dtb, and in
# none of these three .bin files, because nobody had rebuilt them. koti_esp
# would have found no node, never probed, and left /dev/ttyKOTI0 absent — with
# every badge green and the symptom appearing only on the bench, as a missing
# device file.
SBI_SHARED = ("sbi.S", "sbi.c", "payload.c", "../console.c", "dtb.S",
              "link.ld", "sdboot.h", "../koti.h", "../console.h",
              "../linux/koti.dtb")

SBI_IMAGES = (
    ("sbi_test", [],                                []),
    ("sbi_sd",   ["-DKOTI_ULX3S"],                  ["sdboot.c", "../usbkbd.c"]),
    ("sbi_prof", ["-DKOTI_ULX3S", "-DKOTI_PROFILE"], ["sdboot.c", "../usbkbd.c"]),
)



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

    # TWO binaries, because the two machines genuinely differ. On the
    # ASIC-shaped one the microSD window does not exist at all — koti_core.sv's
    # `pa_dev` stops at 0x04 without KOTI_FPGA — so touching 0x0005_0000 there
    # faults on a write and never acks on a read. That cannot be probed at
    # runtime, because probing means touching it. So:
    #
    #   sbi_test.bin  no SD. test/run.py's ASIC bench, and nothing else.
    #   sbi_sd.bin    -DKOTI_ULX3S. tb_boot, and the `image: sbi` bitstream —
    #                 i.e. everything that is the ULX3S machine.
    #
    # Same sources, same link script; only the one call differs.
    # sdboot.c and usbkbd.c are not merely #ifdef'd out of the no-peripheral
    # build, they are NOT LINKED.
    # Leaving it in as dead code would still move every symbol after it and
    # change the image, and the point of the no-SD binary is that the ASIC bench
    # runs against exactly the firmware it ran against before the microSD
    # existed — provable by comparing bytes, not by reading the source.
    # sbi_prof is sbi_sd plus the M-mode sampling profiler (see sbi.c). It is a
    # SEPARATE binary rather than a flag on sbi_sd because the firmware image is
    # committed and baked into bitstreams by $readmemh: a profiler quietly added
    # to sbi_sd.bin would ship in the machine that boots normally, printing a
    # line a second into the console for ever.
    for name, extra, srcs in SBI_IMAGES:
        run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
             "-ffreestanding", "-nostdlib", "-nostartfiles", "-static",
             *extra,
             "-I", "..", "-T", "link.ld", "-o", f"{name}.elf",
             "sbi.S", "sbi.c", "payload.c", "../console.c",
             *srcs, "dtb.S"])
        run([OBJCOPY, "-O", "binary", f"{name}.elf", f"{name}.bin"])
        size = (SBI / f"{name}.bin").stat().st_size
        print(f"{name}.bin: {size} bytes")

    # The blob has to land exactly where sbi.c reads it. objcopy pads the gap
    # between .payload and .dtb with zeros, so an off-by-one here is invisible
    # in the file size and fatal at boot: the firmware would fail its magic
    # test and hand a kernel a1 = 0.
    # Checked on BOTH binaries. -DKOTI_ULX3S moves code around, and the one that
    # boots the board is sbi_sd.bin — checking only the other would be checking
    # the image that never meets a kernel.
    for name in ("sbi_test", "sbi_sd", "sbi_prof"):
        img = (SBI / f"{name}.bin").read_bytes()
        got = img[0x6000:0x6004]
        if got != b"\xd0\x0d\xfe\xed":
            raise SystemExit(f"{name}.bin: no FDT magic at flash 0x6000, found {got!r}")
        print(f"  {name}.bin .dtb at 0x6000: {dtb.stat().st_size} bytes, magic ok")

    write_provenance()


def write_provenance():
    """Record what built these three .bin files. See ../check_firmware.py."""
    import hashlib
    import json

    prov = SBI / "firmware.provenance"

    def sha_bin(q):
        return hashlib.sha256(q.read_bytes()).hexdigest()

    def sha_src(q):
        # Line endings normalised — the firmware sources are mixed CRLF/LF
        # in this repo and the compiler does not care either. Same rule as
        # sw/build.py's sha_source(); koti.dtb is binary and goes through
        # sha_bin instead, because normalising a binary would corrupt the
        # comparison it exists to make.
        raw = q.read_bytes()
        return hashlib.sha256(raw.replace(CRLF, LF)).hexdigest()

    rec = {}
    for name, _extra, srcs in SBI_IMAGES:
        binp = SBI / f"{name}.bin"
        if not binp.exists():
            continue
        files = {}
        for rel in sorted(set(srcs) | set(SBI_SHARED)):
            q = SBI / rel
            if not q.exists():
                continue
            files[rel] = sha_bin(q) if rel.endswith(".dtb") else sha_src(q)
        rec[name] = {"bin_sha256": sha_bin(binp),
                     "bin_bytes": binp.stat().st_size,
                     "sources": files}
    prov.write_text(json.dumps(rec, indent=2, sort_keys=True) + LF.decode(),
                    encoding="utf-8")
    print(f"wrote sbi/firmware.provenance for {len(rec)} images")


if __name__ == "__main__":
    main()
