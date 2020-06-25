// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire and1, or1, nor1, xor1;
    and a1(and1, A, B);
    or o1(or1, A, B);
    nor n1(nor1, A, B);
    xor x1(xor1, A, B);
    mux4 m1(out,and1, or1, nor1, xor1, control);
endmodule // logicunit
