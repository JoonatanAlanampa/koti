`default_nettype none
//
// usb_kbd.sv — turn the vendored USB HID host core into keystrokes software can
// read, and cross the clock domain between it and the SoC.
//
// THE CORE IS VENDORED; THIS FILE IS KOTI'S HALF. `vendor/usb_hid_host.v` does
// the whole USB protocol — enumeration, SET_ADDRESS, GET_DESCRIPTOR, boot
// protocol, periodic IN transfers — and reports which keys are held. It is not
// a keyboard driver: it never says "a key was pressed", only "these are down
// right now". Everything between that and a character belongs here.
//
// THREE PROBLEMS, and they are the whole file:
//
// 1. CLOCK DOMAINS. The core runs at 12 MHz because USB low speed is 1.5 Mbps
//    and it oversamples 8x; koti runs at 25 MHz. The two are unrelated — not
//    integer multiples, not phase-locked — so nothing may be sampled across
//    them without care. `report` is a ONE-CLOCK pulse at 12 MHz, and a 25 MHz
//    domain can miss a pulse that short's edges entirely, so it is converted to
//    a TOGGLE, synchronised with two flops, and edge-detected here. The payload
//    (`key1..4`, `key_modifiers`) is NOT synchronised bit by bit — that would
//    be wrong for a multi-bit bus, where two flops can each resolve to a
//    different report. It is sampled only after the toggle has crossed, by
//    which time it has been stable for ~120 ns and will stay stable for ~10 ms
//    until the next report. The toggle is the only thing that crosses.
//
// 2. HELD KEYS ARE NOT KEYSTROKES. A HID boot report lists up to six keys
//    currently down, so holding `a` puts 0x04 in every report, ~125 times a
//    second. Emitting those as characters would type an unstoppable stream. The
//    keystroke is the TRANSITION, so this compares each report against the
//    previous one and emits only keys that were not down before.
//    ⚠️ Position within the report is NOT stable — a key can move slot as other
//    keys are pressed and released — so a slot-by-slot comparison would emit
//    phantom presses. Each new key is checked against ALL four previous slots.
//
// 3. SOFTWARE MUST NOT HAVE TO KEEP UP. Reports arrive every ~8-10 ms, which is
//    slow, but a burst of four new keys in one report arrives together. An
//    eight-entry FIFO absorbs that, and `ovf` records the truth if it ever
//    overflows. The PS/2 block's single register with no overrun flag is a
//    known defect (see project.sv); this does not repeat it.
//
// HID USAGE CODES, NOT ASCII, and not PS/2 scancodes either. Translation lives
// in sw/usbkbd.c, for the same reason ps2kbd.c does it in software: a keymap is
// a table that changes with layout and belongs where it is cheap to change.
//
// REGISTERS (byte offsets in the 0x0006_0000 window):
//   +0x00  R  {ovf, avail, code[7:0]}
//             ⚠️ READING POPS the FIFO when `avail` is set. `ovf` is sticky and
//             clears on the same read. Nothing else lives here, deliberately:
//             a status bit in a register with a side effect invites a "just
//             checking" read that eats a keystroke.
//   +0x04  R  {conerr, typ[1:0], modifiers[7:0]} — no side effects at all.
//             `modifiers` is LIVE, not queued. Shift and ctrl are levels,
//             not events, so queueing them would pair a character with whatever
//             the modifiers happened to be when software got round to reading.
//             ⚠️ This is therefore the modifier state NOW, which for a fast
//             typist can differ from the state when the queued key went down.
//             The fix if it ever matters is to widen the FIFO, not to poll
//             harder.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

module usb_kbd (
    input  wire        clk,              // 25 MHz, the SoC's clock
    input  wire        rst,

    // MMIO, same request/ack contract as sd_ctrl: `sel` is the select cycle,
    // `ack` comes back one clock later.
    input  wire        sel,
    input  wire        we,
    input  wire [1:0]  reg_a,
    output logic [31:0] rdata,

    // From vendor/usb_hid_host.v, in ITS clock domain (12 MHz).
    // ⚠️ `usb_report_tog` is a TOGGLE, not the core's one-clock `report` pulse.
    // The harness flips it in the USB domain (fpga/ulx3s/ulx3s_top.sv); wiring
    // the raw pulse here would work in simulation, where a 12 MHz pulse happens
    // to be two 25 MHz clocks wide, and drop keystrokes on real hardware where
    // the two clocks drift. The name says so because the mistake is invisible.
    input  wire        usb_report_tog,
    input  wire [1:0]  usb_typ,
    input  wire        usb_conerr,
    input  wire [7:0]  usb_key_modifiers,
    input  wire [7:0]  usb_key1, usb_key2, usb_key3, usb_key4,

    output logic       kb_avail_irq       // level: something is queued
);

  // ------------------------------------------------- 1. the domain crossing
  // The pulse becomes a level that flips. A toggle cannot be missed however
  // the two clocks line up, whereas a 12 MHz single-cycle pulse is 83 ns and a
  // 25 MHz sampler looking for a level would need it to survive a setup window
  // it has no reason to survive.
  //
  // ⚠️ This toggle is written in the USB domain and read in the SoC domain, and
  // that is the ONLY signal that crosses. Everything below is 25 MHz.
  // This module has ONE clock by design — a second clock here would put a CDC
  // inside a block that is also doing protocol work, which is how CDC bugs get
  // hidden. The toggle is generated in the harness and arrives as a level.
  logic [2:0] rep_sync;
  always_ff @(posedge clk)
      if (rst) rep_sync <= 3'b000;
      else     rep_sync <= {rep_sync[1:0], usb_report_tog};

  // Either edge of the toggle is a new report.
  wire new_report = rep_sync[2] ^ rep_sync[1];

  // The payload, sampled once the toggle has crossed. Two flops of margin
  // before it is used, and it has been stable for the whole crossing.
  logic [7:0] k1, k2, k3, k4, mods;
  always_ff @(posedge clk)
      if (new_report) begin
          k1   <= usb_key1;
          k2   <= usb_key2;
          k3   <= usb_key3;
          k4   <= usb_key4;
          mods <= usb_key_modifiers;
      end

  // Modifiers are a LEVEL and are exposed live rather than queued — see the
  // header. Sampled in this domain so software never reads a 12 MHz signal.
  logic [7:0] mods_live;
  always_ff @(posedge clk) mods_live <= mods;

  // ------------------------------------------- 2. held keys -> keystrokes
  // The previous report, to diff against.
  logic [7:0] p1, p2, p3, p4;
  logic       diff_run;                  // walking the four slots of a report
  logic [1:0] diff_i;

  // A key is "new" if it is non-zero and matches NONE of the four previous
  // slots. Checking all four is what makes this immune to keys changing slot.
  // 0x01..0x03 are HID's error codes (rollover, POST fail, undefined), never
  // real keys, and a rollover would otherwise be typed as a character.
  function automatic logic is_new(input logic [7:0] k);
      is_new = (k > 8'h03) && (k != p1) && (k != p2) && (k != p3) && (k != p4);
  endfunction

  logic [7:0] cand;
  always_comb
      case (diff_i)
          2'd0: cand = k1;
          2'd1: cand = k2;
          2'd2: cand = k3;
          2'd3: cand = k4;
      endcase

  // ------------------------------------------------------------ 3. the FIFO
  // Eight entries: a report can contribute at most four, and reports are ~8 ms
  // apart, so this only fills if software has stopped reading entirely — which
  // is exactly when `ovf` needs to be true rather than silently wrong.
  logic [7:0] fifo [0:7];
  logic [3:0] wptr, rptr;                // 4 bits: the extra bit distinguishes
  logic       ovf;                       // full from empty without a count
  wire        f_empty = (wptr == rptr);
  wire        f_full  = (wptr[2:0] == rptr[2:0]) && (wptr[3] != rptr[3]);

  wire sel_rd = sel && !we;
  wire pop    = sel_rd && (reg_a == 2'd0) && !f_empty;

  always_ff @(posedge clk)
      if (rst) begin
          wptr <= 4'd0; rptr <= 4'd0; ovf <= 1'b0;
          p1 <= 8'd0; p2 <= 8'd0; p3 <= 8'd0; p4 <= 8'd0;
          diff_run <= 1'b0; diff_i <= 2'd0;
      end else begin
          // Start a diff pass when a report crosses. One slot per clock: at
          // 25 MHz that is four clocks against a ~8 ms report period, so it is
          // always finished long before the next one.
          if (new_report) begin
              diff_run <= 1'b1;
              diff_i   <= 2'd0;
          end else if (diff_run) begin
              if (is_new(cand)) begin
                  if (f_full) begin
                      ovf <= 1'b1;       // record it; do NOT overwrite
                  end else begin
                      fifo[wptr[2:0]] <= cand;
                      wptr <= wptr + 4'd1;
                  end
              end
              if (diff_i == 2'd3) begin
                  diff_run <= 1'b0;
                  // The diffed report becomes the baseline only once the whole
                  // pass is done — updating it early would make later slots
                  // compare against themselves.
                  p1 <= k1; p2 <= k2; p3 <= k3; p4 <= k4;
              end
              diff_i <= diff_i + 2'd1;
          end

          if (pop) begin
              rptr <= rptr + 4'd1;
              ovf  <= 1'b0;              // sticky until read
          end
      end

  assign kb_avail_irq = !f_empty;

  // ---------------------------------------------------------- the registers
  // Captured on the select cycle and served on the ack cycle, the same
  // discipline the PLIC's claim register and sd_ctrl's buffer need: `rptr` has
  // already moved by the time the ack arrives.
  logic [31:0] rmux;
  always_comb
      case (reg_a)
          2'd0:    rmux = {22'd0, ovf, !f_empty,
                           f_empty ? 8'd0 : fifo[rptr[2:0]]};
          // Status lives HERE, not in register 0, because reading register 0
          // POPS. A "is a keyboard attached?" check that silently ate the
          // keystroke it was asked about would be a bug nobody would find by
          // reading the caller. Nothing in this register has a side effect.
          2'd1:    rmux = {21'd0, usb_conerr, usb_typ, mods_live};
          default: rmux = 32'd0;
      endcase

  logic [31:0] rdata_q;
  always_ff @(posedge clk)
      if (sel_rd) rdata_q <= rmux;

  assign rdata = rdata_q;

  wire _unused = &{1'b0, we};

endmodule

`default_nettype wire
