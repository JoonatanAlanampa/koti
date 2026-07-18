// vga_timing.sv — 640x480@60 timing generator.
// `ce` is the pixel-clock enable: tie high for clk = 25 MHz, or pulse
// at clk/2 for the 50 MHz core clock (25.0 MHz pixel rate; monitors
// accept the 0.7% deviation from 25.175).
// Both syncs are active-low (standard 640x480 polarity). All outputs
// are registered and mutually aligned: hsync/vsync/active describe the
// pixel at the exported x/y. Visible pixels: x < 640 && y < 480.
// `hblank_start` pulses (with ce) when x becomes 640 on a visible line
// — the video controller launches its charbuf prefetch burst there.
// `frame_start` pulses at x==0, y==0.
module vga_timing (
    input  logic       clk, rst,
    input  logic       ce,
    output logic [9:0] x, y,
    output logic       hsync, vsync,
    output logic       active,
    output logic       hblank_start,
    output logic       frame_start
);
    // 640x480@60: H total 800 = 640 vis + 16 fp + 96 sync + 48 bp
    //             V total 525 = 480 vis + 10 fp +  2 sync + 33 bp
    localparam H_VIS = 640, H_FP = 16, H_SYNC = 96, H_TOT = 800;
    localparam V_VIS = 480, V_FP = 10, V_SYNC = 2,  V_TOT = 525;

    logic [9:0] nx, ny;
    always_comb
        if (x == H_TOT - 1) begin
            nx = 10'd0;
            ny = (y == V_TOT - 1) ? 10'd0 : y + 10'd1;
        end else begin
            nx = x + 10'd1;
            ny = y;
        end

    always_ff @(posedge clk)
        if (rst) begin
            x <= 10'd0; y <= 10'd0;
            hsync <= 1'b1; vsync <= 1'b1; active <= 1'b0;
            hblank_start <= 1'b0; frame_start <= 1'b0;
        end else if (ce) begin
            x <= nx; y <= ny;
            hsync  <= ~(nx >= H_VIS + H_FP && nx < H_VIS + H_FP + H_SYNC);
            vsync  <= ~(ny >= V_VIS + V_FP && ny < V_VIS + V_FP + V_SYNC);
            active <= (nx < H_VIS) && (ny < V_VIS);
            hblank_start <= (nx == H_VIS) && (ny < V_VIS);
            frame_start  <= (nx == 10'd0) && (ny == 10'd0);
        end else begin
            hblank_start <= 1'b0;
            frame_start  <= 1'b0;
        end
endmodule
