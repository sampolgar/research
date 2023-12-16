pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.
include "../node_modules/circomlib/circuits/comparators.circom";


template Equality() {
   signal input a[3];
   signal output c;

   signal interim1;
   signal interim2;

   component ise1 = IsEqual();
   component ise2 = IsEqual();

   // if interim1 is equal, interim1 is 
   a[0] ==> ise1.in[0];
   a[1] ==> ise1.in[1];

   interim1 <== ise1.out;

   a[1] ==> ise2.in[0];
   a[1] ==> ise2.in[1];
   interim2 <== ise2.out;

   c <== interim1 * interim2;
}

component main = Equality();

//  [ -1 a[0] + a[1] ] * [ ise1.isz.inv ] - [ 1 + c ] = 0
//    
//  [ -1 a[0] + a[1] ] * [ c ] - [  ] = 0

// yarn test ./test/Equality.js

// component main = IsZero();

// template IsEqual() {
//    signal input in[2];
//    signal output out;

//    component isz = IsZero();
//    in[1] - in[0] ==> isz.in;
//    isz.out ==> out;
// }

// component main = IsEqual();