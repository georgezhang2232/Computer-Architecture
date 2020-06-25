module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    //forwarding wires
    wire forwardA, forwardB;
    wire [31:0] forwardAOutput, prev_forwardB;
    //stall
    wire stall;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);

    //new PC plus4
    wire [31:2] newPC_plus4;
    register #(30) newPCplus4Reg(newPC_plus4, PC_plus4, clk, ~stall, (PCSrc | reset));
    adder30 target_PC_adder(PC_target, newPC_plus4, imm[29:0]);

    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break

    //prev_inst
    wire [31:0]  prev_inst;
    instruction_memory imem(prev_inst, PC[31:2]);
    register #(32) instReg(inst, prev_inst, clk, ~stall, (PCSrc | reset));

    //decode output
    wire prevRegWrite, prevMemRead, prevMemWrite, prevMemToReg;
    mips_decode decode(ALUOp, prevRegWrite, BEQ, ALUSrc, prevMemRead, prevMemWrite, prevMemToReg, RegDst,
                      opcode, funct);
    register #(1) RegWriteReg(RegWrite, prevRegWrite, clk, /* enable */1'b1, reset);
    register #(1) MemReadReg(MemRead, prevMemRead, clk, /* enable */1'b1, reset);
    register #(1) MemWriteReg(MemWrite, prevMemWrite, clk, /* enable */1'b1, reset);
    register #(1) MemToRegReg(MemToReg, prevMemToReg, clk, /* enable */1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    wire [31:0] forwardBOutput;
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);
    register #(32) forwardBOutputReg(forwardBOutput, prev_forwardB, clk, /* enable */1'b1, reset);

    mux2v #(32) imm_mux(B_data, prev_forwardB, imm, ALUSrc);

    //alu out data new
    wire [31:0] prev_alu_out_data;
    alu32 alu(prev_alu_out_data, zero, ALUOp, forwardAOutput, B_data);
    register #(32) alu_out_dataReg(alu_out_data, prev_alu_out_data, clk, /* enable */1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data, forwardBOutput, MemRead, MemWrite, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);

    //wr regnum new
    wire [4:0] prev_wr_regnum;
    mux2v #(5) rd_mux(prev_wr_regnum, rt, rd, RegDst);
    register #(5) wr_regnumReg(wr_regnum, prev_wr_regnum, clk, /* enable */1'b1, reset);

    //forward
    assign forwardA = RegWrite & (wr_regnum == rs) & (rs != 5'b0);
    assign forwardB = RegWrite & (wr_regnum == rt) & (rt != 5'b0);
    mux2v #(32) forwardAmux(forwardAOutput, rd1_data, alu_out_data, forwardA);
    mux2v #(32) forwardBmux(prev_forwardB, rd2_data, alu_out_data, forwardB);

    //stall
    assign stall = MemRead & (((rs == wr_regnum) & (rs != 5'b0)) || ((rt == wr_regnum) & (rt != prev_wr_regnum) & (rt != 5'b0)));

endmodule // pipelined_machine
