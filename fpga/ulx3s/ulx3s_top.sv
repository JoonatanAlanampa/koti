// ulx3s_top.sv — Koti-1 on the ULX3S 85F (ECP5): the pre-tapeout
// validation build. Wraps the exact TT top (tt_um_koti) so what runs
// on the FPGA is what gets hardened; only the pad ring differs.
//
// STATUS: UNTESTED SCAFFOLD — written before the board is in hand.
// Pin sites in ulx3s.lpf must be verified against the official
// constraint file before first use (see README.md here).
//
// Mapping:
//   clk_25mhz  -> clk (the design's real frequency)
//   btn[1]     -> reset (active high; btn[0] is the power button)
//   uo[7:0]    -> both led[5:0]+ftdi (headless view) AND gp VGA pins
//                 (the design's own VGA_EN mux decides what uo carries)
//   uio[7:0]   -> QSPI Pmod on gp/gn with per-pin tristates
//   ui[1:0]    -> PS/2 keyboard (needs pull-ups; US2 port or Pmod)
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module ulx3s_top (
    input  wire        clk_25mhz,
    input  wire [6:0]  btn,
    output wire [7:0]  led,
    output wire        ftdi_rxd,    // FPGA -> host serial
    inout  wire [27:0] gp,
    inout  wire [27:0] gn,
    output wire        wifi_gpio0   // keep the board powered
);
    assign wifi_gpio0 = 1'b1;

    wire clk = clk_25mhz;
    wire rst_n = ~btn[1];

    wire [7:0] ui_in, uo_out, uio_in, uio_out, uio_oe;

    tt_um_koti dut (
        .ui_in(ui_in), .uo_out(uo_out),
        .uio_in(uio_in), .uio_out(uio_out), .uio_oe(uio_oe),
        .ena(1'b1), .clk(clk), .rst_n(rst_n)
    );

    // headless view: LEDs + serial (harmless duplicates in VGA mode)
    assign led = {uo_out[7:2], 2'b00};
    assign ftdi_rxd = uo_out[0];

    // QSPI Pmod on gp[0..7] (verify sites in the LPF first!)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : qspi_io
            assign gp[i] = uio_oe[i] ? uio_out[i] : 1'bz;
        end
    endgenerate
    assign uio_in = gp[7:0];

    // VGA (via resistor DAC / Digilent VGA Pmod) on gn[0..7]:
    // R1,G1,B1,VS,R0,G0,B0,HS in uo order
    generate
        for (i = 0; i < 8; i = i + 1) begin : vga_io
            assign gn[i] = uo_out[i];
        end
    endgenerate

    // PS/2 keyboard on gp[8] (clk) / gp[9] (data), inputs w/ pull-ups
    assign ui_in = {6'd0, gp[9], gp[8]};

    // unused pads
    assign gp[27:10] = 18'bz;
    assign gn[27:8]  = 20'bz;
endmodule
