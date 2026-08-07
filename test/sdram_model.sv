// sdram_model.sv — behavioural SDR SDRAM, strict enough to be worth testing
// against.
//
// A model that just stores what it is told proves nothing: the bugs in an SDRAM
// controller are protocol bugs, and a permissive model passes them all. This
// one refuses instead — it fails the simulation on a READ or WRITE to a bank
// with no open row, on any access before the mode register is loaded, on a
// mode register that does not match what the controller claims to implement,
// and on an auto-refresh that arrives with a row still open. Those are exactly
// the mistakes that produce a controller which works in simulation and corrupts
// memory on the board.
//
// Reduced address space on purpose: {bank, row[6:0], col} rather than the full
// 24 bits, so the array is 512 KB instead of 32 MB. Wide enough to exercise all
// four banks and 128 distinct rows, which is what a mapping bug shows up in.
//
// ⚠️ 512 KB is the ARRAY, not the contiguous span. sdram_ctrl maps
// row = addr[20:8] on a 32-bit-word address, so the row[7] dropped here is word
// bit 15 = BYTE offset 0x20000: a contiguous walk aliases after 128 KB, and the
// bank bits that make up the rest of the 512 KB only change at byte offset 8 MB.
// Choose a test window inside 128 KB or expect every word to come back as the
// value written 128 KB higher (measured by sw/memtest.c, 2026-08-07).

`default_nettype none
`timescale 1ns / 1ps

module sdram_model #(
    parameter int CL = 2
) (
    input  wire        clk,
    input  wire        cke,
    input  wire        csn,
    input  wire        rasn,
    input  wire        casn,
    input  wire        wen,
    input  wire [12:0] a,
    input  wire [1:0]  ba,
    input  wire [1:0]  dqm,
    input  wire [15:0] din,        // from the controller
    input  wire        doe,        // controller is driving
    output reg  [15:0] dout,       // to the controller
    output reg         dout_oe
);

  localparam logic [12:0] EXPECT_MODE = 13'b000_1_00_010_0_001;  // BL2, CL2, single write

  reg [15:0] mem [0:262143];       // {ba[1:0], row[6:0], col[8:0]}
  reg [12:0] open_row [0:3];
  reg        row_open [0:3];
  reg        initialised;

  // read pipeline: a READ issued now delivers its first word CL clocks later
  reg [15:0] pipe_d [0:7];
  reg        pipe_v [0:7];

  reg [8:0]  burst_col;
  reg [1:0]  burst_ba;
  reg [1:0]  burst_left;
  reg        burst_ap;

  integer    nxwarn;               // x/z-store reports emitted so far

  integer i;

  function automatic [17:0] idx(input [1:0] b, input [12:0] r, input [8:0] c);
    idx = {b, r[6:0], c};
  endfunction

  wire [3:0] cmd = {csn, rasn, casn, wen};
  localparam [3:0] C_NOP = 4'b0111, C_ACT = 4'b0011, C_RD = 4'b0101,
                   C_WR  = 4'b0100, C_PRE = 4'b0010, C_REF = 4'b0001,
                   C_MRS = 4'b0000;

  initial begin
    // Power up with DEFINED contents. Real SDRAM comes up holding arbitrary
    // bits, not x, and the difference is not cosmetic: an unwritten location
    // read as x propagates straight through the CPU into `d_req`, the arbiter's
    // grant register latches x, and the whole SoC wedges — with both acks clean
    // and nothing pointing at memory. The QSPI model this replaced returned
    // zeros from a bytearray and so never showed the problem.
    for (i = 0; i < 262144; i = i + 1) mem[i] = 16'h0000;
    initialised = 1'b0;
    dout_oe = 1'b0;
    dout = 16'd0;
    burst_left = 2'd0;
    nxwarn = 0;
    for (i = 0; i < 4; i = i + 1) begin
      row_open[i] = 1'b0;
      open_row[i] = 13'd0;
    end
    for (i = 0; i < 8; i = i + 1) pipe_v[i] = 1'b0;
  end

  always @(posedge clk) begin
    // advance the CL pipeline
    dout_oe <= pipe_v[0];
    dout    <= pipe_d[0];
    for (i = 0; i < 7; i = i + 1) begin
      pipe_v[i] <= pipe_v[i+1];
      pipe_d[i] <= pipe_d[i+1];
    end
    pipe_v[7] <= 1'b0;

    if (cke && csn === 1'b0) begin
      case (cmd)
        C_MRS: begin
          if (a !== EXPECT_MODE) begin
            $display("SDRAM MODEL: mode register %b, expected %b", a, EXPECT_MODE);
            $fatal(1);
          end
          initialised <= 1'b1;
        end

        C_ACT: begin
          if (row_open[ba])
            $display("SDRAM MODEL: WARNING ACTIVE on bank %0d with row already open", ba);
          open_row[ba] <= a;
          row_open[ba] <= 1'b1;
        end

        C_PRE: begin
          if (a[10]) begin
            for (i = 0; i < 4; i = i + 1) row_open[i] <= 1'b0;
          end else begin
            row_open[ba] <= 1'b0;
          end
        end

        C_REF: begin
          for (i = 0; i < 4; i = i + 1)
            if (row_open[i]) begin
              $display("SDRAM MODEL: AUTO REFRESH with bank %0d still open", i);
              $fatal(1);
            end
        end

        C_RD: begin
          if (!initialised) begin
            $display("SDRAM MODEL: READ before the mode register was loaded");
            $fatal(1);
          end
          if (!row_open[ba]) begin
            $display("SDRAM MODEL: READ on bank %0d with no open row", ba);
            $fatal(1);
          end
          // Burst length 2, sequential, from an even column.
          //
          // CL is counted in clocks from the edge at which the part samples the
          // READ (this one) to the edge at which the controller may sample the
          // first word. `dout` is registered off pipe_d[0], so a word placed at
          // pipe_d[0] now becomes dout at the next edge and is therefore
          // sampleable one edge after that — CL=2. Indexing at [CL-1] instead
          // makes the model a clock SLOWER than the real part, which is the
          // dangerous direction: the controller gets tuned to the model, works
          // in simulation, and reads the wrong word on hardware.
          pipe_d[CL-2] <= mem[idx(ba, open_row[ba], a[8:0])];
          pipe_v[CL-2] <= 1'b1;
          pipe_d[CL-1] <= mem[idx(ba, open_row[ba], a[8:0] | 9'd1)];
          pipe_v[CL-1] <= 1'b1;
          if (a[10]) row_open[ba] <= 1'b0;         // auto-precharge
        end

        C_WR: begin
          if (!initialised) begin
            $display("SDRAM MODEL: WRITE before the mode register was loaded");
            $fatal(1);
          end
          if (!row_open[ba]) begin
            $display("SDRAM MODEL: WRITE on bank %0d with no open row", ba);
            $fatal(1);
          end
          // Check the BUS, not the controller's enable. `doe` is only
          // meaningful when the model sits directly on the controller; in the
          // full harness the tri-state is resolved a level up and doe is tied
          // off, so keying the warning on it cried wolf on every write. What
          // actually matters is whether real data arrived.
          //
          // And check it PER LANE, only where DQM lets the byte through. The
          // whole-bus version cried wolf a second time, for a subtler reason:
          // on a byte store the CPU drives one lane and masks the other, and
          // what it leaves on the masked half is nobody's business. Every `sb`
          // therefore printed a warning about data that is deliberately
          // discarded — which is worse than no check, because a warning that
          // fires on correct behaviour is one you learn to scroll past.
          if ((!dqm[0] && (^din[7:0] === 1'bx))
              || (!dqm[1] && (^din[15:8] === 1'bx))) begin
            if (nxwarn == 0)
              $display("SDRAM MODEL: NOTE x/z reaching an UNMASKED byte. Some of this is expected: a C prologue spills callee-saved registers before anything has initialised them, which is real garbage on silicon and x here. Every occurrence in the koti harness so far has been a stack address. Worry when the address is not one.");
            if (nxwarn < 8)
              $display("SDRAM MODEL: x/z stored: ba=%0d row=%0d col=%0d din=%h dqm=%b",
                       ba, open_row[ba], a[8:0], din, dqm);
            if (nxwarn == 8)
              $display("SDRAM MODEL: (further x/z-store reports suppressed)");
            nxwarn <= nxwarn + 1;
          end
          // DQM is active high and masks the byte out
          if (!dqm[0]) mem[idx(ba, open_row[ba], a[8:0])][7:0]  <= din[7:0];
          if (!dqm[1]) mem[idx(ba, open_row[ba], a[8:0])][15:8] <= din[15:8];
          if (a[10]) row_open[ba] <= 1'b0;         // auto-precharge
        end

        default: ;
      endcase
    end
  end

endmodule

`default_nettype wire
