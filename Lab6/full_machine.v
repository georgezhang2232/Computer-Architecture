// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] slt_;
    wire [31:0] lui_;
    wire [31:0] mem_;
    wire [31:0] byte_;
    wire [31:0] data_;
    wire [31:0] zero32 = 32'b0;
    wire [31:0] lui1 = {inst[15:0], zero32[15:0]};
    wire [31:0] slt_right = {zero32[31:1], (negative & ~overflow) | (~negative & overflow)};
    wire [31:0] read_select;
    wire [31:0] rs_rt;
    wire [7:0] byte4;
    wire [4:0] rdNum;
    wire [2:0] alu_op;
    wire [1:0] ctrl_type;
    wire [31:0] pc4off;
    wire [31:0] pc4;
    wire [31:0] nextPC;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [31:0] rdData;
    wire [31:0] out;
    wire [31:0] imm32 = {{16{inst[15]}}, inst[15:0]};
    wire [31:0] branch_offset = {{14{inst[15]}}, inst[15:0], 2'b0};
    wire [31:0] B;

    wire writeenable;
    wire alu_src2, rd_src, negative, zero, slt, lui, addm, byte_we, word_we, mem_read, overflow, byte_load;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf(rsData, rtData,inst[25:21], inst[20:16], rdNum, rdData, writeenable, clock, reset);

    /* add other modules */
    //mux
    mux2v mux1(read_select, out, rsData, addm);
    mux2v mux2(rdData, lui_, rs_rt, addm);
    mux2v mux3(B, rtData, imm32, alu_src2);
    mux2v mux4(rdNum, inst[15:11], inst[20:16], rd_src);
    mux2v mux5(slt_, out, slt_right, slt);
    mux2v mux6(lui_, mem_, lui1, lui);
    mux2v mux7(mem_, slt_, byte_, mem_read);
    mux2v mux8(byte_, data_, {zero32[23:0], byte4}, byte_load);
    mux4v mux9(nextPC, pc4, pc4off, {PC[31:28], inst[25:0], 2'b0}, rsData, ctrl_type);
    mux4v mux10(byte4, data_[7:0], data_[15:8], data_[23:16], data_[31:24], out[1:0]);

    //alu
    alu32 alu_p4(pc4, , , , PC, 32'h04, `ALU_ADD);
    alu32 operation_alu(out, overflow, zero, negative, rsData, B, alu_op);
    alu32 PC_alu(pc4off, , , , pc4, branch_offset, `ALU_ADD);
    alu32 addm_alu(rs_rt, , , , byte_, rtData, `ALU_ADD);

    //memory
    data_mem data(data_, read_select, rtData, word_we, byte_we, clock, reset);
    mips_decode decode(alu_op, writeenable, rd_src, alu_src2, except, ctrl_type, mem_read, word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero);

   endmodule // full_machine
