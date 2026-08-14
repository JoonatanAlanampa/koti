// i2c_bit.sv — two open-drain pins and nothing else. koti's I2C bus.
//
// PLAN.md item 28: the DS3231 real-time clock module the user bought, on the
// J1 header. This block is what Linux drives it through.
//
// ⭐ WHY THERE IS NO I2C STATE MACHINE HERE, AND THAT IS THE DESIGN.
// The obvious block is a byte-level master: write an address, write a length,
// poll a done bit. This is not that. It is TWO BITS OF DRIVE AND TWO PIN
// LEVELS, and every START, STOP, bit, byte and acknowledge is composed in
// software by Linux's own `i2c-algo-bit`, the same driver that has run the
// bit-banged busses of a thousand PC graphics cards since 1995.
//
// The reason is not minimalism, it is WHERE A BUG CAN BE FIXED. Everything in
// this file ships inside the bitstream, and the bitstream lives in the board's
// config flash: changing one line of it costs a `fujprog -j flash` (~142 s)
// with the board on the bench and the user in the room. Everything in the
// driver ships in the kernel on the microSD card, which is a file copy. A
// protocol implemented in fabric is a protocol whose every corner case — the
// repeated START that a register read needs, clock stretching, arbitration,
// bus recovery after a reset mid-transfer — has to be RIGHT THE FIRST TIME or
// cost another reflash. Implemented in software it is mainline code that was
// already right, and any surprise costs a card write.
//
// ⚠️ WHAT IT COSTS: the bus runs at roughly 20-50 kHz rather than the DS3231's
// 400 kHz maximum, because every edge is an MMIO store from a 25 MHz core.
// Reading the seven timekeeping registers is a few milliseconds, ONCE PER BOOT
// plus whenever `hwclock` is run. There is no workload here to be slow at.
// I2C has no minimum clock rate — the DS3231 is static CMOS with no bus
// timeout — so a slow master is a correct master, not a marginal one.
//
// ⛔ THE PINS CAN ONLY PULL DOWN. There is no path in this file that drives
// either line high, and that is a safety property, not an omission: I2C is a
// wired-AND bus, and a master that drives high shorts to any device holding
// the line low. The register bit says "let it float" or "pull it down"; the
// pull-up resistors on the RTC module (and PULLMODE=UP in the LPF as a
// fallback) are what make a floating line read as 1.
//
// ---- the register, at 0x0009_0000 ------------------------------------------
//
//   write   [0] SCL: 1 = release (idles high), 0 = pull low
//           [1] SDA: same
//           everything else ignored
//
//   read    [0] SCL pin level, as sampled at the pad
//           [1] SDA pin level
//           [2] SCL drive state, i.e. what was last written to bit 0
//           [3] SDA drive state
//           [4] SQW/INT pin level (input only, see below)
//           [31:8] = 24'h693263 — ASCII "i2c"
//
// ⭐ THE SIGNATURE IS NOT DECORATION. The one question a bench session asks
// after a reflash is "is the new block actually in this bitstream", and an
// unimplemented window does not read as zero on koti — it is simply not
// decoded, and the read falls through to flash and returns whatever is there.
// `koti peek rtc` printing 0x6932631F answers it in one line; a plausible
// number would not. 0x1F is the idle bus: both lines released and high, SQW
// pulled up, nothing attached or nothing pulling down.
//
// ⚠️ READS RETURN THE PIN, WRITES SET THE DRIVE, AND BITS 0-1 ARE THEREFORE
// NOT A READ-BACK OF WHAT YOU WROTE. That asymmetry is the entire point of a
// wired-AND bus — you write 1 and read 0 exactly when the far end is holding
// the line down, which is how an acknowledge is detected — but it means
// software must NOT do a read-modify-write to change one line. It would latch
// the far end's pull-down into its own drive register and never let go.
// sw/linux/koti_i2c.c keeps a shadow copy for that reason, and bits [3:2]
// exist so a human with `koti peek` can see both halves at once.
//
// SQW is INPUT ONLY and is wired to a pin nothing else uses (gn[8], A5, the
// "-" hole of row 8 on J1). The DS3231 can emit 1 Hz, 1.024 kHz, 4.096 kHz or
// 8.192 kHz on it, or an alarm interrupt. Nothing uses it today; it is here
// because the pin and the LPF entry are free NOW and a reflash later is not.
// It reads 1 when nothing is attached — the LPF pulls it up, and the DS3231's
// INT/SQW is open-drain, so idle-high is the correct resting state either way.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module i2c_bit (
    input  wire        clk,
    input  wire        rst,
    input  wire        sel,        // decoded window, asserted for one cycle
    input  wire        we,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,

    // Open drain. `*_oe` high means PULL THE LINE LOW; the pad floats
    // otherwise and the bus's pull-up resistor decides the level.
    output wire        scl_oe,
    output wire        sda_oe,

    // Pad levels, straight off the pins. Synchronised below.
    input  wire        scl_in,
    input  wire        sda_in,
    input  wire        sqw_in
);

  // What software has asked the two lines to do. Reset RELEASED, so the bus is
  // idle from power-on and stays idle through every reset of the CPU — a
  // machine that came up holding SCL low would wedge the RTC for as long as
  // the bitstream was loaded, and nothing in software would be running yet to
  // say so.
  reg scl_hi, sda_hi;

  always @(posedge clk)
      if (rst) begin
          scl_hi <= 1'b1;
          sda_hi <= 1'b1;
      end else if (sel && we) begin
          scl_hi <= wdata[0];
          sda_hi <= wdata[1];
      end

  assign scl_oe = ~scl_hi;
  assign sda_oe = ~sda_hi;

  // ---- the inputs ----------------------------------------------------------
  // Two flops each, and they are not optional. These three pins are driven by
  // a part with its own crystal: every edge is asynchronous to `clk` by
  // construction, and a single flop sampling one is a metastability source
  // feeding a value software will branch on. Two stages at 25 MHz cost 80 ns
  // of latency against an I2C bit that lasts at least 10 us.
  //
  // ⚠️ Reset to 1, not 0. These are pulled-up lines; coming out of reset
  // believing they are low would make the first thing software reads a bus
  // that appears held down by somebody else, which is what the driver's
  // recovery path exists to react to. Better to start at the resting state and
  // let the pins correct it two clocks later.
  reg [1:0] scl_q, sda_q, sqw_q;
  always @(posedge clk)
      if (rst) begin
          scl_q <= 2'b11;
          sda_q <= 2'b11;
          sqw_q <= 2'b11;
      end else begin
          scl_q <= {scl_q[0], scl_in};
          sda_q <= {sda_q[0], sda_in};
          sqw_q <= {sqw_q[0], sqw_in};
      end

  // ⭐ COMBINATIONAL, AND SAFE TO BE. Every other read path in this SoC latches
  // its data on the SELECT cycle because `d_addr` may have moved on by the ack
  // cycle (see the VGA and PLIC blocks in project.sv). This one has ONE
  // register in the whole window: there is no address to mux on, so there is
  // nothing for a stale address to select wrongly. project.sv still registers
  // this value on the select cycle for uniformity with its neighbours.
  assign rdata = {24'h69_32_63,                 // "i2c", so a peek is unambiguous
                  3'b000,
                  sqw_q[1], sda_hi, scl_hi, sda_q[1], scl_q[1]};

endmodule

`default_nettype wire
