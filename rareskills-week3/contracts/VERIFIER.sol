//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "https://github.com/witnet/elliptic-curve-solidity/blob/master/contracts/EllipticCurve.sol"

contract Verifier {
    function add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
        require(ok, "add failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    function mul(uint256 x1, uint256 y1, uint256 scalar) public view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(7).staticcall(abi.encode(x1, y1, scalar));
        require(ok, "mul failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den)
        public
        view
        returns (bool verified)
    {
        // use precompile to add points
        (uint256 x1, uint256 y1) = add(A.x, A.y, B.x, B.y);

        // to calculate G1 * num/den, change den into multiplicative inverse i.e. pow(den, -1, curve_order)
        uint256 curve_order = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        uint256 denInv = modularMultiplicativeInverse(den, curve_order);
        uint256 scalar = num * denInv;
        (uint256 x2, uint256 y2) = mul(1, 2, scalar);

        require(x1 == x2, "x1 x2 failed");
        require(y1 == y2, "y1 y2 failed");
        if (x1 != x2 && y1 != y2) return false;
        return true;
    }

    // Helper function to safely subtract two unsigned integers
    function safeSubtract(uint256 a, uint256 b) internal pure returns (uint256, bool) {
        if (a < b) {
            // Would underflow
            return (0, false);
        } else {
            return (a - b, true);
        }
    }

    // Extended Euclidean Algorithm adapted for unsigned integers.
    function extendedEuclidean(uint256 a, uint256 b) public pure returns (uint256, uint256, uint256) {
        if (a == 0) {
            return (b, 0, 1);
        } else {
            (uint256 gcd, uint256 x1, uint256 y1) = extendedEuclidean(b % a, a);
            (uint256 x, bool subtracted) = safeSubtract(y1, (b / a) * x1);
            require(subtracted, "Operation would underflow");
            return (gcd, x, x1); // Note that y = x1, since subtraction cannot be negative here.
        }
    }

    // Computes the modular multiplicative inverse of a modulo m.
    function modularMultiplicativeInverse(uint256 a, uint256 m) public pure returns (uint256) {
        (uint256 gcd, uint256 x, uint256 y) = extendedEuclidean(a, m);
        require(gcd == 1, "Inverse doesn't exist");
        return x; // x is already in the range 0 to m-1
    }
}
