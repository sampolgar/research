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