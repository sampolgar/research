import numpy as np
import random
from py_ecc.bn128 import FQ, FQP, G1, G2, add, multiply, neg, pairing, eq, is_inf, curve_order, field_modulus

# this is the computation
# we need to turn it into a circuit
def doubleOrSquare(x,y):
    assert y == 0 or y == 1
    if y == 0:
        return x * x
    else:
        return 2 * x
    
print("doubleOrSquare(2,0)", doubleOrSquare(3,0))
print("doubleOrSquare(2,1)", doubleOrSquare(3,1))

# this is the circuit
x = random.randint(1,1000)
y = 1 # or y = 1

out = x * x * y + 2 * (1 - y)
y = y * y
v1 = x * x
w = np.array([1,out,x,y,v1])

O = np.array([
    [0,0,0,0,1],
    [0,0,0,1,0],
    [-2,1,0,2,0]])

L = np.array([
    [0,0,1,0,0],
    [0,0,0,1,0],
    [0,0,0,0,1]])

R = np.array([
    [0,0,1,0,0],
    [0,0,0,1,0],
    [0,0,0,1,0]]
)

# loop these
l = L.dot(w)
r = R.dot(w)
o = O.dot(w)

for i in range(len(l)):
    print("pairing(l[i],r[i])", i)
    lhs = pairing(multiply(G2,l[i]),multiply(G1,r[i]))
    rhs = pairing(G2,multiply(G1,o[i]))
    assert eq(lhs,rhs), "result contains inequality"