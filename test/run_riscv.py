# Official riscv-tests (rv32ui+um+ua) on koti_core over the XIP model:
#   python build_riscv_tests.py   (once, or after toolchain changes)
#   python run_riscv.py
# Same build as run_cpu.py, different test module.

from pathlib import Path

from cocotb_tools.runner import get_runner

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"

SOURCES = [
    SRC_DIR / "koti_core.sv",
    SRC_DIR / "control.sv",
    SRC_DIR / "alu.sv",
    SRC_DIR / "branch.sv",
    SRC_DIR / "immgen.sv",
    SRC_DIR / "regfile.sv",
    SRC_DIR / "muldiv.sv",
    SRC_DIR / "csr.sv",
    SRC_DIR / "tlb.sv",
    SRC_DIR / "uart_rx.sv",
    SRC_DIR / "uart_tx.sv",
    TEST_DIR / "xip_model.sv",
    TEST_DIR / "tb_cpu.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_cpu",
        build_dir=TEST_DIR / "sim_build" / "riscv",
        build_args=["-g2012", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    runner.test(
        hdl_toplevel="tb_cpu",
        test_module="riscv_suite",
        test_dir=TEST_DIR,
    )


if __name__ == "__main__":
    main()
