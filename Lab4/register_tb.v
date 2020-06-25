module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;

    reg [4:0] regnum;
    reg [31:0] d;

    wire [31:0] q;
    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the register 

        # 10
          // write 88 to the register
          enable = 1;
          d = 10'd88;

        # 10
          // try writing to the register when its disabled
          enable = 0;
          d = 10'd89;

        // Add your own testcases here!
	 # 100
	   enable = 1;
	   d = 10'd129;
	
	 # 100
	   enable = 0;
	   d = 10'd301;

	 # 100
	   reset = 1;
	   enable = 0;
	   d = 10'd77;

        # 700 $finish;
    end
    
    initial begin
    end

    register reg1(q, d, clk, enable, reset);
   
endmodule // test