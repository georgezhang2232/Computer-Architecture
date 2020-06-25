// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, cout, a, b, cin);
  output s, cout;
  input a, b, cin;
  wire sa, cor, cnot;
  sc_block s1(sa, cnot, a, b);
  sc_block s2(s, cor, sa, cin);
  or o1(cout, cor, cnot);
endmodule // sc2_block
