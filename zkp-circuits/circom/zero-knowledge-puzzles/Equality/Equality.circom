pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.
include "../node_modules/circomlib/circuits/comparators.circom";


template Equality() {
   signal input a[3];
   signal output c;
   signal interim1;
   signal interim2;

   component isz1 = IsZero();
   component isz2 = IsZero();
   component isz3 = IsZero();

   a[0] - a[1] ==> isz1.in;
   isz1.out ==> interim1;
   
   a[1] - a[2] ==> isz2.in;
   isz2.out ==> interim2;

   interim1 - interim2 ==> isz3.in;
   isz3.out ==> c;
}


component main {public [a]} = Equality();
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