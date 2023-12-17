pragma circom 2.1.4;

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template Pow() {
   signal input a[2];
   signal output c;
   // a**b
   // c <== a[0]**a[1];
   // for i in a[1], multiply a[0] by a[0]. sum += iterator
   signal exponent;
   signal base;
   signal new_sum;
   signal prev_sum;
   prev_sum = base;

   for (var i = 2; i < exponent+1; i++){
      new_sum = base * prev_sum;
      prev_sum = new_sum;
   }

   c <== new_sum;

}

component main = Pow();

// non quadratic constraints not allowed
// quadratic constraint = A * B + C = 0, A, B, C are linear combinations of signals


template Pow() {
    signal input a[2];
    signal output c;

    signal intermediate[bits]; // 'bits' is the number of bits in the exponent
    intermediate[0] <== a[0]; // base case

    for (var i = 1; i < bits; i++) {
        // If the i-th bit of the exponent is 1, multiply by the base, otherwise keep the same
        intermediate[i] <== a[1][i] ? intermediate[i-1] * a[0] : intermediate[i-1];
    }

    c <== intermediate[bits-1]; // The result after all iterations
}

component main = Pow();

template Pow(bits) {
    signal input a[2]; // a[0] is the base, a[1] is the exponent
    signal output c;

    signal intermediate[bits];
    intermediate[0] <== a[0]; // Start with the base

    for (var i = 1; i < bits; i++) {
        // Square the previous result
        intermediate[i] <== intermediate[i-1] * intermediate[i-1];

        // If the i-th bit of the exponent is 1, multiply by the base
        // This requires the exponent's bits to be preprocessed into signals
        if (exponentBit[i] === 1) {
            intermediate[i] <== intermediate[i] * a[0];
        }
    }

    // The final result is the last element after processing all bits
    c <== intermediate[bits-1];
}

component main = Pow(<number_of_bits_for_exponent>);


// 2 ^ 5, 1, 01, 11, 001, 101