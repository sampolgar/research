//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// import "https://github.com/witnet/elliptic-curve-solidity/blob/master/contracts/EllipticCurve.sol"

// import "@elliptic-curve-solidity/EllipticCurve.sol";
// import "./EllipticCurve.sol";
// import "@witnet/EllipticCurve.sol";

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

    /// @dev Modular euclidean inverse of a number (mod p).
    /// @param _x The number
    /// @param _pp The modulus
    /// @return q such that x*q = 1 (mod _pp)
    function invMod(uint256 _x, uint256 _pp) public pure returns (uint256) {
        require(_x != 0 && _x != _pp && _pp != 0, "Invalid number");
        uint256 q = 0;
        uint256 newT = 1;
        uint256 r = _pp;
        uint256 t;
        while (_x != 0) {
            t = r / _x;
            (q, newT) = (newT, addmod(q, (_pp - mulmod(t, newT, _pp)), _pp));
            (r, _x) = (_x, r - t * _x);
        }

        return q;
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
        uint256 denInv = EllipticCurve.invMod(den, curve_order);
        uint256 scalar = num * denInv;
        (uint256 x2, uint256 y2) = mul(1, 2, scalar);

        require(x1 == x2, "x1 x2 failed");
        require(y1 == y2, "y1 y2 failed");
        if (x1 != x2 && y1 != y2) return false;
        return true;
    }
}
