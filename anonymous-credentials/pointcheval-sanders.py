# https://eprint.iacr.org/2015/525

# 4.2
from py_ecc.bn128 import G1, G2, pairing, add, multiply, neg, curve_order, eq
import hashlib

# functions


def string_to_int(message):
    return int.from_bytes(message, byteorder='big')

# keygen


# random field elements to scale G2
x = 10
y1 = 15
y2 = 20
y3 = 25
y4 = 30

X = multiply(G2, x)
Y1 = multiply(G2, y1)
Y2 = multiply(G2, y2)
Y3 = multiply(G2, y3)
Y4 = multiply(G2, y4)

sk = [x, y1, y2, y3, y4]
pk = [X, Y1, Y2, Y3, Y4]

# sign
m1 = b"sam"
m2 = b"polgar"
m3 = b"student"
m4 = b"1/1/2000"

h = 77
H = multiply(G1, h)

