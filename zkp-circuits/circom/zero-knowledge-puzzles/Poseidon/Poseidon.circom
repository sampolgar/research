pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/poseidon.circom";

template poseidon() {
   signal input a;
   signal input b;
   signal input c;
   signal input d;
   signal output out;

   signal array[4];
   a ==> array[0];
   b ==> array[1];
   c ==> array[2];
   d ==> array[3];
   
   component poseidon = Poseidon(4);

   poseidon.inputs[0] <== array[0];
   poseidon.inputs[1] <== array[1];
   poseidon.inputs[2] <== array[2];
   poseidon.inputs[3] <== array[3];
   
   out <== poseidon.out;
}

component main = poseidon();