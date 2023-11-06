import numpy as np
from py_ecc.bn128 import G1, multiply, add, curve_order
from py_ecc.fields import FQ
from fractions import Fraction
import random

# def test_rational_add_easy(verifier_contract):
#     frac_add = Fraction(123, 456) + Fraction(789, 123)

#     scalar1 = 123 * pow(456, -1, curve_order) % curve_order
#     scalar2 = 789 * pow(123, -1, curve_order) % curve_order

#     hidden_ecp1 = multiply(G1, scalar1)
#     hidden_ecp2 = multiply(G1, scalar2)

#     # Prepare the points for addition
#     point_A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
#     point_B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

#     # Add the points on the curve and check if the result is as expected
#     assert verifier_contract.rationalAdd(
#         point_A, point_B, frac_add.numerator, frac_add.denominator) == True
#     print("Verification successful.")


# def test_rational_add_harder(verifier_contract):
#     frac_add = Fraction(123456, 456789) + Fraction(789123, 123456)

#     # Calculate scalars and ECC point addition
#     scalar1 = 123456 * pow(456789, -1, curve_order) % curve_order
#     scalar2 = 789123 * pow(123456, -1, curve_order) % curve_order
#     hidden_ecp1 = multiply(G1, scalar1)
#     hidden_ecp2 = multiply(G1, scalar2)

#     # Prepare the points for addition
#     point_A = (hidden_ecp1[0].n, hidden_ecp1[1].n)
#     point_B = (hidden_ecp2[0].n, hidden_ecp2[1].n)

#     # Add the points on the curve and check if the result is as expected
#     assert verifier_contract.rationalAdd(
#         point_A, point_B, frac_add.numerator, frac_add.denominator) == True
#     print("Verification successful.")


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

def test_matrix_vector_multiplication(verifier_contract):
    n = 2
    matrix = [5, 6, 7, 8]
    s = [(1, 2), (1, 2)]
    o = [19033251874843656108471242320417533909414939332036131356573128480367742634479, 20792135454608030201903199625673964159744755218442260092768620403349374102584,
         20620327752371756597889511849668302065574790742892641857779427155670977738300, 13476221886639441297190182883126933680754442408693165714792516739857175455715]
    # assert verifier_contract.matmul(matrix, n, s, o) == True
    print(verifier_contract.matmul(matrix, n, s, o))
