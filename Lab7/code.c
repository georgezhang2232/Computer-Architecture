#include <stdio.h>
#include <stdlib.h>

struct Ingredient {
  unsigned ing_type;
  unsigned amount;
};

struct Request {
  unsigned length;
  Ingredient ingredients [11];
};

// Sets the values of the array to the corresponding values in the request
void decode_request(unsigned long int request, int* array) { 
  // The hi and lo values are already given to you, so you don't have to
  // perform these shifting operations. They are included so that this
  // code functions in C. The lo value is $a0 and the hi value is $a1.
  unsigned lo = (unsigned)((request << 32) >> 32);
  unsigned hi = (unsigned)(request >> 32);

  for (int i = 0; i < 6; ++i) {
    array[i] = lo & 0x0000001f;
    lo = lo >> 5;
  }
  unsigned upper_three_bits = (hi << 2) & 0x0000001f;
  array[6] = upper_three_bits | lo;
  hi = hi >> 3;
  for (int i = 7; i < 11; ++i) {
    array[i] = hi & 0x0000001f;
    hi = hi >> 5;
  }
}

//Performs a bubble sort on the given request using the given comparison function
void bubble_sort(Request* request, int (*cmp_func) (Ingredient*, Ingredient*)) {
    for (int i = 0; i < request->length; ++i) {
        for (int j = 0; j < request->length - i - 1; ++j) {
            if (cmp_func(&request->ingredients[j], &request->ingredients[j + 1]) > 0) {
                Ingredient temp = request->ingredients[j];
                request->ingredients[j] = request->ingredients[j + 1];
                request->ingredients[j + 1] = temp;
            }
        }
    }
}
 
int compare_ingredients(Ingredient* ingredient1, Ingredient* ingredient2) {
    if (ingredient1->amount > ingredient2->amount) {
        return 1;
    } else {
        return 0;   
    }
}
 
//Computes the euclidean squared distance between the given starting_coordinates
//and the index of the kitchen array that contains the given ingredient
int euclidean_squared(unsigned kitchen[15][15], 
                      int starting_coordinates[2], unsigned ingredient) {
  for (int i = 0 ; i < 15 ; ++ i) {
    for (int j = 0 ; j < 15 ; ++ j) {
      if (kitchen[i][j] == ingredient) {
        return ((i - starting_coordinates[0]) * (i - starting_coordinates[0]) + 
                (j - starting_coordinates[1]) * (j - starting_coordinates[1]));
      }
    }
  }
  return -1;
}

// Returns a long int message given the decoded message in
// the array.
long int create_request(int* array) {
  unsigned lo = ((array[6] << 30) >> 30);
  for (int i = 5; i >= 0; --i) {
    lo = lo << 5;
    lo |= array[i];
  }
  
  unsigned hi = 0;
  for (int i = 11; i > 7; --i) {
    hi |= array[i];
    hi = hi << 5;
  }
  hi |= array[7];
  hi = hi << 3;
  hi |= (array[6] >> 2);

  //Because you can't store long int values in a register, the
  //following code is not necessary to implement in MIPS. It
  //is included so that this code functions in C.

  unsigned long int request = (unsigned long int)hi << 32;
  request |= (unsigned long int)lo; 
  return request;
}