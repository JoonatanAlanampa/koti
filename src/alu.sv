// alu.sv — RV32I ALU, 10 operations.
//
// op = {funct7[5], funct3} lifted straight from the instruction — RV32I's
// version of the tiny ISA trick where opcode bits WERE the ALU select.
// instr[30] (funct7[5]) splits ADD/SUB and SRL/SRA; for I-type ALU ops that
// bit belongs to the immediate (except shifts), so alu_ctrl masks it — see
// PLAN.md "ALU-op encoding note".
module alu (
    input  logic [3:0]  op,      // {funct7[5], funct3}
    input  logic [31:0] a, b,
    output logic [31:0] y
);
    always_comb
        case (op)
            4'b0000: y = a + b;                                // ADD
            4'b1000: y = a - b;                                // SUB
            4'b0001: y = a << b[4:0];                          // SLL
            4'b0010: y = {31'd0, $signed(a) < $signed(b)};     // SLT
            4'b0011: y = {31'd0, a < b};                       // SLTU
            4'b0100: y = a ^ b;                                // XOR
            4'b0101: y = a >> b[4:0];                          // SRL
            4'b1101: y = $signed(a) >>> b[4:0];                // SRA
            4'b0110: y = a | b;                                // OR
            4'b0111: y = a & b;                                // AND
            default: y = 32'd0;
        endcase
endmodule
