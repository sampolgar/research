pragma circom 2.1.6;

template Array(n) {
    signal input a;
    signal output array[n];

    array[0] <== a;

    for (var i = 1; i < n; i++) {
        array[i] <== powers[i - 1] * a;
    }
}

component main = Array(6)

// equivalent to
template Array1() {
    signal input a;
    signal output array[6];

    powers[0] <== a;
    powers[1] <== powers[0] * a;
    powers[2] <== powers[1] * a;
    powers[3] <== powers[2] * a;
    powers[4] <== powers[3] * a;
    powers[5] <== powers[4] * a;
}

component main = Array1();