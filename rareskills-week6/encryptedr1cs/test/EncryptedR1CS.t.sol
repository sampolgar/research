// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console2 } from "forge-std/Test.sol";
import { EncryptedR1CS } from "../src/EncryptedR1CS.sol";
// import "../src/EncryptedR1CS.sol";

contract EncryptedR1CSTest is Test {
  EncryptedR1CS public encryptedr1cs;

  function setUp() public {
    encryptedr1cs = new EncryptedR1CS();
  }
  // create a matrix of points
  // create vectors of points
  // loop through 1 row of matrix points, scalar multiply each point with witness vector and corresponding g point, add together
  // result should be 1 point representing addition of points
  // reserve for pairing

  uint256 CURVE_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

  function testPairing2by2Matrix() public view {
    // R1CS Circuit
    uint256[4][2] memory matrixL = [[uint256(0), uint256(0), uint256(1), uint256(0)], [uint256(0), uint256(0), uint256(0), uint256(1)]];
    uint256[4][2] memory matrixR = [[uint256(0), uint256(0), uint256(1), uint256(0)], [uint256(0), uint256(0), uint256(1), uint256(0)]];
    uint256[4][2] memory matrixO = [[uint256(0), uint256(0), uint256(0), uint256(1)], [uint256(CURVE_ORDER - 5), uint256(1), uint256(CURVE_ORDER - 1), uint256(0)]];

    // uint256[4] witness = [1, 35, 3, 9];
    //Convert py_ecc to G2 like this: py_ecc = ((x1,x2),(y1,y2)) => G2Point here is ([x2,x1],[y2,y1])
    EncryptedR1CS.G1Point memory W1G1 = EncryptedR1CS.G1Point(1, 2);
    EncryptedR1CS.G1Point memory W2G1 = EncryptedR1CS.G1Point(19603121658858655875247255127227546065511167701958109023745805570144594432590, 18396643206309242224060210403331962159520263222429416365150105776739848612253);
    EncryptedR1CS.G1Point memory W3G1 = EncryptedR1CS.G1Point(3353031288059533942658390886683067124040920775575537747144343083137631628272, 19321533766552368860946552437480515441416830039777911637913418824951667761761);
    EncryptedR1CS.G1Point memory W4G1 = EncryptedR1CS.G1Point(1624070059937464756887933993293429854168590106605707304006200119738501412969, 3269329550605213075043232856820720631601935657990457502777101397807070461336);

    // G1 Witness
    EncryptedR1CS.G1Point[4] memory g1Array = [W1G1, W2G1, W3G1, W4G1];

    

    bool x = encryptedr1cs.verifier(matrixL, matrixR, matrixO, g1Array);
  }
}
