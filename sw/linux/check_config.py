#!/usr/bin/env python3
"""Assert that the RESOLVED kernel .config is the kernel koti can run.

    python3 sw/linux/check_config.py <path-to-.config>

Why this exists: `make koti_defconfig` silently DROPS any line whose
dependencies are not met. A defconfig is a request, not a result — so a
symbol that got renamed upstream, or one whose `depends on` we did not
notice, disappears without a word and the build goes green. Several of the
symbols below fail in ways that produce no error message at all:

  * RISCV_ISA_C left on  -> the kernel is built with compressed instructions
                            koti cannot decode. It dies on an illegal
                            instruction before printing anything.
  * RISCV_SBI_V01 off    -> in 6.12 both hvc and earlycon prefer the SBI DBCN
                            extension and only fall back to the v0.1 console
                            `if (IS_ENABLED(CONFIG_RISCV_SBI_V01))`. koti's
                            firmware has no DBCN, so the kernel boots
                            perfectly and says nothing.
  * SMP left on          -> the kernel asks for IPI/RFENCE, which the firmware
                            deliberately refuses.

Each of those is a day of debugging a silent machine. This is minutes.
"""
import re
import sys
from pathlib import Path

# (symbol, expected) — expected is "y", "n", or a string value.
# "n" covers both "# CONFIG_X is not set" and the symbol being absent
# entirely, because kconfig writes the former and drops the latter and both
# mean the same thing to the compiler.
REQUIRED = [
    # the architecture koti actually is
    ("CONFIG_ARCH_RV32I", "y"),
    ("CONFIG_32BIT", "y"),
    ("CONFIG_NONPORTABLE", "y"),
    ("CONFIG_MMU", "y"),
    ("CONFIG_RISCV_ISA_C", "n"),
    # EFI is asserted off not because koti minds UEFI but because `config EFI`
    # does `select RISCV_ISA_C`, and a select beats a defconfig's "is not set".
    # This pair is the reason this script exists: on its first run
    # RISCV_ISA_C came back y with nothing in the log to say why.
    ("CONFIG_EFI", "n"),
    ("CONFIG_FPU", "n"),
    ("CONFIG_SMP", "n"),
    # Not a hardening opinion — an arithmetic one. It makes vmlinux.lds.S align
    # every section to PMD_SIZE, which on sv32 is 4 MiB, and there are four
    # such boundaries. It cost 16 MiB of padding on a machine with 12.
    ("CONFIG_STRICT_KERNEL_RWX", "n"),

    # the firmware contract (see sw/sbi/sbi.c)
    ("CONFIG_RISCV_SBI", "y"),
    ("CONFIG_RISCV_SBI_V01", "y"),
    ("CONFIG_HVC_RISCV_SBI", "y"),
    ("CONFIG_SERIAL_EARLYCON_RISCV_SBI", "y"),
    ("CONFIG_RISCV_TIMER", "y"),
    ("CONFIG_RISCV_INTC", "y"),
    ("CONFIG_SIFIVE_PLIC", "y"),

    # The command line comes from koti.dts /chosen/bootargs, and that is where
    # console=hvc0 earlycon=sbi live. CMDLINE_FORCE would override it with the
    # built-in CMDLINE, which is "" — an empty command line boots a kernel with
    # no console and no complaint. (RISC-V spells the default CMDLINE_FALLBACK,
    # not the generic CMDLINE_FROM_BOOTLOADER.)
    ("CONFIG_CMDLINE_FORCE", "n"),

    # Not cryptography — boot time. CRYPTO_MANAGER_DISABLE_TESTS only EXISTS
    # inside the crypto menu, and with it absent IS_ENABLED() is false and
    # lib/crypto/blake2s.c runs its self-test unconditionally: >33 million
    # clocks of silence that two sessions mistook for a hang. This is exactly
    # the failure mode this script was written for — the symbol koti depends on
    # not existing, rather than being wrong.
    ("CONFIG_CRYPTO", "y"),
    ("CONFIG_CRYPTO_MANAGER_DISABLE_TESTS", "y"),

    # the machine description and the rootfs
    ("CONFIG_OF", "y"),
    ("CONFIG_BLK_DEV_INITRD", "y"),
    ("CONFIG_BINFMT_ELF", "y"),

    # being able to see what happened
    ("CONFIG_PRINTK", "y"),
    ("CONFIG_PRINTK_TIME", "y"),
]

# Symbols whose value is only reported, not asserted: they change the size and
# the shape of the boot but no single value is wrong.
REPORT = [
    "CONFIG_CC_OPTIMIZE_FOR_SIZE",
    "CONFIG_PAGE_OFFSET",
    "CONFIG_CMDLINE",
    "CONFIG_CMDLINE_FALLBACK",
    "CONFIG_INITRAMFS_SOURCE",
    "CONFIG_LOG_BUF_SHIFT",
    "CONFIG_HZ",
    "CONFIG_KALLSYMS",
    "CONFIG_RISCV_ISA_ZBB",
    "CONFIG_RISCV_ISA_ZICBOM",
    "CONFIG_PAGE_SIZE_4KB",
]


def parse(path):
    """Return {symbol: value}; unset symbols are simply absent."""
    out = {}
    set_re = re.compile(r"^(CONFIG_[A-Za-z0-9_]+)=(.*)$")
    for line in Path(path).read_text().splitlines():
        m = set_re.match(line)
        if m:
            out[m.group(1)] = m.group(2)
    return out


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    cfg = parse(sys.argv[1])

    bad = []
    print("=== required ===")
    for sym, want in REQUIRED:
        got = cfg.get(sym)
        if want == "n":
            ok = got is None
            shown = "n" if got is None else got
        else:
            ok = got == want
            shown = "n" if got is None else got
        print(f"  {'ok  ' if ok else 'FAIL'} {sym} = {shown}   (want {want})")
        if not ok:
            bad.append((sym, want, shown))

    print("=== reported ===")
    for sym in REPORT:
        print(f"       {sym} = {cfg.get(sym, 'n')}")

    if bad:
        print()
        print(f"{len(bad)} kernel config symbol(s) are not what koti needs:")
        for sym, want, got in bad:
            print(f"  {sym}: want {want}, got {got}")
        print()
        print("kconfig drops a defconfig line whose dependencies are unmet, so")
        print("check sw/linux/koti_defconfig against this kernel version's")
        print("Kconfig before assuming the symbol was simply forgotten.")
        return 1

    print("\nconfig ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
