// uart_tx.sv — 8N1 serial transmitter.
// DIV = clocks per bit (25 MHz / 115200 baud = 217).
// Write pulses `wr` with `data` while !busy; the line idles high, then:
// start bit (0), 8 data bits LSB-first, stop bit (1).
module uart_tx #(
    parameter DIV = 217
) (
    input  logic       clk, rst,
    input  logic       wr,
    input  logic [7:0] data,
    output logic       tx,
    output logic       busy
);
    logic [8:0]  shift;      // {stop bit, data[7:0]}, shifted out LSB-first
    logic [3:0]  bits;
    logic [15:0] cnt;

    always_ff @(posedge clk)
        if (rst) begin
            tx <= 1'b1; busy <= 1'b0; bits <= 4'd0; cnt <= 16'd0;
        end else if (!busy) begin
            if (wr) begin
                tx    <= 1'b0;                   // start bit, immediately
                shift <= {1'b1, data};
                bits  <= 4'd9;
                cnt   <= 16'(DIV - 1);
                busy  <= 1'b1;
            end
        end else if (cnt != 16'd0)
            cnt <= cnt - 16'd1;
        else if (bits != 4'd0) begin
            tx    <= shift[0];
            shift <= {1'b1, shift[8:1]};
            bits  <= bits - 4'd1;
            cnt   <= 16'(DIV - 1);
        end else
            busy <= 1'b0;                        // stop bit time served
endmodule
