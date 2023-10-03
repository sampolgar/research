# inspired by mini_ecdsa https://github.com/qubd/mini_ecdsa/blob/master/mini_ecdsa.py
# Functions (discrimanint, order, generate(all points on curve), double, multiply, double-and-add, showpoints)

from hashlib import sha256
from random import SystemRandom, randrange


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def isInfinity(self):
        return self.x == 0 and self.y == 0

    @classmethod
    def secp256k1(cls):
        return cls(55066263022277343669578718895168534326250603453777594175500187360389116729240,
                   32670510020758816978083085130507043184471273380659243275938904335757337482424)

    def __repr__(self):
        return f"Point({self.x}, {self.y})"


class Curve(object):
    def __init__(self, curve_eq, prime):
        self.curve_eq = curve_eq
        self.zero_point = Point(0, 0)
        self.prime = prime

    def __repr__(self):
        return f"Curve({self.curve_eq})"

    def __str__(self):
        return 'curve: ' + str(self.curve_eq) + ' over ' + 'F_' + str(self.prime)

    def point_addition(self, P1: Point, P2: Point):
        """
        receives 2 points, first checks if either are zero point, if so, don't need to add them
        then checks if the points are the same, then double it

        """
        x1, y1 = P1.x, P1.y
        x2, y2 = P2.x, P2.y

        if P1.isInfinity():
            return P2
        elif P2.isInfinity():
            return P1
        elif P1.x == P2.x and P1.y == P2.y:
            lambdar = (3 * x1 * x1) * pow(2 * y1, -1, self.prime)
        else:
            if x2 - x1 == 0 or x2 - x1 % self.prime == 0:
                raise ValueError(
                    "Points can't be added x2 - x1 is zero or a multiple of the prime.  x1: ", x1, " x2: ", x2)
            lambdar = (y2 - y1) * pow(x2 - x1, -1, self.prime)

        lambdar %= self.prime

        x3 = (lambdar ** 2 - x1 - x2) % self.prime
        y3 = (lambdar * (x1 - x3) - y1) % self.prime

        return Point(x3, y3)


# Utils
# (keygen, sign, verify, hash, truncate)
#
#
def hash(message):
    return int(sha256(message.encode('utf-8')).hexdigest(), 16)


# Mathematics
#
#
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


def modular_multiplicative_inverse(a, m):
    """
    Finds x where (a * x) % m = 1, using Extended Euclidean Algorithm.
    if the gcd != 1, the numbers aren't coprime and can't be used for modular multiplicative inverse
    Crucial for signature generation and verification in ECDSA.
    Function uses extended euclidean algo to find the inverse
    """
    gcd, x, y = extended_euclidean(a, m)
    if gcd != 1:
        return None  # gcd isn't 1 - factors aren't coprime
    else:
        return x % m

# Tests
#
#


def test_point_addition():
    # Initialize curve with equation and prime
    curve = Curve("2**256-2**32-2**9-2**8-2**7-2**6-2**4-1",
                  97)  # Using a small prime for simplicity

    # Test points
    P1 = Point(3, 6)
    P2 = Point(3, 91)  # Negative of P1
    P3 = Point(80, 10)
    zero_point = Point(0, 0)  # Assuming this represents the point at infinity

    # Test: Adding point at infinity
    assert curve.point_addition(P1, zero_point) == P1
    assert curve.point_addition(zero_point, P1) == P1

    # Test: Adding point and its negative (should return point at infinity)
    assert curve.point_addition(P1, P2) == zero_point

    # Test: Adding two distinct points
    assert curve.point_addition(P1, P3) == Point(
        80, 87)  # Replace with the actual result

    # Test: Doubling a point
    assert curve.point_addition(P1, P1) == Point(
        80, 87)  # Replace with the actual result

    print("All tests passed!")


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
    # p1 = Point(1, 2)
    # print(f"Created point: {p1}")

    # # Test Curve class
    # curve_eqn = 2**256-2**32-2**9-2**8-2**7-2**6-2**4-1
    # curve1 = Curve(curve_eqn, 13)
    # print(f"Created curve: {curve1}")

    # # Test Euclidean & Modular Multiplicative Inverse
    # test_extended_euclidean()
    # test_modular_multiplicative_inverse()

    # Run the test function
    test_point_addition()
