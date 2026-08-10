# Core-level unit tests (muldiv, later CSR/MMU):
#   python run_core.py
# Separate build from run.py so the TT gate-level flow never sees
# core-only testbench modules.

from pathlib import Path

from cocotb_tools.runner import get_runner

import gate

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"

SOURCES = [
    SRC_DIR / "muldiv.sv",
    TEST_DIR / "tb_core.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_core",
        build_dir=TEST_DIR / "sim_build" / "core",
        build_args=["-g2012", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    results = runner.test(
        hdl_toplevel="tb_core",
        test_module="test_core",
        test_dir=TEST_DIR,
    )
    gate.check(results, "muldiv unit tests")


if __name__ == "__main__":
    main()
