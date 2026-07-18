# Instruction-level pipeline tests (RV32IM on cpu_pipe + sim models):
#   python run_cpu.py

from pathlib import Path

from cocotb_tools.runner import get_runner

TEST_DIR = Path(__file__).parent
CORE_DIR = TEST_DIR.parent / "core"

SOURCES = [
    CORE_DIR / "cpu_pipe.sv",
    CORE_DIR / "control.sv",
    CORE_DIR / "alu.sv",
    CORE_DIR / "branch.sv",
    CORE_DIR / "immgen.sv",
    CORE_DIR / "regfile.sv",
    CORE_DIR / "muldiv.sv",
    CORE_DIR / "csr.sv",
    CORE_DIR / "uart_tx.sv",
    TEST_DIR / "sim_models.sv",
    TEST_DIR / "tb_cpu.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_cpu",
        build_dir=TEST_DIR / "sim_build" / "cpu",
        build_args=["-g2012", f"-I{CORE_DIR}"],
        timescale=("1ns", "1ps"),
    )
    runner.test(
        hdl_toplevel="tb_cpu",
        test_module="test_cpu",
        test_dir=TEST_DIR,
    )


if __name__ == "__main__":
    main()
