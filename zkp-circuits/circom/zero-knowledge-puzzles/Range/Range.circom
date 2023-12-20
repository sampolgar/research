pragma circom 2.1.4;

template Range() {
    signal input a;
    signal input lowerbound;
    signal input upperbound;
    signal output out;

    signal i;
    signal ii;
    i <-- a > lowerbound ? 1 : 0;
    ii <-- a < upperbound ? 1 : 0;
    out <== i * ii;
}

component main  = Range();

    // [ -1 * i ] * [ ii ] - [ -1 * out ] = 0


    // non quadratic constraints not allowed
    // var i = a > lowerbound ? 1 : 0;
    // var ii = a < upperbound ? 1 : 0;
    // out <== i * ii;


    // works but no linear constraints, no non-linear constraints
    // var i = a > lowerbound ? 1 : 0;
    // var ii = a < upperbound ? 1 : 0;
    // out <-- i * ii;
