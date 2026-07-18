// cpu.sv — RV32I single-cycle core.
//
// ONE architectural register: the PC. Fetch, decode, execute, memory, and
// writeback all happen combinationally between two clock edges — CPI is 1 by
// construction, and the price is the longest combinational path in the
// project (imem -> regfile -> ALU -> dmem -> regfile). Step 4 pipelines
// exactly this path.
module cpu #(
    parameter HEXFILE  = "",
    parameter UART_DIV = 217     // clocks per serial bit
) (
    input  logic clk, rst,
    output logic halted,
    output logic [7:0] led,      // MMIO register at 0x10000 (first peripheral!)
    output logic uart_txd,       // MMIO UART at 0x10004: write=send, read bit0=busy
    // video store bus: stores to 0x20000+ (tilemap/patterns/palette)
    output logic        vid_we,
    output logic [17:0] vid_addr,
    output logic [31:0] vid_wdata,
    // video status, readable at 0x10008: bit0 = vblank, [31:16] = frame count
    input  logic [31:0] vid_status,
    // controller buttons, readable at 0x1000C (1 = pressed)
    input  logic [15:0] pad,
    // sound: 4-bit PCM for the board's resistor DAC (0x10010/14/18)
    output logic [3:0] audio
);
    logic [31:0] pc;
    wire  [31:0] pc_plus4 = pc + 32'd4;

    // ---- fetch (registered: imem captures NEXT pc each posedge) ----
    logic [31:0] instr;
    imem #(.HEXFILE(HEXFILE)) im (.clk(clk),
                                  .addr_next(rst ? 32'd0 : pc_next),
                                  .rdata(instr));

    // ---- decode ----
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];

    logic       reg_write, alu_b_src, mem_write, is_branch, is_jump, halt;
    logic [2:0] imm_sel;
    logic [1:0] alu_a_src, wb_src;
    logic [3:0] alu_op;
    control ctl (.opcode(opcode), .funct3(funct3), .funct7b5(instr[30]),
                 .reg_write(reg_write), .imm_sel(imm_sel),
                 .alu_a_src(alu_a_src), .alu_b_src(alu_b_src),
                 .alu_op(alu_op), .mem_write(mem_write), .wb_src(wb_src),
                 .is_branch(is_branch), .is_jump(is_jump), .halt(halt));

    logic [31:0] imm;
    immgen ig (.instr(instr), .sel(imm_sel), .imm(imm));

    wire run = !rst && !halted;          // gate all state writes
    logic [31:0] rdata1, rdata2, wb_data;
    regfile rf (.clk(clk), .we(reg_write && run), .waddr(rd), .wdata(wb_data),
                .raddr1(rs1), .raddr2(rs2), .rdata1(rdata1), .rdata2(rdata2));

    // ---- execute ----
    logic [31:0] alu_a, alu_b, alu_y;
    always_comb begin
        case (alu_a_src)
            2'd1:    alu_a = pc;
            2'd2:    alu_a = 32'd0;      // LUI
            default: alu_a = rdata1;
        endcase
        alu_b = alu_b_src ? imm : rdata2;
    end
    alu ex (.op(alu_op), .a(alu_a), .b(alu_b), .y(alu_y));

    logic br_taken;
    branch_cmp bc (.funct3(funct3), .a(rdata1), .b(rdata2), .taken(br_taken));

    // ---- memory: byte-lane alignment for SB/SH/SW, LB/LH/LW/LBU/LHU ----
    wire [1:0]  off     = alu_y[1:0];
    wire [31:0] st_data = rdata2 << (8 * off);
    logic [3:0] be;
    always_comb
        case (funct3[1:0])
            2'b00:   be = 4'b0001 << off;    // SB
            2'b01:   be = 4'b0011 << off;    // SH
            default: be = 4'b1111;           // SW
        endcase

    // address decode: bit 17 = video region, bit 16 = I/O, else RAM
    wire vid_sel = alu_y[17];
    wire io_sel  = alu_y[16] && !vid_sel;
    assign vid_we    = mem_write && run && vid_sel;
    assign vid_addr  = alu_y[17:0];
    assign vid_wdata = st_data;

    logic [31:0] ld_word;
    dmem dm (.clk(clk), .we(mem_write && run && !io_sel && !vid_sel),
             .be(be), .addr(alu_y), .wdata(st_data), .rdata(ld_word));

    // I/O sub-decode: 0x10000 LED, 0x10004 UART, 0x10010+ audio (bit 4)
    wire io_aud  = alu_y[4];
    wire io_uart = alu_y[2];
    always_ff @(posedge clk)
        if (rst)                                led <= 8'd0;
        else if (mem_write && run && io_sel && !io_aud && !io_uart)
                                                led <= st_data[7:0];

    logic uart_busy;
    uart_tx #(.DIV(UART_DIV)) u0
        (.clk(clk), .rst(rst),
         .wr(mem_write && run && io_sel && !io_aud && io_uart),
         .data(st_data[7:0]), .tx(uart_txd), .busy(uart_busy));

    audio_gen aud (.clk(clk), .rst(rst),
                   .we(mem_write && run && io_sel && io_aud),
                   .ch(alu_y[3:2]), .wdata(st_data), .pcm(audio));

    wire [31:0] ld_shift = ld_word >> (8 * off);
    logic [31:0] ld_ext;
    always_comb
        case (funct3)
            3'b000:  ld_ext = {{24{ld_shift[7]}},  ld_shift[7:0]};   // LB
            3'b001:  ld_ext = {{16{ld_shift[15]}}, ld_shift[15:0]};  // LH
            3'b100:  ld_ext = {24'd0, ld_shift[7:0]};                // LBU
            3'b101:  ld_ext = {16'd0, ld_shift[15:0]};               // LHU
            default: ld_ext = ld_word;                               // LW
        endcase

    // ---- writeback ----
    always_comb
        case (wb_src)
            2'd1:    wb_data = io_sel ? (alu_y[3] ? (alu_y[2] ? {16'd0, pad}
                                                              : vid_status)
                                                  : {31'd0, uart_busy})
                                      : ld_ext;
            2'd2:    wb_data = pc_plus4;     // JAL/JALR link
            default: wb_data = alu_y;
        endcase

    // ---- next PC ----
    wire take = is_jump || (is_branch && br_taken);
    wire [31:0] pc_next = take ? {alu_y[31:1], 1'b0}   // bit 0 cleared: JALR spec
                               : pc_plus4;

    always_ff @(posedge clk)
        if (rst) begin
            pc <= 32'd0; halted <= 1'b0;
        end else if (!halted) begin
            pc <= pc_next;
            if (halt) halted <= 1'b1;
        end
endmodule
