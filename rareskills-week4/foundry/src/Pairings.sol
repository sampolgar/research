// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Pairings {
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
    /**
     *  returns true if == 0,
     *  returns false if != 0,
     *  reverts with "Wrong pairing" if invalid pairing
     */

    function run(uint256[12] memory input) public view returns (bool) {
        assembly {
            let success := staticcall(gas(), 0x08, input, 0x0180, input, 0x20)
            if success { return(input, 0x20) }
        }
        revert("Wrong pairing");
    }

    function run2(bytes calldata input) public view returns (bool) {
        // optional, the precompile checks this too and reverts (with no error) if false, this helps narrow down possible errors
        if (input.length % 192 != 0) revert("Points must be a multiple of 6");
        (bool success, bytes memory data) = address(0x08).staticcall(input);
        if (success) return abi.decode(data, (bool));
        revert("Wrong pairing");
    }

    function run3(uint256[18] memory input) public view returns (bool) {
        uint256 inputSize = 28;
        bool success;
        uint256[1] memory out;

        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mload(inputSize), out, 0x20)
            switch success
            case 0 { invalid() }
        }
        require(success, "pairing-opcode-failed");
        return out[0] != 0;
    }

    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    function createX(uint256[] memory input) public view returns (uint256, uint256) {
        ECPoint memory pointSummary;

        for (uint256 i = 0; i < input.length; i++) {
            //scalar mul G1 point with input
            // add to point at i
            ECPoint memory iteratorPoint;
            (iteratorPoint.x, iteratorPoint.y) = mul(1, 2, input[i]);
            (pointSummary.x, pointSummary.y) = add(pointSummary.x, pointSummary.y, iteratorPoint.x, iteratorPoint.y);
        }
        return (pointSummary.x, pointSummary.y);
    }

    /// (4444740815889402603535294170722302758225367627362056425101568584910268024244, 10537263096529483164618820017164668921386457028564663708352735080900270541420)

    /// function verifyPairing(bytes calldata pairingInput, bytes calldata xInput) public view returns (bool) {}
}
