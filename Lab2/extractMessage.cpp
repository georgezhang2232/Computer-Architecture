/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here
  int** a = new int*[length];
     for(int i = 0; i < length; i++){
       a[i] = new int[8];
     }

     for(int i = 0; i < length; i++){
       for(int j = 0; j < 8; j++){
         a[i][j] = 0;
       }
  }

     for(int i = 0; i < length; i++){
       int val = message_in[i];
       if(val < 0){
         val = 256 + val;
       }
       int count = 1;
       while (val != 0) {
              if(val%2 == 0){
                a[i][8 - count] = 0;
              }else{
                a[i][8 - count] = 1;
              }
            count++;
            val /= 2;
         }
     }

     int value = 0;
     int count = 0;
     int actual = 0;
     for(int i =  0; i < length; i+=8){
       for(int j = 0; j < 8; j++){
         value = 0;
         count = 0;
         while(count < 8){
         if(a[i + count][7 - j] == 1){
           if(count == 0){
           value += 1;
         }else if(count == 1){
           value += 2;
         }else if(count == 2){
           value += 4;
         }else if(count == 3){
           value += 8;
         }else if(count == 4){
           value += 16;
         }else if(count == 5){
           value += 32;
         }else if(count == 6){
           value += 64;
         }else if(count == 7){
           value += 128;
         }
         count++;
       }else{
         count++;
       }
     }

     message_out[actual] = static_cast<char>(value);
     actual++;
       }
     }

	return message_out;
}
