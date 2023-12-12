pragma circom 2.1.6;

template Multiply() {
  signal input a;
  signal input b;
  // signal input c;
  // signal s1;
  signal output c;
  
  c <== a * b;
  // s1 <== a * b;
  // out <== s1 * c;
}
// { "a": "2", "b": "3", "c": "5" }
component main = Multiply();



// the same as 
// c <== a * b;

//   signal input a;
//   signal input b;
//   signal input c;
//   signal output out;

//   out <== a * b * c;
// error[T3001]: Non quadratic constraints are not allowed!

//   signal input a;
//   signal input b;
//   signal input c;
//   signal s1;
//   signal output out;
  
//   s1 <== a * b;
//   out <== s1 * c;