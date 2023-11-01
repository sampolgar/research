//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VERIFIER {
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

    function test(uint256 x1) public view returns (uint256 x) {
        x = x1;
    }
}
