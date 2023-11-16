from Crypto.Hash import keccak
from py_ecc.bn128 import G1, add, multiply, curve_order
import random
import binascii

# keccak256 = keccak.new(data=b'hello', digest_bits=256).digest()
# print("Keccak256:", binascii.hexlify(keccak256))
# Sigma Dlog

def sigma_dlog():
    (proof, A, K, c) = sigma_dlog_generate_proof()
    print(verify_sigma_dlog(proof, A, K, c))


def sigma_dlog_generate_proof():
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    # random k, hidden K
    k = random.randint(0, curve_order)
    K = multiply(G1, k)

    c = random.randint(0, curve_order)

    s = (k + c * a) % curve_order
    proof = multiply(G1, s)
    return proof, A, K, c

def verify_sigma_dlog(proof, A: G1, K: G1, c) -> bool:
    assert proof == add(multiply(A, c), K)
    return True


# Sigma Dlog Non-Interactive
def sigma_dlog_noninteractive():
    (proof, A, K, Hc_str) = sigma_dlog_noninteractive_generate()
    print(verify_sigma_dlog_noninteractive(proof, A, K, Hc_str))

# best practice to hash the random value with statement 𝑔𝑟||𝑔𝑥 for strong fiat shamir
# https://eprint.iacr.org/2016/771.pdf
def sigma_dlog_noninteractive_generate():
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    # random k, hidden K
    k = random.randint(0, curve_order)
    K = multiply(G1, k)
    c_string = str(K)
    Hc_str = keccak.new(data=c_string.encode('utf-8'), digest_bits=256).digest().hex()
    print("Hc_str:", Hc_str)
    s = (k + Hc_str * a) % curve_order
    proof = multiply(G1, s)
    return proof, A, K, Hc_str

def verify_sigma_dlog_noninteractive(proof, A: G1, K: G1, Hc_str) -> bool:
    assert proof == add(multiply(A, Hc_str), K)
    return True

sigma_dlog_noninteractive()
# sigma_dlog()