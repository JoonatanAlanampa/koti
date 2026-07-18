# Windows-friendly alternative to the Makefile (no `make` required):
#   python run.py
# Runs the same RTL simulation via cocotb's Python runner.

from pathlib import Path

from cocotb_tools.runner import get_runner

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"

SOURCES = [
    SRC_DIR / "project.sv",
    SRC_DIR / "vga_timing.sv",
    SRC_DIR / "ps2_rx.sv",
    SRC_DIR / "clint.sv",
    TEST_DIR / "tb.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb",
        build_dir=TEST_DIR / "sim_build" / "rtl",
        build_args=["-g2012", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    runner.test(
        hdl_toplevel="tb",
        test_module="test",
        test_dir=TEST_DIR,
    )


if __name__ == "__main__":
    main()
