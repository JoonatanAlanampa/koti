/*
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 *
 * project.sv — Koti-1 top level (bring-up stub).
 * Milestone-2 top: a VGA test pattern on the Tiny VGA Pmod plus the
 * PS/2 receiver — the last scancode picks the checkerboard colors, so
 * both peripherals are proven on real pins. The CPU/memory subsystem
 * replaces the pattern generator as the port progresses (PLAN.md).
 * clk is the 25 MHz pixel clock in this stub (ce tied high); the full
 * SoC moves to 50 MHz with ce = clk/2.
 */
`default_nettype none

module tt_um_koti (
    input  wire [7:0] ui_in,    // [0] PS2_CLK, [1] PS2_DAT
    output wire [7:0] uo_out,   // Tiny VGA Pmod
    input  wire [7:0] uio_in,   // future: QSPI Pmod
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
    wire rst = ~rst_n;

    wire [9:0] x, y;
    wire hsync, vsync, active, hblank_start, frame_start;
    vga_timing vga (
        .clk(clk), .rst(rst), .ce(1'b1),
        .x(x), .y(y), .hsync(hsync), .vsync(vsync), .active(active),
        .hblank_start(hblank_start), .frame_start(frame_start)
    );

    wire [7:0] scancode;
    wire       sc_valid;
    ps2_rx #(.CLK_HZ(25_000_000)) ps2 (
        .clk(clk), .rst(rst),
        .ps2_clk(ui_in[0]), .ps2_dat(ui_in[1]),
        .data(scancode), .valid(sc_valid)
    );

    logic [7:0] last_sc;
    always_ff @(posedge clk)
        if (rst)           last_sc <= 8'h55;
        else if (sc_valid) last_sc <= scancode;

    // 64-pixel checkerboard; cells alternate scancode / inverted colors
    wire       chk = x[6] ^ y[6];
    wire [5:0] pat = chk ? last_sc[5:0] : ~last_sc[5:0];
    wire [5:0] rgb  = active ? pat : 6'd0;
    wire [1:0] r = rgb[5:4];
    wire [1:0] g = rgb[3:2];
    wire [1:0] b = rgb[1:0];

    // Tiny VGA Pmod pinout
    assign uo_out[0] = r[1];
    assign uo_out[1] = g[1];
    assign uo_out[2] = b[1];
    assign uo_out[3] = vsync;
    assign uo_out[4] = r[0];
    assign uo_out[5] = g[0];
    assign uo_out[6] = b[0];
    assign uo_out[7] = hsync;

    // uio reserved for the QSPI Pmod; inputs until the memory
    // controller arrives
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    wire _unused = &{ena, ui_in[7:2], uio_in, hblank_start, frame_start,
                     x[9:7], x[5:0], y[9:7], y[5:0], 1'b0};
endmodule
