pragma circom 2.1.4;
// In this exercise , you need to create a circuit that takes an array "a"
// of length '2' as input and a output "c" .
// Create a circuit that adds the 2 inputs and outputs it .

template Add() {
   signal input a[2];
   signal output c;
   c <== a[0] + a[1];
   // out <== a[0] + a[1];
}

component main {public [a]}  = Add();

// yarn test ./test/<TestName>.js