module sc2_test;

    reg a, b, c_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire s, c_out;                        // wires for the outputs of "circuit under test"

    sc2_block sc2 (s, c_out, a, b, c_in);  // the circuit under test

    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial

        $dumpfile("sc2.vcd");                  // name of dump file to create
        $dumpvars(0,sc2_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches

        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        a = 0; b = 0; c_in = 0; # 10;             // set initial values and wait 10 time units
        a = 0; b = 0; c_in = 1; # 10;             // change inputs and then wait 10 time units
        a = 1; b = 0; c_in = 0; # 10;             // as above
        a = 1; b = 1; c_in = 0; # 10;
        a = 1; b = 0; c_in = 1; # 10;             // as above
        a = 1; b = 1; c_in = 1; # 10;
        a = 0; b = 1; c_in = 0; # 10;             // as above
        a = 0; b = 1; c_in = 1; # 10;
        $finish;                              // end the simulation
    end

    initial
        $monitor("At time %2t, a = %d b = %d c_in = %d s = %d c_out = %d",
                 $time, a, b, c_in, s, c_out);
endmodule // sc2_test
