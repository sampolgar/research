# import galois
import numpy as np

# # 1, out, x, y, v1, v2, v3galoi
# L = np.array([
#     [0, 0, 1, 1, 0, 0, 0],
#     [0, 0, 0, 0, 1, 0, 0],
#     [0, 0, 0, -5, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 1],
# ])

# x = 4
# y = -2
# v1 = x * x
# v2 = v1 * v1         # x^4
# v3 = -5*y * y
# out = v3*v1 + v2    # -5y^2 * x^2
# witness = np.array([1, out, x, y, v1, v2, v3])
# # print(np.matmul(L, witness))

# T = np.array([[1,3],[3,4]])
# Tt = np.array([2,3])
# print(np.matmul(T, Tt))



# L = np.array([
#     [0, 0, 1, 0, 0, 0, 0],
#     [0, 0, 0, 0, 1, 0, 0],
#     [0, 0, 0, 74, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 1],
# ])

# R = np.array([
#     [0, 0, 1, 0, 0, 0, 0],
#     [0, 0, 0, 0, 1, 0, 0],
#     [0, 0, 0, 1, 0, 0, 0],
#     [0, 0, 0, 0, 1, 0, 0],
# ])

# O = np.array([
#     [0, 0, 0, 0, 1, 0, 0],
#     [0, 0, 0, 0, 0, 1, 0],
#     [0, 0, 0, 0, 0, 0, 1],
#     [0, 1, 0, 0, 0, 78, 0],
# ])

# GF = galois.GF(79)
# def interpolate_column(col):
#     xs = GF(np.array([1,2,3,4]))
#     return galois.lagrange_poly(xs, col)




# L_galois = GF(L)
# R_galois = GF(R)
# O_galois = GF(O)
# axis 0 is the columns. apply_along_axis is the same as doing a for loop over the columns and collecting the results in an array
# U_polys = np.apply_along_axis(interpolate_column, 0, L_galois)
# V_polys = np.apply_along_axis(interpolate_column, 0, R_galois)
# W_polys = np.apply_along_axis(interpolate_column, 0, O_galois)

# test = np.apply_along_axis(interpolate_column, 0, L_galois)
# test_col = GF(np.array([0,0,0,1]))
# print(interpolate_column(test_col))

# print(interpolate_column(test))

# GF = galois.GF(79)
# def interpolate_column(col):
#     xs = GF(np.array([1,2]))
#     return galois.lagrange_poly(xs, col)

# test_col = GF(np.array([0,2]))
# print(interpolate_column(test_col))


import numpy as np
from scipy.interpolate import lagrange

x = np.array([1,2,3])
y = np.array([5,12,6])

polyC = lagrange(x, y)

print(polyC)
# -7x^2 + 29x - 18# check that it passes through x = {1,2,3} as expected
print(polyC(1))
# 4.0
print(polyC(2))
# 12.0
print(polyC(3))
# 6.0