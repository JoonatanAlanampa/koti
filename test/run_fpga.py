# ULX3S harness simulation:
#   python run_fpga.py
#
# Same chip sources as run.py, plus the harness (fpga/ulx3s/ulx3s_top.sv) and
# a bench that talks to it through the J1 header wires instead of driving uio
# directly. See test_fpga.py for what that buys.

from pathlib import Path

from cocotb_tools.runner import get_runner

import gate

TEST_DIR = Path(__file__).parent
SRC_DIR = TEST_DIR.parent / "src"
FPGA_DIR = TEST_DIR.parent / "fpga" / "ulx3s"
VENDOR_DIR = TEST_DIR.parent / "vendor"

SOURCES = [
    SRC_DIR / "project.sv",
    SRC_DIR / "koti_core.sv",
    SRC_DIR / "qspi_ctrl.sv",
    SRC_DIR / "sdram_ctrl.sv",
    SRC_DIR / "icache.sv",
    SRC_DIR / "dcache.sv",
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
    SRC_DIR / "uart_rx.sv",
    SRC_DIR / "uart_tx.sv",
    # The microSD stack. project.sv instantiates sd_ctrl under KOTI_FPGA, which
    # this bench defines, so leaving these out is not "not testing SD" — it is
    # an elaboration error that fails the whole harness suite. It did: `test`
    # went red at 05430e7 (the commit that added the SD rung) and stayed red,
    # while the two SD benches this workflow runs separately were both green.
    # A suite can be green in every step a human reads and still be red.
    SRC_DIR / "sd_ctrl.sv",
    VENDOR_DIR / "sd_spi.sv",
    VENDOR_DIR / "spi_master.sv",
    # GPDI/HDMI. sim_prims.v supplies behavioural EHXPLLL and ODDRX1F so this
    # suite can still elaborate ulx3s_top — it is the only suite covering the
    # header permutations, the orientation straps and the UART source mux, so
    # losing it to add HDMI would be a bad trade.
    # ⛔ sim_prims.v lives in test/ and must NEVER reach yosys: it would shadow
    # the real ECP5 hard blocks and put soft logic where a PLL belongs.
    VENDOR_DIR / "tmds_encoder.sv",
    VENDOR_DIR / "dvi_tx.sv",
    VENDOR_DIR / "pll_25_125.v",
    TEST_DIR / "sim_prims.v",
    # USB HID keyboard on US2. src/usb_hid_host_rom.v is koti's, not vendored —
    # upstream's ROM wrapper reads its microcode with a relative $readmemh path
    # that cannot resolve from both here and the repo root, and fails silently.
    SRC_DIR / "usb_kbd.sv",
    SRC_DIR / "usb_hid_host_rom.v",
    VENDOR_DIR / "usb_hid_host.v",
    VENDOR_DIR / "usb_clock.v",
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
        # The ULX3S configuration: RAM comes from the board's onboard 32 MB
        # SDRAM, not the QSPI Pmod's PSRAM. This must match the define in
        # fpga/ulx3s/synth.ps1 and .github/workflows/fpga-ulx3s.yaml, because
        # this suite is the only thing that simulates what those two build.
        defines={"KOTI_FPGA": 1},
        timescale=("1ns", "1ps"),
        # ALWAYS rebuild. cocotb's runner decides staleness from source
        # timestamps and ignores build_args, so toggling here
        # silently reuses the previous binary and the run reports on a
        # configuration you are not testing. That cost a wrong conclusion
        # once — "still failing with SDRAM off" — when SDRAM was in fact
        # still compiled in. A 30 s rebuild is cheaper than that.
        always=True,
    )
    # Distinct results file: run.py writes results.xml, and CI uploads that
    # one. Sharing the name would mean whichever suite ran last silently
    # decided what the summary said.
    results = runner.test(
        hdl_toplevel="tb_fpga",
        test_module="test_fpga",
        test_dir=TEST_DIR,
        results_xml="results_fpga.xml",
    )
    gate.check(results, "ULX3S harness simulation")


if __name__ == "__main__":
    main()
