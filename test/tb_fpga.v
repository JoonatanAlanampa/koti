`default_nettype none
`timescale 1ns / 1ps

// tb_fpga — the ULX3S harness, not just the chip.
//
// Every other suite in this repo drives `tt_um_koti` directly, which means the
// logic BETWEEN the proven chip and the physical pins — the J1/J2 header
// permutation, the orientation straps, the UART source mux, the tristates —
// has never been simulated at all. This bench instantiates `ulx3s_top` and
// talks to it the way the board does: through the header wires.
//
// PHYSICAL SEATING vs THE STRAP. `seat_flip` models how the memory Pmod is
// actually plugged in; `sw[0]` is what the gateware has been TOLD. They are
// deliberately separate signals so the tests can set them to disagree — a
// reversed Pmod must fail cleanly, not half-work, and that is only provable if
// the bench can be wrong on purpose.
//
// Bus model: 1-bit serial mode (QSPI_CFG resets to 0, which is how the chip
// boots), so SD1 is the only line the memory ever drives. That is the same
// simplification tb_rehearse uses in the console repo, and it keeps this bench
// free of quad-mode contention while still exercising the permutation in BOTH
// directions — outputs through the row algebra, MISO back through the
// reconstruction, which is a different expression and the easier one to typo.

module tb_fpga ();

  initial begin
    $dumpfile("tb_fpga.fst");
    $dumpvars(0, tb_fpga);
    #1;
  end

  reg        clk;
  reg  [6:0] btn;
  reg  [3:0] sw;
  wire [7:0] led;
  wire       ftdi_rxd;
  wire       wifi_gpio0, wifi_en;

  wire [3:0] pmod_gp, pmod_gn;
  wire [3:0] vga_gp, vga_gn;

  // ---- the modelled memory Pmod -------------------------------------------
  // It drives exactly one wire: SD1 (uio[2]), and only while the selected
  // device is shifting data out. Which physical wire that is depends on the
  // seating: unflipped, uio[2] lands on gp[1]; flipped, on gn[1].
  reg seat_flip;
  reg mem_dq1;
  reg mem_dq1_oe;

  assign pmod_gp[1] = (mem_dq1_oe && !seat_flip) ? mem_dq1 : 1'bz;
  assign pmod_gn[1] = (mem_dq1_oe &&  seat_flip) ? mem_dq1 : 1'bz;

  // PULLMODE=UP in ulx3s.lpf, modelled. Without these an undriven header wire
  // is z, which propagates X into the chip and turns a mapping bug into an
  // unreadable waveform instead of a clean failure.
  pullup (pmod_gp[0]); pullup (pmod_gp[1]); pullup (pmod_gp[2]); pullup (pmod_gp[3]);
  pullup (pmod_gn[0]); pullup (pmod_gn[1]); pullup (pmod_gn[2]); pullup (pmod_gn[3]);

  // ---- onboard SDRAM ------------------------------------------------------
  // The RAM half of the memory map now lands here rather than on the QSPI
  // Pmod, so the harness needs a part to talk to or nothing that touches a
  // stack, a page table or the charbuf will work.
  wire        sdram_clk, sdram_cke, sdram_csn, sdram_rasn, sdram_casn, sdram_wen;
  wire [12:0] sdram_a;
  wire [1:0]  sdram_ba, sdram_dqm;
  wire [15:0] sdram_d;

  wire [15:0] part_dout;
  wire        part_oe;
  assign sdram_d = part_oe ? part_dout : 16'hzzzz;

  // The part is clocked on sdram_clk, which the harness drives as ~clk. Feeding
  // the model the same inverted clock is what makes this bench test the real
  // arrangement rather than a convenient one.
  sdram_model #(.CL(2)) part (
      .clk(sdram_clk), .cke(sdram_cke), .csn(sdram_csn),
      .rasn(sdram_rasn), .casn(sdram_casn), .wen(sdram_wen),
      .a(sdram_a), .ba(sdram_ba), .dqm(sdram_dqm),
      .din(sdram_d), .doe(1'b0),
      .dout(part_dout), .dout_oe(part_oe)
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

  // Convenience for the tests: what the chip itself sees, so a failure can be
  // localised to the harness rather than the SoC.
  wire [7:0] chip_uo  = uut.uo_out;
  wire [7:0] chip_uio_in = uut.uio_in;

`ifdef KOTI_PROBE
  // ---- memory-transaction ring + stall watchdog (needs KOTI_FPGA) ----------
  //
  // Why a ring and a watchdog rather than a stream of $display. The suite runs
  // two million clocks; logging every memory transaction produces a file nobody
  // reads and hides the one moment that matters. What is actually wanted is the
  // TAIL: the last few dozen transactions before the machine went quiet, plus
  // the complete state of everything that could be holding it. So keep a
  // 64-entry ring, and dump it the first time no ack has arrived for a long
  // time.
  //
  // The previous probe here logged WRITES ONLY, which cannot distinguish a CPU
  // that has stopped from a CPU blocked on a read. This one keys on `m_ack`, so
  // reads and writes are both in the ring and the device that answered (or did
  // not) is recorded per transaction.
  localparam integer RN = 64;

  integer    r_head, r_n;
  reg [63:0] r_clk [0:RN-1];
  reg [1:0]  r_gr  [0:RN-1];
  reg        r_we  [0:RN-1];
  reg        r_bu  [0:RN-1];
  reg [22:0] r_ad  [0:RN-1];
  reg        r_dev [0:RN-1];          // 1 = sdram answered, 0 = qspi

  integer n_rd_s, n_wr_s, n_rd_q, n_wr_q;
  integer watchdog, fired, k, e;
  reg [63:0] clkcnt;                  // clocks, NOT $time — no ps/ns ambiguity
  reg        vga_en_q;

  initial begin
    r_head = 0; r_n = 0; watchdog = 0; fired = 0; clkcnt = 0;
    n_rd_s = 0; n_wr_s = 0; n_rd_q = 0; n_wr_q = 0; vga_en_q = 0;
  end

  wire        pb_ack   = uut.dut.m_ack;
  wire        pb_sack  = uut.dut.s_ack;
  wire        pb_qack  = uut.dut.q_ack;
  wire        pb_we    = uut.dut.m_we;
  wire [22:0] pb_addr  = uut.dut.m_addr;
  wire [1:0]  pb_grant = uut.dut.arb.grant;

  task dump_state(input [255:0] why);
    begin
      $display("");
      $display("=== KOTI PROBE: %0s at clk %0d (no m_ack for %0d clk) ===",
               why, clkcnt, watchdog);
      $display("  totals : sdram rd=%0d wr=%0d | qspi rd=%0d wr=%0d",
               n_rd_s, n_wr_s, n_rd_q, n_wr_q);
      $display("  arbiter: grant=%0d m_req=%b m_we=%b m_burst=%b m_addr=%h m_ack=%b",
               pb_grant, uut.dut.m_req, uut.dut.m_we, uut.dut.m_burst,
               pb_addr, pb_ack);
      $display("  ports  : v_req=%b d_req_arb=%b f_req=%b || d_req_cpu=%b d_we=%b d_addr=%h",
               uut.dut.v_req, uut.dut.arb.d_req, uut.dut.if_req,
               uut.dut.d_req, uut.dut.d_we, uut.dut.d_addr);
      $display("  acks   : v_ack=%b d_ack_arb=%b f_ack=%b || q_ack=%b s_ack=%b",
               uut.dut.v_ack, uut.dut.ad_ack, uut.dut.if_ack, pb_qack, pb_sack);
      $display("  select : inflight=%b sel_q=%b sel_ram=%b",
               uut.dut.inflight, uut.dut.sel_q, uut.dut.sel_ram);
      $display("  sdram  : st=%0d req=%b acked=%b tmr=%0d second=%b ref_pending=%b",
               uut.dut.sdram.st, uut.dut.sdram.req, uut.dut.sdram.acked,
               uut.dut.sdram.tmr, uut.dut.sdram.second,
               uut.dut.sdram.ref_pending);
      $display("  qspi   : state=%0d req=%b", uut.dut.qspi.state, uut.dut.qspi.req);
      $display("  video  : vga_en=%b f_busy=%b f_txn=%0d v_addr=%h",
               uut.dut.vga_en, uut.dut.vt.f_busy, uut.dut.vt.f_txn,
               uut.dut.v_addr);
      $display("  cpu    : pc_d=%h pc_e=%h halted=%b pstall=%b mstall=%b iw_state=%0d fbusy=%b",
               uut.dut.core.pc_d, uut.dut.core.pc_e, uut.dut.halted,
               uut.dut.core.pstall, uut.dut.core.mstall,
               uut.dut.core.iw_state, uut.dut.core.fbusy);
      $display("  --- last %0d memory transactions, oldest first ---", r_n);
      for (k = 0; k < r_n; k = k + 1) begin
        e = (r_head - r_n + k + 2*RN) % RN;
        $display("   [%0d] clk=%0d %0s %0s addr=%h (byte %h) grant=%0d%0s",
                 k, r_clk[e], r_dev[e] ? "SDRAM" : "qspi ",
                 r_we[e] ? "WR" : "rd", r_ad[e], {r_ad[e], 2'b00},
                 r_gr[e], r_bu[e] ? " burst" : "");
      end
      $display("");
    end
  endtask

  always @(posedge clk) begin
    clkcnt = clkcnt + 1;

    // Mark the moment video DMA is allowed to contend — the hypothesised
    // trigger, and the point the old evidence stopped just short of.
    vga_en_q <= uut.dut.vga_en;
    if (uut.dut.vga_en && !vga_en_q)
      $display("KOTI PROBE: VGA_EN set at clk %0d (video DMA starts contending)",
               clkcnt);

    if (pb_ack === 1'b1) begin
      r_clk[r_head] = clkcnt;
      r_gr[r_head]  = pb_grant;
      r_we[r_head]  = pb_we;
      r_bu[r_head]  = uut.dut.m_burst;
      r_ad[r_head]  = pb_addr;
      r_dev[r_head] = pb_sack;
      r_head = (r_head + 1) % RN;
      if (r_n < RN) r_n = r_n + 1;
      if (pb_sack) begin
        if (pb_we) n_wr_s = n_wr_s + 1; else n_rd_s = n_rd_s + 1;
      end else begin
        if (pb_we) n_wr_q = n_wr_q + 1; else n_rd_q = n_rd_q + 1;
      end
      watchdog = 0;
    end else if (uut.rst_n === 1'b1) begin
      watchdog = watchdog + 1;
    end

    // 20k clocks is 0.8 ms. The slowest legitimate access is a 1-bit serial
    // QSPI burst at ~130 clocks, and the CPU fetches every instruction over
    // that bus, so a real machine can never be this quiet — not even spinning
    // in `for(;;)`, which still fetches.
    if (watchdog == 20000 && fired == 0) begin
      fired = 1;
      dump_state("STALL");
    end
  end
`endif

endmodule
