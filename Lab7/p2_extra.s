.text

##// Returns a long int message given the decoded message in
##// the array.
##long int create_request(int* array) {
##  unsigned lo = ((array[6] << 30) >> 30);
##  for (int i = 5; i >= 0; --i) {
##    lo = lo << 5;
##    lo |= array[i];
##  }
##  
##  unsigned hi = 0;
##  for (int i = 11; i > 7; --i) {
##   hi |= array[i];
##    hi = hi << 5;
##  }
##  hi |= array[7];
##  hi = hi << 3;
##  hi |= (array[6] >> 2);
##
##  //Because you can't store long int values in a register, the
##  //following code is not necessary to implement in MIPS. It
##  //is included so that this code functions in C.
##
##  unsigned long int request = (unsigned long int)hi << 32;
##  request |= (unsigned long int)lo; 
##  return request;
##}

.globl create_request
create_request:
	jr	$ra