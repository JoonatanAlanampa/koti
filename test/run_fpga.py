# ULX3S harness simulation:
#   python run_fpga.py
#
# Same chip sources as run.py, plus the harness (fpga/ulx3s/ulx3s_top.sv) and
# a bench that talks to it through the J1 header wires instead of driving uio
# directly. See test_fpga.py for what that buys.

from pathlib import Path

from cocotb_tools.runner import get_runner

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"
FPGA_DIR = TEST_DIR.parent / "fpga" / "ulx3s"

SOURCES = [
    SRC_DIR / "project.sv",
    SRC_DIR / "koti_core.sv",
    SRC_DIR / "qspi_ctrl.sv",
    SRC_DIR / "sdram_ctrl.sv",
    SRC_DIR / "clint.sv",
    SRC_DIR / "vga_text.sv",
    SRC_DIR / "vga_timing.sv",
    SRC_DIR / "ps2_rx.sv",
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
    FPGA_DIR / "ulx3s_top.sv",
    TEST_DIR / "sdram_model.sv",
    TEST_DIR / "tb_fpga.v",
]


def main():
    runner = get_runner("icarus")
    runner.build(
        sources=SOURCES,
        hdl_toplevel="tb_fpga",
        build_dir=TEST_DIR / "sim_build" / "fpga",
        build_args=["-g2012", f"-I{SRC_DIR}"],
        timescale=("1ns", "1ps"),
        # ALWAYS rebuild. cocotb's runner decides staleness from source
        # timestamps and ignores build_args, so toggling -DKOTI_FPGA here
        # silently reuses the previous binary and the run reports on a
        # configuration you are not testing. That cost a wrong conclusion
        # once — "still failing with SDRAM off" — when SDRAM was in fact
        # still compiled in. A 30 s rebuild is cheaper than that.
        always=True,
    )
    # Distinct results file: run.py writes results.xml, and CI uploads that
    # one. Sharing the name would mean whichever suite ran last silently
    # decided what the summary said.
    runner.test(
        hdl_toplevel="tb_fpga",
        test_module="test_fpga",
        test_dir=TEST_DIR,
        results_xml="results_fpga.xml",
    )


if __name__ == "__main__":
    main()
