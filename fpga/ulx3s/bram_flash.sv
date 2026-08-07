`default_nettype none
//
// bram_flash.sv — the boot flash, in fabric. HARNESS ONLY, never synthesised
// into the chip.
//
// WHY THIS EXISTS. koti boots by XIP from flash address 0, so with nothing on
// J1 the CPU cannot fetch a single instruction and the board can only be
// checked as far as "it configures and nothing is stuck" (README step 2). The
// Cartridge Pmod that would sit there has not arrived, and J1 is bare holes.
// This is a QSPI *device* on the same eight uio wires the Pmod would use,
// backed by the ULX3S's own block RAM, so the SoC boots with NO Pmod attached.
//
// It EMULATES the device rather than bypassing the controller, and that is the
// whole point: `qspi_ctrl`, the three-master arbiter and the I-cache all still
// run, on hardware, exactly as they will with a real part. An ifdef that
// swapped qspi_ctrl for a BRAM port would mean the bus logic never ran on the
// board at all — and the bus is where this SoC's bugs have lived.
//
// RAM IS NOT MODELLED HERE, on purpose. Under `KOTI_FPGA` project.sv routes
// addr[22]=1 to `sdram_ctrl` and the onboard 32 MB part, and only addr[22]=0
// reaches qspi_ctrl. So `cs_ram_n` never asserts in this build and a PSRAM
// model would be dead code. A boot through this file therefore exercises the
// REAL SDRAM controller, including the `RD_ADV` question — which is the point
// of putting it on hardware.
//
// ── THE ONE THING THAT MATTERS: WHICH EDGE ANSWERS ──────────────────────────
// `qspi_ctrl` drives `sck` as a REGISTERED output from posedge clk, two system
// clocks per SPI bit, and in S_RD it samples the incoming bit at the posedge
// where it raises sck:
//
//     S_RD: if (!sck) begin sck <= 1'b1; rx <= {rx[…], sd_in[1]}; …
//
// So it captures whatever MISO held BEFORE that posedge. A device clocked on
// posedge clk could only present a bit after that same edge — one full bit-time
// late, every bit. This module therefore runs entirely on **negedge clk**,
// which puts its answer half a clock ahead of the controller's sample and
// mirrors, edge for edge, what test/test.py's `SpiMem` does in simulation
// (`await FallingEdge(dut.clk)`). That model is the only specification koti's
// controller has ever been verified against, so matching its edges is not a
// stylistic choice.
//
// The same reasoning fixes the read latency. 03h has NO dummy cycles: the last
// address bit is sampled on one edge and bit 7 of the data must be on the wire
// at the next one. So the array read is issued with a COMBINATIONAL address at
// the edge that completes the address (`raddr` below), which is exactly what a
// synchronous-read block RAM does, and the byte is waiting one negedge later.
// Getting this wrong is not subtle in its symptom — every fetched word is
// shifted by one bit and the CPU executes noise.
//
// WHAT IS IMPLEMENTED: 03h read, 1-bit serial, mode 0, with the address
// auto-incrementing across a burst. That is the entire set koti uses — nothing
// in sw/ ever writes QSPI_CFG (0x1000C), which resets to 0 = 1-bit safe mode,
// so quad never turns on. Every other opcode raises `bad_cmd`, which the
// harness puts on an LED. A model that quietly returned zeroes for an opcode it
// did not understand would look exactly like working hardware running a broken
// program, and the reason this file exists is to make the memory boring so that
// everything else can be suspected instead.
//
// ADDRESS ALIASING IS DELIBERATE. Only the low $clog2(FLASH_BYTES) bits are
// decoded, so the flash window folds. A real part aliases too (the APS6404 does
// exactly this, which is how software learns it has run off the end), and it
// means one unmodified image boots on both this and a real Pmod.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0

module bram_flash #(
    // 32 KB covers sw/sbi/sbi_test.bin (26012 B) and therefore everything
    // smaller, including sw/hello.bin (597 B). 16 DP16KD on an 85F that has
    // 208 — koti itself uses 3 plus the I-cache.
    parameter int FLASH_BYTES = 32768,
    // A path, not a path plus a computed suffix: a $readmemh that silently
    // finds nothing leaves an array of X, and X on MISO propagates into the
    // CPU and looks like a broken CPU rather than an empty memory.
    parameter     IMAGE_HEX   = "fpga/ulx3s/build/flash.hex"
) (
    input  wire clk,          // the SoC's own 25 MHz clock
    input  wire rst,          // active high
    input  wire cs_n,         // uio[0] — cs_flash_n
    input  wire sck,          // uio[3]
    input  wire mosi,         // uio[1] — sd_out[0]
    output reg  miso,         // -> uio_in[2], which project.sv reads as sd_in[1]
    output reg  bad_cmd       // sticky: an opcode this model does not implement
);

  localparam int AW = $clog2(FLASH_BYTES);

  localparam [1:0] P_CMD = 2'd0, P_ADDR = 2'd1, P_RD = 2'd2, P_IGN = 2'd3;
  localparam [7:0] OP_READ = 8'h03;

  // One byte per entry. A byte-wide array is what makes the hex file trivially
  // generatable from a .bin (one byte per line) and needs no lane splitting —
  // the two-lane trick console's bram_cart uses is only necessary when the
  // controller gives you less than one full clock, and koti's gives two.
  (* no_rw_check *) reg [7:0] mem [0:FLASH_BYTES-1];
  initial $readmemh(IMAGE_HEX, mem, 0, FLASH_BYTES-1);

  reg [1:0]      phase;
  reg [4:0]      n;            // bits received in this phase
  reg [23:0]     sh;           // command/address shifter
  reg [AW-1:0]   addr_reg;     // byte address of the byte currently shifting out
  reg [7:0]      cur;          // the byte being shifted out
  reg [3:0]      bidx;         // bits of `cur` already sent; 8 = load next byte
  reg [7:0]      dout;         // the array's registered read data
  reg            sck_q;

  wire rise = sck && !sck_q;
  wire fall = !sck && sck_q;

  // The address as of THIS edge, including the bit arriving on it — needed
  // because the read has to be issued on the very edge the address completes.
  wire [23:0] addr_now = {sh[22:0], mosi};

  wire addr_done = rise && (phase == P_ADDR) && (n == 5'd23);
  wire do_load   = fall && (phase == P_RD)   && (bidx == 4'd8);

  // Combinational read address, registered data: a synchronous-read BRAM. Both
  // special cases have to be here rather than reading `addr_reg`, because
  // `addr_reg` only takes its new value at the end of this same edge.
  wire [AW-1:0] raddr = addr_done ? addr_now[AW-1:0]
                      : do_load   ? addr_reg + 1'b1
                                  : addr_reg;

  always @(negedge clk) begin
    dout <= mem[raddr];
    sck_q <= sck;

    if (rst) begin
      phase   <= P_CMD;
      n       <= 5'd0;
      bidx    <= 4'd8;
      miso    <= 1'b0;
      bad_cmd <= 1'b0;                 // cleared by reset only, never by CS
      sck_q   <= 1'b0;
    end else if (cs_n) begin
      // Deselect restarts the transaction, exactly like SpiMem.deselect().
      phase <= P_CMD;
      n     <= 5'd0;
      bidx  <= 4'd8;
      miso  <= 1'b0;
    end else if (rise) begin
      case (phase)
        P_CMD: begin
          sh <= {sh[22:0], mosi};
          if (n == 5'd7) begin
            n <= 5'd0;
            if ({sh[6:0], mosi} == OP_READ) begin
              phase <= P_ADDR;
            end else begin
              phase   <= P_IGN;
              bad_cmd <= 1'b1;
            end
          end else begin
            n <= n + 5'd1;
          end
        end
        P_ADDR: begin
          sh <= {sh[22:0], mosi};
          if (n == 5'd23) begin
            n        <= 5'd0;
            addr_reg <= addr_now[AW-1:0];
            phase    <= P_RD;
            bidx     <= 4'd8;          // first fall loads the byte
          end else begin
            n <= n + 5'd1;
          end
        end
        default: ;                     // P_RD ignores MOSI; P_IGN waits for CS
      endcase
    end else if (fall && (phase == P_RD)) begin
      if (bidx == 4'd8) begin
        cur      <= dout;
        miso     <= dout[7];
        bidx     <= 4'd1;
        addr_reg <= addr_reg + 1'b1;    // the read for it was issued this edge
      end else begin
        miso <= cur[7 - bidx[2:0]];
        bidx <= bidx + 4'd1;
      end
    end
  end

endmodule

`default_nettype wire
