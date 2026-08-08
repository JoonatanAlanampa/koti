// arbiter3.sv — 3:1 memory arbiter for Koti-1: video DMA (highest —
// hard real-time line-buffer refills), then data (the pipeline is
// frozen on it), then instruction fetch. Grant is held until the
// controller acks. Video and fetch are always pair-read bursts.
//
// Worst-case video latency: one in-flight transaction (grant is not
// preempted) — a serial-mode 64-bit burst, ~132 clk. The row-fetch
// budget in vga_text.sv absorbs this with an order of magnitude to
// spare.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module mem_arbiter3 (
    input  logic        clk,
    input  logic        rst,

    // video port (read-only, burst)
    input  logic        v_req,
    input  logic [23:0] v_addr,
    output logic        v_ack,

    // instruction fetch port (burst)
    input  logic        f_req,
    input  logic [23:0] f_addr,
    output logic        f_ack,

    // data port
    input  logic        d_req,
    input  logic        d_we,
    input  logic [23:0] d_addr,
    input  logic [31:0] d_wdata,
    input  logic [3:0]  d_be,
    output logic        d_ack,

    // downstream (qspi_ctrl)
    output logic        m_req,
    output logic        m_we,
    output logic        m_burst,
    output logic [23:0] m_addr,
    output logic [31:0] m_wdata,
    output logic [3:0]  m_be,
    input  logic        m_ack
);
    localparam [1:0] G_NONE = 2'd0, G_VID = 2'd1, G_DATA = 2'd2,
                     G_FETCH = 2'd3;

    logic [1:0] grant;

    // Release on a DROPPED request as well as on an ack (added 2026-08-04,
    // found while booting Linux). `m_req` below IS whichever port holds the
    // grant, so `!m_req` in a granted state means that requester walked away
    // before it was served — and the FETCH port does exactly that, every time
    // the pipeline flushes on a taken branch or a trap.
    //
    // Without this clause the arbiter sits holding a grant for a request that
    // no longer exists: m_req is low, so no controller starts a transaction,
    // so no ack ever arrives, so the grant is never released, and the machine
    // stops with the data port asking for something that can never be
    // forwarded. It is the same hazard project.sv already guards for the
    // FPGA build's device-select latch, one level further in — that comment
    // names the fetch port for the same reason.
    //
    // Safe against a transaction that HAS started: a controller only begins
    // while m_req is high and holds its own state afterwards, so releasing on
    // !m_req cannot cut one short. A late ack from an abandoned fetch lands
    // while grant is G_NONE and is simply discarded, which is what should
    // happen to an answer nobody is waiting for.
    always_ff @(posedge clk)
        if (rst)                  grant <= G_NONE;
        else if (grant == G_NONE) grant <= v_req ? G_VID
                                        : d_req ? G_DATA
                                        : f_req ? G_FETCH : G_NONE;
        else if (m_ack || !m_req) grant <= G_NONE;

    always_comb
        case (grant)
            G_VID:   begin m_req = v_req; m_addr = v_addr; end
            G_DATA:  begin m_req = d_req; m_addr = d_addr; end
            G_FETCH: begin m_req = f_req; m_addr = f_addr; end
            default: begin m_req = 1'b0;  m_addr = 24'd0;  end
        endcase

    assign m_we    = (grant == G_DATA) && d_we;
    assign m_burst = (grant == G_VID) || (grant == G_FETCH);
    assign m_wdata = d_wdata;
    assign m_be    = (grant == G_DATA) ? d_be : 4'b1111;
    assign v_ack   = (grant == G_VID)   && m_ack;
    assign d_ack   = (grant == G_DATA)  && m_ack;
    assign f_ack   = (grant == G_FETCH) && m_ack;
endmodule
