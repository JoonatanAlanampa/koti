# Equivalence proof for the DFFRAM RF macro integration:
# the SAME official rv32ui+um+ua suite as run_riscv.py, but built with
# -DUSE_MACRO so src/regfile.sv instantiates the DFFRF_2R1W macro (modelled
# behaviourally by src/DFFRF_2R1W.v) and registers its combinational read.
# If every test that passes on the behavioural sync-read regfile also passes
# here, the output-registered wrapper reproduces the read-first sync-read
# timing the pipeline was built around. See src/regfile.sv.
#
# Run:  python run_riscv_macro.py   (build_riscv_tests.py first, as for run_riscv.py)

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
        build_dir=TEST_DIR / "sim_build" / "riscv_macro",
        build_args=["-g2012", "-DUSE_MACRO", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
    )
    runner.test(
        hdl_toplevel="tb_cpu",
        test_module="riscv_suite",
        test_dir=TEST_DIR,
    )


if __name__ == "__main__":
    main()
