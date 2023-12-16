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

// node generate_witness.js multiply.wasm input.json witness.wtns

// snarkjs wtns export json witness.wtns

// cat witness.json

// -1 * a[0] + a[1] ] * [ ise.isz.inv ] - [ 1 + c ] = 0
// -1 * 15+16    * 

// -1 * a[0] + a[1] ] * [ c ] - [  ] = 0



// Valid witness
// Valid because out is 1
// [
//  "1",
//  "1",
//  "15",
//  "15",
//  "0"
// ]


// Invalid Witness
// Invalid because out is 0?
// [
//  "1",
//  "0",
//  "16",
//  "15",
//  "21888242871839275222246405745257275088548364400416034343698204186575808495616"
// ]