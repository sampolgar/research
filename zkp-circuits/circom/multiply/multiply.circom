pragma circom 2.1.6;

template Multiply() {
  signal input a;
  signal input b;
  signal input c;
  signal i;
  signal output out;
  
  i <== a * b;
  out <== i * c; 
}
component main = Multiply();

// { "a": "2", "b": "3", "c": "5" }