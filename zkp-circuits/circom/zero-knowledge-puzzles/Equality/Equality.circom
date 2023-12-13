pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

// template Equality() {
//    signal input a[3];
//    signal output c;
//    signal v1;
//    signal v2;
//    signal v3;
//    v1 <-- a[0] * a[1];
//    v2 <-- a[1] * a[2];
//    v3 <-- v1 * v2;
   
// }

template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}

component main = IsZero();

// component main = public({a[3]}) Equality();

// component main {public [a]} = Equality();

// template IsZero() {
//     signal input in;
//     signal output out;

//     signal inv;

//     inv <-- in!=0 ? 1/in : 0;

//     out <== -in*inv +1;
//     in*out === 0;
// }


// template IsEqual() {
//     signal input in[2];
//     signal output out;

//     component isz = IsZero();

//     in[1] - in[0] ==> isz.in;

//     isz.out ==> out;
// }