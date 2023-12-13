pragma circom 2.1.6;

template Public(){
    signal input a;
    signal input b;
    signal input c;
    signal v;
    signal output out;

    v <==a * b;
    out <== c * v;
}

component main {public [a,c]} = Public();