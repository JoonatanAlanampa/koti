// clint.sv — RISC-V core-local interruptor: mtime, mtimecmp, msip.
// Compact register map (32-bit accesses only, `addr` is the byte
// offset within the CLINT MMIO window):
//   0x00 MSIP      bit 0 = machine software interrupt   (r/w)
//   0x08 MTIMECMP  low 32                               (r/w)
//   0x0C MTIMECMP  high 32                              (r/w)
//   0x10 MTIME     low 32                               (r/w)
//   0x14 MTIME     high 32                              (r/w)
// mtime increments every clk. 32-bit reads of the running 64-bit
// counter use the standard software loop (hi, lo, re-read hi).
// mtip is registered: it lags a mtimecmp write by one cycle, which the
// privilege spec permits (spurious-free by the next instruction).
module clint (
    input  logic        clk, rst,
    input  logic        sel,          // this MMIO window addressed
    input  logic        we,
    input  logic [4:0]  addr,         // byte offset, addr[1:0] ignored
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    output logic        mtip, msip
);
    logic [63:0] mtime, mtimecmp;

    always_ff @(posedge clk)
        if (rst) begin
            mtime <= 64'd0; mtimecmp <= 64'd0;
            msip  <= 1'b0;  mtip     <= 1'b0;
        end else begin
            mtime <= mtime + 64'd1;
            mtip  <= (mtime >= mtimecmp);
            if (sel && we)
                case (addr[4:2])
                    3'b000: msip     <= wdata[0];
                    3'b010: mtimecmp <= {mtimecmp[63:32], wdata};
                    3'b011: mtimecmp <= {wdata, mtimecmp[31:0]};
                    3'b100: mtime    <= {mtime[63:32], wdata};
                    3'b101: mtime    <= {wdata, mtime[31:0]};
                    default: ;
                endcase
        end

    // word taps outside the process: part-selects inside always_comb
    // trip Icarus's conservative-sensitivity "sorry" diagnostic
    wire [31:0] cmp_lo = mtimecmp[31:0], cmp_hi = mtimecmp[63:32];
    wire [31:0] tim_lo = mtime[31:0],    tim_hi = mtime[63:32];

    always_comb
        case (addr[4:2])
            3'b000:  rdata = {31'd0, msip};
            3'b010:  rdata = cmp_lo;
            3'b011:  rdata = cmp_hi;
            3'b100:  rdata = tim_lo;
            3'b101:  rdata = tim_hi;
            default: rdata = 32'd0;
        endcase
endmodule
