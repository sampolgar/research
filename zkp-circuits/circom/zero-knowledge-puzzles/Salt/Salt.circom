pragma circom 2.1.4;

// In this exercise, we will learn an important concept related to hashing . There are 2 values a and b. You want to 
// perform computation on these and verify it , but secretly without discovering the values. 
// One way is to hash the 2 values and then store the hash as a reference.
// There is on problem in this concept , attacker can brute force the 2 variables by comparing the public hash with the resulting hash.
// To overcome this , we use a secret value in the input privately. We hash it with a and b. 

// This way brute force becomes illogical as the cost will increase multifolds for the attacker.

// Input 3 values, a, b and salt. 
// Hash all 3 using mimcsponge as a hashing mechanism. 
// Output the res using 'out'.

include "../node_modules/circomlib/circuits/mimcsponge.circom";

template Salt() {
    signal input a;
    signal input b;
    signal input salt;
    signal output out;
    signal outputs[2];

    component hash = MiMCSponge(2, 220, 2);

    hash.ins[0] <== a;
    hash.ins[1] <== b;
    hash.k <== salt;
    out <== hash.outs[0];
    
}

component main  = Salt();