`default_nettype none
`timescale 1ns / 1ps

// tb_fpga — the ULX3S harness, not just the chip.
//
// Every other suite in this repo drives `tt_um_koti` directly, which means the
// logic BETWEEN the proven chip and the physical pins — the J1/J2 header
// permutation, the orientation straps, the UART source mux, the tristates —
// has never been simulated at all. This bench instantiates `ulx3s_top` and
// talks to it the way the board does: through the header wires.
//
// PHYSICAL SEATING vs THE STRAP. `seat_flip` models how the memory Pmod is
// actually plugged in; `sw[0]` is what the gateware has been TOLD. They are
// deliberately separate signals so the tests can set them to disagree — a
// reversed Pmod must fail cleanly, not half-work, and that is only provable if
// the bench can be wrong on purpose.
//
// Bus model: 1-bit serial mode (QSPI_CFG resets to 0, which is how the chip
// boots), so SD1 is the only line the memory ever drives. That is the same
// simplification tb_rehearse uses in the console repo, and it keeps this bench
// free of quad-mode contention while still exercising the permutation in BOTH
// directions — outputs through the row algebra, MISO back through the
// reconstruction, which is a different expression and the easier one to typo.

module tb_fpga ();

  initial begin
    $dumpfile("tb_fpga.fst");
    $dumpvars(0, tb_fpga);
    #1;
  end

  reg        clk;
  reg  [6:0] btn;
  reg  [3:0] sw;
  wire [7:0] led;
  wire       ftdi_rxd;
  wire       wifi_gpio0;

  wire [3:0] pmod_gp, pmod_gn;
  wire [3:0] vga_gp, vga_gn;
  reg  [1:0] ps2_gp;

  // ---- the modelled memory Pmod -------------------------------------------
  // It drives exactly one wire: SD1 (uio[2]), and only while the selected
  // device is shifting data out. Which physical wire that is depends on the
  // seating: unflipped, uio[2] lands on gp[1]; flipped, on gn[1].
  reg seat_flip;
  reg mem_dq1;
  reg mem_dq1_oe;

  assign pmod_gp[1] = (mem_dq1_oe && !seat_flip) ? mem_dq1 : 1'bz;
  assign pmod_gn[1] = (mem_dq1_oe &&  seat_flip) ? mem_dq1 : 1'bz;

  // PULLMODE=UP in ulx3s.lpf, modelled. Without these an undriven header wire
  // is z, which propagates X into the chip and turns a mapping bug into an
  // unreadable waveform instead of a clean failure.
  pullup (pmod_gp[0]); pullup (pmod_gp[1]); pullup (pmod_gp[2]); pullup (pmod_gp[3]);
  pullup (pmod_gn[0]); pullup (pmod_gn[1]); pullup (pmod_gn[2]); pullup (pmod_gn[3]);

  ulx3s_top uut (
      .clk_25mhz  (clk),
      .btn        (btn),
      .sw         (sw),
      .led        (led),
      .ftdi_rxd   (ftdi_rxd),
      .wifi_gpio0 (wifi_gpio0),
      .pmod_gp    (pmod_gp),
      .pmod_gn    (pmod_gn),
      .vga_gp     (vga_gp),
      .vga_gn     (vga_gn),
      .ps2_gp     (ps2_gp)
  );

  // Convenience for the tests: what the chip itself sees, so a failure can be
  // localised to the harness rather than the SoC.
  wire [7:0] chip_uo  = uut.uo_out;
  wire [7:0] chip_uio_in = uut.uio_in;

endmodule
