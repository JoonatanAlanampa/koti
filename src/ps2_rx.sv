// ps2_rx.sv — PS/2 device-to-host receiver (keyboard scancodes).
// Receive-only: enough for scancodes; no host-to-device commands (the
// keyboard's power-on defaults suffice — we live without LED control).
// ps2_clk/ps2_dat are asynchronous; both go through a 2FF synchronizer,
// then frames are sampled on falling edges of ps2_clk:
// start(0), 8 data bits LSB-first, odd parity, stop(1) — 11 bits at
// the device's 10-16.7 kHz clock. `valid` pulses one clk with `data`
// when a frame passes the start/parity/stop checks; bad frames are
// dropped silently. A ~240 µs idle watchdog re-arms the receiver if a
// frame dies mid-flight, so one glitch can't shift all later frames.
module ps2_rx #(
    parameter CLK_HZ = 50_000_000
) (
    input  logic       clk, rst,
    input  logic       ps2_clk, ps2_dat,
    output logic [7:0] data,
    output logic       valid
);
    localparam WDOG_MAX = CLK_HZ / 4096;            // ~244 us
    localparam WDOG_W   = $clog2(WDOG_MAX + 1);

    logic c0, c1, c2, d0, d1;                       // 2FF sync + edge tap
    always_ff @(posedge clk) begin
        c0 <= ps2_clk; c1 <= c0; c2 <= c1;
        d0 <= ps2_dat; d1 <= d0;
    end
    wire fall = c2 & ~c1;

    logic [10:0]       shift;    // {stop, parity, data[7:0], start}
    logic [3:0]        bits;
    logic [WDOG_W-1:0] wdog;
    logic              done;     // full frame in `shift` this cycle

    always_ff @(posedge clk)
        if (rst) begin
            bits <= 4'd0; wdog <= '0; done <= 1'b0;
        end else begin
            done <= fall && (bits == 4'd10);
            if (fall) begin
                shift <= {d1, shift[10:1]};
                wdog  <= '0;
                bits  <= (bits == 4'd10) ? 4'd0 : bits + 4'd1;
            end else if (bits != 4'd0) begin
                if (wdog == WDOG_W'(WDOG_MAX)) begin
                    bits <= 4'd0; wdog <= '0;       // mid-frame timeout
                end else
                    wdog <= wdog + 1'b1;
            end
        end

    wire frame_ok = !shift[0]                       // start bit low
                  && shift[10]                      // stop bit high
                  && (^shift[9:1]);                 // odd parity

    always_ff @(posedge clk)
        if (rst) begin
            data <= 8'd0; valid <= 1'b0;
        end else begin
            valid <= done && frame_ok;
            if (done && frame_ok)
                data <= shift[8:1];
        end
endmodule
