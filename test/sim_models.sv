// sim_models.sv — simulation stand-ins for the FPGA-side memories the
// vendored core expects. Interfaces match cpu_pipe.sv's instantiations
// exactly. Test code loads imem/dmem by hierarchical backdoor from
// cocotb, so HEXFILE stays optional.

// registered-fetch instruction memory: rdata follows addr_next by one
// clock and holds while addr_next holds (the pipeline's stall contract)
module imem #(
    parameter HEXFILE = ""
) (
    input  logic        clk,
    input  logic [31:0] addr_next,
    output logic [31:0] rdata
);
    logic [31:0] mem [0:16383];          // 64 KB

    initial if (HEXFILE != "") $readmemh(HEXFILE, mem);

    always_ff @(posedge clk)
        rdata <= mem[addr_next[15:2]];
endmodule

// data memory: asynchronous read (M stage consumes it the same cycle),
// synchronous byte-enabled write
module dmem (
    input  logic        clk,
    input  logic        we,
    input  logic [3:0]  be,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);
    logic [31:0] mem [0:16383];          // 64 KB

    assign rdata = mem[addr[15:2]];

    always_ff @(posedge clk)
        if (we) begin
            if (be[0]) mem[addr[15:2]][7:0]   <= wdata[7:0];
            if (be[1]) mem[addr[15:2]][15:8]  <= wdata[15:8];
            if (be[2]) mem[addr[15:2]][23:16] <= wdata[23:16];
            if (be[3]) mem[addr[15:2]][31:24] <= wdata[31:24];
        end
endmodule

// audio stub: enough to elaborate; the FPGA's PCM channels don't exist
// on Koti-1
module audio_gen (
    input  logic        clk, rst,
    input  logic        we,
    input  logic [1:0]  ch,
    input  logic [31:0] wdata,
    output logic [3:0]  pcm
);
    assign pcm = 4'd0;
    wire _unused = &{clk, rst, we, ch, wdata, 1'b0};
endmodule
