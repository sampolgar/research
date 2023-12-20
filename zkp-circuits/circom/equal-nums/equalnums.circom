pragma circom 2.1.6;
include "../zero-knowledge-puzzles/node_modules/circomlib/circuits/comparators.circom";

template EqualNums(){
    signal input a[2];
    signal output c;
    
    component ise = IsEqual();


    a ==> ise.in;
    c <== ise.out;
}

component main = EqualNums();