pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.
// include "comparators.circom";

template IsZero() {
    signal input in;
    signal output out;

    signal inv;

   // check if in is 0, if not it get's inverted. 
   // if in is 0, inv is 0.
    inv <-- in!=0 ? 1/in : 0; 

   // if in is 0, -in*inv is 0 because inv is 0 and -in*inv = 0. out = 1
   // if in isn't 0, inv is in inverted. so it's some number
   // then out = some big number * -in (another big number) + 1
    out <== -in*inv +1;

   //  in * out === 0
    in*out === 0;
}

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