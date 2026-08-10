#!/usr/bin/env python3
"""check_sources.py — the source lists and src/ must agree.

WHY THIS EXISTS, and it is not hypothetical. This repo keeps FOUR independent
lists of RTL files, and on 2026-08-08 two separate CI failures came from the
same shape of mistake in one session:

  * PS/2 was deleted and `fpga/ulx3s/sources.txt` + `test/Makefile` still named
    `src/ps2_rx.sv`. `fpga-ulx3s` and `test` both died on "File not found".
  * `src/dcache.sv` was added and `test/run_fpga.py` was not told, so the ULX3S
    harness died on "Unknown module type: dcache".

Both were found by CI rather than before a push, and the second happened after
the first had already been diagnosed — the lesson did not stick because there
was nothing to make it stick. This is that something.

⚠️ THE SEARCH THAT MISSED THEM IS WORTH RECORDING TOO. A `grep -r --include=*.sv
--include=*.py ...` is readable and fast and CANNOT SEE `test/Makefile`, which
has no extension. The files whose whole job is to list sources are exactly the
ones an extension filter hides.

Two directions, and both have bitten:
  MISSING  a file in src/ that a list should name but does not  -> "Unknown
           module type" at elaboration.
  STALE    a name in a list with no file behind it              -> "File not
           found", and the build stops before anything runs.

Not every list names every file, and that is legitimate: `test/Makefile` and
`test/run.py` build the ASIC variant, which has no block RAM and therefore none
of the KOTI_FPGA-only modules. So FPGA-only files are checked against the FPGA
lists only. That exception is data below, not a special case in the code.

⛔ AND ON 2026-08-09 THIS FILE PROVED THE POINT AGAINST ITSELF. `src/uart_rx.sv`
was added and named in `test/run_fpga.py`; `test/run_cpu.py` and
`test/run_riscv.py` were not told, and `core-tests` died on
"src/koti_core.sv:1012: error: Unknown module type: uart_rx" for three
consecutive pushes — the exact error in the docstring above — while THIS CHECK
PRINTED PASS. It only knew about the two FPGA lists. A guard that names a
failure mode and does not cover every place it can happen is the failure mode.

So the CPU lists are checked too, and they cannot use the "names everything"
rule: they build `tb_cpu`, which instantiates `koti_core` alone — no SoC, no
block RAM, no card, no keyboard. Their rule is EXACTNESS against what
`koti_core` actually instantiates, computed here by walking the instantiations
rather than kept as a hand-written second list. A hand-written expected-set
would be a fifth list to forget to update, which is the bug this file exists
to prevent.

    python test/check_sources.py

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"

# Kept for the record: these five were once compiled only into the ULX3S build,
# behind `ifdef KOTI_FPGA`, because a TinyTapeout tile had no block RAM and no
# pins for a card or a keyboard. koti became FPGA-only on 2026-08-08, the second
# configuration was deleted, and every list must now name every module — so this
# set no longer excludes anything. It is left here because the NEXT question
# about a source list is usually "why would a file be missing from one?".
FPGA_ONLY = {"sdram_ctrl.sv", "icache.sv", "dcache.sv", "sd_ctrl.sv",
             "usb_kbd.sv"}

# Files that are not modules the SoC instantiates.
NOT_A_MODULE = {"font_rom.svh"}


def names_in(path, pattern):
    # re.M because the module-declaration pattern anchors on ^, which without
    # it matches only the first line of the file — i.e. never. The file-name
    # patterns do not anchor, so the flag is free for them.
    text = path.read_text(encoding="utf-8", errors="replace")
    return set(re.findall(pattern, text, flags=re.M))


def strip_comments(text):
    """Comments name modules constantly in this repo and instantiate none."""
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    return re.sub(r"//[^\n]*", " ", text)


def instantiated_in(text, known):
    """Which of `known` this file instantiates.

    An instantiation is the module name followed either by a parameter
    override or by an instance name, then an open paren:

        uart_rx #(.DIV(UART_DIV)) u1 ( ...      <- both forms appear
        alu alu0 ( ...                             in koti_core.sv

    Matching only against names that are real modules in src/ is what keeps
    this honest — `state`, `cnt` and `case` cannot be mistaken for a module
    because no file in src/ declares one.
    """
    body = strip_comments(text)
    hits = set()
    for mod in known:
        if re.search(rf"\b{re.escape(mod)}\b\s*(?:#\s*\(|\w+\s*\()", body):
            hits.add(mod)
    return hits


def closure_from(top, mod_file):
    """Every module reachable from `top` by instantiation, `top` included."""
    seen, queue = {top}, [top]
    while queue:
        text = (SRC / mod_file[queue.pop()]).read_text(
            encoding="utf-8", errors="replace")
        for mod in instantiated_in(text, set(mod_file)) - seen:
            seen.add(mod)
            queue.append(mod)
    return {mod_file[m] for m in seen}


def main():
    on_disk = {p.name for p in SRC.glob("*.sv")} - NOT_A_MODULE

    # module name -> file it lives in, so the walk can follow instantiations.
    mod_file = {}
    for f in sorted(on_disk):
        for mod in names_in(SRC / f, r"^\s*module\s+(\w+)"):
            mod_file[mod] = f

    # What tb_cpu actually needs. Derived, never written down twice.
    core_set = closure_from("koti_core", mod_file)

    # "full" — the whole machine is built, so every module must be named.
    # "core" — only koti_core is built, so the list must equal core_set.
    lists = {
        "fpga/ulx3s/sources.txt": (
            names_in(ROOT / "fpga/ulx3s/sources.txt", r"src/(\w+\.sv)"), "full"),
        "test/run_fpga.py": (
            names_in(ROOT / "test/run_fpga.py", r'SRC_DIR / "(\w+\.sv)"'),
            "full"),
        "test/run_cpu.py": (
            names_in(ROOT / "test/run_cpu.py", r'SRC_DIR / "(\w+\.sv)"'),
            "core"),
        "test/run_riscv.py": (
            names_in(ROOT / "test/run_riscv.py", r'SRC_DIR / "(\w+\.sv)"'),
            "core"),
    }

    bad = []
    print(f"src/ holds {len(on_disk)} modules "
          f"({len(FPGA_ONLY)} of them FPGA-only)")
    print(f"koti_core instantiates {len(core_set)} of them, transitively: "
          f"{' '.join(sorted(m[:-3] for m in core_set))}")

    for name, (listed, kind) in lists.items():
        # STALE: named but not present. Always wrong, in every list.
        stale = sorted(listed - on_disk)
        want = on_disk if kind == "full" else core_set
        missing = sorted(want - listed)
        # A "core" list naming something koti_core does not instantiate still
        # compiles, so it never breaks CI — which is exactly why it is worth
        # reporting. It means the list and the design have drifted apart and
        # nothing else will ever say so.
        extra = sorted(listed - want) if kind == "core" else []

        flag = "FAIL" if (stale or missing or extra) else "ok  "
        print(f"  {flag} {name}: {len(listed)} listed ({kind})")
        for f in stale:
            print(f"         STALE  {f} is named here but is not in src/")
            bad.append(f"{name} names {f}, which does not exist")
        for f in missing:
            print(f"         MISSING {f} is in src/ but not named here")
            bad.append(f"{name} does not name {f}")
        for f in extra:
            print(f"         UNNEEDED {f} is named here but koti_core "
                  f"does not instantiate it")
            bad.append(f"{name} names {f}, which tb_cpu does not need")

    if bad:
        print(f"\ncheck_sources: FAIL ({len(bad)})")
        for b in bad:
            print(f"  - {b}")
        sys.exit(1)
    print("\ncheck_sources: PASS")


if __name__ == "__main__":
    main()
