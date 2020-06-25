#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    // for (int i = 0; i < SIZE; i ++) {
    //     for (int j = 0; j < SIZE; j ++) {
    //         dest[i][j] = src[j][i];
    //     }
    // }
        for (int j = 0; j < SIZE; j += 32) {
            for (int i = 0; i < SIZE; i ++) {
                    for (int k = j; k < min(j+32, SIZE); k ++){
                            dest[i][k] = src[k][i];
                    }
            }
        }

}
