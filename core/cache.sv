// cache.sv — direct-mapped write-back cache in front of the SDRAM: THE
// classic architecture lesson after pipelining. The controller made DRAM
// correct; this makes it *affordable* by exploiting locality.
//
// Geometry: 256 lines x 4 words (16 B) = 4 KB. The 23-bit word address
// splits {tag[12:0], index[7:0], offset[1:0]} — index picks the line,
// tag proves the line is the one you meant (direct-mapped = every address
// has exactly one home; two addresses 4 KB apart fight over it).
//
// Policies (simplest textbook set that still teaches the full mechanism):
//   write-back    — stores land in the cache and set a DIRTY bit; DRAM only
//                   sees the line when it's evicted (vs write-through's
//                   store-goes-to-DRAM-every-time)
//   write-allocate — a store miss fetches the line first, then merges the
//                   bytes; required anyway since SB/SH touch partial words
//
// Both ports speak the same hold-req-until-ack handshake, so the cache
// drops in between cpu_pipe and sdram_ctrl with zero changes to either.
// Hit cost: 1 cycle (ack the cycle after req) vs ~8 for raw DRAM.
// Miss cost: 4-word line fill (~30 cyc) + 4-word writeback first if the
// victim is dirty (~35 more) — the bet is that hits repay it many-fold.
module cache (
    input  logic        clk, rst,
    // CPU side (what cpu_pipe's sd_* bus plugs into)
    input  logic        req,
    input  logic        we,
    input  logic [22:0] addr,          // word address into 32 MB
    input  logic [31:0] wdata,
    input  logic [3:0]  be,
    output logic        ack,
    output logic [31:0] rdata,
    // memory side (plugs into sdram_ctrl's CPU port)
    output logic        m_req,
    output logic        m_we,
    output logic [22:0] m_addr,
    output logic [31:0] m_wdata,
    output logic [3:0]  m_be,
    input  logic        m_ack,
    input  logic [31:0] m_rdata
);
    wire [1:0]  c_off = addr[1:0];
    wire [7:0]  c_idx = addr[9:2];
    wire [12:0] c_tag = addr[22:10];

    logic [31:0] data [0:1023];        // 256 lines x 4 words (BRAM)
    logic [12:0] tags [0:255];
    logic [255:0] valid, dirty;

    typedef enum logic [1:0] { IDLE, WB_RD, WB_GO, FILL } st_t;
    st_t st;
    logic [1:0] beat;                  // which word of the line, during WB/FILL

    // lookup: combinational, from arrays held stable by the CPU's req.
    // !ack masks the cycle after a hit (req may still be high mid-drop).
    wire        lookup   = req && !ack;
    wire [12:0] line_tag = tags[c_idx];
    wire        hit      = valid[c_idx] && (line_tag == c_tag);
    wire        evict    = valid[c_idx] && dirty[c_idx] && !hit;

    // data BRAM read on the FALLING edge (same trick as dmem): address
    // settles in the first half-cycle, data is ready for the next posedge.
    // IDLE reads the CPU's word (for a read hit), WB reads the victim beat.
    wire [9:0] rd_idx = (st == IDLE) ? {c_idx, c_off} : {c_idx, beat};
    logic [31:0] ram_q;
    always_ff @(negedge clk)
        ram_q <= data[rd_idx];

    // single write port, two customers: a store hit merges CPU bytes,
    // a fill beat writes the whole word arriving from DRAM
    wire        dwe   = (st == IDLE && lookup && hit && we)
                     || (st == FILL && m_ack);
    wire [9:0]  waddr = (st == FILL) ? {c_idx, beat} : {c_idx, c_off};
    wire [31:0] wd    = (st == FILL) ? m_rdata : wdata;
    wire [3:0]  wbe   = (st == FILL) ? 4'b1111 : be;
    always_ff @(posedge clk)
        if (dwe) begin
            if (wbe[0]) data[waddr][7:0]   <= wd[7:0];
            if (wbe[1]) data[waddr][15:8]  <= wd[15:8];
            if (wbe[2]) data[waddr][23:16] <= wd[23:16];
            if (wbe[3]) data[waddr][31:24] <= wd[31:24];
        end

    // memory side: writeback sends the victim under its OLD tag, the fill
    // reads the new line; drop req on ack (the sdram_ctrl lesson, learned)
    assign m_req   = (st == WB_GO || st == FILL) && !m_ack;
    assign m_we    = (st == WB_GO);
    assign m_addr  = (st == WB_GO) ? {line_tag, c_idx, beat}
                                   : {c_tag,    c_idx, beat};
    assign m_wdata = ram_q;
    assign m_be    = 4'b1111;

    logic [31:0] hits, misses, wbacks;   // sim visibility; pruned on FPGA

    always_ff @(posedge clk)
        if (rst) begin
            st <= IDLE; ack <= 1'b0; beat <= 2'd0;
            valid <= '0; dirty <= '0;
            hits <= '0; misses <= '0; wbacks <= '0;
        end else begin
            ack <= 1'b0;
            case (st)
                IDLE: if (lookup) begin
                    if (hit) begin
                        hits  <= hits + 32'd1;
                        ack   <= 1'b1;
                        rdata <= ram_q;              // negedge-read this cycle
                        if (we) dirty[c_idx] <= 1'b1;
                    end else begin
                        misses <= misses + 32'd1;
                        beat   <= 2'd0;
                        if (evict) begin
                            wbacks <= wbacks + 32'd1;
                            st <= WB_RD;
                        end else
                            st <= FILL;
                    end
                end
                WB_RD: st <= WB_GO;                  // one cycle: BRAM reads beat
                WB_GO: if (m_ack) begin
                    if (beat == 2'd3) begin beat <= 2'd0; st <= FILL; end
                    else begin beat <= beat + 2'd1; st <= WB_RD; end
                end
                FILL: if (m_ack) begin               // word landed in data array
                    if (beat == 2'd3) begin
                        tags[c_idx]  <= c_tag;
                        valid[c_idx] <= 1'b1;
                        dirty[c_idx] <= 1'b0;
                        st <= IDLE;                  // req is still held: the
                    end else                         // retry lookup is now a hit
                        beat <= beat + 2'd1;
                end
                default: st <= IDLE;
            endcase
        end
endmodule
