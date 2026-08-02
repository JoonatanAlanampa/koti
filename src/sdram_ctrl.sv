// sdram_ctrl.sv — SDR SDRAM controller for the ULX3S's onboard 32 MB.
//
// WHY THIS EXISTS. Koti's memory has always been the QSPI Pmod: 8 MB of PSRAM
// reached one serial transaction at a time, ~130 clocks for a 64-bit burst in
// 1-bit mode. That is survivable for a demo and hopeless for a machine you sit
// down at — it is the difference between a boot you time with a stopwatch and
// one you do not. The ULX3S has 32 MB of 16-bit SDRAM soldered on, and once
// koti stopped being a tapeout target (2026-08-02) there was no longer a reason
// to pretend the pins do not exist.
//
// PROTOCOL. Deliberately identical to qspi_ctrl's, so this is a drop-in
// alternative rather than a new interface to teach the SoC: master holds `req`
// until the 1-cycle `ack`; `rdata` (and `rdata2` on a burst) are valid during
// that ack; `wdata` bytes arrive pre-shifted into lane position and `be` marks
// which of them to store.
//
// SHAPE, AND WHY IT IS THE SIMPLE ONE. Every access is ACTIVE -> READ/WRITE
// with auto-precharge, one 32-bit word at a time; a burst is just two of those
// back to back. That leaves performance on the table — an open-row policy would
// save the re-ACTIVE, and a longer SDRAM burst would fetch both words in one
// command — but at 25 MHz a whole access is about 8 clocks against QSPI's ~130,
// so the simple version already wins by more than an order of magnitude. The
// clever version can come later, against a working reference and a passing
// test suite, which is the only sane order to attempt it in.
//
// The 4-word-burst trap this avoids: an SDR burst of 4 is ordered within a
// 4-aligned block, so a read of words N and N+1 where N is odd comes back in
// the wrong order. Burst length 2 with an even column can never hit that.
//
// TIMING. At 25 MHz one clock is 40 ns and essentially every SDRAM constraint
// (tRCD, tRP ~15-20 ns; tRC, tRFC ~60-70 ns) collapses to one or two clocks.
// The parameters below are therefore generous rather than tuned, and they are
// expressed in nanoseconds so that raising CLK_HZ recomputes them instead of
// silently violating them.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module sdram_ctrl #(
    parameter int CLK_HZ  = 25_000_000,
    parameter int T_RCD_NS = 20,      // ACTIVE -> READ/WRITE
    parameter int T_RP_NS  = 20,      // PRECHARGE -> ACTIVE
    parameter int T_RFC_NS = 70,      // AUTO REFRESH cycle
    parameter int T_MRD_NS = 20,      // LOAD MODE -> next command
    parameter int T_INIT_US = 200,    // power-up wait before any command
    parameter int T_REFI_NS = 7800    // 64 ms / 8192 rows
) (
    input  logic        clk,
    input  logic        rst,

    // ---- request port (same contract as qspi_ctrl) ----
    input  logic        req,
    input  logic        we,
    input  logic        burst,      // read 64 bits: rdata = @addr, rdata2 = @addr+1
    input  logic [22:0] addr,       // 32-bit word address (8M words = 32 MB)
    input  logic [31:0] wdata,      // bytes pre-shifted into lane position
    input  logic [3:0]  be,
    output logic        ack,
    output logic [31:0] rdata,
    output logic [31:0] rdata2,

    // ---- SDRAM pins (tristate resolved by the caller, as qspi_ctrl does) ----
    output logic        sdram_cke,
    output logic        sdram_csn,
    output logic        sdram_rasn,
    output logic        sdram_casn,
    output logic        sdram_wen,
    output logic [12:0] sdram_a,
    output logic [1:0]  sdram_ba,
    output logic [1:0]  sdram_dqm,
    output logic [15:0] sdram_dout,
    output logic        sdram_doe,  // 1 = drive sdram_d
    input  logic [15:0] sdram_din
);

  // ---------------------------------------------------------------- timing
  // +1 on each: a constraint of N ns needs ceil(N/period) clocks, and the
  // integer division below truncates. Being one clock slow costs nothing at
  // 25 MHz; being one clock fast corrupts memory.
  localparam int NS_PER_CLK = 1_000_000_000 / CLK_HZ;
  localparam int C_RCD  = T_RCD_NS  / NS_PER_CLK + 1;
  localparam int C_RP   = T_RP_NS   / NS_PER_CLK + 1;
  localparam int C_RFC  = T_RFC_NS  / NS_PER_CLK + 1;
  localparam int C_MRD  = T_MRD_NS  / NS_PER_CLK + 1;
  localparam int C_INIT = (T_INIT_US * 1000) / NS_PER_CLK + 1;
  localparam int C_REFI = T_REFI_NS / NS_PER_CLK;
  localparam int CL     = 2;                 // CAS latency, set in the MR below

  // Mode register: burst length 2 (A2:A0=001), sequential (A3=0),
  // CAS latency 2 (A6:A4=010), standard operation (A8:A7=00),
  // single-location writes (A9=1). Single writes matter: with a burst write
  // the second half-word of a 32-bit store would have to be masked off, and
  // DQM timing on writes is the classic place to get SDRAM subtly wrong.
  localparam logic [12:0] MODE_REG = 13'b000_1_00_010_0_001;

  // ---------------------------------------------------------------- commands
  // {csn, rasn, casn, wen}
  localparam logic [3:0] CMD_NOP      = 4'b0111;
  localparam logic [3:0] CMD_ACTIVE   = 4'b0011;
  localparam logic [3:0] CMD_READ     = 4'b0101;
  localparam logic [3:0] CMD_WRITE    = 4'b0100;
  localparam logic [3:0] CMD_PRECHG   = 4'b0010;
  localparam logic [3:0] CMD_REFRESH  = 4'b0001;
  localparam logic [3:0] CMD_LOADMODE = 4'b0000;

  logic [3:0] cmd;
  assign {sdram_csn, sdram_rasn, sdram_casn, sdram_wen} = cmd;

  // ---------------------------------------------------------------- address map
  // A 32-bit word is two consecutive 16-bit columns, so the column always
  // starts even and a burst of 2 delivers {low, high} in that order.
  //   bank = addr[22:21]   row = addr[20:8]   col = {addr[7:0], 1'b0}
  // 2 x 13 x 9 bits of 16-bit words = 32 MB, which is the whole part.
  wire [1:0]  a_bank = addr[22:21];
  wire [12:0] a_row  = addr[20:8];
  wire [8:0]  a_col  = {addr[7:0], 1'b0};

  // Second word of a burst, computed on the full word address so that a burst
  // crossing a row or bank boundary still lands in the right place. It costs a
  // full ACTIVE either way, so there is no reason to special-case staying in
  // the row.
  wire [22:0] addr2  = addr + 23'd1;
  wire [1:0]  b_bank = addr2[22:21];
  wire [12:0] b_row  = addr2[20:8];
  wire [8:0]  b_col  = {addr2[7:0], 1'b0};

  // ---------------------------------------------------------------- state
  typedef enum logic [3:0] {
    S_INIT_WAIT, S_INIT_PRE, S_INIT_REF1, S_INIT_REF2, S_INIT_MODE, S_INIT_MRD,
    S_IDLE, S_ACT, S_RCD, S_RD, S_RD_WAIT, S_WR_LO, S_WR_HI, S_DONE, S_REFRESH
  } state_t;

  state_t st;
  logic [15:0] tmr;            // one shared down-counter; only one wait at a time
  logic        second;         // servicing the second word of a burst
  logic        rd_phase;       // which half-word of the pair is arriving
  logic [31:0] cap, cap2;
  logic [15:0] refi;
  logic        ref_pending;

  // Registered request context. Latched at accept so the master may drop its
  // inputs the moment it sees ack, and so `second` can re-point the address
  // without the master having to hold addr+1.
  logic        r_we, r_burst;
  logic [31:0] r_wdata;
  logic [3:0]  r_be;

  // Handshake guard. `ack` is registered, so on the clock the master finally
  // sees it the master is still driving `req` — it cannot possibly have
  // reacted yet. Without this flag S_IDLE samples that stale `req` and runs the
  // whole access a second time: harmless-looking on a write (it stores the same
  // bytes again) and quietly wrong everywhere else. Found by a cycle-by-cycle
  // trace showing a WRITE command during what should have been a read.
  logic        acked;

  wire [1:0]  cur_bank = second ? b_bank : a_bank;
  wire [12:0] cur_row  = second ? b_row  : a_row;
  wire [8:0]  cur_col  = second ? b_col  : a_col;

  assign rdata  = cap;
  assign rdata2 = cap2;

  // Refresh interval. Free-running: the counter never waits for the bus, so a
  // long stall cannot push refreshes late enough to lose a row.
  always_ff @(posedge clk)
    if (rst) begin
      refi <= '0;
      ref_pending <= 1'b0;
    end else begin
      if (refi >= C_REFI[15:0]) begin
        refi <= '0;
        ref_pending <= 1'b1;
      end else begin
        refi <= refi + 16'd1;
      end
      if (st == S_REFRESH) ref_pending <= 1'b0;
    end

  always_ff @(posedge clk) begin
    if (rst) begin
      st         <= S_INIT_WAIT;
      tmr        <= C_INIT[15:0];
      cmd        <= CMD_NOP;
      sdram_cke  <= 1'b0;
      sdram_a    <= '0;
      sdram_ba   <= '0;
      sdram_dqm  <= 2'b11;      // masked until initialised
      sdram_dout <= '0;
      sdram_doe  <= 1'b0;
      ack        <= 1'b0;
      second     <= 1'b0;
      rd_phase   <= 1'b0;
      cap        <= '0;
      cap2       <= '0;
      r_we       <= 1'b0;
      r_burst    <= 1'b0;
      r_wdata    <= '0;
      r_be       <= '0;
      acked      <= 1'b0;
    end else begin
      cmd       <= CMD_NOP;
      ack       <= 1'b0;
      sdram_doe <= 1'b0;
      if (tmr != 0) tmr <= tmr - 16'd1;
      if (!req) acked <= 1'b0;      // master has let go; the next req is real

      unique case (st)
        // ---- power-up: CKE low through the whole wait, then NOPs ----
        S_INIT_WAIT: begin
          sdram_cke <= 1'b1;
          if (tmr == 0) begin
            cmd     <= CMD_PRECHG;
            sdram_a <= 13'h0400;      // A10 = 1: precharge ALL banks
            tmr     <= C_RP[15:0];
            st      <= S_INIT_PRE;
          end
        end
        S_INIT_PRE: if (tmr == 0) begin
          cmd <= CMD_REFRESH;
          tmr <= C_RFC[15:0];
          st  <= S_INIT_REF1;
        end
        S_INIT_REF1: if (tmr == 0) begin
          cmd <= CMD_REFRESH;         // the spec asks for at least two
          tmr <= C_RFC[15:0];
          st  <= S_INIT_REF2;
        end
        S_INIT_REF2: if (tmr == 0) begin
          cmd      <= CMD_LOADMODE;
          sdram_a  <= MODE_REG;
          sdram_ba <= 2'b00;
          tmr      <= C_MRD[15:0];
          st       <= S_INIT_MODE;
        end
        S_INIT_MODE: if (tmr == 0) st <= S_INIT_MRD;
        S_INIT_MRD: begin
          sdram_dqm <= 2'b00;         // unmask: the part is ready
          st        <= S_IDLE;
        end

        // ---- idle: refresh first, then work ----
        S_IDLE: begin
          second <= 1'b0;
          if (ref_pending) begin
            cmd <= CMD_REFRESH;
            tmr <= C_RFC[15:0];
            st  <= S_REFRESH;
          end else if (req && !acked) begin
            r_we    <= we;
            r_burst <= burst;
            r_wdata <= wdata;
            r_be    <= be;
            st      <= S_ACT;
          end
        end

        S_REFRESH: if (tmr == 0) st <= S_IDLE;

        // ---- one 32-bit access ----
        S_ACT: begin
          cmd      <= CMD_ACTIVE;
          sdram_ba <= cur_bank;
          sdram_a  <= cur_row;
          tmr      <= C_RCD[15:0] - 16'd1;
          st       <= S_RCD;
        end

        S_RCD: if (tmr == 0) begin
          sdram_ba <= cur_bank;
          if (r_we) begin
            // A10 = 0: NO auto-precharge on the low half-word. The row has to
            // stay open for the high half-word that follows, and a controller
            // that precharges here reads back garbage in the top 16 bits.
            sdram_a    <= {4'b0000, cur_col};
            cmd        <= CMD_WRITE;
            sdram_dout <= r_wdata[15:0];
            sdram_doe  <= 1'b1;
            // DQM is the byte-enable on a write, and it is ACTIVE HIGH: a 1
            // masks the byte out. Inverting `be` here is the whole of write
            // byte-enable support.
            sdram_dqm  <= ~r_be[1:0];
            st         <= S_WR_LO;
          end else begin
            // A10 = 1: auto-precharge. The column occupies A8:A0; A9 and
            // A12:A11 are don't-care. Note the width — {3'b001, cur_col} is
            // twelve bits into a thirteen-bit port, which zero-extends and puts
            // the 1 on A9 instead of A10. Auto-precharge then silently never
            // happens, rows stay open, and the only symptom is a model
            // complaining about ACTIVE on an open bank.
            sdram_a  <= {4'b0010, cur_col};
            cmd      <= CMD_READ;
            rd_phase <= 1'b0;
            // CL is counted from the clock at which the PART samples the READ,
            // which is one after the clock this controller registers it on.
            tmr      <= CL[15:0] - 16'd1;
            st       <= S_RD;
          end
        end

        // Single-location writes (MR A9=1), so the high half-word needs its own
        // WRITE command. Auto-precharge is asserted only on the second, or the
        // row would close underneath it.
        S_WR_LO: begin
          sdram_ba   <= cur_bank;
          sdram_a    <= {4'b0010, cur_col | 9'd1};   // A10 = 1: close the row now
          cmd        <= CMD_WRITE;
          sdram_dout <= r_wdata[31:16];
          sdram_doe  <= 1'b1;
          sdram_dqm  <= ~r_be[3:2];
          tmr        <= C_RP[15:0];
          st         <= S_WR_HI;
        end
        S_WR_HI: begin
          sdram_dqm <= 2'b00;
          if (tmr == 0) st <= S_DONE;
        end

        // CL clocks after the READ the first half-word appears, then the
        // second on the next clock (burst length 2).
        S_RD: if (tmr == 0) begin
          st <= S_RD_WAIT;
        end
        S_RD_WAIT: begin
          rd_phase <= ~rd_phase;
          if (!rd_phase) begin
            if (second) cap2[15:0]  <= sdram_din;
            else        cap[15:0]   <= sdram_din;
          end else begin
            if (second) cap2[31:16] <= sdram_din;
            else        cap[31:16]  <= sdram_din;
            tmr <= C_RP[15:0];
            st  <= S_DONE;
          end
        end

        S_DONE: if (tmr == 0) begin
          // A burst is two accesses; only the second one acks. Writes ignore
          // `burst` entirely — the SoC never issues one.
          if (r_burst && !r_we && !second) begin
            second <= 1'b1;
            st     <= S_ACT;
          end else begin
            ack   <= 1'b1;
            acked <= 1'b1;
            st    <= S_IDLE;
          end
        end

        default: st <= S_IDLE;
      endcase
    end
  end

endmodule

`default_nettype wire
