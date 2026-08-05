#!/usr/bin/env python3
"""Assert that a built userspace is one koti can actually execute.

    python3 sw/linux/check_rootfs.py <buildroot/.config> <elf> [<elf>...]

Two separate claims, and they are not the same claim.

THE CONFIG is what was asked for. Buildroot drops a symbol whose dependencies
are unmet exactly the way kconfig does — silently — so a fragment appended to a
defconfig is a request, not a result. This is the same trap sw/linux/
check_config.py exists for on the kernel side, where `config EFI` quietly
select-ed RISCV_ISA_C back on behind a defconfig that had asked for it off.

THE BINARIES are what will actually run, and they are the claim that matters.
A toolchain can be configured correctly and still emit something koti cannot
execute, and the failure mode is brutal: the kernel boots perfectly, mounts the
rootfs, execve's /init, and dies on an illegal instruction with the machine
looking healthy right up to that point.

WHY e_flags IS THE RIGHT THING TO READ. The RISC-V psABI puts the two
properties koti cares about straight into the ELF header:

    EF_RISCV_RVC              0x0001   compressed instructions present
    EF_RISCV_FLOAT_ABI_SINGLE 0x0002   floats passed in F registers
    EF_RISCV_FLOAT_ABI_DOUBLE 0x0004   floats passed in F/D registers

koti's core decodes none of those: no C in the decoder, no FPU at all. So the
whole requirement is `e_flags == 0` plus ELF32 plus EM_RISCV. That is one
number per file, it comes from the binary rather than from the build system
that produced it, and it cannot be satisfied by accident.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import re
import struct
import sys
from pathlib import Path

EM_RISCV = 0xF3
EF_RISCV_RVC = 0x0001
EF_RISCV_FLOAT_ABI_SINGLE = 0x0002
EF_RISCV_FLOAT_ABI_DOUBLE = 0x0004

# (symbol, expected). "n" means absent or "is not set" — kconfig writes one and
# drops the other, and they mean the same thing to the build.
REQUIRED = [
    ("BR2_riscv", "y"),
    ("BR2_RISCV_32", "y"),
    ("BR2_RISCV_USE_MMU", "y"),
    # Spelled out rather than taking "G" (= IMAFD), because koti has no FPU.
    # ⚠️ These are BR2_RISCV_ISA_RV*, not BR2_RISCV_ISA_CUSTOM_RV*. This list
    # carried the CUSTOM_ spelling on its first run and every entry was
    # vacuously satisfied: an absent symbol reads as "n", so asking for RVF=n
    # and RVD=n PASSED while the resolved config actually had both ON. The
    # asserts that mattered were the two `want y` ones, which failed and
    # exposed it. A checker whose symbol names are wrong is a checker that
    # cannot fail — this project's signature defect, met again here.
    ("BR2_RISCV_ISA_RVM", "y"),
    ("BR2_RISCV_ISA_RVA", "y"),
    ("BR2_RISCV_ISA_RVC", "n"),
    ("BR2_RISCV_ISA_RVF", "n"),
    ("BR2_RISCV_ISA_RVD", "n"),
    ("BR2_RISCV_ABI_ILP32", "y"),
    # koti brings its own kernel, its own SBI (sw/sbi) and no bootloader.
    ("BR2_LINUX_KERNEL", "n"),
    ("BR2_TARGET_OPENSBI", "n"),
    # The rootfs has to travel inside the Image: koti has no storage yet.
    ("BR2_TARGET_ROOTFS_CPIO", "y"),
]


def parse_config(path):
    """Return (values, seen).

    `seen` is every symbol the config MENTIONS, in either form. kconfig writes
    `# X is not set` for a symbol that is visible and off, and omits entirely
    one whose dependencies are unmet or which does not exist at all.

    That distinction is the whole point. Without it a `want n` assertion is
    satisfied by a symbol NAME THAT DOES NOT EXIST, so a typo turns into a
    silent pass — which is exactly what happened here: this list first asked
    for BR2_RISCV_ISA_CUSTOM_RVF=n and BR2_RISCV_ISA_CUSTOM_RVD=n, both were
    vacuously satisfied because neither symbol exists, and the real config had
    floating point ON. Only the two `want y` lines failed and gave it away.
    """
    values, seen = {}, set()
    set_re = re.compile(r"^(BR2_[A-Za-z0-9_]+)=(.*)$")
    unset_re = re.compile(r"^# (BR2_[A-Za-z0-9_]+) is not set$")
    for line in Path(path).read_text().splitlines():
        m = set_re.match(line)
        if m:
            values[m.group(1)] = m.group(2).strip('"')
            seen.add(m.group(1))
            continue
        m = unset_re.match(line)
        if m:
            seen.add(m.group(1))
    return values, seen


def elf_facts(path):
    """(is_elf, class_is_32, machine, flags) from the ELF header alone."""
    data = Path(path).read_bytes()[:64]
    if len(data) < 52 or data[:4] != b"\x7fELF":
        return None
    ei_class = data[4]                      # 1 = ELF32
    e_machine = struct.unpack_from("<H", data, 18)[0]
    # e_flags sits at 0x24 in ELF32 and 0x30 in ELF64.
    e_flags = struct.unpack_from("<I", data, 0x24 if ei_class == 1 else 0x30)[0]
    return ei_class, e_machine, e_flags


def describe_flags(flags):
    bits = []
    if flags & EF_RISCV_RVC:
        bits.append("RVC (compressed instructions - koti cannot decode these)")
    if flags & EF_RISCV_FLOAT_ABI_SINGLE:
        bits.append("float ABI single (koti has no FPU)")
    if flags & EF_RISCV_FLOAT_ABI_DOUBLE:
        bits.append("float ABI double (koti has no FPU)")
    left = flags & ~(EF_RISCV_RVC | EF_RISCV_FLOAT_ABI_SINGLE
                     | EF_RISCV_FLOAT_ABI_DOUBLE)
    if left:
        bits.append(f"unrecognised bits {left:#x}")
    return ", ".join(bits) if bits else "none"


def main():
    args = sys.argv[1:]
    # --config-only exists so the config can be checked BEFORE the forty-minute
    # build rather than after it. Every symbol in REQUIRED produces a rootfs
    # koti cannot run, and learning that at the end costs the whole build.
    config_only = "--config-only" in args
    args = [a for a in args if a != "--config-only"]
    if len(args) < (1 if config_only else 2):
        print(__doc__)
        return 2
    if config_only and len(args) > 1:
        # Refused rather than ignored. Silently dropping the binaries would
        # make `--config-only <cfg> <binaries>` report success while checking
        # none of them, which is the exact failure this script exists to catch
        # one level up.
        print("--config-only takes the config alone; you also passed "
              f"{len(args) - 1} file(s), which it would not check.")
        return 2
    cfg, seen = parse_config(args[0])
    binaries = args[1:]
    bad = []

    print("=== buildroot config (what was asked for) ===")
    for sym, want in REQUIRED:
        got = cfg.get(sym)
        if sym not in seen:
            # Not "off" — UNKNOWN. Either the name is wrong or its
            # dependencies are unmet, and in both cases this line is asserting
            # nothing at all. Treating it as "n" is how a typo passes.
            print(f"  FAIL {sym} = <absent>   (want {want})")
            bad.append(f"{sym}: absent from the resolved config — wrong "
                       f"symbol name, or its dependencies are unmet. Either "
                       f"way this assertion was checking nothing.")
            continue
        ok = (got is None) if want == "n" else (got == want)
        shown = "n" if got is None else got
        print(f"  {'ok  ' if ok else 'FAIL'} {sym} = {shown}   (want {want})")
        if not ok:
            bad.append(f"{sym}: want {want}, got {shown}")

    if config_only:
        if bad:
            print(f"\n{len(bad)} problem(s):")
            for b in bad:
                print(f"  {b}")
            return 1
        print("\nconfig ok (binaries not checked: --config-only)")
        return 0

    print("=== binaries (what will actually run) ===")
    checked = 0
    for b in binaries:
        facts = elf_facts(b)
        if facts is None:
            print(f"  skip {b} (not an ELF)")
            continue
        checked += 1
        ei_class, machine, flags = facts
        problems = []
        if ei_class != 1:
            problems.append(f"not ELF32 (ei_class={ei_class})")
        if machine != EM_RISCV:
            problems.append(f"not RISC-V (e_machine={machine:#x})")
        if flags != 0:
            problems.append(f"e_flags={flags:#x}: {describe_flags(flags)}")
        status = "ok  " if not problems else "FAIL"
        print(f"  {status} {b}  ELF{32 if ei_class == 1 else 64} "
              f"flags={flags:#x}")
        for p in problems:
            print(f"       {p}")
            bad.append(f"{b}: {p}")

    if checked == 0:
        # A checker that silently checks nothing is worse than no checker, and
        # this project has already shipped one of those. If the glob that feeds
        # this script ever stops matching, that is a failure, not a pass.
        print("\nno ELF binaries were checked - the file list matched nothing.")
        return 1

    if bad:
        print(f"\n{len(bad)} problem(s):")
        for b in bad:
            print(f"  {b}")
        print("\nA userspace koti cannot execute fails at execve, with the")
        print("kernel looking perfectly healthy right up to that instant.")
        return 1

    print(f"\nrootfs ok ({checked} binaries checked)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
