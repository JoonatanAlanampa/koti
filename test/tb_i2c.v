// tb_i2c.v — koti's two-bit I2C register, carrying a real transaction.
//
// PLAN item 28. The block under test (src/i2c_bit.sv) contains no protocol at
// all: it is two open-drain drive bits and two pin levels. So the thing worth
// testing is not the block in isolation — it is whether a full I2C exchange
// can be COMPOSED out of it, against a slave that answers the way the DS3231
// does. This bench therefore bit-bangs the register exactly the way
// sw/linux/koti_i2c.c will, one MMIO write per edge, and talks to
// test/ds3231_model.sv.
//
// ⭐ THE WIRING UNDER TEST IS THE HARNESS'S, COPIED. The two `assign`s below
// are character-for-character what fpga/ulx3s/ulx3s_top.sv does with
// rtc_scl/rtc_sda, and the `pullup`s are what PULLMODE=UP in the LPF means.
// That matters because the failure this design is most exposed to is an
// open-drain pin that quietly stops being one — see the sd_d[0] story in
// ulx3s_top.sv, where losing a tristate lost the pull-up with it and read as a
// dead card for a day.
//
// ⛔ WHAT THIS CANNOT PROVE: that the driver's udelay is long enough, that the
// real part answers, that the module is wired to the right holes, or that the
// kernel binds. It proves the register can carry the protocol, which is
// exactly the layer that ships inside the bitstream and therefore the layer
// whose bugs cost a reflash rather than a file copy.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps

module tb_i2c ();

  reg clk = 1'b0;
  reg rst = 1'b1;
  always #20 clk = ~clk;              // 40 ns period = 25 MHz, koti's clock

  reg         sel = 1'b0;
  reg         we = 1'b0;
  reg  [31:0] wdata = 32'd0;
  wire [31:0] rdata;

  wire scl_oe, sda_oe;
  wire scl, sda, sqw;

  i2c_bit dut (
      .clk(clk), .rst(rst),
      .sel(sel), .we(we), .wdata(wdata), .rdata(rdata),
      .scl_oe(scl_oe), .sda_oe(sda_oe),
      .scl_in(scl), .sda_in(sda), .sqw_in(sqw)
  );

  // The harness's open-drain wiring, and the LPF's pull-ups.
  assign scl = scl_oe ? 1'b0 : 1'bz;
  assign sda = sda_oe ? 1'b0 : 1'bz;
  pullup (scl);
  pullup (sda);
  pullup (sqw);                       // nothing drives INT/SQW in this bench

  ds3231_model #(.ADDR(7'h68)) rtc (.scl(scl), .sda(sda));

  integer errors = 0;

  task expect_eq(input [31:0] got, input [31:0] want, input [255:0] what);
      begin
          if (got !== want) begin
              $display("  FAIL %0s: got %08x want %08x", what, got, want);
              errors = errors + 1;
          end else begin
              $display("  ok   %0s = %08x", what, got);
          end
      end
  endtask

  // ---- the MMIO port, driven the way project.sv drives it ------------------
  // `sel` is a one-cycle strobe sampled at the rising edge, so it is set and
  // cleared on falling edges — anything else either misses the edge or is
  // sampled twice, and a doubled write to this register is a doubled edge on
  // the bus.
  task mmio_write(input [31:0] v);
      begin
          @(negedge clk);
          sel = 1'b1; we = 1'b1; wdata = v;
          @(negedge clk);
          sel = 1'b0; we = 1'b0;
      end
  endtask

  task mmio_read(output [31:0] v);
      begin
          @(negedge clk);
          sel = 1'b1; we = 1'b0;
          @(negedge clk);
          sel = 1'b0;
          v = rdata;
      end
  endtask

  // ---- the bus, one edge at a time -----------------------------------------
  // HALF is half a bit period. 1 us here, i.e. a ~500 kHz bus, which is faster
  // than koti will ever manage from software and therefore the harder case for
  // the model: a slow master cannot be caught out by a slave that is late.
  localparam integer HALF = 1000;

  reg drv_scl = 1'b1;                 // the shadow copy, exactly as the driver keeps
  reg drv_sda = 1'b1;

  task set_lines(input s_scl, input s_sda);
      begin
          drv_scl = s_scl;
          drv_sda = s_sda;
          // ⛔ THE SHADOW IS WHY THIS IS A PLAIN WRITE AND NOT A
          // READ-MODIFY-WRITE. Bits [1:0] read back the PIN, not the drive, so
          // a read-modify-write would latch the far end's pull-down into our
          // own drive register and never release it. The driver has the same
          // two variables for the same reason.
          mmio_write({30'd0, drv_sda, drv_scl});
          #HALF;
      end
  endtask

  task i2c_start;
      begin
          set_lines(1'b1, 1'b1);
          set_lines(1'b1, 1'b0);      // SDA falls while SCL is high
          set_lines(1'b0, 1'b0);
      end
  endtask

  task i2c_restart;
      begin
          set_lines(1'b0, 1'b1);      // release SDA with SCL low
          set_lines(1'b1, 1'b1);
          set_lines(1'b1, 1'b0);      // then the same falling edge as a START
          set_lines(1'b0, 1'b0);
      end
  endtask

  task i2c_stop;
      begin
          set_lines(1'b0, 1'b0);
          set_lines(1'b1, 1'b0);
          set_lines(1'b1, 1'b1);      // SDA rises while SCL is high
      end
  endtask

  // Returns the acknowledge bit: 0 = the slave pulled SDA down, 1 = nobody did.
  task i2c_write_byte(input [7:0] b, output ack);
      integer i;
      reg [31:0] r;
      begin
          for (i = 7; i >= 0; i = i - 1) begin
              set_lines(1'b0, b[i]);
              set_lines(1'b1, b[i]);
              set_lines(1'b0, b[i]);
          end
          // The ninth clock: release SDA and look at what comes back.
          set_lines(1'b0, 1'b1);
          set_lines(1'b1, 1'b1);
          mmio_read(r);
          ack = r[1];                 // bit 1 is the PIN, not what we drove
          set_lines(1'b0, 1'b1);
      end
  endtask

  task i2c_read_byte(input ack, output [7:0] b);
      integer i;
      reg [31:0] r;
      begin
          b = 8'h00;
          for (i = 7; i >= 0; i = i - 1) begin
              set_lines(1'b0, 1'b1);  // we release; the slave drives
              set_lines(1'b1, 1'b1);
              mmio_read(r);
              b[i] = r[1];
              set_lines(1'b0, 1'b1);
          end
          // Our acknowledge: pull SDA down for one clock to ask for another
          // byte, leave it up to end the read.
          set_lines(1'b0, ~ack);
          set_lines(1'b1, ~ack);
          set_lines(1'b0, ~ack);
          set_lines(1'b0, 1'b1);
      end
  endtask

  // ---- what the RTC is holding when the bench starts -----------------------
  // 2026-08-14, a Friday, 21:34:56, in the BCD the datasheet's Figure 1 lays
  // out. The seconds are 0x56 and not 56: a model that stored plain binary
  // would make a driver that forgot bcd2bin() pass.
  localparam [7:0] T_SEC = 8'h56, T_MIN = 8'h34, T_HOUR = 8'h21;
  localparam [7:0] T_DAY = 8'h06, T_DATE = 8'h14, T_MON = 8'h08, T_YEAR = 8'h26;

  reg [7:0] got [0:7];
  reg [31:0] r;
  reg ack;
  integer i;

  initial begin
      $dumpfile("tb_i2c.fst");
      $dumpvars(0, tb_i2c);

      rtc.mem[8'h00] = T_SEC;
      rtc.mem[8'h01] = T_MIN;
      rtc.mem[8'h02] = T_HOUR;
      rtc.mem[8'h03] = T_DAY;
      rtc.mem[8'h04] = T_DATE;
      rtc.mem[8'h05] = T_MON;
      rtc.mem[8'h06] = T_YEAR;
      rtc.mem[8'h0E] = 8'h1C;         // control, the power-on value
      rtc.mem[8'h0F] = 8'h00;         // status: OSF clear, so the time is valid
      rtc.mem[8'h11] = 8'h19;         // temperature MSB: +25 C
      rtc.mem[8'h12] = 8'h40;         //             LSB: .25

      repeat (4) @(posedge clk);
      rst = 1'b0;
      repeat (4) @(posedge clk);

      $display("tb_i2c: koti's two-bit I2C register against a DS3231 model");

      // ---- 1. the block is there, and the bus is idle ---------------------
      // 0x6932631F: the "i2c" signature, both lines released, both pins high,
      // SQW pulled up. This is the value `koti peek rtc` prints on a healthy
      // machine with nothing plugged in, so it is worth pinning exactly.
      mmio_read(r);
      expect_eq(r, 32'h6932631F, "idle register");

      // ---- 2. pulling a line down is visible on the pin -------------------
      // The asymmetry the register exists for: write 0, and BOTH the drive bit
      // and the pin read 0. Nothing else in koti behaves like this.
      mmio_write(32'b01);             // SCL released, SDA pulled low
      mmio_read(r);
      expect_eq(r, 32'h69326315, "SDA pulled low");   // pins 01, drive 01
      mmio_write(32'b11);
      mmio_read(r);
      expect_eq(r, 32'h6932631F, "released again");

      // ---- 3. a full write: point the RTC at register 0 --------------------
      i2c_start;
      i2c_write_byte(8'h68 << 1, ack);            // 0xD0: address + write
      expect_eq({31'd0, ack}, 32'd0, "address 0x68 ACKed");
      i2c_write_byte(8'h00, ack);                 // the register pointer
      expect_eq({31'd0, ack}, 32'd0, "pointer byte ACKed");

      // ---- 4. repeated START, then read the seven time registers ----------
      i2c_restart;
      i2c_write_byte((8'h68 << 1) | 8'h01, ack);  // 0xD1: address + read
      expect_eq({31'd0, ack}, 32'd0, "address 0x68 read ACKed");
      for (i = 0; i < 7; i = i + 1)
          i2c_read_byte((i == 6) ? 1'b0 : 1'b1, got[i]);   // NACK the last one
      i2c_stop;

      expect_eq({24'd0, got[0]}, {24'd0, T_SEC},  "seconds");
      expect_eq({24'd0, got[1]}, {24'd0, T_MIN},  "minutes");
      expect_eq({24'd0, got[2]}, {24'd0, T_HOUR}, "hours");
      expect_eq({24'd0, got[3]}, {24'd0, T_DAY},  "day of week");
      expect_eq({24'd0, got[4]}, {24'd0, T_DATE}, "date");
      expect_eq({24'd0, got[5]}, {24'd0, T_MON},  "month");
      expect_eq({24'd0, got[6]}, {24'd0, T_YEAR}, "year");

      // ---- 5. a wrong address must be NACKed ------------------------------
      // Not a formality: a master that cannot tell "nobody answered" from "0x00
      // came back" reports the epoch as a valid time, which is precisely the
      // failure a clock must not have. The AT24C32 EEPROM on the same module
      // sits at 0x57 and is a real second address on this bus.
      i2c_start;
      i2c_write_byte(8'h69 << 1, ack);
      expect_eq({31'd0, ack}, 32'd1, "address 0x69 NACKed");
      i2c_stop;

      // ---- 6. writing a register, and reading it back ---------------------
      // Setting the clock is a write, and a bus that could only read would
      // look perfect until the first `hwclock -w`.
      i2c_start;
      i2c_write_byte(8'h68 << 1, ack);
      i2c_write_byte(8'h00, ack);                 // pointer = seconds
      i2c_write_byte(8'h07, ack);                 // 7 seconds, in BCD
      expect_eq({31'd0, ack}, 32'd0, "data byte ACKed");
      i2c_stop;

      i2c_start;
      i2c_write_byte(8'h68 << 1, ack);
      i2c_write_byte(8'h00, ack);
      i2c_restart;
      i2c_write_byte((8'h68 << 1) | 8'h01, ack);
      i2c_read_byte(1'b0, got[0]);
      i2c_stop;
      expect_eq({24'd0, got[0]}, 32'h07, "seconds after the write");

      // ---- 7. the temperature registers, and the pointer wrap -------------
      // 0x11/0x12 are the last two registers; a read that continues past 0x12
      // must land back on 0x00, which is the datasheet's own sentence and the
      // easiest thing in an address-pointer to get wrong.
      i2c_start;
      i2c_write_byte(8'h68 << 1, ack);
      i2c_write_byte(8'h11, ack);
      i2c_restart;
      i2c_write_byte((8'h68 << 1) | 8'h01, ack);
      i2c_read_byte(1'b1, got[0]);                // 0x11
      i2c_read_byte(1'b1, got[1]);                // 0x12
      i2c_read_byte(1'b0, got[2]);                // wraps to 0x00
      i2c_stop;
      expect_eq({24'd0, got[0]}, 32'h19, "temperature MSB");
      expect_eq({24'd0, got[1]}, 32'h40, "temperature LSB");
      expect_eq({24'd0, got[2]}, 32'h07, "pointer wrapped 0x12 -> 0x00");

      // ---- 8. the bus was left idle ---------------------------------------
      // A STOP that does not actually release both lines leaves the next
      // transaction starting from a bus that is already low, which fails in a
      // way that looks like the SECOND access being broken.
      mmio_read(r);
      expect_eq(r, 32'h6932631F, "bus idle after the last STOP");

      // ---- 9. the slave saw the traffic the bench thinks it sent ----------
      // Guards against a bench that scores itself. A pull-up supplies a 1 on
      // an idle line, so a model that had ignored the bus entirely would still
      // read as "everything NACKed" rather than as an obvious failure — and a
      // master with a broken clock could exchange nothing at all while several
      // checks above went on passing. These two counts are derived from the
      // script rather than from the model's output:
      //
      //   bytes the slave ACCEPTED (pointer bytes and data bytes)
      //     3: pointer                                     1
      //     6: pointer + the seconds byte                  2   -> 3
      //     6 read-back: pointer                           1   -> 4
      //     7: pointer                                     1   -> 5
      //   (5 addresses each ACKed too; those are counted separately by the
      //    address state and are not in this total.)
      //
      //   bytes the slave TRANSMITTED
      //     4: the seven time registers                    7
      //     6 read-back: seconds                           1   -> 8
      //     7: 0x11, 0x12, and the wrap to 0x00            3   -> 11
      expect_eq(rtc.n_byte_wr, 32'd5,  "bytes the slave accepted");
      expect_eq(rtc.n_byte_rd, 32'd11, "bytes the slave transmitted");
      expect_eq(rtc.n_nack,    32'd1,  "addresses the slave refused");

      if (errors == 0)
          $display("tb_i2c: PASS");
      else
          $display("tb_i2c: FAIL (%0d)", errors);
      $finish;
  end

  // A bus that wedges must not hang the run: an I2C master with a bug holds a
  // line and waits for ever, and a CI job that times out after six hours says
  // much less than one that fails in a second.
  initial begin
      #20_000_000;
      $display("tb_i2c: FAIL (timeout - the bus never finished)");
      $finish;
  end

endmodule
