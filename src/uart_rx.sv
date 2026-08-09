// uart_rx.sv — 8N1 serial receiver. The half koti never had.
//
// ⛔ UNTIL THIS EXISTED, NOTHING COULD EVER ARRIVE AT KOTI OVER A WIRE. src/
// held uart_tx.sv and no receiver at all, which is why the serial console is
// famously "transmit-only" throughout this project: the board could talk and
// could not listen. Every consequence of that traces back here — a login prompt
// on hvc0 nobody can type at, a debugging session that can only watch, and no
// possible link to the onboard ESP32.
//
// DIV = clocks per bit (25 MHz / 115200 baud = 217), the same parameter
// uart_tx.sv takes, and it must be the same number in both or the two ends of
// one cable disagree about how long a bit is.
//
// THREE THINGS THIS HAS TO GET RIGHT, and each is a classic:
//
// 1. THE LINE IS ASYNCHRONOUS. `rx_pin` is driven by someone else's clock —
//    an FTDI, an ESP32 — with no phase relationship to ours at all. Sampling it
//    directly into logic is a metastability bug that simulates perfectly and
//    fails on hardware occasionally, which is the worst way for it to fail. So
//    it goes through three flops and everything downstream reads the last one.
//
// 2. SAMPLE THE MIDDLE OF THE BIT, NOT THE EDGE. After the start bit's falling
//    edge this waits DIV/2 — half a bit — and then a full DIV per bit
//    thereafter, so every sample lands as far from both edges as possible. That
//    is what buys tolerance against the two clocks drifting: at 8 bits plus
//    start and stop, the last sample is 9.5 bit-times from the edge that
//    started it, so half a bit of margin is ~5% of clock error absorbed.
//    Sampling on the edge instead works in simulation, where both ends share a
//    timebase, and shreds data between two real crystals.
//
// 3. A GLITCH IS NOT A START BIT. The line idles high, so any noise pulse low
//    looks like the beginning of a byte. The start bit is therefore RE-CHECKED
//    at its own midpoint and the whole reception abandoned if the line has gone
//    back high — the same "validate at the middle" trick as above, used to
//    reject rather than to sample.
//
// WHAT IT REPORTS. `valid` is one clock wide with `data` beside it; `frame_err`
// is one clock wide when the stop bit was not high, which means the divisor is
// wrong or the line is noise. That distinction matters more than it looks: it
// separates "nothing arrived" from "something arrived and was garbage", and
// koti has already spent a session unable to tell those apart on the transmit
// side (see the hex dump in the capture scripts, which exists for exactly this
// reason).
//
// ⚠️ NO BUFFERING. One byte is presented for one clock and then gone. Anything
// that cannot consume it immediately needs a register with an `avail` flag —
// and, unlike the PS/2 block this project already regrets, an OVERRUN bit. That
// belongs in the MMIO layer, not here, so this module stays a receiver rather
// than a receiver-and-a-policy.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
`default_nettype none

module uart_rx #(
    parameter DIV = 217
) (
    input  wire        clk,
    input  wire        rst,
    input  wire        rx_pin,      // asynchronous, from the outside world
    output logic [7:0] data,
    output logic       valid,       // one clock, `data` is good this cycle
    output logic       frame_err    // one clock, the stop bit was not high
);

    // ---- 1. the crossing ---------------------------------------------------
    // Three flops: the first two settle metastability, the third gives a stable
    // value AND a stable previous value for edge detection. Reset high because
    // an idle line is high — starting low would look like a start bit at t=0.
    logic [2:0] sync;
    always_ff @(posedge clk)
        if (rst) sync <= 3'b111;
        else     sync <= {sync[1:0], rx_pin};

    wire rx_s    = sync[2];                  // the settled line level
    wire rx_fall = sync[2] && !sync[1];      // 1 -> 0, settled

    // ---- 2. the state machine ---------------------------------------------
    typedef enum logic [1:0] { IDLE, START, DATA, STOP } state_t;
    state_t      state;
    logic [15:0] cnt;                        // clocks left in this bit
    logic [2:0]  bits;                       // data bits received so far
    logic [7:0]  shifter;

    // Half a bit for the start, a whole bit thereafter. Both are "minus one"
    // because the count is inclusive of the cycle it reaches zero on.
    localparam int unsigned HALF = (DIV / 2) - 1;
    localparam int unsigned FULL = DIV - 1;

    always_ff @(posedge clk)
        if (rst) begin
            state     <= IDLE;
            cnt       <= 16'd0;
            bits      <= 3'd0;
            shifter   <= 8'd0;
            data      <= 8'd0;
            valid     <= 1'b0;
            frame_err <= 1'b0;
        end else begin
            // Both outputs are single-cycle pulses; default them low and let
            // the one cycle that means something drive them high.
            valid     <= 1'b0;
            frame_err <= 1'b0;

            case (state)
                IDLE:
                    if (rx_fall) begin
                        cnt   <= 16'(HALF);
                        bits  <= 3'd0;
                        state <= START;
                    end

                START:
                    if (cnt != 16'd0) cnt <= cnt - 16'd1;
                    else if (rx_s)
                        // Still high at the middle of what claimed to be a
                        // start bit: it was a glitch, not a byte. Drop it and
                        // wait for a real edge rather than shifting in noise.
                        state <= IDLE;
                    else begin
                        cnt   <= 16'(FULL);
                        state <= DATA;
                    end

                DATA:
                    if (cnt != 16'd0) cnt <= cnt - 16'd1;
                    else begin
                        // LSB first, so each new bit enters at the top and the
                        // byte is right-aligned once eight have arrived.
                        shifter <= {rx_s, shifter[7:1]};
                        cnt     <= 16'(FULL);
                        if (bits == 3'd7) state <= STOP;
                        else              bits  <= bits + 3'd1;
                    end

                STOP:
                    if (cnt != 16'd0) cnt <= cnt - 16'd1;
                    else begin
                        // The stop bit must be high. If it is not, the two ends
                        // disagree about the bit rate or the line is noise —
                        // either way the byte is not trustworthy, and saying so
                        // is more useful than delivering it.
                        if (rx_s) begin
                            data  <= shifter;
                            valid <= 1'b1;
                        end else
                            frame_err <= 1'b1;
                        state <= IDLE;
                    end
            endcase
        end

endmodule

`default_nettype wire
