# Equivalence proof (directed hazards) for the DFFRAM RF macro integration:
# the SAME instruction-level suite as run_cpu.py, built with -DUSE_MACRO so
# src/regfile.sv uses the DFFRF_2R1W macro wrapper. These directed tests stress
# exactly the read-after-write / load-use / forwarding windows where a
# read-first vs write-first mistake in the wrapper would show up.
#
# Run:  python run_cpu_macro.py

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
    SRC_DIR / "DFFRF_2R1W.v",   # behavioural model of the hard macro
    SRC_DIR / "muldiv.sv",
    SRC_DIR / "csr.sv",
    SRC_DIR / "tlb.sv",
    SRC_DIR / "uart_tx.sv",
    TEST_DIR / "xip_model.sv",
    TEST_DIR / "tb_cpu.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_cpu",
        build_dir=TEST_DIR / "sim_build" / "cpu_macro",
        build_args=["-g2012", "-DUSE_MACRO", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    runner.test(
        hdl_toplevel="tb_cpu",
        test_module="test_cpu",
        test_dir=TEST_DIR,
    )


if __name__ == "__main__":
    main()
