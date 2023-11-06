// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Pairings {
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
}
