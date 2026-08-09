// vga_text.sv — 80x60 text-mode video: 640x480@60, 8x8 font rendered
// 1:1 into 8x8 cells.
//
// ⭐ IT WAS 40x30 UNTIL 2026-08-09, with pixels doubled both ways — a
// C64-class density chosen when koti was an 8x2 TinyTapeout tile and 40
// columns halved the line buffers. On a real monitor running a real shell it
// is unusable: `ls -l`, `dmesg` and `ps` wrap on every single line, which is
// most of why the machine felt cramped. 80 columns is what every unix tool
// assumes.
//
// ⚠️ The cost is 4x the character fetches (twice per row, twice as many rows)
// and it is still nothing: a row is 10 transactions per 8 scanlines, and 8
// scanlines is ~6400 clocks, so video takes well under 2% of the bus. The
// arbiter was never the constraint here — measure before believing otherwise.
// Lowercase renders as lowercase since 2026-08-08: the fold that mapped
// 0x60+ onto 0x40+ is gone, and the ROM carries all 96 glyphs of
// 0x20..0x7F (768 B as logic, up from 512). The character buffer lives
// in RAM (1200 bytes); on-die state is two 40-byte line buffers
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
    input  logic [23:0] base,           // charbuf word address (PSRAM)

    // video DMA: pair-read port through the 3-port arbiter
    output logic        v_req,
    output logic [23:0] v_addr,
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

    // ping-pong line buffers: 2 x 80 characters
    logic [7:0] lb [2][80];
    logic       cur;                    // buffer being displayed

    // row fetch FSM: 5 transactions x 8 chars into lb[!cur]
    logic        f_busy;
    logic [3:0]  f_txn;                 // 0..9
    logic [5:0]  f_row;                 // text row being fetched (0..59)
    logic [23:0] f_base;                // charbuf base latched at fetch start

    // 20 words per row: base + row*20 + txn*2  (row*20 = row*16 + row*4)
    wire [23:0] row_off = ({18'd0, f_row} << 4) + ({18'd0, f_row} << 2);
    // Once a refill is accepted for arbitration it must finish even if
    // software clears `en` (or moves `base`) mid-row: withdrawing v_req
    // after a grant but before the ACK parks the arbiter forever (F3).
    // New refills still only START while en is high (fetch_trigger below).
    assign v_req  = f_busy;
    assign v_addr = f_base + row_off + {19'd0, f_txn, 1'b0};

    wire fetch_trigger = hblank_start
                      && ((y[2:0] == 3'd0 && y < 10'd472)   // next row
                          || y == 10'd508);                 // row 0
    wire [5:0] fetch_row = (y < 10'd472) ? y[8:3] + 6'd1 : 6'd0;
    wire swap = hblank_start
             && ((y[2:0] == 3'd7 && y < 10'd480) || y == 10'd524);

    always_ff @(posedge clk)
        if (rst) begin
            f_busy <= 1'b0; f_txn <= 4'd0; f_row <= 6'd0;
            f_base <= 24'd0; cur <= 1'b0;
        end else begin
            if (fetch_trigger && en && !f_busy) begin
                f_busy <= 1'b1;
                f_txn  <= 4'd0;
                f_row  <= fetch_row;
                f_base <= base;
            end else if (f_busy && v_ack) begin
                for (int i = 0; i < 4; i++) begin
                    lb[!cur][{f_txn, 3'd0} + i]     <= v_rdata[8*i +: 8];
                    lb[!cur][{f_txn, 3'd0} + i + 4] <= v_rdata2[8*i +: 8];
                end
                if (f_txn == 4'd9) f_busy <= 1'b0;
                else               f_txn  <= f_txn + 4'd1;
            end
            if (swap && ce) cur <= !cur;
        end

    // pixel pipeline, registered: linebuf mux + font ROM was both a
    // long path and a slew source straight onto the pads. One pixel
    // (40 ns) of delay against the syncs is invisible on a monitor.
    // Pixels are 1:1 now — see the header.
    `include "font_rom.svh"
    wire [7:0] ch   = lb[cur][x[9:3]];
    // ⭐ NO FOLD. Until 2026-08-08 this read
    //     chf = (ch[6:5] == 2'b11) ? ch - 8'h20 : ch;
    // which mapped lowercase onto uppercase so the font ROM only had to carry
    // 0x20..0x5F -- a die-area trade for an 8x2 TinyTapeout tile. koti is
    // FPGA-only now, the ROM carries all 96 glyphs, and a terminal that cannot
    // show lowercase is not a terminal anyone would use.
    wire [7:0] chf  = ch;
    wire [7:0] grow = font_row(chf, y[2:0]);
    always_ff @(posedge clk)
        if (rst)     pix <= 1'b0;
        else if (ce) pix <= en && active && grow[x[2:0]];

    wire _unused = &{frame_start, 1'b0};
endmodule
