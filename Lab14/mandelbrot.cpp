#include "mandelbrot.h"
#include <xmmintrin.h>

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics
int *
cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];
    //float x1, y1, x2, y2;
    __m128 X1, X2, Y1, Y2, X, Y, X1_sq, Y1_sq;
    __m128 three_time, lim, result;
    three_time = _mm_set1_ps(3.0);
    lim = _mm_set1_ps(M_MAG * M_MAG);
    float temp[4];
    for (int i = 0; i < SIZE; i += 4) {
        //x1 = y1 = 0.0;
        X1 = _mm_set1_ps(0.0);
        Y1 = _mm_set1_ps(0.0);
        X = _mm_loadu_ps(&x[i]);
        Y = _mm_loadu_ps(&y[i]);
        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate x1^2 and y1^2
            //float X1_sq = x1 * x1;
           // float Y1_sq = y1 * y1;
           X1_sq = _mm_mul_ps(X1, X1);
           Y1_sq = _mm_mul_ps(Y1, Y1);
            // Calculate the real piece of (x1 + (y1*i))^3 + (x + (y*i))
            //x2 = x1 * (X1_sq - 3 * Y1_sq) + x[i];
            X2 = _mm_add_ps(_mm_mul_ps(X1, _mm_sub_ps(X1_sq, _mm_mul_ps(Y1_sq, three_time))), X);

            // Calculate the imaginary portion of (x1 + (y1*i))^3 + (x + (y*i))
            //y2 = y1 * (3 * X1_sq - Y1_sq) + y[i];
            Y2 = _mm_add_ps(_mm_mul_ps(Y1, _mm_sub_ps(_mm_mul_ps(X1_sq, three_time), Y1_sq)), Y);
            // Use the resulting complex number as the input for the next
            // iteration
            //x1 = x2;
            //y1 = y2;
            X1 = X2;
            Y1 = Y2;
        }

        // caculate the magnitude of the result;
        // we could take the square root, but we instead just
        // compare squares
        //ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
        result = _mm_cmplt_ps(_mm_add_ps(_mm_mul_ps(X2, X2), _mm_mul_ps(Y2, Y2)), lim);
        _mm_storeu_ps(temp, result);

        for (int a = 0; a < 4; a ++){
                ret[i + a] = temp[a];
        }
    }
    return ret;
}
