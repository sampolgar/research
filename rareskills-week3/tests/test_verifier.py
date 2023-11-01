from py_ecc.bn128 import G1, multiply, add


def test_ecadd(acct1, verifier_contract):
    res = add(G1, G1)
    res = (int(res[0]), int(res[1]))
    print("res: ", res)

    G1X = int(G1[0])
    G1Y = int(G1[1])
    addres = verifier_contract.add(G1X, G1Y, G1X, G1Y)
    addres = (int(addres[0]), int(addres[1]))
    print("addres: ", addres)
    assert addres == res


def test_ecmul(verifier_contract):
    res = multiply(G1, 2)
    res = (int(res[0]), int(res[1]))
    print("res: ", res)

    G1X = int(G1[0])
    G1Y = int(G1[1])
    mulres = verifier_contract.mul(G1X, G1Y, 2)
    mulres = (int(mulres[0]), int(mulres[1]))
    print("mulres: ", mulres)
    assert mulres == res
