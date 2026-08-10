# sdram_ctrl unit simulation:
#   python run_sdram.py
#
# Standalone on purpose: the controller is verified against a strict behavioural
# part before it goes anywhere near the SoC, because a memory controller that is
# wrong in a corner is far cheaper to find here than under a running kernel.

from pathlib import Path

from cocotb_tools.runner import get_runner

import gate

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"

SOURCES = [
    SRC_DIR / "sdram_ctrl.sv",
    TEST_DIR / "sdram_model.sv",
    TEST_DIR / "tb_sdram.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_sdram",
        build_dir=TEST_DIR / "sim_build" / "sdram",
        build_args=["-g2012", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    results = runner.test(
        hdl_toplevel="tb_sdram",
        test_module="test_sdram",
        test_dir=TEST_DIR,
        results_xml="results_sdram.xml",
    )
    gate.check(results, "SDRAM controller")


if __name__ == "__main__":
    main()
