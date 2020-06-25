// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;



    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] PC_next;
    wire [31:0] rs_data, rt_data, rd_data;
    wire [31:0] imm32 = {{16{inst[15]}},inst[15:0]};
    wire [31:0] B;
    wire [4:0] rd;
    wire [2:0] alu_op;
    wire rd_enable, alu_src2, rd_src;
    wire overflow, zero, negative;




    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,PC_next,clock,1,reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rs_data,rt_data,inst[25:21],inst[20:16],rd,rd_data,rd_enable,clock,reset);



    mips_decode md(alu_op,rd_enable,rd_src,alu_src2,except,inst[31:26],inst[5:0]);
    mux2v mx(B,rt_data,imm32,alu_src2);
    mux2v #(5) mm(rd,inst[15:11],inst[20:16],rd_src);
    alu32 a1(PC_next,,,,PC,32'h04,`ALU_ADD);
    alu32 a2(rd_data, overflow, zero, negative, rs_data,B,alu_op);



endmodule // arith_machine
