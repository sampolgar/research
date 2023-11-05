from py_ecc.bn128 import G1, multiply, add, curve_order
from fractions import Fraction


def test_rational_add_easy(verifier_contract):
    frac_add = Fraction(123, 456) + Fraction(789, 123)

    scalar1 = 123 * pow(456, -1, curve_order) % curve_order
    scalar2 = 789 * pow(123, -1, curve_order) % curve_order

    hidden_ecp1 = multiply(G1, scalar1)
    hidden_ecp2 = multiply(G1, scalar2)

    # Prepare the points for addition
    point_A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
    point_B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

    # Add the points on the curve and check if the result is as expected
    assert verifier_contract.rationalAdd(
        point_A, point_B, frac_add.numerator, frac_add.denominator) == True
    print("Verification successful.")


def test_rational_add_harder(verifier_contract):
    frac_add = Fraction(123456, 456789) + Fraction(789123, 123456)

    # Calculate scalars and ECC point addition
    scalar1 = 123456 * pow(456789, -1, curve_order) % curve_order
    scalar2 = 789123 * pow(123456, -1, curve_order) % curve_order
    hidden_ecp1 = multiply(G1, scalar1)
    hidden_ecp2 = multiply(G1, scalar2)

    # Prepare the points for addition
    point_A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
    point_B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

    # Add the points on the curve and check if the result is as expected
    assert verifier_contract.rationalAdd(
        point_A, point_B, frac_add.numerator, frac_add.denominator) == True
    print("Verification successful.")
