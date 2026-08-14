// ds3231_model.sv — an I2C slave that behaves like the RTC koti is getting.
//
// Enough of a DS3231 to be worth testing against, and no more: the 7-bit
// address 0x68, a register pointer that auto-increments and wraps at 0x12,
// acknowledge on every accepted byte, a NACK for any other address, and the
// timekeeping registers in BCD. It has no oscillator — nothing here counts
// seconds — because what the bench is proving is the BUS, not the clock.
//
// Behaviour taken from the datasheet (Maxim 19-5170 Rev 10, 3/15), the copy in
// ASIC/ds3231.pdf:
//   * "During a multibyte access, when the address pointer reaches the end of
//     the register space (12h), it wraps around to location 00h."
//   * Slave address 1101000 = 0x68, with the R/W bit in the LSB of the address
//     byte.
//   * The registers are BCD, and bit 6 of the hours register selects 12-hour
//     mode — this model is written in 24-hour mode, which is what Linux's
//     rtc-ds1307 configures.
//
// ⚠️ WHAT IT DELIBERATELY DOES NOT DO: clock stretching (the real part never
// stretches), the temperature conversion timing, alarms, the aging offset, or
// the secondary buffer that freezes the time on a START. A bench that modelled
// those would be testing this file rather than koti.
//
// ⛔ IT IS A MODEL, AND A MODEL AGREEING WITH THE DRIVER PROVES ONLY THAT THEY
// AGREE. Both were written from the same datasheet by the same person on the
// same day. What this bench genuinely proves is that koti's TWO-BIT REGISTER
// can carry a real I2C transaction — START, address, ACK, repeated START,
// multi-byte read, NACK, STOP — and that the open-drain wiring lets the far
// end talk back. Whether the part on the bench answers is a bench question.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module ds3231_model #(
    parameter [6:0] ADDR = 7'h68
) (
    input  wire scl,
    inout  wire sda
);

  // Open drain, like the real part: it only ever pulls the line down.
  reg sda_low = 1'b0;
  assign sda = sda_low ? 1'b0 : 1'bz;

  // 0x00..0x12, the whole documented register space.
  reg [7:0] mem [0:18];
  reg [7:0] ptr = 8'h00;

  // Zeroed, not left x. An x read out of a model is indistinguishable from an
  // x produced by the design under test, which is the one thing a bench must
  // never be unable to tell apart. The bench loads the values it checks.
  integer i;
  initial for (i = 0; i < 19; i = i + 1) mem[i] = 8'h00;

  localparam integer IDLE = 0, ADDRB = 1, RX = 2, TX = 3;
  integer   state = IDLE;
  integer   bitcnt = 0;
  reg [7:0] shreg = 8'h00;
  reg       reading = 1'b0;    // this transfer's direction, from the address byte
  reg       got_ptr = 1'b0;    // the first byte written after an address is the pointer
  reg       master_ack = 1'b0;

  // Counters, so a bench can assert that a transaction happened at all rather
  // than that it merely produced the right numbers.
  integer n_start = 0, n_stop = 0, n_byte_rd = 0, n_byte_wr = 0, n_nack = 0;

  // ---- START and STOP ------------------------------------------------------
  // Both are the only transitions of SDA that happen while SCL is HIGH, which
  // is what makes them distinguishable from data at all.
  always @(negedge sda) if (scl === 1'b1) begin
      state   = ADDRB;
      bitcnt  = 0;
      shreg   = 8'h00;
      sda_low = 1'b0;
      got_ptr = 1'b0;
      n_start = n_start + 1;
  end

  always @(posedge sda) if (scl === 1'b1 && state != IDLE) begin
      state   = IDLE;
      sda_low = 1'b0;
      n_stop  = n_stop + 1;
  end

  // ---- the bit clock -------------------------------------------------------
  // Data is sampled on the RISING edge and changed on the FALLING one. Every
  // decision this model makes is therefore in one of these two blocks, and the
  // ninth clock of each byte is the acknowledge.
  always @(posedge scl) begin
      case (state)
          ADDRB, RX: begin
              if (bitcnt < 8) shreg = {shreg[6:0], (sda === 1'b0) ? 1'b0 : 1'b1};
              bitcnt = bitcnt + 1;
          end
          TX: begin
              // The ninth clock of a read byte carries the MASTER's acknowledge.
              if (bitcnt == 8) master_ack = (sda === 1'b0);
              bitcnt = bitcnt + 1;
          end
          default: ;
      endcase
  end

  always @(negedge scl) begin
      case (state)
          ADDRB: begin
              if (bitcnt == 8) begin
                  if (shreg[7:1] == ADDR) begin
                      reading = shreg[0];
                      sda_low = 1'b1;              // ACK
                  end else begin
                      sda_low = 1'b0;              // NACK: not our address
                      n_nack  = n_nack + 1;
                  end
              end else if (bitcnt == 9) begin
                  sda_low = 1'b0;
                  bitcnt  = 0;
                  if (shreg[7:1] != ADDR) begin
                      state = IDLE;                // ignore the rest of it
                  end else if (reading) begin
                      state = TX;
                      shreg = mem[ptr[4:0]];
                      // Present bit 7 immediately: this falling edge IS the one
                      // the master expects the first data bit on.
                      sda_low = ~shreg[7];
                  end else begin
                      state = RX;
                  end
              end
          end

          RX: begin
              if (bitcnt == 8) begin
                  sda_low   = 1'b1;                // ACK every byte we take
                  n_byte_wr = n_byte_wr + 1;
              end else if (bitcnt == 9) begin
                  sda_low = 1'b0;
                  bitcnt  = 0;
                  if (!got_ptr) begin
                      // First byte after the address is the register pointer —
                      // this is what makes a "read register N" a write of one
                      // byte followed by a repeated START.
                      ptr     = (shreg > 8'h12) ? 8'h00 : shreg;
                      got_ptr = 1'b1;
                  end else begin
                      mem[ptr[4:0]] = shreg;
                      ptr = (ptr == 8'h12) ? 8'h00 : ptr + 8'h01;
                  end
              end
          end

          TX: begin
              if (bitcnt < 8) begin
                  sda_low = ~shreg[7 - bitcnt];
              end else if (bitcnt == 8) begin
                  sda_low = 1'b0;                  // release for the master's ack
              end else begin
                  bitcnt    = 0;
                  n_byte_rd = n_byte_rd + 1;
                  // The pointer advances on every byte read, and WRAPS at 0x12.
                  ptr = (ptr == 8'h12) ? 8'h00 : ptr + 8'h01;
                  if (master_ack) begin
                      shreg   = mem[ptr[4:0]];
                      sda_low = ~shreg[7];
                  end else begin
                      // NACK from the master ends the read; the next thing on
                      // the bus is a STOP or a repeated START.
                      state   = IDLE;
                      sda_low = 1'b0;
                  end
              end
          end

          default: ;
      endcase
  end

endmodule

`default_nettype wire
