# import numpy as np
# import random
# from py_ecc.bn128 import G1,G2, multiply, add, neg, eq, pairing, curve_order

# O = np.array([
#     [0,0,0,0,1,0],
#     [0,0,0,0,0,1],
#     [curve_order-3,1,1,2,0,curve_order-3]])

# L = np.array([
#     [0,0,1,0,0,0],
#     [0,0,0,0,1,0],
#     [0,0,5,0,0,0]])

# R = np.array([
#     [0,0,1,0,0,0],
#     [0,0,0,1,0,0],
#     [0,0,0,1,0,0]]
# )

# x = 864
# y = 754

# out = 3 * x * x * y + 5 * x * y - x - 2 * y + 3

# v1 = x * x
# v2 = v1 * y
# w = np.array([1,1691828863,864,754,746496,562857984])
# # print(1,"out:",out,"x: ",x,"y:",y,"v1: ",v1,"v2: ",v2)

# LG1 = np.zeros(5)
# RG2 = np.zeros(5)
# OG1 = np.zeros(5)

# for i in range(len(w)):
#     LG1[i] = multiply(G1,w[i])

# for i in range(len(w)):
#     RG2[i] = multiply(G2,w[i])

# OG1 = LG1.copy()

# Lres = np.zeros(3)
# Rres = np.zeros(3)
# Ores = np.zeros(3)

# for j in range(len(L)):
#     for k in range(len(w)):
#         # multiply w with each column of L if not zero
#         # if Lres isn't empty, add the result to Lres. Otherwise, it is Lres
#         if L[j][k] != 0:
#             if Lres[j] != 0:
#                 Lres[j] = add(Lres[j],multiply(LG1[k],L[j][k]))
#             else:
#                 Lres[j] = multiply(LG1[k],L[j][k])

# for z in range(len(Lres)):
#     print("Lres",z,":",Lres[z])

# # for j in range(len(R)):
# #     for k in range(len(w)):
# #         # multiply w with each column of R if not zero
# #         # if Rres isn't empty, add the result to Rres. Otherwise, it is Rres
# #         if R[j][k] != 0:
# #             if Rres[j] != 0:
# #                 Rres[j] = add(Rres[j],multiply(RG2[k],R[j][k]))
# #             else:
# #                 Rres[j] = multiply(RG2[k],R[j][k])












# result = O.dot(w) == np.multiply(L.dot(w), R.dot(w))
# assert result.all(), "result contains inequality"

# # x: 864
# # y: 754
# # 1 out: 1691828863 x:  864 y: 754 v1:  746496 v2:  562857984