module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire v1, v2, r1, r2, r3;
   or o1(v1, d, e, f);
   or o2(v2, d, e, f, g);
   and a1(r1, v1, a);
   and a2(r2, v2, b);
   and a3(r3, v1, c);
   or o3(valid, r1, r2, r3);
   assign number[0] = (a&d)||(a&f)||(c&d)||(c&f)||(b&e);
   assign number[1] = (b&d)||(c&d)||(a&f)||(c&e);
   assign number[2] = (a&e)||(b&e)||(c&e)||(a&f);
   assign number[3] = (b&f)||(c&f);

endmodule // keypad
