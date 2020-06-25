// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration

// make generator
// ./generator
#include <cstdio>
using std::printf;

int main() {
    int width = 32;
    for (int i = 1 ; i < width ; i ++) {
        printf("     dffe ff(q[%d], d[%d], clk, enable, reset);\n", i, i);
    }
    for(int i = 1; i < width ; i++){
        printf("    or o%d(neg[%d], out[%d], neg[%d]);\n",i,i,i+1,i-1);
    }
}
