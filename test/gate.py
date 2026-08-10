# SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
"""gate.py — make a cocotb suite able to fail its CI job.

⛔ WHY THIS EXISTS, and it is the tenth instance of this repo's signature
defect. `cocotb_tools.runner.Runner.test()` RUNS the tests, writes results.xml,
returns its path — and returns normally whether every test passed or every test
failed. It has no raise-on-failure option. The intended check is a separate
call, `get_results()`, and until 2026-08-10 not one of this repo's four runners
made it.

Measured, not reasoned: with test_psram_upper_bound_access_fault failing,

    $ python run_cpu.py ; echo $?
    ** TESTS=24 PASS=23 FAIL=1 SKIP=0 **
    0

⇒ `core-tests` could report a red suite as a green job, and had been doing it.
That is the same disease as the two found on 2026-08-06 (tb_boot's verdict that
nothing read, and $fatal's exit status swallowed by a pipe into `tee`): the
result exists, is correct, is printed — and is not wired to anything.

⚠️ A suite that ran ZERO tests fails here too. A typo in a test_module or a
testcase filter produces a clean, fast, entirely empty run, and "0 failed" is
true of nothing at all. That is how a gate stops applying without anyone
editing it.
"""

import sys

from cocotb_tools.runner import get_results


def check(results_xml, label):
    """Exit non-zero unless `label`'s suite ran tests and all of them passed."""
    total, failed = get_results(results_xml)

    if failed:
        print(f"\n{label}: FAIL — {failed} of {total} tests failed "
              f"({results_xml})")
        sys.exit(1)
    if total == 0:
        print(f"\n{label}: FAIL — the suite ran ZERO tests ({results_xml}). "
              f"Nothing was verified; check test_module and any filter.")
        sys.exit(1)

    print(f"\n{label}: PASS — {total} tests")
