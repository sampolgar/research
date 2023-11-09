// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import "../src/Pairings.sol";

contract PairingsTest is Test {
  Pairings public pairings;

  function setUp() public {
    pairings = new Pairings();
  }
    
  function testEasy2Pairing() public view {
    // neg(G1)
    uint256 aG1_x = 1;
    uint256 aG1_y = 21888242871839275222246405745257275088696311157297823662689037894645226208581;

    // G2
    uint256 bG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 bG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 bG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 bG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    // G1
    uint256 cG1_x = 1;
    uint256 cG1_y = 2;

    // G2
    uint256 dG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 dG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 dG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 dG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    uint256[12] memory points = [aG1_x, aG1_y, bG2_x2, bG2_x1, bG2_y2, bG2_y1, cG1_x, cG1_y, dG2_x2, dG2_x1, dG2_y2, dG2_y1];

    bool x = pairings.verifyArrayInts(points);
    console2.log("result:", x);
  }

  function testEasy2PairingWithBytes() public view {
    // neg(G1)
    uint256 aG1_x = 1;
    uint256 aG1_y = 21888242871839275222246405745257275088696311157297823662689037894645226208581;

    // G2
    uint256 bG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 bG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 bG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 bG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    // G1
    uint256 cG1_x = 1;
    uint256 cG1_y = 2;

    // G2
    uint256 dG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 dG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 dG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 dG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    bytes memory pointsBytes = abi.encode(aG1_x, aG1_y, bG2_x2, bG2_x1, bG2_y2, bG2_y1, cG1_x, cG1_y, dG2_x2, dG2_x1, dG2_y2, dG2_y1);

    bool x = pairings.verifyBytes(pointsBytes);
    console2.log("result:", x);
  }

  function testEasy3PairingWithBytes() public view {
    // multiply(neg(G1),2)
    uint256 aG1_x = 1368015179489954701390400359078579693043519447331113978918064868415326638035;
    uint256 aG1_y = 11970132820537103637166003141937572314130795164147247315533067598634108082819;

    // G2
    uint256 bG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 bG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 bG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 bG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    // G1
    uint256 cG1_x = 1;
    uint256 cG1_y = 2;

    // G2
    uint256 dG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 dG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 dG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 dG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    // G1
    uint256 eG1_x = 1;
    uint256 eG1_y = 2;

    // G2
    uint256 fG2_x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 fG2_x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 fG2_y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 fG2_y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    bytes memory pointsBytes = abi.encode(aG1_x, aG1_y, bG2_x2, bG2_x1, bG2_y2, bG2_y1, cG1_x, cG1_y, dG2_x2, dG2_x1, dG2_y2, dG2_y1, eG1_x, eG1_y, fG2_x2, fG2_x1, fG2_y2, fG2_y1);

    bool x = pairings.verifyBytes(pointsBytes);
    console2.log("result:", x);
  }

  struct G1Point {
    uint256 x;
    uint256 y;
  }

  struct G2Point {
    uint256[2] x;
    uint256[2] y;
  }

  function test2PairingPointObject() public view {
    //Convert py_ecc to G2 like this: py_ecc = ((x1,x2),(y1,y2)) => G2Point here is ([x2,x1],[y2,y1])
    Pairings.G1Point memory A = Pairings.G1Point(1, 21888242871839275222246405745257275088696311157297823662689037894645226208581);
    Pairings.G2Point memory B = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);
    Pairings.G1Point memory C = Pairings.G1Point(1, 2);
    Pairings.G2Point memory D = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    bool x = pairings.pairingVerifierSimple(A, B, C, D);
    console2.log("result:", x);
  }

  function test4PointPairingEasy() public view {
    //Convert py_ecc to G2 like this: py_ecc = ((x1,x2),(y1,y2)) => G2Point here is ([x2,x1],[y2,y1])
    Pairings.G1Point memory A = Pairings.G1Point(3353031288059533942658390886683067124040920775575537747144343083137631628272, 2566709105286906361299853307776759647279481117519912024775619069693558446822);
    Pairings.G2Point memory B = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);
    Pairings.G1Point memory C = Pairings.G1Point(1, 2);
    Pairings.G2Point memory D = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);
    Pairings.G1Point memory E = Pairings.G1Point(1, 2);
    Pairings.G2Point memory F = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);
    Pairings.G1Point memory G = Pairings.G1Point(1, 2);
    Pairings.G2Point memory H = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    bool x = pairings.pairingVerifier8Point(A, B, C, D, E, F, G, H);
    console2.log("result:", x);
  }

  // // -A_1 * B_2  +  alpha_1 * beta_2  +  X_1 * gamma_2  +  C_1 * delta_2  = 0 for ethereum pre-compile 8
  //Convert py_ecc to G2 like this: py_ecc = ((x1,x2),(y1,y2)) => G2Point here is ([x2,x1],[y2,y1])
  function test4PointPairingHard() public view {
    // Generate X1 = x1 * G1  +  x2 * G1  +  x3 * G1
    uint256[2] memory X1arr;
    uint256[] memory x1_x2_x3 = new uint256[](3);
    x1_x2_x3[0] = 5;
    x1_x2_x3[1] = 10;
    x1_x2_x3[2] = 35;
    (X1arr[0], X1arr[1]) = pairings.createX_1(x1_x2_x3);

    // -A1B2 = pairing(multiply(G2,50),neg(multiply(G1,2))
    Pairings.G1Point memory NegA1 = Pairings.G1Point(1368015179489954701390400359078579693043519447331113978918064868415326638035, 11970132820537103637166003141937572314130795164147247315533067598634108082819);
    Pairings.G2Point memory B2 = Pairings.G2Point([13380007740614884042676552027792669517352976714172339801095960593301186558468, 17322369349692087243447028505687535678015944818229625650476124495994659493777], [16468620448456686443772276482522600812800837353895826753363425853415626031564, 15491351605040989835654031651748126421046576685865653138953335697202469887252]);

    // alpha_1 * beta_2 pairing(G2,multiply(G1,20))
    Pairings.G1Point memory alpha1 = Pairings.G1Point(18947110137775984544896515092961257947872750783784269176923414004072777296602, 12292085037693291586083644966434670280746730626861846747147579999202931064992);
    Pairings.G2Point memory beta2 = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    // X_1 * gamma_2  | (G2, X1) where X1 = 5G1 + 10G1 + 35G1 = 50G1
    Pairings.G1Point memory X1 = Pairings.G1Point(X1arr[0], X1arr[1]);
    Pairings.G2Point memory gamma2 = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    //  C_1 * delta_2  | multiply(G2,30),G1
    Pairings.G1Point memory C1 = Pairings.G1Point(1, 2);
    Pairings.G2Point memory delta2 = Pairings.G2Point([3045295354179676677849867948999926981809716450107785272685219528794174444834, 16254737008305706031004429264063885572618336716292470244842285039341668886874], [3687031281311398245656729489850260357742732581131462810186398483442070052844, 10847281460042142598816270676372539992803021388916026621484136992759522018115]);

    bool x = pairings.pairingVerifier8Point(NegA1, B2, alpha1, beta2, X1, gamma2, C1, delta2);
    console2.log("result:", x);
  }

  function test4PointPairingFail() public {
    // Generate X1
    uint256[2] memory X1arr;

    uint256[] memory x1_x2_x3 = new uint256[](3);
    x1_x2_x3[0] = 5;
    x1_x2_x3[1] = 10;
    x1_x2_x3[2] = 35;
    (X1arr[0], X1arr[1]) = pairings.createX_1(x1_x2_x3);

    // -A1B2 = pairing(multiply(G2,50),neg(multiply(G1,2))
    Pairings.G1Point memory NegA1 = Pairings.G1Point(1368015179489954701390400359078579693043519447331113978918064868415326638035, 11970132820537103637166003141937572314130795164147247315533067598634108082819);
    Pairings.G2Point memory B2 = Pairings.G2Point([13380007740614884042676552027792669517352976714172339801095960593301186558468, 17322369349692087243447028505687535678015944818229625650476124495994659493777], [16468620448456686443772276482522600812800837353895826753363425853415626031564, 15491351605040989835654031651748126421046576685865653138953335697202469887252]);

    // alpha_1 * beta_2 pairing(G2,multiply(G1,20))
    Pairings.G1Point memory alpha1 = Pairings.G1Point(18947110137775984544896515092961257947872750783784269176923414004072777296602, 12292085037693291586083644966434670280746730626861846747147579999202931064992);
    Pairings.G2Point memory beta2 = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    // X_1 * gamma_2  | (G2, X1) where X1 = 5G1 + 10G1 + 35G1 = 50G1
    Pairings.G1Point memory X1 = Pairings.G1Point(X1arr[0], X1arr[1]);
    Pairings.G2Point memory gamma2 = Pairings.G2Point([11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781], [4082367875863433681332203403145435568316851327593401208105741076214120093531, 8495653923123431417604973247489272438418190587263600148770280649306958101930]);

    //  C_1 * delta_2  | multiply(G2,30),G1
    Pairings.G1Point memory C1 = Pairings.G1Point(1, 2);
    Pairings.G2Point memory delta2 = Pairings.G2Point([123123, 16254737008305706031004429264063885572618336716292470244842285039341668886874], [3687031281311398245656729489850260357742732581131462810186398483442070052844, 10847281460042142598816270676372539992803021388916026621484136992759522018115]);

    vm.expectRevert();
    bool x = pairings.pairingVerifier8Point(NegA1, B2, alpha1, beta2, X1, gamma2, C1, delta2);
    console2.log("result:", x);
  }
}
