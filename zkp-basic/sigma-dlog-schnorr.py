from Crypto.Hash import keccak
from py_ecc.bn128 import G1, add, multiply, curve_order
import random
import binascii

# keccak256 = keccak.new(data=b'hello', digest_bits=256).digest()
# print("Keccak256:", binascii.hexlify(keccak256))
# Sigma Dlog

fn sigma_dlog() -> proof:
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    # random k, hidden K
    k = random.randint(0, curve_order)
    K = multiply(G1, k)

    c = random.randint(0, curve_order)

    s = (k + c * a) % curve_order
    proof = multiply(G1, s)

    # Verify
    assert proof == add(multiply(A, c), K)