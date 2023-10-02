# conda install -n ecdsa hashlib
# conda activate ecdsa
# conda create -n ecdsa python=3.11
# https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/
# https://github.com/qubd/mini_ecdsa/blob/master/mini_ecdsa.py
# secp256k1_order = 115792089237316195423570985008687907852837564279074904382605163141518161494337

import random
import hashlib

# Elliptic curve parameters for y^2 = x^3 + ax + b over Zp
p = 17  # Prime field
a = 0   # Coefficient in curve. this curve is 0
b = 7   #
G = (3, 6)  # Base point
n = 19  # Order of G


def mod_inv(a, m):
    # print(a, m)
    a = a % m  # convert to positive
    g, x, y = extended_gcd(a, m)
    if g != 1:
        # print("Modular inverse does not exist, numbers aren't coprime a, m, g", a, m, g)
        return None  # Modular inverse does not exist, numbers aren't coprime
    else:
        return x % m


def gcd(a, b):
    if a == 0:
        return b
    return gcd(b % a, a)


def extended_gcd(a, b):
    # print("ab is ", a, b)
    if a == 0:
        return b, 0, 1
    else:
        g, x1, y1 = extended_gcd(b % a, a)
        x = y1 - (b // a) * x1
        y = x1
        # print("returning g, x, y", g, x, y)
        return g, x, y


# Elliptic curve point addition

def point_addition(P, Q, p, a):
    if P == (0, 0):
        return Q
    if Q == (0, 0):
        return P

    if P != Q:
        lam = (Q[1] - P[1]) * mod_inv(Q[0] - P[0], p) % p
    else:
        lam = (3 * P[0]**2 + a) * mod_inv(2 * P[1], p) % p

    x_r = (lam**2 - P[0] - Q[0]) % p
    y_r = (lam * (P[0] - x_r) - P[1]) % p

    return (x_r, y_r)

# Scalar multiplication (double-and-add)


def point_mul(k, P, p, a):
    R = (0, 0)
    # for i in range(256):
    bit_length_k = k.bit_length()
    for i in range(bit_length_k):
        if (k >> i) & 1:
            R = point_addition(R, P, p, a)
        P = point_addition(P, P, p, a)
    return R


def verify_order_of_g():
    if point_mul(n, G, p, a) == (0, 0) and point_mul(n-1, G, p, a) != (0, 0):
        print("n is the correct order of G", point_mul(n, G, p, a))
    else:
        print("n is NOT the correct order of G")


verify_order_of_g()
print(n.bit_length())

# Key Generation. Select a random d between 1 and n -1
# d must be coprime to the order
# d = random.randint(1, n-1)

# create public key = d * Generator Point
# Q = point_mul(d, G, p, a)
# print(Q)

# print("gcd", d, n, "=", gcd(12, 17))

