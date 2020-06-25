/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned tempR = (input & 0x55555555);
	 unsigned tempL = (input & 0xAAAAAAAA);
	 tempL = tempL >> 1;
	 input = tempR + tempL;

	 tempR = (input & 0x33333333);
	 tempL = (input & 0xCCCCCCCC);
	 tempL = tempL >> 2;
	 input = tempL + tempR;

	 tempR = (input & 0x0F0F0F0F);
	 tempL = (input & 0xF0F0F0F0);
	 tempL = tempL >> 4;
	 input = tempL + tempR;

	 tempR = (input & 0x00FF00FF);
	 tempL = (input & 0xFF00FF00);
	 tempL = tempL >> 8;
	 input = tempL + tempR;

	 tempR = (input & 0x0000FFFF);
	 tempL = (input & 0xFFFF0000);
	 tempL = tempL >> 16;
	 input = tempL + tempR;

	return input;
}
