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
    // signal inputs[3];
    // signal outputs[1];
    // inputs[0] <== a;
    // inputs[1] <== b;
    // inputs[2] <== salt;

    component hash = MiMCSponge(3, 220, 1);
    hash.nInputs[0] <== a;
    hash.nInputs[1] <== b;
    hash.nInputs[2] <== salt;

    // outputs[0] <== hash.outs;
    out <== hash.outs;


}

component main  = Salt();
// By default all inputs are private in circom. We will not define any input as public 
// because we want them to be a secret , at least in this case. 

// There will be cases where some values will be declared explicitly public .




