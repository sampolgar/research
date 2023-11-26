// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { console2 } from "forge-std/console2.sol";

contract Verifier {
  struct G1Point {
    uint256 x;
    uint256 y;
  }

  struct G2Point {
    uint256[2] x;
    uint256[2] y;
  }

  uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
  G2Point G2 = G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

  /* This is the negate function from Tornado Cash
    https://github.com/tornadocash/tornado-core/blob/master/contracts/Verifier.sol
    * @return The negation of p, i.e. p.plus(p.negate()) should be zero.
    */
  function negate(G1Point memory p) public pure returns (G1Point memory) {
    // The prime q in the base field F_q for G1
    if (p.x == 0 && p.y == 0) {
      return G1Point(0, 0);
    } else {
      return G1Point(p.x, PRIME_Q - (p.y % PRIME_Q));
    }
  }

  /* 
    * 
    */
  function pairing(G1Point memory A, G2Point memory B, G1Point memory C) public view returns (bool verified) {
    verified = true;
    verified = verify(negate(A), B, C);
  }

  /* takes in 3 Points and pairs the last with G2
    *
    */
  function verify(G1Point memory A, G2Point memory B, G1Point memory C) internal view returns (bool) {
    G1Point[2] memory p1 = [A, C];
    G2Point[2] memory p2 = [B, G2];

    uint256 inputSize = 12;
    uint256[] memory input = new uint256[](inputSize);

    for (uint256 i = 0; i < 2; i++) {
      uint256 j = i * 6;
      input[j + 0] = p1[i].x;
      input[j + 1] = p1[i].y;
      input[j + 2] = p2[i].x[0];
      input[j + 3] = p2[i].x[1];
      input[j + 4] = p2[i].y[0];
      input[j + 5] = p2[i].y[1];
    }
    console2.log("input: ", input[0], input[1]);

    uint256[1] memory out;
    bool success;

    assembly {
      success := staticcall(sub(gas(), 2000), 0x80, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
      // Use "invalid" to make gas estimation work
      switch success
      case 0 { invalid() }
    }
    require(success, "pairing-opcode-failed");
    return out[0] != 0;
  }
}
