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
PROVENANCE = SW / "firmware.provenance"

# Every image, and everything it is built from. This table is the single place
# that knows it, because check_firmware.py hashes exactly these files to decide
# whether a committed .bin still corresponds to its sources — and a second,
# hand-kept copy of the list would be one more thing to forget.
#
# ⚠️ SHARED_SRCS is deliberately over-inclusive: link.ld and koti.h affect every
# image, console.h only some. Hashing all three against all images can ask for a
# rebuild that was not strictly needed; the opposite error ships firmware that
# does not match its source, which is what happened on 2026-08-11.
SHARED_SRCS = ("link.ld", "koti.h", "console.h")


def sha_source(path):
    """sha256 of a text source, with line endings normalised first.

    🪤 NOT the raw bytes, and this repo has already paid for that lesson once.
    sw/linux/rootfs.provenance hashes raw bytes, and on 2026-08-09 it reported
    "the committed initramfs is stale" twice in one day when nothing was stale:
    the files were CRLF in a Windows working tree and LF in CI. .gitattributes
    now pins those paths to eol=lf to fix it.

    That fix cannot simply be copied here, because the firmware sources are
    ALREADY mixed — measured 2026-08-11: sw/esptest.c is CRLF in the working
    tree while sw/koti.h is LF, in the same directory. Pinning would rewrite
    files and still leave every existing checkout disagreeing until it was
    renormalised. Normalising inside the hash makes the answer independent of
    core.autocrlf, of .gitattributes and of which machine ran it — and it loses
    nothing, because the compiler does not care about line endings either.

    ⚠️ Sources only. A .bin is hashed raw; normalising a binary would corrupt
    the very comparison it exists to make.
    """
    import hashlib
    return hashlib.sha256(
        path.read_bytes().replace(b"\r\n", b"\n")).hexdigest()

IMAGES = (
    ("hello",   ["crt0.S", "console.c", "hello.c"]),
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
    ("usbtest", ["crt0.S", "usbtest.c"]),
    # esptest.bin: the ESP32 link, and the experiment that
    # gates PLAN item 11. It is the ONLY image in this repo
    # that raises ESP_EN — every other build leaves
    # esp_uart.sv's control register at its reset value,
    # which holds the chip in reset. It has to be an image
    # rather than a note in a README because the question is
    # whether an awake ESP32 breaks the microSD it shares six
    # GPIOs with, and that needs the card read before, during
    # and after, which is not something to do by hand.
    ("esptest", ["crt0.S", "esptest.c"]),
)



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
    # memtest.bin is the third: a full walk of the 32 MB RAM window with an
    # ADDRESS-DERIVED pattern, which is what catches aliasing. bringup.bin proves
    # the SDRAM's read timing; only this proves its address decode.
    for name, srcs in IMAGES:
        run([GCC, "-march=rv32ima_zicsr", "-mabi=ilp32", "-O2",
             "-nostdlib", "-nostartfiles", "-static",
             "-T", "link.ld", "-o", f"{name}.elf", *srcs])
        run([OBJCOPY, "-O", "binary", f"{name}.elf", f"{name}.bin"])
        size = (SW / f"{name}.bin").stat().st_size
        print(f"{name}.bin: {size} bytes")

    write_provenance()


def write_provenance():
    """Record which sources built the .bin files sitting on disk right now.

    Written by every build, not by a separate opt-in step: a record that has to
    be remembered is a record that drifts, and the whole point of it is to catch
    drift.
    """
    import hashlib
    import json

    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()

    rec = {}
    for name, srcs in IMAGES:
        binp = SW / f"{name}.bin"
        if not binp.exists():
            continue
        rec[name] = {
            "bin_sha256": sha(binp),
            "bin_bytes": binp.stat().st_size,
            "sources": {s: sha_source(SW / s)
                        for s in sorted(set(srcs) | set(SHARED_SRCS))
                        if (SW / s).exists()},
        }
    PROVENANCE.write_text(json.dumps(rec, indent=2, sort_keys=True) + "\n",
                          encoding="utf-8")
    print(f"wrote {PROVENANCE.name} for {len(rec)} images")


if __name__ == "__main__":
    main()
