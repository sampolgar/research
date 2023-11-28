//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// import "https://github.com/witnet/elliptic-curve-solidity/blob/master/contracts/EllipticCurve.sol"

// import "@elliptic-curve-solidity/EllipticCurve.sol";
// import "./EllipticCurve.sol";
import "@witnet/EllipticCurve.sol";
import "hardhat/console.sol";

contract Verifier {
    // @constant = curve order
    uint256 CURVE_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    /// @dev ECPoint addition
    /// @param x1 ECPoint1 x
    /// @param y1 ECPoint1 y
    /// @param x2 ECPoint2 x
    /// @param y2 ECPoint2 y
    /// @return x addition of x1 and x2 from precompile address 6 ECPoint x
    /// @return y addition of y1 and y2 from precompile address 6 ECPoint y
    function add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) internal view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
        require(ok, "add failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    /// @dev ECPoint scalar multiplication using precompile 7
    /// @param x1 ECPoint x
    /// @param y1 ECPoint y
    /// @param scalar is scalar multiple
    /// @return x ECPoint x
    /// @return y ECPoint y
    function mul(uint256 x1, uint256 y1, uint256 scalar) internal view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(7).staticcall(abi.encode(x1, y1, scalar));
        require(ok, "mul failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    }

    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    /// @notice Verifies the prover  knows 2 numbers num, den that add together to secret input ECPoint A + ECPoint B
    /// @param A EC Point A, dlog of [a]
    /// @param B EC Point B, dlog of [b]
    /// @param num = numerator
    /// @param den = denominator
    /// @return verified = return true if ECPoint A + ECPoint B = G1 * num / den
    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den)
        public
        view
        returns (bool verified)
    {
        require(den != 0, "denominator can't be 0");

        //LHS = add ECPoints A, B
        (uint256 LHSx, uint256 LHSy) = add(A.x, A.y, B.x, B.y);

        //RHS = num * pow(den, -1, curve_order)
        uint256 rhsScalar = mulmod(num, EllipticCurve.invMod(den, CURVE_ORDER), CURVE_ORDER);
        (uint256 RHSx, uint256 RHSy) = mul(1, 2, rhsScalar);

        require(LHSx == RHSx, "x eq failed");
        require(LHSy == RHSy, "y eq failed");
        return true;
    }

    /// @dev matrix multiplication of an n x n matrix of uint256 and a 1 x n matrix of points.
    /// @dev It validates the claim that matrix Ms = o where o is a 1 x n matrix of uint256.
    /// @param matrix of uint. For a 2 x 2 matrix [[1,2][3,4]] = [1,2,3,4]
    /// @param n size of matrix 2 x 2 matrix, n = 2
    /// @param s ECPoints should be size n x 2. ECPoints (1,2) and (3,4) = [(1,2),(3,4)]
    /// @param o 1 x n matrix
    /// @return verified or not for zk matrix vector multiplication
    function matmul(uint256[] calldata matrix, uint256 n, ECPoint[] calldata s, uint256[] calldata o)
        public
        view
        returns (bool verified)
    {
        require(matrix.length == n * n, "Invalid matrix size");
        require(s.length == n, "Invalid vector length");
        require(o.length == 2 * n, "Invalid validator length"); // for x and y co-ordinates

        ECPoint[] memory result = new ECPoint[](n);

        for (uint256 i = 0; i < n; i++) {
            ECPoint memory iteratorPoint;

            for (uint256 j = 0; j < n; j++) {
                //first scalar mul the first G point & Array pos
                uint256 scalar = matrix[i * n + j];
                ECPoint memory pointToMultiply = s[j];

                (iteratorPoint.x, iteratorPoint.y) = mul(pointToMultiply.x, pointToMultiply.y, scalar);
                (result[i].x, result[i].y) = add(result[i].x, result[i].y, iteratorPoint.x, iteratorPoint.y);
            }
        }
        // verify calc to input. o is in the form [x,y,x,y,x,y], loop every 2
        for (uint256 i = 0; i < n; i++) {
            if (result[i].x != o[2 * i] || result[i].y != o[2 * i + 1]) {
                return false;
            }
        }
        return true;
    }
}
