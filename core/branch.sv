// branch.sv — branch comparator, separate from the ALU.
//
// In step 2 the shared ALU did branch compares (SUB + zero wire) because
// sharing was the design. Single-cycle has no sharing: the ALU computes the
// branch TARGET while this unit decides taken/not-taken, both in one cycle.
// RV32I's six conditions vs our two: they spent opcode space where our tiny
// ISA spent instructions (SLT + BNE).
module branch_cmp (
    input  logic [2:0]  funct3,
    input  logic [31:0] a, b,
    output logic        taken
);
    always_comb
        case (funct3)
            3'b000:  taken = (a == b);                       // BEQ
            3'b001:  taken = (a != b);                       // BNE
            3'b100:  taken = ($signed(a) <  $signed(b));     // BLT
            3'b101:  taken = ($signed(a) >= $signed(b));     // BGE
            3'b110:  taken = (a <  b);                       // BLTU
            3'b111:  taken = (a >= b);                       // BGEU
            default: taken = 1'b0;
        endcase
endmodule
