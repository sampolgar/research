from py_ecc.bn128 import G1, multiply, add, curve_order
from fractions import Fraction

# def test_rational_add_easy(verifier_contract):
#     frac1 = Fraction(123, 456)
#     frac2 = Fraction(789, 123)
#     frac_add = frac1 + frac2
#     frac_add_num = frac_add.numerator
#     frac_add_den = frac_add.denominator

#     scalar1 = 123 * pow(456, -1, curve_order) % curve_order
#     scalar2 = 789 * pow(123, -1, curve_order) % curve_order
#     hidden_ecp1 = multiply(G1, scalar1)
#     hidden_ecp2 = multiply(G1, scalar2)

#     A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
#     B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

#     res = verifier_contract.rationalAdd(
#         A, B, frac_add_num, frac_add_den)
#     print("verifier_res: ", res)
#     assert res == True


def test_rational_add_harder(verifier_contract):
    frac1 = Fraction(123456, 456789)
    frac2 = Fraction(789123, 123456)
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
    print("verifier_res: ", res)
    assert res == True
