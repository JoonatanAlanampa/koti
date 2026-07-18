// control.sv — RV32I single-cycle decoder.
//
// This is step 2's microcode ROM collapsed: one "row" per instruction,
// addressed combinationally by opcode, all signals asserted at once because
// everything happens in the same cycle. The `case` below IS the control ROM.
module control (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7b5,   // instr[30]
    output logic       reg_write,
    output logic [2:0] imm_sel,    // 0=I 1=S 2=B 3=U 4=J
    output logic [1:0] alu_a_src,  // 0=rs1 1=PC 2=zero
    output logic       alu_b_src,  // 0=rs2 1=imm
    output logic [3:0] alu_op,     // final ALU op ({funct7b5, funct3} shape)
    output logic       mem_write,
    output logic [1:0] wb_src,     // 0=ALU 1=MEM 2=PC+4
    output logic       is_branch,
    output logic       is_jump,    // JAL or JALR
    output logic       halt        // ECALL/EBREAK
);
    always_comb begin
        reg_write = 0; imm_sel = 3'd0; alu_a_src = 2'd0; alu_b_src = 0;
        alu_op = 4'd0; mem_write = 0; wb_src = 2'd0;
        is_branch = 0; is_jump = 0; halt = 0;
        case (opcode)
            7'b0110111: begin reg_write = 1; imm_sel = 3'd3;            // LUI
                              alu_a_src = 2'd2; alu_b_src = 1; end      //   0 + immU
            7'b0010111: begin reg_write = 1; imm_sel = 3'd3;            // AUIPC
                              alu_a_src = 2'd1; alu_b_src = 1; end      //   PC + immU
            7'b1101111: begin reg_write = 1; imm_sel = 3'd4;            // JAL
                              alu_a_src = 2'd1; alu_b_src = 1;          //   ALU = target
                              is_jump = 1; wb_src = 2'd2; end           //   rd = PC+4
            7'b1100111: begin reg_write = 1; alu_b_src = 1;             // JALR
                              is_jump = 1; wb_src = 2'd2; end           //   rs1 + immI
            7'b1100011: begin imm_sel = 3'd2;                           // branches
                              alu_a_src = 2'd1; alu_b_src = 1;          //   ALU = target,
                              is_branch = 1; end                        //   cmp is separate
            7'b0000011: begin reg_write = 1; alu_b_src = 1;             // loads
                              wb_src = 2'd1; end                        //   rs1 + immI
            7'b0100011: begin imm_sel = 3'd1; alu_b_src = 1;            // stores
                              mem_write = 1; end                        //   rs1 + immS
            7'b0010011: begin reg_write = 1; alu_b_src = 1;             // ALU-imm
                              // instr[30] is IMMEDIATE data except for
                              // shifts (see PLAN.md gotcha)
                              alu_op = (funct3 == 3'b001 || funct3 == 3'b101)
                                       ? {funct7b5, funct3}
                                       : {1'b0, funct3}; end
            7'b0110011: begin reg_write = 1;                            // ALU-reg
                              alu_op = {funct7b5, funct3}; end
            7'b1110011: halt = 1;                                       // ECALL/EBREAK
            default: ;                                                  // FENCE = NOP
        endcase
    end
endmodule
