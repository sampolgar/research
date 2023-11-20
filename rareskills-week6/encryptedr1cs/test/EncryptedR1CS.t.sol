// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EncryptedR1CS} from "../src/EncryptedR1CS.sol";

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

    uint256[4][2] matrixL = [[0, 0, 1, 0], [0, 0, 0, 1]];
    uint256[4][2] matrixR = [[0, 0, 1, 0], [0, 0, 1, 0]];
    uint256[4][2] matrixO = [
        [uint256(0), uint256(0), uint256(0), uint256(1)],
        [uint256(CURVE_ORDER - 5), uint256(1), uint256(CURVE_ORDER - 1), uint256(0)]
    ];

    // uint256[4] witness = [1, 35, 3, 9];
    EncryptedR1CS.G1Point memory W1 = EncryptedR1CS.G1Point(1,2);
    EncryptedR1CS.G1Point memory W2 = EncryptedR1CS.G1Point();

}
