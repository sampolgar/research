# Circuit
import numpy as np
from py_ecc.bn128 import G1,G2, multiply, add, neg, eq, curve_order, pairing
L = np.array([[0, 0, 1, 0], [0, 0, 0, 1]])
R = np.array([[0, 0, 1, 0], [0, 0, 1, 0]])
O = np.array([[0, 0, 0, 1], [-5, 1, -1, 0]])

out = 35
x = 3
v1 = 9
w = np.array([1,out,x,v1])

Li = multiply(G1,x)
Ri = multiply(G2,x)
Oi = multiply(G1,v1)
# test pairing
eq(pairing(Ri,Li), pairing(G2,Oi))

Lii = multiply(G1,v1)
Rii = multiply(G2,x)
Oii = add(add(multiply(G1,curve_order-5),multiply(G1,curve_order-1)),G1)
# test pairing
eq(pairing(Rii,Lii),pairing(G2,Oii))