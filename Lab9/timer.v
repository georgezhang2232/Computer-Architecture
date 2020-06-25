module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire [31:0] first;
    wire [31:0] second;
    wire [31:0] alu_;
    wire ac,select, timeRead , timeWrite;
    wire [31:0] t_1;
    wire [31:0] t_2;

    assign t_1 = 32'hffff001c;
    assign t_2 = 32'hffff006c;

   register #( ,32'hffffffff) reg1(first,data,clock,timeWrite,reset);
   register reg2(second,alu_,clock,1'd1,reset);
   alu32 alu1(alu_,,,`ALU_ADD,second,32'd1);
   assign select = reset||ac;
   register #(1, ) final(TimerInterrupt,1'd1,clock,(first == second),select);
   tristate trid(cycle, second, timeRead);
   wire t0 = (t_1 == address);
   wire t1 = (t_2 == address);
   and a1(timeWrite,t0,MemWrite);
   and a2(timeRead,t0,MemRead);
   and a3(ac,t1,MemWrite);
   or o1(TimerAddress,t0,t1);

endmodule
