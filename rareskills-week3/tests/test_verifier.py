import numpy as np
from py_ecc.bn128 import G1, multiply, add, curve_order
from py_ecc.fields import FQ
from fractions import Fraction
import random


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


def test_matrix_vector_multiplication_easy(verifier_contract):
    n = 2
    matrix = [1, 2, 1, 2]
    s = [(1, 2), (1, 2)]
    o = [3353031288059533942658390886683067124040920775575537747144343083137631628272,  19321533766552368860946552437480515441416830039777911637913418824951667761761,
         3353031288059533942658390886683067124040920775575537747144343083137631628272,  19321533766552368860946552437480515441416830039777911637913418824951667761761]
    assert verifier_contract.matmul(matrix, n, s, o) == True


def test_matrix_vector_multiplication_hard(verifier_contract):
    n = 3
    matrix = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    s = [(1, 2), (1, 2), (1, 2)]
    o = [
        4503322228978077916651710446042370109107355802721800704639343137502100212473, 6132642251294427119375180147349983541569387941788025780665104001559216576968,
        20620327752371756597889511849668302065574790742892641857779427155670977738300, 13476221886639441297190182883126933680754442408693165714792516739857175455715,
        20453939078259811958859768391452073654460321168773748684493785442363495374770, 9582859829925552874957318860636821932456214701004608986274201852321144884827
    ]
    assert verifier_contract.matmul(matrix, n, s, o) == True


# def test_matrix_vector_multiplication(verifier_contract):
#     n = 3
#     matrix = np.random.randint(100, size=(n, n))
#     vector = []
#     for i in range(n):
#         ecpoint = multiply(G1, random.randint(1, 100))
#         vector.append(ecpoint)

#     result = [None] * n

#     for j in range(n):
#         # loop n across the matrix, doing scalar mul and +
#         for k in range(n):
#             scalar = matrix[j][k]
#             pointToMultiply = vector[k]
#             if result[j] is None:
#                 result[j] = multiply(pointToMultiply, scalar)
#             else:
#                 result[j] = add(result[j], multiply(pointToMultiply, scalar))

#     # shape the matrix, vector, and result for the contract
#     flat_matrix = matrix.flatten()
#     matrix_list = [item for item in flat_matrix]

#     # verification_vector = [list(item) for item in vector]
#     result_converted = [coordinate for point in result for coordinate in point]

#     print("matrix_list", matrix_list)
#     print("matrix_list", type(matrix_list))
#     print("verification vector", vector)
#     print("result_converted", result_converted)
#     assert verifier_contract.matmul(
#         matrix_list, n, vector, result_converted) == True
