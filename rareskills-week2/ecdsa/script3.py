# inspired by mini_ecdsa https://github.com/qubd/mini_ecdsa/blob/master/mini_ecdsa.py

# Classes
# Point
# Curve
# - Attributes (x, y, cls)
# - Methods (secp256k1, cls (constructor), )
# Functions (discrimanint, order, generate(all points on curve), double, multiply, double-and-add, showpoints)
# Number Theoretic (multiplicative inverse, extended euclids, divisors???)
# ECDSA (keygen, sign, verify, hash, truncate)


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    @classmethod
    def isInfinity(self):
        return self.x == 0 and self.y == 0

    def __repr__(self):
        return f"Point({self.x}, {self.y})"


class Curve(object):
    def __init__(self, curve_eq, prime):
        self.curve_eq = curve_eq
        self.zero_point = Point(0, 0)
        self.generator_point = Point(55066263022277343669578718895168534326250603453777594175500187360389116729240,
                                     32670510020758816978083085130507043184471273380659243275938904335757337482424)
        self.prime = prime
        # print(self.curve_eq, prime)

    def __repr__(self):
        return f"Curve({self.curve_eq})"

    def __str__(self):
        return 'curve: ' + str(self.curve_eq) + ' over ' + 'F_' + str(self.prime)

    def point_addition(self, P1: Point, P2: Point):
        x1, y1 = P1
        x2, y2 = P2

        if Point.isInfinity(P1):
            return P2
        elif Point.isInfinity(P2):
            return P1
        elif P1 == P2:
            lambdar = (3 * x1 * x1) * pow(2 * y1, -1, self.prime)
        else:
            lambdar = (y2 - y1) * pow(x2 - x1, -1, self.prime)

        lambdar %= self.prime

        x3 = (lambdar ** 2 - x1 - x2) % self.prime
        y3 = (lambdar * (x1 - x3) - y1) % self.prime

        return (x3, y3)

# Mathematics
# Number Theoretic (multiplicative inverse, extended euclids, divisors???)

# extended euclidean finds gcd, x, y for eqn ax + by = gcd(a,b)


def extended_euclidean(a, b):
    """
    Computes gcd(a, b) and Bezout's coefficients x, y: ax + by = gcd(a, b).
    Finds the modular inverse, used for signature generation and verification in ECDSA
    ECDSA Signature generation creates s = k^-1 * (z + r * d) mod n. 
    Verification generates u1 = z * s^-1 mod n & u2 = r * s^-1 mod n. s^-1 is mod multiplicative inv of s mod n
    Note that s^-1 is the modular multiplicative inverse
    """
    if a == 0:
        return b, 0, 1
    else:
        gcd, x1, y1 = extended_euclidean(b % a, a)
        x = y1 - (b // a) * x1  #
        y = x1
        return gcd, x, y


# ax = 1 mod(m) -> finds modular multiplicative inverse x of a mod(m)


def modular_multiplicative_inverse(a, m):
    """
    Finds x where (a * x) % m = 1, using Extended Euclidean Algorithm.
    Crucial for signature generation and verification in ECDSA.
    Function uses extended euclidean algo to find the inverse
    """
    gcd, x, y = extended_euclidean(a, m)
    if gcd != 1:
        return None # bcd isn't 1 - factors aren't coprime
    else:
        return x % m


def test_extended_euclidean():
    assert extended_euclidean(0, 1) == (1, 0, 1)
    assert extended_euclidean(10, 0) == (10, 1, 0)
    assert extended_euclidean(35, 15) == (5, 1, -2)
    # assert extended_euclidean(101, 103) == (1, -31, 30)


def test_modular_multiplicative_inverse():
    assert modular_multiplicative_inverse(
        3, 11) == 4  # Because (3 * 4) % 11 = 1
    assert modular_multiplicative_inverse(
        10, 17) == 12  # Because (10 * 12) % 17 = 1
    assert modular_multiplicative_inverse(
        7, 20) == 3  # Because (7 * 3) % 20 = 1
    assert modular_multiplicative_inverse(15, 35) is None  # No inverse exists
    # assert modular_multiplicative_inverse(
    #     22, 91) == 50  # Because (22 * 50) % 91 = 1


# Test cases
if __name__ == "__main__":
    # Test Point class
    p1 = Point(1, 2)
    print(f"Created point: {p1}")

    # Test Curve class
    curve_eqn = 2**256-2**32-2**9-2**8-2**7-2**6-2**4-1
    curve1 = Curve(curve_eqn, 13)
    print(f"Created curve: {curve1}")

    # Test Euclidean & Modular Multiplicative Inverse
    test_extended_euclidean()
    test_modular_multiplicative_inverse()
