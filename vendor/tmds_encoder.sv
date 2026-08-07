`default_nettype none
//
// tmds_encoder.sv — DVI 1.0 TMDS encoder, PIPELINED IN THREE STAGES.
//
// Lifted verbatim out of gpdi_test_top.sv when rung 3 needed the same encoder:
// two copies of a DC-balance state machine is exactly the kind of duplication
// that goes subtly out of step and is then debugged twice. Both the rung-0
// colour-bar bitstream and the console's dvi_tx now instantiate THIS file, so
// the encoder that passed on the monitor is the encoder the console ships.
//
// Stage 1 minimises transitions (XOR or XNOR chain), stage 2 keeps the line
// DC-balanced with a running disparity counter. Done as one combinational run
// this misses 125 MHz badly - measured 90.28 MHz post-route on an 85F, because
// popcount -> 8-deep XOR chain -> popcount -> disparity compare is far more
// than 8 ns. The clock ENABLE does not help: static timing knows nothing about
// it and constrains every path at the full clock period.
//
// Splitting costs 3 pixels of latency, which is invisible and identical on all
// three channels, and there are 5 clocks per pixel to spend anyway.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

module tmds_encoder (
    input  wire        clk,
    input  wire        ce,
    input  wire        rst,
    input  wire [7:0]  d,
    input  wire [1:0]  c,
    input  wire        de,
    output reg  [9:0]  q
);
  // ---- stage 1: how many ones, and therefore XOR or XNOR
  wire [3:0] n1d = {3'b0, d[0]} + {3'b0, d[1]} + {3'b0, d[2]} + {3'b0, d[3]}
                 + {3'b0, d[4]} + {3'b0, d[5]} + {3'b0, d[6]} + {3'b0, d[7]};
  wire use_xnor_c = (n1d > 4'd4) || ((n1d == 4'd4) && (d[0] == 1'b0));

  reg [7:0] d1;
  reg       use_xnor, de1;
  reg [1:0] c1;
  always @(posedge clk) if (ce) begin
    d1 <= d; use_xnor <= use_xnor_c; de1 <= de; c1 <= c;
  end

  // ---- stage 2: the transition-minimised word, and its balance
  wire [8:0] qm_c;
  assign qm_c[0] = d1[0];
  genvar i;
  generate
    for (i = 1; i < 8; i = i + 1) begin : g_qm
      assign qm_c[i] = use_xnor ? ~(qm_c[i-1] ^ d1[i]) : (qm_c[i-1] ^ d1[i]);
    end
  endgenerate
  assign qm_c[8] = ~use_xnor;           // 1 = XOR was used, 0 = XNOR

  wire [3:0] n1q_c = {3'b0, qm_c[0]} + {3'b0, qm_c[1]} + {3'b0, qm_c[2]}
                   + {3'b0, qm_c[3]} + {3'b0, qm_c[4]} + {3'b0, qm_c[5]}
                   + {3'b0, qm_c[6]} + {3'b0, qm_c[7]};

  reg [8:0]        qm;
  reg signed [5:0] diff;
  reg              de2;
  reg [1:0]        c2;
  always @(posedge clk) if (ce) begin
    qm   <= qm_c;
    diff <= $signed({2'b00, n1q_c}) - $signed({2'b00, 4'd8 - n1q_c});
    de2  <= de1;
    c2   <= c1;
  end

  // ---- stage 3: DC balance and output
  reg signed [5:0] cnt;                 // running disparity

  always @(posedge clk) begin
    if (rst) begin
      cnt <= 6'sd0;
      q   <= 10'b1101010100;
    end else if (ce) begin
      if (!de2) begin
        // Control period: fixed words, and the disparity resets.
        cnt <= 6'sd0;
        case (c2)
          2'b00:   q <= 10'b1101010100;
          2'b01:   q <= 10'b0010101011;
          2'b10:   q <= 10'b0101010100;
          default: q <= 10'b1010101011;
        endcase
      end else if ((cnt == 6'sd0) || (diff == 6'sd0)) begin
        q[9]   <= ~qm[8];
        q[8]   <=  qm[8];
        q[7:0] <=  qm[8] ? qm[7:0] : ~qm[7:0];
        cnt    <=  qm[8] ? (cnt + diff) : (cnt - diff);
      end else if (((cnt > 6'sd0) && (diff > 6'sd0)) ||
                   ((cnt < 6'sd0) && (diff < 6'sd0))) begin
        q[9]   <= 1'b1;
        q[8]   <= qm[8];
        q[7:0] <= ~qm[7:0];
        cnt    <= cnt - diff + (qm[8] ? 6'sd2 : 6'sd0);
      end else begin
        q[9]   <= 1'b0;
        q[8]   <= qm[8];
        q[7:0] <= qm[7:0];
        cnt    <= cnt + diff - (qm[8] ? 6'sd0 : 6'sd2);
      end
    end
  end
endmodule
`default_nettype wire
