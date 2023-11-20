// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "forge-std/console.sol";

contract EncryptedR1CS {
  // @constant = curve order, PrimeQ
  uint256 constant CURVE_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
  uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

  G2Point g2 = G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

  /**
   * @dev G1Point addition
   *  @param x1 G1Point1 x
   *  @param y1 G1Point1 y
   *  @param x2 G1Point2 x
   *  @param y2 G1Point2 y
   *  @return x addition of x1 and x2 from precompile address 6 G1Point x
   * @return y addition of y1 and y2 from precompile address 6 G1Point y
   */
  function add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) internal view returns (uint256 x, uint256 y) {
    (bool ok, bytes memory result) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
    require(ok, "add failed");
    (x, y) = abi.decode(result, (uint256, uint256));
  }

  /**
   * @dev G1Point scalar multiplication using precompile 7
   * @param x1 G1Point x
   * @param y1 G1Point y
   * @param scalar is scalar multiple
   * @return x G1Point x
   * @return y G1Point y
   */
  function mul(uint256 x1, uint256 y1, uint256 scalar) internal view returns (uint256 x, uint256 y) {
    (bool ok, bytes memory result) = address(7).staticcall(abi.encode(x1, y1, scalar));
    require(ok, "mul failed");
    (x, y) = abi.decode(result, (uint256, uint256));
  }

  /* This is the negate function from Tornado Cash https://github.com/tornadocash/tornado-core/blob/master/contracts/Verifier.sol
   * @return The negation of p, i.e. p.plus(p.negate()) should be zero.
   */
  function negate(G1Point memory p) internal pure returns (G1Point memory) {
    // The prime q in the base field F_q for G1
    if (p.x == 0 && p.y == 0) {
      return G1Point(0, 0);
    } else {
      return G1Point(p.x, PRIME_Q - (p.y % PRIME_Q));
    }
  }

  struct G1Point {
    uint256 x;
    uint256 y;
  }

  struct G2Point {
    uint256[2] x;
    uint256[2] y;
  }

  /* takes in 3 x matrix of uint256, 1 x array G1 points, 1 x array G2 points
    *
    */
  function verifier(uint256[4][2] memory matrixL, uint256[4][2] memory matrixR, uint256[4][2] memory matrixO, G1Point[4] memory g1Array) public view returns (bool) {
    //loop through top array of matrixL, scale points in g1Array, then add them together
    //repeat for 2nd matrix row
    //I should now have L[sG1,sG1]
    //repeat for G2 and matrixR
    //I should now have L[sG2,sG2]
    //repeat for G1 and matrix O
    //I should now have O[sG1,sG1]
    //do pairing operation with e(-L,R)+e(O,G2)
    G2Point memory G2 = G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);
    G1Point memory LiG1 = scaleAndAggregateMatrixG1(matrixL[0], g1Array);
    console2.log("LiG1:", LiG1.x, LiG1.y);
    G1Point memory LiiG1 = scaleAndAggregateMatrixG1(matrixL[1], g1Array);

    G1Point memory RiG1 = scaleAndAggregateMatrixG1(matrixR[0], g1Array);
    G1Point memory RiiG1 = scaleAndAggregateMatrixG1(matrixR[1], g1Array);
    console2.log("RiG1:", RiG1.x, RiG1.y);

    G1Point memory OiG1 = scaleAndAggregateMatrixG1(matrixO[0], g1Array);
    G1Point memory OiiG1 = scaleAndAggregateMatrixG1(matrixO[1], g1Array);
    G1Point memory negOiG1 = negate(OiG1);
    G1Point memory negOiiG1 = negate(OiiG1);
    console2.log("negOiiG1", negOiiG1.x, negOiiG1.y);

    bool x = pairingVerifier6Point(LiG1, G2, RiG1, G2, negOiG1, G2);
    console2.log(x);
    return true;
  }

  function scaleAndAggregateMatrixG1(uint256[4] memory matrix, G1Point[4] memory g1Array) public view returns (G1Point memory g1Aggregate) {
    for (uint256 i = 0; i < matrix.length; i++) {
      G1Point memory iteratorPoint;
      if (matrix[i] != 0) {
        (iteratorPoint.x, iteratorPoint.y) = mul(g1Array[i].x, g1Array[i].y, matrix[i]);
        (g1Aggregate.x, g1Aggregate.y) = add(g1Aggregate.x, g1Aggregate.y, iteratorPoint.x, iteratorPoint.y);
      }
    }
    return g1Aggregate;
  }


    // for (uint256 i = 0; i < input.length; i++) {
    //   require(input[i] < CURVE_ORDER, "curve order size fail");
      
    //   vk_x = Pairing.plus(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
    // }

  /**
   *  @return true if pairing response from precompile = 0
   *  @param input is calldata bytes, length must modulo 192 because of 6 x 32 byte uint256 input
   *  @dev structure of input is [G1x, G1y, G2x1, G2x2, G2y1, G2y2,...]
   */
  function verifyBytes(bytes calldata input) public view returns (bool) {
    // optional, the precompile checks this too and reverts (with no error) if false, this helps narrow down possible errors
    if (input.length % 192 != 0) revert("Points must be a multiple of 6");
    (bool success, bytes memory data) = address(0x08).staticcall(input);
    console2.log("success: ", success);
    console2.log("data: ", abi.decode(data, (bool)));
    if (success) return abi.decode(data, (bool));
    revert("Wrong pairing");
  }

  /**
   *  @return true if pairing response from precompile = 0
   *  @param L1, B2, C1, D2, E1, F2, G1, H2 is 4 G1 points, 4 G2 points to verify in pairing precompile
   *  @dev note that A1 is already negated here
   */
  function pairingVerifier6Point(G1Point memory L1, G2Point memory R2, G1Point memory O1, G2Point memory L2, G1Point memory R1, G2Point memory O2) public view returns (bool) {
    G1Point[3] memory p1 = [L1, R1, O1];
    G2Point[3] memory p2 = [L2, R2, O2];

    uint256 inputSize = 18;
    uint256[] memory input = new uint256[](inputSize);

    for (uint256 i = 0; i < 3; i++) {
      uint256 j = i * 6;
      input[j + 0] = p1[i].x;
      input[j + 1] = p1[i].y;
      input[j + 2] = p2[i].x[0];
      input[j + 3] = p2[i].x[1];
      input[j + 4] = p2[i].y[0];
      input[j + 5] = p2[i].y[1];
    }

    for (uint256 i = 0; i < 24; i++) {
      console2.log("i: ", input[i]);
    }

    uint256[1] memory out;
    bool success;

    assembly {
      success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
      // Use "invalid" to make gas estimation work
      switch success
      case 0 { invalid() }
    }

    require(success, "pairing-opcode-failed");
    return out[0] != 0;
  }

  /**
   *  @return true if pairing response from precompile = 0
   *  @param A1, B2, C1, D2 is 2 G1 points, 2 G2 points to verify in pairing precompile
   */

  function pairingVerifierSimple(G1Point memory A1, G2Point memory B2, G1Point memory C1, G2Point memory D2) public view returns (bool) {
    G1Point[2] memory p1 = [A1, C1];
    G2Point[2] memory p2 = [B2, D2];

    uint256 inputSize = 12;
    uint256[] memory input = new uint256[](inputSize);

    // change G1 G2 points into input array of uint256
    for (uint256 i = 0; i < 2; i++) {
      uint256 j = i * 6;
      input[j + 0] = p1[i].x;
      input[j + 1] = p1[i].y;
      input[j + 2] = p2[i].x[0];
      input[j + 3] = p2[i].x[1];
      input[j + 4] = p2[i].y[0];
      input[j + 5] = p2[i].y[1];
    }

    for (uint256 i = 0; i < 12; i++) {
      console2.log("i: ", input[i]);
    }

    uint256[1] memory out;
    bool success;

    // use precompile 8
    assembly {
      success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
      // Use "invalid" to make gas estimation work
      switch success
      case 0 { invalid() }
    }

    require(success, "pairing-opcode-failed");
    return out[0] != 0;
  }

  /**
   *  @return true if pairing response from precompile = 0
   *  @param A1, B2, C1, D2, E1, F2, G1, H2 is 4 G1 points, 4 G2 points to verify in pairing precompile
   *  @dev note that A1 is already negated here
   */
  function pairingVerifier8Point(G1Point memory A1, G2Point memory B2, G1Point memory C1, G2Point memory D2, G1Point memory E1, G2Point memory F2, G1Point memory G1, G2Point memory H2) public view returns (bool) {
    G1Point[4] memory p1 = [A1, C1, E1, G1];
    G2Point[4] memory p2 = [B2, D2, F2, H2];

    uint256 inputSize = 24;
    uint256[] memory input = new uint256[](inputSize);

    for (uint256 i = 0; i < 4; i++) {
      uint256 j = i * 6;
      input[j + 0] = p1[i].x;
      input[j + 1] = p1[i].y;
      input[j + 2] = p2[i].x[0];
      input[j + 3] = p2[i].x[1];
      input[j + 4] = p2[i].y[0];
      input[j + 5] = p2[i].y[1];
    }

    for (uint256 i = 0; i < 24; i++) {
      console2.log("i: ", input[i]);
    }

    uint256[1] memory out;
    bool success;

    assembly {
      success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
      // Use "invalid" to make gas estimation work
      switch success
      case 0 { invalid() }
    }

    require(success, "pairing-opcode-failed");
    return out[0] != 0;
  }
}
