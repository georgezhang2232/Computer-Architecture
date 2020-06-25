// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire add_ = ((opcode == `OP_OTHER0) & (funct == `OP0_ADD));
    wire sub_ = ((opcode == `OP_OTHER0) & (funct == `OP0_SUB));
    wire and_ = ((opcode == `OP_OTHER0) & (funct == `OP0_AND));
    wire or_ = ((opcode == `OP_OTHER0) & (funct == `OP0_OR));
    wire nor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_NOR));
    wire xor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_XOR));
    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);

    wire bne = (opcode == `OP_BNE);
    wire beq = (opcode == `OP_BEQ);
    wire j = (opcode == `OP_J);
    wire jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
    wire lw = (opcode == `OP_LW);
    wire lbu = (opcode ==`OP_LBU);
    wire sw = (opcode == `OP_SW);
    wire sb = (opcode == `OP_SB);
    wire lui = (opcode == `OP_LUI);
    wire slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    wire addm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

    assign alu_op[0] = sub_ | or_ | xor_ | ori | xori | slt | beq | bne;
    assign alu_op[1] = add_ | sub_ | nor_ | xor_ | addi | xori | slt | lw | lbu | sw | sb | beq | bne | addm;
    assign alu_op[2] = and_ | andi | or_ | nor_ | xor_ | ori | xori ;

   assign writeenable = add_ |sub_ |and_ |or_ |nor_ |xor_ |addi |andi |ori |xori |lui |slt |lw |lbu| addm;

   assign rd_src = addi | andi | ori | xori | lui | lw | lbu;
   assign alu_src2 = addi | andi | ori | xori | lw | lbu | sw | sb;

   assign control_type[0] = (beq & zero) | jr | (bne & ~zero); // jr eq neq
   assign control_type[1] = jr | j;
   assign mem_read = lw | lbu | addm;
   assign word_we = sw;
   assign byte_we = sb;
   assign byte_load = lbu;
   assign except = ~(add_|sub_|and_|or_|nor_|xor_|addi|andi|ori|xori|bne|beq|j|jr|lui|slt|lw|lbu|sw|sb|addm);
endmodule // mips_decode


