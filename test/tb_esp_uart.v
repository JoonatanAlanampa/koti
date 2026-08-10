// tb_esp_uart.v — the gate for src/esp_uart.sv, koti's link to the onboard ESP32.
//
// ⛔ THE MOST IMPORTANT TEST HERE IS TEST 1, AND IT IS ABOUT A PIN STAYING LOW.
// The ESP32's GPIOs ARE the microSD bus (GPIO2/4/12/13/14/15 = sd_d[0], sd_d[1],
// sd_d[2], sd_d[3], sd_clk, sd_cmd), and koti loads its kernel off that card.
// This block introduces the first way for software to bring that chip out of
// reset, so the property that matters before any of the serial logic is that it
// does NOT do so by accident: `esp_en` must be 0 out of reset and stay 0 until
// something deliberately writes the control register.
//
// The rest is the usual receiver/transmitter ground, plus the one this repo
// keeps relearning: a status read must not consume the thing it reports on.
//
// Plain Verilog, no cocotb, so it runs on the development host in seconds.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns / 1ps
`default_nettype none

module tb_esp_uart;

  // 20 clocks per bit rather than 217: same logic, a fortieth of the sim time.
  localparam integer DIV = 20;

  reg clk = 0, rst = 1;
  always #5 clk = ~clk;

  reg         sel = 0, we = 0;
  reg  [1:0]  reg_a = 0;
  reg  [31:0] wdata = 0;
  wire [31:0] rdata;
  wire        esp_rxd, esp_en, esp_gpio0;
  reg         esp_txd = 1'b1;          // idle high, as a real line is

  esp_uart #(.DIV(DIV)) dut (
      .clk(clk), .rst(rst), .sel(sel), .we(we), .reg_a(reg_a),
      .wdata(wdata), .rdata(rdata),
      .esp_rxd(esp_rxd), .esp_txd(esp_txd),
      .esp_en(esp_en), .esp_gpio0(esp_gpio0));

  // ⭐ THE TRANSMITTER IS CHECKED BY A REAL RECEIVER, not by hand-timed
  // sampling in the testbench. The first version of test 5 counted clocks to
  // land in the middle of each bit and got 0xE9 for 0xA5 — the bench and
  // uart_tx disagreed about the bit period by a clock, which accumulates. A
  // second uart_rx instance listening to the transmitted line has exactly the
  // timing recovery a real link has, and it is separately mutation-tested by
  // tb_uart_rx.v, so it is not marking its own homework.
  wire [7:0] mon_data;
  wire       mon_valid;
  reg  [7:0] mon_byte = 8'h00;
  reg        mon_got = 1'b0;

  uart_rx #(.DIV(DIV)) mon (
      .clk(clk), .rst(rst), .rx_pin(esp_rxd),
      .data(mon_data), .valid(mon_valid), .frame_err());

  always @(posedge clk)
      if (mon_valid) begin mon_byte <= mon_data; mon_got <= 1'b1; end

  integer fails = 0;

  task check(input [55*8:1] what, input integer g, input integer w);
    begin
      if (g === w) $display("  ok   %0s = %0d", what, g);
      else begin
        $display("  FAIL %0s = %0d, want %0d", what, g, w);
        fails = fails + 1;
      end
    end
  endtask

  // One MMIO access, honouring the select/ack contract: `sel` is one cycle.
  // ⚠️ The trailing edge is not padding. `sel` is driven non-blocking, so the
  // DUT samples it on the edge that ends this task, and its registers update in
  // the NBA region of that same edge — a check placed immediately after would
  // read the value from BEFORE the write. That is exactly what it did: the
  // strap checks below lagged one write behind while the register itself read
  // back correctly, which looks like broken hardware and is a broken testbench.
  task mmio_write(input [1:0] a, input [31:0] d);
    begin
      @(posedge clk); sel <= 1; we <= 1; reg_a <= a; wdata <= d;
      @(posedge clk); sel <= 0; we <= 0;
      @(posedge clk);
    end
  endtask

  task mmio_read(input [1:0] a, output [31:0] d);
    begin
      @(posedge clk); sel <= 1; we <= 0; reg_a <= a;
      @(posedge clk); d = rdata; sel <= 0;
    end
  endtask

  // Send a byte INTO koti the way the ESP32 would: 8N1, LSB first.
  task send_byte(input [7:0] b);
    integer i;
    begin
      esp_txd = 1'b0;               // start
      repeat (DIV) @(posedge clk);
      for (i = 0; i < 8; i = i + 1) begin
        esp_txd = b[i];
        repeat (DIV) @(posedge clk);
      end
      esp_txd = 1'b1;               // stop
      repeat (DIV) @(posedge clk);
    end
  endtask

  reg [31:0] v;
  integer i;
  reg [7:0] got_tx;

  initial begin
    repeat (4) @(posedge clk);
    rst <= 0;
    @(posedge clk);

    // ---- 1. THE SAFETY PROPERTY: the ESP32 stays in reset -----------------
    // Out of reset both straps must be low, which is bit-for-bit what
    // ulx3s_top.sv hardwired before this block existed. A board flashed with
    // this bitstream must behave at power-on exactly as it did before, or the
    // microSD is sharing its bus with a chip nobody asked to wake.
    check("esp_en is LOW out of reset", esp_en, 0);
    check("esp_gpio0 is LOW out of reset", esp_gpio0, 0);
    // ...and it stays low through unrelated traffic. A control register that
    // reset correctly and then got written by a decode accident would pass the
    // two checks above and still put the ESP32 on the card's bus.
    mmio_write(2'd0, 32'h55);            // a transmit
    mmio_read(2'd1, v);                  // a status read
    mmio_read(2'd3, v);                  // a counter read
    check("esp_en still LOW after unrelated MMIO", esp_en, 0);

    // ---- 2. receive ------------------------------------------------------
    send_byte(8'h6B);
    mmio_read(2'd1, v);
    check("status says a byte is waiting", v[1], 1);
    mmio_read(2'd0, v);
    check("the received byte", v[7:0], 8'h6B);
    check("avail was set on the popping read", v[8], 1);
    mmio_read(2'd1, v);
    check("status says empty after the pop", v[1], 0);

    // ---- 3. a status read must NOT pop -----------------------------------
    // ⛔ THE SCAR THIS COMES FROM: usb_kbd.sv's first draft had a "is a key
    // waiting?" helper read the POPPING register, so asking the question ate
    // the answer. Here the byte must survive any number of status reads.
    send_byte(8'h41);
    for (i = 0; i < 5; i = i + 1) mmio_read(2'd1, v);
    mmio_read(2'd3, v);                  // and the counter, also side-effect free
    mmio_read(2'd0, v);
    check("byte survived 5 status reads", v[7:0], 8'h41);

    // ---- 4. overrun keeps the NEWEST -------------------------------------
    send_byte(8'h11);
    send_byte(8'h22);
    mmio_read(2'd1, v);
    check("overrun flagged", v[2], 1);
    mmio_read(2'd0, v);
    check("the NEWEST byte is kept", v[7:0], 8'h22);
    check("ovf visible on the data read too", v[9], 1);

    // ---- 5. transmit ------------------------------------------------------
    mon_got = 1'b0;
    mmio_write(2'd0, 32'hA5);
    repeat (12 * DIV) @(posedge clk);    // a whole frame, plus slack
    check("a frame was transmitted at all", mon_got, 1);
    check("the transmitted byte", mon_byte, 8'hA5);
    check("the line returns to idle high", esp_rxd, 1);

    // ---- 6. the counter counts what arrived ------------------------------
    mmio_read(2'd3, v);
    check("received-byte count", v, 4);   // 6B, 41, 11, 22

    // ---- 7. the straps are software-controlled, and ORDER matters --------
    // gpio0 HIGH first, then enable: a chip released from reset with gpio0 low
    // comes up in serial download mode instead of booting its own flash.
    mmio_write(2'd2, 32'b10);
    check("gpio0 raised alone", {esp_gpio0, esp_en}, 2'b10);
    mmio_write(2'd2, 32'b11);
    check("then enable", {esp_gpio0, esp_en}, 2'b11);
    mmio_read(2'd2, v);
    check("control reads back", v[1:0], 2'b11);
    // And it is reversible: putting the ESP32 back in reset must be one write,
    // because the experiment this register exists for needs an undo.
    mmio_write(2'd2, 32'b00);
    check("back into reset in one write", {esp_gpio0, esp_en}, 2'b00);

    if (fails == 0) $display("\ntb_esp_uart: PASS");
    else begin
      $display("\ntb_esp_uart: FAIL (%0d)", fails);
      $fatal(1);
    end
    $finish;
  end

  initial begin
    #4000000;
    $display("tb_esp_uart: TIMEOUT");
    $fatal(1);
  end

endmodule
