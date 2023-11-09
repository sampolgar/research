// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract ECPairing {
    struct G1Point {
        uint256 x;
        uint256 y;
    }

    struct G2Point {
        uint256[2] x;
        uint256[2] y;
    }

    uint256 order = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 PQ_PRIME = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    G1Point G1 = G1Point(1, 2);

    function negate(G1Point memory p) public view returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        if (p.x == 0 && p.y == 0) {
            return G1Point(0, 0);
        } else {
            return G1Point(p.x, PQ_PRIME - (p.y % PQ_PRIME));
        }
    }

    /// @dev Adds two EC points together and returns the resulting point.
    /// @param x1 The x coordinate of the first point
    /// @param y1 The y coordinate of the first point
    /// @param x2 The x coordinate of the second point
    /// @param y2 The y coordinate of the second point
    /// @return x The x coordinate of the resulting point
    /// @return y The y coordinate of the resulting point
    function ec_add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
        require(ok, "add failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    /// @dev Multiplies an EC point by a scalar and returns the resulting point.
    /// @param scalar The scalar to multiply by
    /// @param x1 The x coordinate of the point
    /// @param y1 The y coordinate of the point
    /// @return x The x coordinate of the resulting point
    /// @return y The y coordinate of the resulting point
    function scalar_mul(uint256 scalar, uint256 x1, uint256 y1) internal view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(7).staticcall(abi.encode(x1, y1, scalar));
        require(ok, "mul failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    function pairing(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2,
        G1Point memory c1,
        G2Point memory c2,
        G1Point memory d1,
        G2Point memory d2
    ) internal view returns (bool) {
        G1Point[4] memory p1 = [a1, b1, c1, d1];
        G2Point[4] memory p2 = [a2, b2, c2, d2];

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

        uint256[1] memory out;
        bool success;

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mload(inputSize), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 { invalid() }
        }

        require(success, "pairing-opcode-failed");

        return out[0] != 0;
    }

    function calc_X1(uint256 x1, uint256 x2, uint256 x3) public view returns (G1Point memory X1) {
        (uint256 x1_G1x, uint256 x1_G1y) = scalar_mul(x1, G1.x, G1.y);
        (uint256 x2_G1x, uint256 x2_G1y) = scalar_mul(x2, G1.x, G1.y);
        (uint256 x3_G1x, uint256 x3_G1y) = scalar_mul(x3, G1.x, G1.y);

        (uint256 x, uint256 y) = ec_add(x1_G1x, x1_G1y, x2_G1x, x2_G1y);
        (x, y) = ec_add(x, y, x3_G1x, x3_G1y);
        X1 = G1Point(x, y);
    }

    function verify(
        G1Point calldata A,
        G2Point calldata B,
        G1Point calldata alpha,
        G2Point calldata beta,
        uint256 x1,
        uint256 x2,
        uint256 x3,
        G1Point calldata C,
        G2Point calldata delta
    ) public view returns (bool verified) {
        G1Point memory X1 = calc_X1(x1, x2, x3);

        G2Point memory gamma = G2Point(
            [
                18029695676650738226693292988307914797657423701064905010927197838374790804409,
                14583779054894525174450323658765874724019480979794335525732096752006891875705
            ],
            [
                2140229616977736810657479771656733941598412651537078903776637920509952744750,
                11474861747383700316476719153975578001603231366361248090558603872215261634898
            ]
        );

        G1Point memory negA = negate(A);

        verified = pairing(negA, B, alpha, beta, X1, gamma, C, delta);
    }
}
