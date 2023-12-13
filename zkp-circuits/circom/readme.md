circom page.circom

circom page.circom --r1cs --sym --wasm: compile to generate r1cs

- r1cs: generate r1cs
- sym:
- wasm:
  -- create input.json file inside page_js, cd there,

use snarkjs to compute witness
--- node generate_witness.js page.wasm input.json witness.wtns
--- snarkjs wtns export json witness.wtns

generate trusted setup
snarkjs setup
snarkjs proof

validate proof or inside smart contract
snarkjs validate
snarkjs generateverifier

The --r1cs flag tells circom to generate an R1CS file and the --sym flag means “save the variable names.” That will become clear shortly.

# Explain Add()

```
template Add() {
   signal input a[2];
   signal output c;
   c <== a[0] + a[1];
}

component main {public [a]}  = Add();
```

`snarkjs r1cs print Add.r1cs`

[INFO] snarkJS: [ ] \* [ ] - [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.c +main.a[0] +main.a[1] ] = 0
py_ecc.bn128 Curve Order: 21888242871839275222246405745257275088548364400416034343698204186575808495617

`cat Add.sym`
1,1,0,main.c
2,2,0,main.a[0]
3,3,0,main.a[1]

Underconstrained circuits
https://eprint.iacr.org/2023/512.pdf
One particularly dangerous problem that can arise in this context is that the circuit is underconstrained, meaning that multiple distinct outputs satisfy the equation for the same input value. In other words, a circuit is underconstrained if the equations do not specify a function. Intuitively, such circuits are problematic because there exist inputs for which it is possible for a malicious user to generate bogus witnesses, thereby causing the verifier to accept a proof that it should not.
