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
//   +0x08  R  {ovf2, avail2, code[7:0]} — LINUX'S PORT. Same layout as +0x00
//             and it POPS the same way, but over its OWN read pointer and its
//             OWN overflow bit. Two consumers, one stream of keystrokes: the
//             firmware feeds hvc0 from +0x00 and sw/linux/koti_kbd.c feeds
//             /dev/input/eventN from here, exactly as a PC delivers a keypress
//             to the console and to evdev at the same time.
//             ⛔ NEITHER PORT CAN STALL THE WRITER. A reader more than 8 behind
//             is lapped (port 2) or has its oldest entry dropped (port 1), and
//             ovf2/ovf says so. That is the shipped policy; the point is that a
//             console nobody reads must not be able to kill the keyboard for
//             the other consumer, which is what test 6b guards.
//             ⚠️ HISTORY, because it will look like flip-flopping otherwise.
//             Stalling was briefly restored on 2026-08-09 to contain what looked
//             like a keystroke flood holding the PLIC line high and starving
//             userspace. It was not a flood: the real cause was `mip.SEIP` in
//             csr.sv latching the PLIC pin through a read-modify-write, so the
//             interrupt never went away no matter what this FIFO did. With that
//             fixed (def5699, verified: 253 keystrokes, 705/705 samples with
//             SEIP clear) the containment is unnecessary and the stronger
//             property is back. `KOTI_KBD_STALL_ON_FULL` still selects the old
//             behaviour, for A/B use. See `drop1`.
//             ⚠️ The PLIC interrupt follows THIS port, not +0x00.
//   +0x0C  R  keystrokes OFFERED since reset, free-running, no side effects.
//             Sample it twice a second apart and the difference is the SOURCE
//             RATE: ~125/s is a real keyboard, tens of thousands is the core
//             free-running. That number is what decides where the bug is.
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

    output logic       kb_avail_irq,      // level: something is queued
    // One pulse per keystroke actually ENQUEUED. A level says whether the
    // queue is occupied right now, which on a healthy machine is a microsecond
    // per key and invisible; this says whether keystrokes are being produced
    // AT ALL. Counting it outside is what tells "the diff dropped the key"
    // apart from "the driver took it and Linux lost it later".
    output logic       dbg_enq,
    // One pulse per report that CONTAINS AT LEAST ONE KEY. Paired with dbg_enq
    // this splits the only two ways the enqueue can stop while the USB core is
    // still delivering reports:
    //   keyed reports arriving, nothing enqueued -> is_new() is rejecting
    //      everything, i.e. the p1..p4 baseline is stuck holding keys that are
    //      no longer held, so every press looks like a repeat.
    //   no keyed reports at all -> the core is sending EMPTY reports while keys
    //      are down, and the fault is in the vendored host, not in the diff.
    output logic       dbg_keyrep
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

  // ⛔ A FULL PORT 1 MUST NOT STALL THE WRITER — fixed 2026-08-09.
  // `f_full` used to gate the enqueue itself, so a firmware that stopped
  // reading filled the queue and then blocked every further keystroke for BOTH
  // readers. That is not a corner case: hvc0's consumer only runs while hvc0
  // has a tty attached, and hvc0 is a console nothing needs any more, because
  // the UART is transmit-only and the screen is what Linux owns. The symptom
  // on the bench was a keyboard that worked for a dozen keys and then died
  // completely, on both consoles at once, permanently, and was not revived by
  // unplugging the keyboard — because the keystrokes were never enqueued.
  //
  // The policy is now the one PORT 2 ALREADY HAD and states in its own header:
  // a reader that has stopped loses events and is told so through `ovf`,
  // rather than stalling the machine for the other reader. Test 5 guaranteed
  // this in one direction only; test 6b is the converse, and it fails on the
  // old behaviour with exactly 8 keystrokes delivered — the FIFO depth.
  //
  // Dropping is suppressed on a cycle that also pops: the pop frees the slot,
  // so there is nothing to drop and `rptr` must move only once.
  wire enq1   = diff_run && !new_report && is_new(cand);

  // ⚗️ KOTI_KBD_STALL_ON_FULL restores the PRE-2026-08-09 behaviour: the writer
  // stalls when port 1 is full instead of dropping the oldest entry. It exists
  // for one experiment, and the experiment is a suspicion about the fix above.
  //
  // A stalled writer lets port 2 DRAIN TO EMPTY, which drops `kb_avail_irq` and
  // makes an interrupt storm impossible — the keyboard dies but the machine
  // keeps running. Drop-oldest never stops the writer, so if entries arrive
  // faster than the driver drains, that level line never falls and the kernel
  // cycles through the PLIC handler for ever, starving userspace. Both look
  // identical from the chair; only one kills the machine.
  //
  // ⚖️ Neither policy is right on its own. Stalling lets a console nobody reads
  // kill the keyboard for BOTH consumers (test 6b fails on it, at exactly the
  // FIFO depth). Dropping cannot stall but cannot stop a storm either. "The
  // writer must never stall" and "a level-triggered queue must never stay
  // non-empty" cannot both be satisfied here, which is the signal that the real
  // fix is UPSTREAM: stop enqueuing keystrokes nobody pressed.
  //
  // ⛔ Diagnostic only. CI builds and tb_usb_kbd run WITHOUT it, so test 6b
  // keeps guarding the shipped behaviour.
`ifdef KOTI_KBD_STALL_ON_FULL
  wire enq_allowed = !f_full;
  wire drop1       = 1'b0;
`else
  wire enq_allowed = 1'b1;
  wire drop1       = enq1 && f_full && !pop;
`endif

  // The source rate, counted whether or not the entry is stored. See register 3.
  logic [31:0] enq_count;
  always_ff @(posedge clk)
      if (rst)       enq_count <= 32'd0;
      else if (enq1) enq_count <= enq_count + 32'd1;

  // ---- port 2: a SECOND, INDEPENDENT READER (added 2026-08-08) ------------
  // WHY. Reading register 0 POPS, and koti's M-mode SBI firmware is its
  // consumer — that is what feeds `hvc0` and makes the login prompt typeable.
  // A Linux input driver would be a SECOND consumer of a single-consumer
  // queue, and the two would split the keystrokes between them. Two
  // independent read pointers over the same entries is what a real PC does:
  // one keypress reaches the console AND /dev/input/eventN.
  //
  // ⛔ PORT 2 IS STRICTLY PASSIVE AND MUST STAY THAT WAY. It has its own
  // pointer and its own overflow flag, and it CANNOT influence `wptr`, `rptr`,
  // `ovf` or `f_full`.
  // The hazard this avoids is specific and would have been nasty: if "full"
  // were computed against the laggier of the two readers, then a Linux driver
  // that stopped draining (nothing has the evdev node open, say) would fill
  // the FIFO and starve the FIRMWARE — and the symptom would be a login prompt
  // that stops accepting keys because of a feature that was supposed to be
  // additive.
  //
  // ⚠️ THIS WAS ONLY HALF THE PROPERTY, AND THE MISSING HALF WAS THE BUG.
  // Port 1 could still stall the writer by filling up, which killed BOTH
  // consoles — a worse outcome than the one guarded against here, and the more
  // likely one, since hvc0's consumer is the one with no reason to keep
  // running. Fixed 2026-08-09 at the `drop1` block above; test 5 and test 6b
  // in test/tb_usb_kbd.v now pin both directions.
  //
  // The cost is that port 2 can be LAPPED: the writer may overwrite entries it
  // has not read. That is the correct trade — a slow observer loses events and
  // is told so, rather than stalling the machine.
  logic [3:0] rptr2;
  logic       ovf2;
  wire        f_empty2 = (wptr == rptr2);
  wire        pop2     = sel_rd && (reg_a == 2'd2) && !f_empty2;
  // How far behind the writer port 2 is. Only the newest 8 entries still
  // exist, so anything beyond that has been overwritten.
  wire [3:0]  lag2    = wptr - rptr2;
  wire        lapped2 = (lag2 > 4'd8);

  always_ff @(posedge clk)
      if (rst) begin
          wptr <= 4'd0; rptr <= 4'd0; ovf <= 1'b0;
          rptr2 <= 4'd0; ovf2 <= 1'b0;
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
                  // Enqueue. When the queue is full the OLDEST entry is dropped
                  // instead (`drop1` advances `rptr` below), which is safe to
                  // write here because f_full means wptr[2:0] and rptr[2:0] are
                  // equal — the slot being overwritten IS the oldest one, and
                  // the reader is moved past it in the same cycle.
                  // Under KOTI_KBD_STALL_ON_FULL `enq_allowed` is `!f_full` and
                  // this becomes the old refuse-and-flag behaviour instead.
                  if (enq_allowed) begin
                      fifo[wptr[2:0]] <= cand;
                      wptr <= wptr + 4'd1;
                  end else
                      ovf <= 1'b1;
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

          if (pop || drop1) rptr <= rptr + 4'd1;
          if (drop1)   ovf <= 1'b1;      // and it is told, like port 2
          else if (pop) ovf <= 1'b0;     // sticky until read

          // Port 2, kept entirely separate from the block above on purpose.
          // Resync BEFORE the pop so a lapped reader cannot also consume a
          // stale slot in the same cycle: it lands on the oldest entry that
          // still exists rather than on one that was overwritten under it.
          if (lapped2) begin
              rptr2 <= wptr - 4'd8;
              ovf2  <= 1'b1;
          end else if (pop2) begin
              rptr2 <= rptr2 + 4'd1;
              ovf2  <= 1'b0;             // sticky until read, like ovf
          end
      end

  // ⭐ THE INTERRUPT FOLLOWS PORT 2, NOT PORT 1, and that is deliberate.
  // This line goes to the PLIC, the PLIC drives `seip`, and `seip` is
  // SUPERVISOR external — i.e. it exists to interrupt LINUX. The firmware
  // never uses it: `console_getchar` polls register 0 when Linux asks it to.
  // Tying it to port 1 would mean the firmware draining its own queue lowered
  // the interrupt line for a driver whose queue was still full.
  assign kb_avail_irq = !f_empty2;

  // Observation only. `dbg_keyrep` samples the RAW inputs at the crossing edge
  // rather than k1..k4, which are latched by this very edge and therefore still
  // hold the previous report on the cycle new_report is high.
  assign dbg_enq    = enq1;
  assign dbg_keyrep = new_report
                   && |{usb_key1, usb_key2, usb_key3, usb_key4};

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
          // ⭐ THE POINTERS RIDE IN THE SPARE BITS, and they answer the question
          // left standing on 2026-08-09: with the producer provably idle
          // (nq frozen) the queue still held entries nobody took, so WHO is not
          // moving? Reading them here costs nothing — this register already has
          // 21 unused bits and no side effects, and the profiler already prints
          // it as `st=`, so no new register and no new print.
          //   [14:11] wptr   the writer. Frozen == the source really has stopped.
          //   [18:15] rptr2  LINUX's reader. **Frozen while wptr is ahead means
          //                  koti_kbd is not popping at all** — and given how
          //                  prominent __irq_resolve_mapping is in the storm's
          //                  PC profile, that would mean the interrupt is being
          //                  dispatched but never reaching our handler.
          //   [22:19] rptr   the firmware's reader, for comparison.
          2'd1:    rmux = {9'd0, rptr, rptr2, wptr,
                           usb_conerr, usb_typ, mods_live};
          // Port 2 — the Linux input driver's own view of the same keystrokes.
          // Same layout as register 0 and it POPS the same way, but its own
          // pointer and its own overflow bit. See the port-2 block above for
          // why it cannot disturb register 0.
          2'd2:    rmux = {22'd0, ovf2, !f_empty2,
                           f_empty2 ? 8'd0 : fifo[rptr2[2:0]]};
          // ⭐ KEYSTROKES OFFERED, free-running, no side effects. The number the
          // whole 2026-08-09 hunt turned on and never had: how FAST is the USB
          // path producing keystrokes? A lamp can say "rolling"; only a counter
          // sampled twice can say 125/s (a real keyboard, so the fault is
          // elsewhere) or 50000/s (the core free-running, which is the theory).
          //
          // ⚠️ It counts ATTEMPTS (`enq1`), not successful writes, on purpose:
          // under the stall policy the writes stop at a full queue while the
          // SOURCE keeps producing, and the source is what is being measured.
          2'd3:    rmux = enq_count;
          default: rmux = 32'd0;
      endcase

  logic [31:0] rdata_q;
  always_ff @(posedge clk)
      if (sel_rd) rdata_q <= rmux;

  assign rdata = rdata_q;

  wire _unused = &{1'b0, we};

endmodule

`default_nettype wire
