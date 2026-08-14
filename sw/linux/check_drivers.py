#!/usr/bin/env python3
"""Assert the koti drivers do not reintroduce defects hardware alone can show.

    python3 sw/linux/check_drivers.py

⛔ WHY A LINT AND NOT A TEST. The one thing that would really prove these
drivers work is opening their device nodes on a booted machine, and nothing in
this repo does that: the Verilator boot gate proves the kernel reaches
userspace and stops there. So a whole class of defect — the driver registers
cleanly, prints its probe banner, creates its device node, and is unusable —
is invisible to every gate here. This file does not fix that. It pins the
specific instances that have already cost a bench session, at the exact line
somebody would write them again.

⚠️ A grep is a weak check and this one knows it. It cannot tell whether the
driver works; it can only tell that a known-wrong construct is back. The real
gate is a boot-time read of the device, which needs an initramfs change.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def check_port_type(src, bad):
    """koti_esp.c must never leave uart_port.type at PORT_UNKNOWN.

    Found on hardware 2026-08-11: `cat /dev/ttyKOTI0` returned EIO immediately,
    with the far end still held in reset, so it read like a wiring fault.

    serial_core's uart_port_startup() opens with

        if (uport->type == PORT_UNKNOWN)
                return 1;

    uart_startup() turns that non-zero into set_bit(TTY_IO_ERROR), and
    uart_port_activate() folds the positive return back into success. The
    result is silent in the nastiest way: open() succeeds, every read() gives
    EIO for ever, and ops->startup() is NEVER CALLED — so request_irq had not
    run either, and /proc/interrupts showed nothing.

    BOTH sites matter. UPF_BOOT_AUTOCONF makes serial_core call config_port()
    at registration, so whatever config_port leaves in port->type is what gets
    tested; fixing only probe() changes nothing at all.
    """
    text = (HERE / src).read_text(encoding="utf-8", errors="replace")

    # Assignments only. The file explains PORT_UNKNOWN at length in comments,
    # and a checker that tripped over its own documentation would be deleted.
    hits = list(re.finditer(r"^[^/*\n]*\bport->type\s*=\s*(\w+)", text,
                            re.MULTILINE))
    assigns = [m.group(1) for m in hits]
    wrong = 0

    for m in hits:
        if m.group(1) == "PORT_UNKNOWN":
            wrong += 1
            line = text[:m.start()].count("\n") + 1
            print(f"  FAIL {src}:{line} sets port->type = PORT_UNKNOWN")
            bad.append(
                f"sw/linux/{src}:{line} sets port->type = PORT_UNKNOWN. "
                f"serial_core then skips ops->startup() and every read() on "
                f"the device returns EIO, while open() still succeeds and the "
                f"probe banner still appears. Give the port a real type in "
                f"BOTH probe() and config_port().")

    if not assigns:
        print(f"  FAIL {src} never sets port->type")
        bad.append(f"sw/linux/{src} never sets port->type at all, so it "
                   f"defaults to PORT_UNKNOWN (0) and every read() will "
                   f"return EIO.")
    elif not wrong:
        # Only claim this once it is true of every assignment, not merely of
        # the last one seen. A checker whose summary line contradicts its own
        # findings is worse than no checker: it gets believed.
        print(f"  ok   {src}: port->type set to {sorted(set(assigns))}, "
              f"never PORT_UNKNOWN")


def check_i2c_shadow(src, bad):
    """koti_i2c.c must never decide what to DRIVE by reading the PINS.

    src/i2c_bit.sv returns the pad levels in bits [1:0] and the drive state in
    bits [3:2], so the register does not read back what was written — which is
    the defining property of a wired-AND bus and the reason it exists. A
    read-modify-write in the write path therefore latches the far end's
    pull-down into koti's own drive register, and koti never lets go.

    It would fail at the ninth clock of the very first byte, i.e. the first
    acknowledge the DS3231 ever sends: the driver would read SDA low (correctly
    — the slave is pulling it), write that back as its own drive, and hold the
    bus down for ever. Every later transfer times out, and the symptom is "the
    RTC answered once and then the bus died".

    The shadow copy in `struct koti_i2c` is what prevents it, and this asserts
    that the function which writes the register does not read it.
    """
    text = (HERE / src).read_text(encoding="utf-8", errors="replace")

    # The write path: koti_i2c_apply() plus the two setters that call it.
    for fn in ("koti_i2c_apply", "koti_i2c_setscl", "koti_i2c_setsda"):
        m = re.search(rf"^static\s+\w[\w\s*]*\b{fn}\s*\([^)]*\)\s*\{{(.*?)^}}",
                      text, re.MULTILINE | re.DOTALL)
        if not m:
            print(f"  FAIL {src}: no function {fn}()")
            bad.append(f"sw/linux/{src} has no {fn}(), so this check is blind. "
                       f"If the write path was renamed, rename it here too.")
            continue
        if "readl" in m.group(1):
            line = text[:m.start()].count("\n") + 1
            print(f"  FAIL {src}:{line} {fn}() reads the register")
            bad.append(
                f"sw/linux/{src}:{line} {fn}() calls readl(). Bits [1:0] of "
                f"that register are the PIN levels, not a read-back of the "
                f"drive bits, so a read-modify-write latches the slave's "
                f"acknowledge into koti's own drive register and holds the bus "
                f"down for ever. Write the shadow copy (ki->scl_hi/sda_hi) "
                f"instead.")
        else:
            print(f"  ok   {src}: {fn}() writes the shadow, never a read-back")


def main():
    bad = []
    check_port_type("koti_esp.c", bad)
    check_i2c_shadow("koti_i2c.c", bad)

    if bad:
        print(f"\nFAIL: {len(bad)} driver problem(s)\n")
        for b in bad:
            print(f"  - {b}")
        return 1

    print("\nOK: the koti drivers carry none of the known-wrong constructs")
    return 0


if __name__ == "__main__":
    sys.exit(main())
