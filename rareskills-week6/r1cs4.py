# [[0, 0, 1, 0], 
# [0, 0, 0, 1]];

# [[0, 0, 1, 0], 
# [0, 0, 1, 0]]

# [[0, 0, 0, 1], 
# [-5, 1, -1, 0]];

from py_ecc.bn128 import G1,G2, multiply, add, neg, eq, curve_order, pairing
out = 35
x = 3
v1 = 9

i = multiply(G1, x)
ii = multiply(G1, v1)

j = multiply(G2,x)
jj = multiply(G2,x)

k = multiply(G1,v1)
kkii = multiply(G1,curve_order-1)
kki = multiply(G1,curve_order-5)
kk = add(add(G1,kki),kkii)

print(i, "\n", ii, "\n", j, "\n",jj,"\n", k,"\n", kk)

eq(pairing(j,i), pairing(G2, k))
eq(pairing(jj,ii), pairing(G2,kk))