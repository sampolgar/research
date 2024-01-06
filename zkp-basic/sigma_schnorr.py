from Crypto.Hash import keccak
from py_ecc.bn128 import G1, add, multiply, curve_order, eq
import random
import binascii

def string_to_int(message):
    return int.from_bytes(message, byteorder='big')

def sigma_dlog():
    """
    sigma protocol to prove "I know the discrete log of a" i.e. [A] = aG
    It's zero knowledge because the user is proving knowledge of a without revealing a
    
    In simple terms, prover hides a value with elliptic curve groups (scalar multiplication) a * G1 = A
    given A, it's infeasable to find a (it's hard to find discrete log)
    Prover(a, A)              Verifier(A)
    """
    s = string_to_int(b"my secret message")
    S = multiply(G1, s) # public knowledge of encrypted secret
    
    # Prover computes secret randomness
    r = random.randint(0, curve_order)
    R = multiply(G1, r)

    # Prover sends R to verifier, Verifier responds with challenge
    c = random.randint(0, curve_order)

    # Prover receives challenge, computes response
    z = (r + c * s) % curve_order
    Z = multiply(G1, z)

    # Verifier receives Z and computes 
    SRc = add(multiply(S, c), R)
    
    # verifier computes
    assert eq(Z,SRc)
    print("passed verification")


# Sigma Dlog Non-Interactive
def sigma_dlog_ni():
    """
    same sigma protocol, including fiat shamir of the random K
    """
    # Prover Computes
    s = string_to_int(b"my secret message")
    S = multiply(G1, s) # public knowledge of encrypted secret

    # Prover computes secret randomness
    r = random.randint(0, curve_order)
    R = multiply(G1, r)

    c_string = str(R)     # weak fiat shamir - hash random value
    Hc_hex = keccak.new(data=c_string.encode('utf-8'), digest_bits=256).digest().hex()
    Hc_int = int(Hc_hex, 16)
    
    # Prover sends s to verifier
    z = (r + Hc_int * s) % curve_order
    SRc = add(multiply(S, Hc_int), R)
    assert eq(multiply(G1, z), SRc)
    print("passed verification")

def schnorr():
    """
    Signer(m,a,A)           Verifier(m,A)
    Similar to sigma dlog, but with message m. 
    """
    # Signer computes
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    # random k, hidden K
    k = random.randint(0, curve_order)
    K = multiply(G1, k)

    m = "hello world"
    c_string = str(K) + m     # weak fiat shamir - hash random value
    Hc_hex = keccak.new(data=c_string.encode('utf-8'), digest_bits=256).digest().hex()
    Hc_int = int(Hc_hex, 16)

    # Signer sends s to verifier
    s = (k + Hc_int * a) % curve_order

    # verifier computes
    verifier_lhs = multiply(G1, s)
    verifier_rhs = add(multiply(A, Hc_int), K)
    assert(verifier_lhs == verifier_rhs)
    print("passed verification")
   

sigma_dlog()
sigma_dlog_ni()
# # schnorr()