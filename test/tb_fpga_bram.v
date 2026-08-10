`default_nettype none
`timescale 1ns / 1ps

/* tb_fpga_bram.v — boot the ULX3S harness with NO Pmod attached.
 *
 * The bitstream that goes on the board has `KOTI_FLASH_BRAM` defined, which
 * replaces the memory Pmod with `fpga/ulx3s/bram_flash.sv` — a QSPI device in
 * fabric. That device has to be right before it is flashed, and "right" here
 * means one specific thing: it answers on the edge `qspi_ctrl` samples. Off by
 * one edge and every fetched word is shifted by a bit, which on hardware is a
 * board that configures, blinks and never says anything.
 *
 * PLAIN VERILOG, NOT COCOTB, and deliberately. test_fpga.py already boots this
 * harness through the J1 wires with a Python `SpiMem`, but cocotb is not
 * installed on the development host, so every iteration on this device model
 * would cost a CI round trip. This bench runs under local iverilog in seconds
 * and under Verilator too, which is the same reason tb_boot.v, tb_icache.v and
 * tb_plic.v are plain Verilog.
 *
 * WHAT IT PROVES, end to end and all of it on the real bus logic:
 *   - `bram_flash` speaks 03h well enough for the CPU to execute out of it
 *   - `qspi_ctrl`, `arbiter3` and `icache` are untouched and still work
 *   - the onboard SDRAM path serves the stack and .bss (sdram_model, clocked on
 *     ~clk exactly as the board wires it)
 *   - the UART source mux and the harness pin algebra
 *   - and the one thing a human will look for on the bench: the banner
 *
 * ⚠️ It stops at the banner, which is not laziness. `sw/hello.c` calls
 * `con_init()` immediately afterwards, and that sets VGA_EN — which switches
 * the `uo` personality and MOVES the UART from uo[0] to uo[6]. With SW3 off
 * (this bench, and the board's default) everything after the banner is RGB
 * wiggling on the pin the receiver is watching. That is documented behaviour,
 * not a fault, and the banner is the whole claim.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 * SPDX-License-Identifier: Apache-2.0
 */
module tb_fpga_bram ();

  // 217 = 25 MHz / 115200, the REAL divider. This harness has no KOTI_SIMMEM,
  // so the UART runs at board speed and the banner costs ~67k clocks. Cheap
  // enough not to be worth a fake divider that would test a different design.
  localparam integer UART_DIV = 217;
  localparam integer MAXCLK   = 3_000_000;

  reg        clk = 1'b0;
  reg  [6:0] btn;
  reg  [3:0] sw;
  wire [7:0] led;
  wire       ftdi_rxd;
  wire       wifi_gpio0, wifi_en;

  wire [3:0] pmod_gp, pmod_gn;
  wire [3:0] vga_gp, vga_gn;

  // PULLMODE=UP in ulx3s.lpf, modelled — and it matters MORE here than in
  // tb_fpga.v: nothing drives these wires at all in this build, so without the
  // pull-ups they are z, and the point of this bench is that the SoC no longer
  // depends on them.
  pullup (pmod_gp[0]); pullup (pmod_gp[1]); pullup (pmod_gp[2]); pullup (pmod_gp[3]);
  pullup (pmod_gn[0]); pullup (pmod_gn[1]); pullup (pmod_gn[2]); pullup (pmod_gn[3]);

  // ---- onboard SDRAM ------------------------------------------------------
  wire        sdram_clk, sdram_cke, sdram_csn, sdram_rasn, sdram_casn, sdram_wen;
  wire [12:0] sdram_a;
  wire [1:0]  sdram_ba, sdram_dqm;
  wire [15:0] sdram_d;

  wire [15:0] part_dout;
  wire        part_oe;
  assign sdram_d = part_oe ? part_dout : 16'hzzzz;

  // Clocked on sdram_clk, which the harness drives as ~clk. Feeding the model
  // the same inverted clock is what makes this the real arrangement rather than
  // a convenient one — the lesson tb_sdram.v paid for (9/9 -> 1/9).
  sdram_model #(.CL(2)) part (
      .clk(sdram_clk), .cke(sdram_cke), .csn(sdram_csn),
      .rasn(sdram_rasn), .casn(sdram_casn), .wen(sdram_wen),
      .a(sdram_a), .ba(sdram_ba), .dqm(sdram_dqm),
      .din(sdram_d), .doe(1'b0),
      .dout(part_dout), .dout_oe(part_oe)
  );

  // ---- onboard microSD -----------------------------------------------------
  // A card model rather than a tie-off: sd_d[0] is MISO and nothing else drives
  // it, so without this it is z, and z on a peripheral input is how an x gets
  // into the CPU and looks like a core defect. This bench does not exercise the
  // card (bringup.bin never touches it) — tb_sd.v does that — it just makes the
  // bus defined.
  wire [3:0] sd_d;
  wire       sd_clk, sd_cmd;
  pullup (sd_d[0]);

  sd_card_model card_model (
      .cs_n(sd_d[3]), .sck(sd_clk), .mosi(sd_cmd), .miso(sd_d[0])
  );

  ulx3s_top uut (
      .wifi_txd   (1'b1),   // idle high; an open input is x
      .clk_25mhz  (clk),
      .btn        (btn),
      .sw         (sw),
      .led        (led),
      .ftdi_rxd   (ftdi_rxd),
      .wifi_gpio0 (wifi_gpio0),
      .wifi_en    (wifi_en),
      .pmod_gp    (pmod_gp),
      .pmod_gn    (pmod_gn),
      .vga_gp     (vga_gp),
      .vga_gn     (vga_gn),
      .sd_clk     (sd_clk),
      .sd_cmd     (sd_cmd),
      .sd_d       (sd_d),
      .sdram_clk  (sdram_clk),
      .sdram_cke  (sdram_cke),
      .sdram_csn  (sdram_csn),
      .sdram_rasn (sdram_rasn),
      .sdram_casn (sdram_casn),
      .sdram_wen  (sdram_wen),
      .sdram_a    (sdram_a),
      .sdram_ba   (sdram_ba),
      .sdram_dqm  (sdram_dqm),
      .sdram_d    (sdram_d)
  );

  always #20 clk = ~clk;              // 40 ns = 25 MHz

  // ---- UART receiver on the pin the board reads --------------------------
  // Reads ftdi_rxd rather than snooping the MMIO write, for the same reason
  // tb_boot.v does: the line is what the board actually emits, and it fails
  // visibly if the divisor or the source mux is wrong.
  reg        uart_prev = 1'b1;
  reg        urx = 1'b0;
  reg  [3:0] ubit = 4'd0;
  reg [15:0] ucnt = 16'd0;
  reg  [7:0] ush = 8'd0;
  integer    nchars = 0;
  reg [63:0] clkcnt = 64'd0;

  // Which string counts as success, chosen with +mark=<n> so ONE bench can
  // verify every image baked into the fabric flash. Adding a bench per image
  // would mean each new image arrives with an untested copy of this UART
  // receiver, the SDRAM model and the harness wiring.
  //   0 (default) sw/bringup.bin — the banner it prints forever
  //   1           sw/sdtest.bin / sw/memtest.bin — their per-pass verdict
  //   2           sw/sdraw.bin — the bit-banged CMD0 got R1 = 01 back. This
  //               gate is what keeps the SD_RAW escape hatch honest: it is the
  //               instrument used to decide whether a silent card is the card's
  //               fault or koti's, so an instrument that has quietly stopped
  //               working would send the next bring-up session hunting in the
  //               wrong half of the problem.
  localparam integer MARKLEN = 29;
  localparam [8*MARKLEN-1:0] MARKER0 = "Koti-1: hello from my own SoC";
  localparam integer MARKLEN1 = 10;
  localparam [8*MARKLEN1-1:0] MARKER1 = "pass CLEAN";
  localparam integer MARKLEN2 = 17;
  localparam [8*MARKLEN2-1:0] MARKER2 = "THE CARD ANSWERED";
  //   3           sw/sbi/sbi_test.bin — the firmware loaded a kernel image off
  //               the card and its checksum matched. This is the TRANSPORT
  //               gate: the whole point of the microSD is getting a 3.95 MB
  //               kernel into a machine whose only other store is 32 KB, and
  //               that path has to be proven against a real header and a real
  //               checksum, which the synthetic card pattern can never carry.
  //               Needs +sdimg/+sdimg_lba, and +sw3=1 because the firmware
  //               enables VGA and the UART moves to uo[6].
  localparam integer MARKLEN3 = 21;
  localparam [8*MARKLEN3-1:0] MARKER3 = "sd: loading kernel ok";
  integer sw3 = 0;
  initial if (!$value$plusargs("sw3=%d", sw3)) sw3 = 0;

  integer mark = 0;
  reg [8*MARKLEN-1:0] markbuf = {(8*MARKLEN){1'b0}};
  reg                 saw_marker = 1'b0;
  initial if (!$value$plusargs("mark=%d", mark)) mark = 0;

  wire rst_n = uut.rst_n;

  always @(posedge clk) begin
    uart_prev <= ftdi_rxd;
    if (!rst_n) begin
      uart_prev <= 1'b1;
      urx       <= 1'b0;
    end else if (!urx) begin
      if (uart_prev === 1'b1 && ftdi_rxd === 1'b0) begin
        urx  <= 1'b1;
        ubit <= 4'd0;
        ucnt <= UART_DIV + (UART_DIV / 2) - 1;    // sample mid-bit-0
      end
    end else if (ucnt != 0) begin
      ucnt <= ucnt - 16'd1;
    end else if (ubit < 4'd8) begin
      ush  <= {ftdi_rxd, ush[7:1]};               // 8N1, LSB first
      ubit <= ubit + 4'd1;
      ucnt <= UART_DIV - 1;
    end else begin
      urx <= 1'b0;
      $write("%c", ush);
      $fflush;
      nchars = nchars + 1;
      markbuf = {markbuf[8*(MARKLEN-1)-1:0], ush};
      if (mark == 0 && markbuf == MARKER0)                     saw_marker = 1'b1;
      if (mark == 1 && markbuf[8*MARKLEN1-1:0] == MARKER1)     saw_marker = 1'b1;
      if (mark == 2 && markbuf[8*MARKLEN2-1:0] == MARKER2)     saw_marker = 1'b1;
      if (mark == 3 && markbuf[8*MARKLEN3-1:0] == MARKER3)     saw_marker = 1'b1;
    end
  end

  // ---- run control -------------------------------------------------------
  initial begin
    btn = 7'b0000000;                 // btn[0] = PWR, active low: held = reset
    // SW1 unused here. SW3 (sw[2]) picks which pin the FTDI listens to:
    // off = uo[0], the headless personality's UART. The SBI firmware turns VGA
    // on, which gives uo[0] to the raster and mirrors the UART on uo[6] — so
    // any image that enables VGA is unreadable with SW3 off, and that is a real
    // DIP switch on the real board, not a bench detail. +sw3=1 selects uo[6].
    sw  = {1'b0, sw3[0], 2'b00};
    repeat (4) @(posedge clk);
    btn[0] = 1'b1;                    // release reset; the POR counter still runs
  end

  task finish_with(input [8*48:1] why);
    begin
      $display("\n--- tb_fpga_bram: %0s", why);
      $display("--- %0d clocks, %0d characters, led=%b", clkcnt, nchars, led);
      if (saw_marker) begin
        $display("--- tb_fpga_bram: PASS (booted from the fabric flash)");
        $finish;
      end
      // Which of the two halves failed is worth saying, because they have
      // completely different fixes: nothing at all means the CPU never
      // executed, garbage means it executed the wrong bits — which for this
      // device model means the wrong EDGE.
      // One $display per line rather than a multi-line string. Adjacent string
      // literals are C, not Verilog, and the Verilog spelling — {"a", "b"} — is
      // the concatenation Verilator refuses to treat as a format (see
      // tb_boot.v). Separate calls are the only form both engines agree on.
      if (nchars == 0) begin
        $display("--- No characters at all: the CPU never fetched anything the");
        $display("--- decoder liked. Suspect bram_flash's opcode handling, or");
        $display("--- the hex image being empty (check the $readmemh path).");
      end else begin
        $display("--- %0d characters arrived but not the banner: the CPU IS", nchars);
        $display("--- executing, so the bus works and the DATA is wrong.");
        $display("--- Suspect the read edge in bram_flash (a one-edge error");
        $display("--- shifts every word by one bit) or the UART divisor.");
      end
      $display("--- flash bad_cmd (led[7]) = %b", led[7]);
      $fatal(1);
    end
  endtask

  always @(posedge clk) begin
    clkcnt <= clkcnt + 64'd1;
    if (saw_marker)          finish_with("the banner arrived");
    else if (uut.dut.halted) finish_with("the core HALTED (ebreak)");
    else if (clkcnt >= MAXCLK) finish_with("clock limit reached");
  end

endmodule

`default_nettype wire
