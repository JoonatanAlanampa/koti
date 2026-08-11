#!/usr/bin/env python3
"""Assert that the committed firmware binaries match the sources beside them.

    python3 sw/check_firmware.py

⛔ WHY THIS EXISTS, and it is not a hypothetical. `fpga-ulx3s.yaml` does not
compile the firmware. It picks `bin="sw/$img.bin"` off disk and packs that into
the bitstream, so **sw/*.bin are committed artefacts, not build outputs.** On
2026-08-11 sw/esptest.c was edited, committed, pushed, built and flashed to the
board — and the board ran the old firmware, because nothing had rebuilt the .bin.
Every badge was green. The only symptom was that the new code was not there,
which reads like a hardware fault and cost a bitstream build and a flash cycle
to find.

The same drift was then found sitting in the tree: sw/hello.bin was 600 bytes
where its sources build to 604, with 432 bytes differing. Nobody had noticed,
because nothing had ever looked.

WHY HASHES AND NOT A REBUILD. Rebuilding in CI would be the stronger check, and
it needs the exact xpack toolchain the .bin was built with — a different patch
release emits different padding and the gate then fails on healthy input, which
is how gates get deleted. Hashing the INPUTS asks the question that actually
matters ("has anything this .bin was built from changed since?") and needs no
toolchain at all, so it runs in the fast job on every push.

⚠️ WHAT THIS CANNOT CATCH: a .bin rebuilt from the right sources by the WRONG
toolchain, and any change outside the recorded source list. It is a freshness
check, not a reproducibility proof.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from build import (  # noqa: E402
    IMAGES, PROVENANCE, SHARED_SRCS, SW, sha_source,
)


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def check_tree(label, root, provenance, images, shared, build_cmd, bad):
    """Verify one directory of committed firmware against its record.

    Two trees, not one, and the second is not an afterthought — it is where the
    2026-08-11 near-miss actually lived. sw/sbi/*.bin EMBED sw/linux/koti.dtb at
    flash 0x6000 and hand it to the kernel, so the machine description Linux
    sees ships inside the FIRMWARE, inside the bitstream. `serial@70000` had
    been in koti.dts and koti.dtb for a day and in none of the three .bin files.
    koti_esp would have found no node, never probed, and left /dev/ttyKOTI0
    absent — with every badge green.
    """
    if not provenance.exists():
        print(f"FAIL: {label}/{provenance.name} is missing.")
        print(f"  Run `{build_cmd}`, which writes it, and commit both.")
        bad.append(f"{label}/{provenance.name} is missing.")
        return

    rec = json.loads(provenance.read_text(encoding="utf-8"))

    for entry_srcs in images:
        name, srcs = entry_srcs[0], entry_srcs[-1]
        binp = root / f"{name}.bin"
        if not binp.exists():
            print(f"  FAIL {name}.bin is missing")
            bad.append(f"{label}/{name}.bin does not exist.")
            continue

        entry = rec.get(name)
        if entry is None:
            print(f"  FAIL {name} has no record")
            bad.append(f"{label}/{provenance.name} has no entry for {name} — "
                       f"run `{build_cmd}` and commit the result.")
            continue

        if entry.get("bin_sha256") != sha(binp):
            print(f"  FAIL {name}.bin does not match its record")
            bad.append(f"{label}/{name}.bin has changed since "
                       f"{provenance.name} was written. Run `{build_cmd}` and "
                       f"commit the .bin and the record together.")
            continue

        want = entry.get("sources", {})
        stale = []
        for s in sorted(set(srcs) | set(shared)):
            p = root / s
            if not p.exists():
                continue
            # koti.dtb is binary; everything else is text whose line endings
            # this repo does not keep consistent.
            got = sha(p) if s.endswith(".dtb") else sha_source(p)
            if s not in want:
                stale.append(f"{label}/{s} is a source of {name} but was not "
                             f"hashed when it was built")
            elif want[s] != got:
                stale.append(f"{label}/{s} has changed since {name}.bin was "
                             f"built, so the bitstream would flash firmware "
                             f"that does NOT contain that change")

        if stale:
            for msg in stale:
                print(f"  FAIL {name}: {msg}")
            bad.extend(f"{m}. Run `{build_cmd}` and commit {label}/{name}.bin "
                       f"together with {label}/{provenance.name}."
                       for m in stale)
        else:
            print(f"  ok   {label}/{name}.bin matches its sources")


def main():
    bad = []

    if not PROVENANCE.exists():
        print(f"FAIL: sw/{PROVENANCE.name} is missing.")
        print("  Run `python sw/build.py`, which writes it, and commit both.")
        return 1

    rec = json.loads(PROVENANCE.read_text(encoding="utf-8"))

    for name, srcs in IMAGES:
        binp = SW / f"{name}.bin"
        if not binp.exists():
            print(f"  FAIL {name}.bin is missing")
            bad.append(f"sw/{name}.bin does not exist, but sw/build.py builds "
                       f"it and fpga-ulx3s.yaml flashes it.")
            continue

        entry = rec.get(name)
        if entry is None:
            print(f"  FAIL {name} has no record")
            bad.append(f"sw/{PROVENANCE.name} has no entry for {name}. It was "
                       f"added to build.py's IMAGES without a rebuild — run "
                       f"`python sw/build.py` and commit the result.")
            continue

        # The binary itself. Catches a .bin edited or replaced by hand, and a
        # .bin rebuilt without its record being updated.
        actual = sha(binp)
        if entry.get("bin_sha256") != actual:
            print(f"  FAIL {name}.bin does not match its record")
            bad.append(f"sw/{name}.bin has changed since sw/{PROVENANCE.name} "
                       f"was written. Run `python sw/build.py` and commit both "
                       f"the .bin and the record together.")
            continue

        # The sources. This is the one that matters: it is the check that would
        # have caught the 2026-08-11 esptest.c edit before it reached the bench.
        want = entry.get("sources", {})
        stale = []
        for s in sorted(set(srcs) | set(SHARED_SRCS)):
            p = SW / s
            if not p.exists():
                continue
            if s not in want:
                stale.append(f"sw/{s} is a source of {name} but was not hashed "
                             f"when sw/{name}.bin was built")
            elif want[s] != sha_source(p):
                stale.append(f"sw/{s} has changed since sw/{name}.bin was "
                             f"built, so the bitstream would flash firmware "
                             f"that does NOT contain that change — silently, "
                             f"with CI green")

        if stale:
            for msg in stale:
                print(f"  FAIL {name}: {msg.split(' — ')[0]}")
            bad.extend(f"{m}. Run `python sw/build.py` and commit "
                       f"sw/{name}.bin together with sw/{PROVENANCE.name}."
                       for m in stale)
        else:
            print(f"  ok   {name}.bin matches its sources")

    # ---- and the SBI tree, which is where the DTB lives ---------------------
    sys.path.insert(0, str(HERE / "sbi"))
    import importlib.util
    spec = importlib.util.spec_from_file_location(
        "sbi_build", HERE / "sbi" / "build.py")
    sbi_build = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(sbi_build)
    check_tree("sw/sbi", HERE / "sbi", HERE / "sbi" / "firmware.provenance",
               sbi_build.SBI_IMAGES, sbi_build.SBI_SHARED,
               "python sw/sbi/build.py", bad)

    if bad:
        print(f"\nFAIL: {len(bad)} firmware problem(s)\n")
        for b in bad:
            print(f"  - {b}")
        return 1

    n = len(IMAGES) + len(sbi_build.SBI_IMAGES)
    print(f"\nOK: {n} firmware images match the sources beside them")
    return 0


if __name__ == "__main__":
    sys.exit(main())
