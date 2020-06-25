`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;


    // your Verilog for coprocessor 0 goes here
    wire   [31:0] user_status, mtc0_out_decoder;
    wire   [29:0] Q, D;
    wire exception_level;
    wire   [31:0] cause_register, status_register;



    assign cause_register = {16'b0, TimerInterrupt, 15'b0};
    assign status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};
    assign TakenInterrupt =	(cause_register[15]&status_register[15])&(~status_register[1]&status_register[0]);
    assign EPC = Q;

    register reg_user_status(user_status, wr_data, clock, mtc0_out_decoder[12], reset);
    register #(1,) reg_exception(exception_level, 1, clock, TakenInterrupt, reset|ERET);
    register #(30,) reg_EPC(Q, D, clock, mtc0_out_decoder[14]|TakenInterrupt, reset);
    mux2v #(30) takeninterrupt(D, wr_data[31:2], next_pc, TakenInterrupt);
    mux32v regnumwtf(rd_data, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, status_register, cause_register, {Q, 2'b0}, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, regnum);
    decoder32 mtc0_decoder(mtc0_out_decoder, regnum, MTC0);

endmodule

