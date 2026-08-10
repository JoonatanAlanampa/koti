// SPDX-FileCopyrightText: © 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
//
// esp_uart.sv — a SECOND serial port, wired to the onboard ESP32, plus the two
// strap pins that decide whether the ESP32 is running at all.
//
// This is the first piece of PLAN item 11 (networking). koti has no network
// stack and no MAC; the cheapest link it could ever have is the ESP32 that is
// already soldered to this board, reached over a UART on its own dedicated
// pins. That is what this is.
//
// ⛔ IT DOES NOT WAKE THE ESP32, AND THAT IS THE WHOLE POINT OF THE DESIGN.
// `esp_en` resets to 0, which is exactly what ulx3s_top.sv drove
// unconditionally before this existed, so a board loaded with this bitstream
// behaves at power-on precisely as it did. Waking the chip is a decision
// software takes, deliberately, at a moment of its choosing — and can undo.
//
// ⚠️ WHY THAT MATTERS MORE THAN IT LOOKS: THE ESP32's GPIOs ARE THE MICROSD
// BUS. Upstream's own constraint file says so, and ulx3s_top.sv repeats it:
//     sd_clk = GPIO14   sd_cmd = GPIO15   sd_d[0] = GPIO2
//     sd_d[1] = GPIO4   sd_d[2] = GPIO12  sd_d[3] = GPIO13
// koti loads its kernel off that card and may have its root filesystem on it.
// An ESP32 out of reset is a second driver on those six wires. Whether it
// actually drives them depends on the firmware it boots — which is an
// EXPERIMENT, not something to assume in either direction, and making the
// enable a register is what makes that experiment cost one bitstream instead
// of one per guess.
//
// Registers (word addresses, reg_a = d_addr[1:0]):
//   +0x00  W  transmit byte (low 8 bits). Ignored while `tx_busy`.
//          R  {ovf, avail, data[7:0]} — ⚠️ READING POPS when `avail` is set.
//   +0x04  R  status, NO SIDE EFFECTS: bit0 tx_busy, bit1 rx_avail, bit2 rx_ovf
//   +0x08  RW control: bit0 esp_en (drives wifi_en), bit1 esp_gpio0
//   +0x0C  R  received-byte count since reset, free-running, no side effects
//
// 🪤 STATUS AND DATA ARE SEPARATE REGISTERS, and this repo has the scar to
// prove it is not fussiness: src/usb_kbd.sv carries the same warning because a
// first draft had `usb_kbd_present()` read the popping register — a status
// check that silently ate the keystroke it was asked about. A caller that
// wants to know whether a byte is waiting reads +0x04 and nothing changes.

module esp_uart #(
    parameter int DIV = 217              // 115200 8N1 at 25 MHz
) (
    input  wire         clk,
    input  wire         rst,

    // MMIO, the same select/ack contract as sd_ctrl and usb_kbd: `sel` is the
    // select cycle, the SoC returns the ack one clock later.
    input  wire         sel,
    input  wire         we,
    input  wire [1:0]   reg_a,
    input  wire [31:0]  wdata,
    output logic [31:0] rdata,

    // The pins. ⚠️ NAMED FROM THE ESP32's POINT OF VIEW, as upstream names
    // them, because that is what the constraint file says and renaming them
    // locally is how a board ends up neither sending nor receiving:
    //   wifi_rxd (K3) is what the ESP32 RECEIVES — we drive it
    //   wifi_txd (K4) is what the ESP32 TRANSMITS — we read it
    output wire         esp_rxd,         // -> wifi_rxd, our transmitter
    input  wire         esp_txd,         // <- wifi_txd, our receiver

    // The two strap pins, driven from the control register.
    output logic        esp_en,          // -> wifi_en   (J5 on v3.1.x)
    output logic        esp_gpio0        // -> wifi_gpio0 (F1 on v3.1.x)
);

    // ---- the serial halves, both reused verbatim ---------------------------
    // Deliberately the SAME modules the console uses rather than a second
    // implementation: uart_rx.sv is mutation-tested (edge sampling, start-bit
    // validation, stop bit) and a private copy would start identical and drift.
    logic tx_busy;
    wire  tx_wr = sel && we && (reg_a == 2'd0);

    uart_tx #(.DIV(DIV)) tx0 (
        .clk(clk), .rst(rst),
        .wr(tx_wr && !tx_busy),          // a write while busy is DROPPED, not
                                         // queued: see the note at the bottom
        .data(wdata[7:0]), .tx(esp_rxd), .busy(tx_busy));

    wire [7:0] rx_data_w;
    wire       rx_valid_w, rx_frame_w;

    uart_rx #(.DIV(DIV)) rx0 (
        .clk(clk), .rst(rst), .rx_pin(esp_txd),
        .data(rx_data_w), .valid(rx_valid_w), .frame_err(rx_frame_w));

    // ---- the received byte -------------------------------------------------
    // One byte deep with an overrun flag, the same shape and the same policy as
    // the console receiver in koti_core: KEEP THE NEWEST. A link partner that
    // sends faster than software reads is a fact to record, not to hide, and a
    // stale byte is worse than a missing one.
    logic [7:0] rx_byte;
    logic       rx_avail, rx_ovf;
    logic [31:0] rx_count;

    wire rx_pop = sel && !we && (reg_a == 2'd0);

    always_ff @(posedge clk)
        if (rst) begin
            rx_byte <= 8'd0; rx_avail <= 1'b0; rx_ovf <= 1'b0;
            rx_count <= 32'd0;
        end else begin
            if (rx_valid_w) begin
                rx_byte  <= rx_data_w;
                rx_avail <= 1'b1;
                rx_count <= rx_count + 32'd1;
                if (rx_avail && !rx_pop) rx_ovf <= 1'b1;
            end else if (rx_pop) begin
                rx_avail <= 1'b0;
                rx_ovf   <= 1'b0;
            end
        end

    // ---- the straps --------------------------------------------------------
    // ⛔ BOTH RESET TO 0, WHICH IS THE PRE-2026-08-10 HARDWIRED BEHAVIOUR:
    //   esp_en    = 0  holds the ESP32 in reset — the state that keeps it off
    //                  the microSD bus
    //   esp_gpio0 = 0  the download-mode strap, read only when the chip leaves
    //                  reset, so it is inert while esp_en holds it there
    // ⚠️ To boot the ESP32 from its own flash, gpio0 must be HIGH when enable
    // goes high. Set bit1 FIRST, then bit0, or the chip comes up in serial
    // download mode wondering why nobody is talking to it.
    logic [1:0] ctrl;
    always_ff @(posedge clk)
        if (rst)                                    ctrl <= 2'b00;
        else if (sel && we && (reg_a == 2'd2))      ctrl <= wdata[1:0];

    assign esp_en    = ctrl[0];
    assign esp_gpio0 = ctrl[1];

    // ---- the read mux ------------------------------------------------------
    always_comb
        case (reg_a)
            2'd0:    rdata = {22'd0, rx_ovf, rx_avail, rx_byte};
            2'd1:    rdata = {29'd0, rx_ovf, rx_avail, tx_busy};
            2'd2:    rdata = {30'd0, ctrl};
            default: rdata = rx_count;
        endcase

    // A write to +0x00 while the transmitter is busy is dropped rather than
    // queued, exactly as uart_putc's `while (UART & 1)` poll already assumes on
    // the console side. Adding a one-deep transmit buffer here would make this
    // port behave differently from the other one for no reason a caller can
    // see, and callers that poll are correct on both.
    //
    // `frame_err` from the receiver is deliberately NOT exposed yet: nothing
    // reads it, and a status bit nobody checks is indistinguishable from one
    // that is always zero. It becomes a register the day a driver acts on it.
    wire _unused = &{1'b0, rx_frame_w, wdata[31:8], 1'b0};

endmodule
