// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
    wire w_add, w_sub, w_and, w_or, w_nor, w_xor, w_addi, w_andi, w_ori, w_xori;

    assign w_add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    assign w_sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    assign w_and = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    assign w_or = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    assign w_nor = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    assign w_xor = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);

    assign w_addi = (opcode == `OP_ADDI);
    assign w_andi = (opcode == `OP_ANDI);
    assign w_ori = (opcode == `OP_ORI);
    assign w_xori = (opcode == `OP_XORI);

    assign except = ~(w_add | w_sub | w_and | w_or | w_nor | w_xor | w_addi | w_andi | w_ori | w_xori);
    assign alu_src2 = (w_addi | w_andi | w_ori | w_xori);
    assign rd_src = alu_src2;
    assign writeenable = ~except;

    assign alu_op[0] = (w_sub | w_or | w_xor | w_ori | w_xori);
    assign alu_op[1] = (w_add | w_sub | w_xor | w_nor | w_addi | w_xori);
    assign alu_op[2] = (w_and | w_or | w_nor | w_xor | w_xori | w_andi | w_ori);

endmodule // mips_decode
