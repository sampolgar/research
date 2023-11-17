from Crypto.Hash import keccak
from py_ecc.bn128 import G1, add, multiply, curve_order
import random
import binascii

def sigma_dlog():
    """
    sigma protocol to prove "I know the discrete log of a" i.e. [A] = aG
    It's zero knowledge because the user is proving knowledge of a without revealing a
    
    In simple terms, prover hides a value with elliptic curve groups (scalar multiplication) a * G1 = A
    given A, no one can find a (it's hard to find discrete log)
    Prover(a, A)              Verifier(A)
    """
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    # random k, hidden K
    k = random.randint(0, curve_order)
    K = multiply(G1, k)

    # challenge from verifier
    c = random.randint(0, curve_order)
    
    # response to verifier
    s = (k + c * a) % curve_order
    
    # verifier computes
    verifier_lhs = multiply(G1, s)
    verifier_rhs = add(multiply(A, c), K)
    assert verifier_lhs == verifier_rhs
    print("passed verification")


# Sigma Dlog Non-Interactive
def sigma_dlog_ni():
    """
    same sigma protocol, including fiat shamir of the random K
    """
    # Prover Computes
    a = random.randint(0, curve_order)
    A = multiply(G1, a)

    k = random.randint(0, curve_order)
    K = multiply(G1, k)

    c_string = str(K)     # weak fiat shamir - hash random value
    Hc_hex = keccak.new(data=c_string.encode('utf-8'), digest_bits=256).digest().hex()
    Hc_int = int(Hc_hex, 16)
    
    # Prover sends s to verifier
    s = (k + Hc_int * a) % curve_order

    # verifier computes
    verifier_lhs = multiply(G1, s)
    verifier_rhs = add(multiply(A, Hc_int), K)
    assert verifier_lhs == verifier_rhs
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
    print("passed verification")
   

# sigma_dlog()
# sigma_dlog_ni()
schnorr()