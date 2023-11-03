from py_ecc.bn128 import G1, multiply, add, curve_order
from fractions import Fraction
from ethpm_types import HexBytes


# def test_ecadd(acct1, verifier_contract):
#     res = add(G1, G1)
#     res = (int(res[0]), int(res[1]))
#     print("res: ", res)

#     G1X = int(G1[0])
#     G1Y = int(G1[1])
#     addres = verifier_contract.add(G1X, G1Y, G1X, G1Y)
#     addres = (int(addres[0]), int(addres[1]))
#     print("addres: ", addres)
#     assert addres == res


# def test_ecmul(verifier_contract):
#     res = multiply(G1, 2)
#     res = (int(res[0]), int(res[1]))
#     print("res: ", res)

#     G1X = int(G1[0])
#     G1Y = int(G1[1])
#     mulres = verifier_contract.mul(G1X, G1Y, 2)
#     mulres = (int(mulres[0]), int(mulres[1]))
#     print("mulres: ", mulres)
#     assert mulres == res

def test_ecc_library(ecc_contract):
    a = 13
    m = 17
    res = ecc_contract.invMod(a, m)
    print("res: ", res)


def test_rational_add(verifier_contract):
    frac1 = Fraction(123, 456)
    frac2 = Fraction(789, 123)
    frac_add = frac1 + frac2
    frac_add_num = frac_add.numerator
    frac_add_den = frac_add.denominator

    scalar1 = 123 * pow(456, -1, curve_order) % curve_order
    scalar2 = 789 * pow(123, -1, curve_order) % curve_order
    hidden_ecp1 = multiply(G1, scalar1)
    hidden_ecp2 = multiply(G1, scalar2)

    A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
    B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

    res = verifier_contract.rationalAdd(
        A, B, frac_add_num, frac_add_den)
    print("verifier_res: ", verifier_res.verified)