
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output load, select, palindrome, done;
	input go, a_ne_b, front_ge_back;
	input clock, reset;
  	wire s_garbage, s_start,s_process,s_done,s_done_no;

	wire s_garbage_next = s_garbage & ~go | reset;
	wire s_start_next = (s_start & go & ~reset)|(s_garbage & go & ~reset)|(s_done & go & 		~reset)|(s_done_no & go & ~reset);

	wire s_process_next = (s_start & ~go & ~reset)|(s_process & ~front_ge_back & ~a_ne_b & 		~reset);

	wire s_done_next = (s_process & front_ge_back & ~a_ne_b & ~reset)|(s_done & ~go & ~reset);
	wire s_done_no_next = (s_process & a_ne_b & ~reset);

	dffe garbage(s_garbage, s_garbage_next, clock, 1'b1, 1'b0);
	dffe start(s_start, s_start_next, clock, 1'b1, 1'b0);
	dffe process(s_process, s_process_next, clock, 1'b1, 1'b0);
	dffe dones(s_done, s_done_next, clock, 1'b1, 1'b0);
	dffe done_no(s_done_no,s_done_no_next,clock, 1'b1, 1'b0);

	assign palindrome = s_done;
	assign done = s_done | s_done_no;
	assign load = (s_process|s_start)&(~s_done & ~s_done_no);
	assign select = s_process;

endmodule // palindrome_control

