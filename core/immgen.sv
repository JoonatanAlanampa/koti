// immgen.sv — RV32I immediate decoder: the format zoo (I/S/B/U/J).
//
// Why the bits are scrambled: RV32I keeps rs1/rs2/rd in the SAME position in
// every format (decode starts before you know the format — same reason our
// tiny ISA reused field slots), so immediate bits take whatever is left,
// shuffled so the sign bit is always instr[31] and hardware muxing is cheap.
module immgen (
    input  logic [31:0] instr,
    input  logic [2:0]  sel,     // 0=I 1=S 2=B 3=U 4=J
    output logic [31:0] imm
);
    always_comb
        case (sel)
            // I: loads, ALU-imm, JALR — imm[11:0] = instr[31:20]
            3'd0: imm = {{20{instr[31]}}, instr[31:20]};
            // S: stores — imm split around rs2/rs1 so THEY don't move
            3'd1: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            // B: branches — like S but imm[0] forced 0 (targets are even)
            3'd2: imm = {{19{instr[31]}}, instr[31], instr[7],
                         instr[30:25], instr[11:8], 1'b0};
            // U: LUI/AUIPC — top 20 bits (RV32's version of our imm9<<7)
            3'd3: imm = {instr[31:12], 12'd0};
            // J: JAL — 20 scrambled bits, imm[0] forced 0
            3'd4: imm = {{11{instr[31]}}, instr[31], instr[19:12],
                         instr[20], instr[30:21], 1'b0};
            default: imm = 32'd0;
        endcase
endmodule
