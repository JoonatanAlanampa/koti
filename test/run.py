# Windows-friendly alternative to the Makefile (no `make` required):
#   python run.py
# Runs the same RTL simulation via cocotb's Python runner.

from pathlib import Path

from cocotb_tools.runner import get_runner

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"

SOURCES = [
    SRC_DIR / "project.sv",
    SRC_DIR / "koti_core.sv",
    SRC_DIR / "qspi_ctrl.sv",
    SRC_DIR / "clint.sv",
    SRC_DIR / "plic.sv",
    SRC_DIR / "vga_text.sv",
    SRC_DIR / "vga_timing.sv",
    SRC_DIR / "arbiter3.sv",
    SRC_DIR / "control.sv",
    SRC_DIR / "alu.sv",
    SRC_DIR / "branch.sv",
    SRC_DIR / "immgen.sv",
    SRC_DIR / "regfile.sv",
    SRC_DIR / "muldiv.sv",
    SRC_DIR / "csr.sv",
    SRC_DIR / "tlb.sv",
    SRC_DIR / "uart_tx.sv",
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
