// vga_text.sv — 40x30 text-mode video: 640x480@60, 8x8 font rendered
// into 16x16 cells (pixels doubled both ways — C64-class density,
// chosen by the 8x2 area budget: 40 columns halves the line buffers).
// Lowercase folds onto uppercase (0x60+ -> 0x40+), so the font ROM
// carries only 64 glyphs (512 B as logic). The character buffer lives
// in PSRAM (1200 bytes); on-die state is two 40-byte line buffers
// (ping-pong) plus the font ROM.
//
// Row DMA: while text row r is displayed (16 scanlines), row r+1 is
// fetched into the back buffer — 5 pair-read transactions (8 chars
// each). Worst case over plain serial SPI: ~1.7 scanlines of the 16
// available; quad is ~4x faster. Row 0 prefetches during late vblank
// (y == 508), buffers swap at the end of each row's last line. A
// fetch overrun (impossible within budget) drops the trigger: stale
// characters, never a hang.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module vga_text (
    input  logic        clk, rst,
    input  logic        ce,             // pixel enable (1 @ 25 MHz)
    input  logic        en,             // display enable (MMIO)
    input  logic [22:0] base,           // charbuf word address (PSRAM)

    // video DMA: pair-read port through the 3-port arbiter
    output logic        v_req,
    output logic [22:0] v_addr,
    input  logic        v_ack,
    input  logic [31:0] v_rdata, v_rdata2,

    output logic        hsync, vsync,
    output logic        active,
    output logic        pix             // foreground at this pixel
);
    logic [9:0] x, y;
    logic       hblank_start, frame_start;
    vga_timing vt (
        .clk(clk), .rst(rst), .ce(ce),
        .x(x), .y(y), .hsync(hsync), .vsync(vsync), .active(active),
        .hblank_start(hblank_start), .frame_start(frame_start)
    );

    // ping-pong line buffers: 2 x 40 characters
    logic [7:0] lb [2][40];
    logic       cur;                    // buffer being displayed

    // row fetch FSM: 5 transactions x 8 chars into lb[!cur]
    logic       f_busy;
    logic [3:0] f_txn;                  // 0..4
    logic [4:0] f_row;                  // text row being fetched (0..29)

    // 10 words per row: base + row*10 + txn*2  (row*10 = row*8 + row*2)
    wire [22:0] row_off = ({18'd0, f_row} << 3) + ({18'd0, f_row} << 1);
    assign v_req  = f_busy && en;
    assign v_addr = base + row_off + {18'd0, f_txn, 1'b0};

    wire fetch_trigger = hblank_start
                      && ((y[3:0] == 4'd0 && y < 10'd464)   // next row
                          || y == 10'd508);                 // row 0
    wire [4:0] fetch_row = (y < 10'd464) ? y[8:4] + 5'd1 : 5'd0;
    wire swap = hblank_start
             && ((y[3:0] == 4'd15 && y < 10'd480) || y == 10'd524);

    always_ff @(posedge clk)
        if (rst) begin
            f_busy <= 1'b0; f_txn <= 4'd0; f_row <= 5'd0; cur <= 1'b0;
        end else begin
            if (fetch_trigger && en && !f_busy) begin
                f_busy <= 1'b1;
                f_txn  <= 4'd0;
                f_row  <= fetch_row;
            end else if (f_busy && v_ack) begin
                for (int i = 0; i < 4; i++) begin
                    lb[!cur][{f_txn, 3'd0} + i]     <= v_rdata[8*i +: 8];
                    lb[!cur][{f_txn, 3'd0} + i + 4] <= v_rdata2[8*i +: 8];
                end
                if (f_txn == 4'd4) f_busy <= 1'b0;
                else               f_txn  <= f_txn + 4'd1;
            end
            if (swap && ce) cur <= !cur;
        end

    // pixel pipeline (combinational: exact sync alignment at 25 MHz);
    // pixels double both ways, lowercase folds to uppercase
    `include "font_rom.svh"
    wire [7:0] ch   = lb[cur][x[9:4]];
    wire [7:0] chf  = (ch[6:5] == 2'b11) ? ch - 8'h20 : ch;
    wire [7:0] grow = font_row(chf, y[3:1]);
    assign pix = en && active && grow[x[3:1]];

    wire _unused = &{frame_start, 1'b0};
endmodule
