from py_ecc.bn128 import G1, multiply, add
from ape import convert


def test_verifier(acct1):
    assert acct1.balance > 0


def test_ecadd(acct1, verifier_contract):
    res = add(G1, G1)
    print(type(G1[0]))
    # x1 = G1[0]
    x1 = convert(G1[0], int)
    assert verifier_contract.add(G1[0], G1[1], G1[0], G1[1]) == res
    assert verifier_contract.add(G1[0], G1[1], G1[0], G1[1]) == res
    print("hello")


def test(verifier_contract):
    print("verifier_contract", verifier_contract.test(2))
    assert verifier_contract.test(1) == 1

# function add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public view returns (uint256 x, uint256 y) {
#     (bool ok, bytes memory result) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
#     require(ok, "add failed");
#     (x, y) = abi.decode(result, (uint256, uint256));
# }

    # function test(uint256 x1) public view returns (uint256 x) {
    #     x = x1;
    # }
