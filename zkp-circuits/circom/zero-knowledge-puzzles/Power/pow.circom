pragma circom 2.1.4;

template Pow() {
   signal input a[2];
   signal output c;

   c <-- a[0] ** a[1];

}

component main = Pow();