pragma circom 2.1.4;


// Input : a , length of 2 .
// Output : c .
// In this exercise , you have to check that a[0] is NOT equal to a[1], if not equal, output 1, else output 0.
// You are free to use any operator you may like . 

// HINT:NEGATION

include "../node_modules/circomlib/circuits/comparators.circom";

template NotEqual() {
    signal input a[2];
    signal output c;
    signal inv;

    inv <-- 1 / (a[0] - a[1]);
    // inverse is 1 / a0 - a1

    inv * (a[0] - a[1]) === 1;
    // inverse mul a0 - a1 constrained to 1;
    // assert inv * a0 - a1
    c <== inv;
}

component main = NotEqual();


// template NotEqual() {
//     signal input a[2];
//     signal output c;

//     component ise = IsEqual();

//     a[0] ==> ise.in[0];
//     a[1] ==> ise.in[1];
    
//     c <== 1 - ise.out;
// }

// component main = NotEqual();