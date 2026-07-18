// xip_model.sv — behavioral stand-in for qspi_ctrl + the Pmod chips,
// speaking koti_core's fetch/data port protocol (req held until the
// 1-cycle ack; data valid during ack). Word address bit 22 selects
// flash (0) vs PSRAM (1); flash writes ack as no-ops, like the real
// controller. LAT models transaction latency; the two ports are
// served independently, which is laxer than the real serialized bus —
// the qspi_ctrl+arbiter combination is pin-level tested in tt-riscv.
module xipmem #(
    parameter LAT = 4
) (
    input  logic        clk, rst,

    input  logic        if_req,
    input  logic [22:0] if_addr,
    output logic        if_ack,
    output logic [31:0] if_rdata, if_rdata2,

    input  logic        d_req,
    input  logic        d_we,
    input  logic [22:0] d_addr,
    input  logic [31:0] d_wdata,
    input  logic [3:0]  d_be,
    output logic        d_ack,
    output logic [31:0] d_rdata
);
    logic [31:0] flash [0:16383];        // 64 KB each
    logic [31:0] ram   [0:16383];

    function automatic [31:0] rd(input [22:0] a);
        rd = a[22] ? ram[a[13:0]] : flash[a[13:0]];
    endfunction

    logic [7:0] fcnt, dcnt;

    always_ff @(posedge clk)
        if (rst) begin
            fcnt <= 8'd0; if_ack <= 1'b0;
        end else begin
            if_ack <= 1'b0;
            if (if_req && !if_ack) begin
                if (fcnt == LAT[7:0]) begin
                    fcnt      <= 8'd0;
                    if_ack    <= 1'b1;
                    if_rdata  <= rd(if_addr);
                    if_rdata2 <= rd(if_addr + 23'd1);
                end else
                    fcnt <= fcnt + 8'd1;
            end else
                fcnt <= 8'd0;
        end

    always_ff @(posedge clk)
        if (rst) begin
            dcnt <= 8'd0; d_ack <= 1'b0;
        end else begin
            d_ack <= 1'b0;
            if (d_req && !d_ack) begin
                if (dcnt == LAT[7:0]) begin
                    dcnt    <= 8'd0;
                    d_ack   <= 1'b1;
                    d_rdata <= rd(d_addr);
                    if (d_we && d_addr[22]) begin      // flash write = no-op
                        if (d_be[0]) ram[d_addr[13:0]][7:0]   <= d_wdata[7:0];
                        if (d_be[1]) ram[d_addr[13:0]][15:8]  <= d_wdata[15:8];
                        if (d_be[2]) ram[d_addr[13:0]][23:16] <= d_wdata[23:16];
                        if (d_be[3]) ram[d_addr[13:0]][31:24] <= d_wdata[31:24];
                    end
                end else
                    dcnt <= dcnt + 8'd1;
            end else
                dcnt <= 8'd0;
        end
endmodule
