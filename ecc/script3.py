# inspired by mini_ecdsa https://github.com/qubd/mini_ecdsa/blob/master/mini_ecdsa.py
from hashlib import sha256
from random import SystemRandom, randrange

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def is_infinity(self):
        return self.x == 0 and self.y == 0

    @classmethod
    def at_infinity(cls):
        P = cls(0, 0)
        P.is_infinity = True
        return P

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

    def set_generator(self, point: Point):
        self.generator = point

    def is_point_on_curve(self, point: Point):
        """
        substitute x, y coordinates into curve eqn
        """
        if point.is_infinity():
            return True
        else:
            return (point.y * point.y) % self.prime == (point.x * point.x * point.x + 7) % self.prime

    def order_of_curve(self):
        """
        total points on the curve. The generator must be 1 of these points
        found by recursing from 1 -> prime for each x and y and finding all x/y points that satisfy the curve eqn #TODO should it be prime -1?
        """
        points = [Point(0, 0)]
        if self.prime > 3000:
            raise ValueError(
                "I'm too lazy to calculate points on a curve with a prime larger than 1000")
        else:
            for i in range(self.prime):
                for j in range(self.prime):
                    P = Point(i, j)
                    if (P.y * P.y) % self.prime == (P.x * P.x * P.x + 7) % self.prime:
                        points.append(P)
            return points

    # ?? check 
    def order_of_point(self, G: Point):
        """
        test cyclic subgroup of a point.
        I don't think this works!!! I don't think it's needed?
        """
        if self.prime > 3000:
            raise ValueError(
                "I'm too lazy to calculate points on a curve with a prime larger than 1000")
        elif not self.is_point_on_curve(G):
            raise ValueError(
                "Generator point isn't on the curve"
            )
        else:
            subgroup = []
            current_G: Point = G
            while not current_G.is_infinity():
                subgroup.append(current_G)
                current_G = self.point_addition(current_G, G)
            if not is_prime(len(subgroup)):
                print("subgroup not prime, can't use in ecc")
                return subgroup

    def get_best_generator_point(self) -> Point:
        """
        given a curve, what's the best generator point (largest order)
        """
        print(self)
        best_generators = []
        all_points = self.order_of_curve()
        for i, point in enumerate(all_points):
            subgroup_length = len(self.order_of_point(point))
            print("Point: ", point, " subgroup length: ", subgroup_length)
            if is_prime(subgroup_length):
                best_generators.append((i, subgroup_length))

        sorted_best_generators = sorted(
            best_generators, key=lambda x: x[1], reverse=True)
        if not sorted_best_generators:
            raise ValueError("No prime subgroups found")
        best_generator_array_pos = sorted_best_generators[0][0]
        return all_points[best_generator_array_pos]

    def point_addition(self, P1: Point, P2: Point) -> Point:
        """
        receives 2 points:
        1. tests for infinity points. P1 + (0,0) = P1
        2. if the points are equal, set lambda to the derivative of the curve for tangent to curve at point
        3. if not, set lambda to tangent to curve of both points
        4. use lambda for finding 3rd point
        """
        x1, y1 = P1.x, P1.y
        x2, y2 = P2.x, P2.y

        if P1.is_infinity():
            return P2
        elif P2.is_infinity():
            return P1
        elif P1.x == P2.x and P1.y == P2.y:
            # this is the derivative of the curve y^2 = x^3 + 7 == 3x^2 / 2y or 3x^2 * 2y^-1
            lambdar = (3 * x1 * x1) * pow(2 * y1, -1, self.prime)
        elif y1 == -y2 % self.prime:
            return Point(0, 0)
        else:
            lambdar = (y2 - y1) * pow(x2 - x1, -1, self.prime)

        lambdar %= self.prime
        # eqn of a line through 2 points is y - y1 = λ(x - x1) === y = λ(x - x1) + y1. Substitute into curve equation
        x3 = (lambdar ** 2 - x1 - x2) % self.prime
        # y3 = λ(x3 - x1) + y1. We already know x and x1, substitute in. Create negative y value to create point on other side of x axis
        y3 = (lambdar * (x1 - x3) - y1) % self.prime

        return Point(x3, y3)


    def point_double(self, P: Point) -> Point:
        return self.point_addition(P, P)

    def scalar_multiplication(self, P: Point, k: int) -> Point:
        """
        Multiply a point P by an integer k using the double-and-add method.
        """
        # Point at infinity multiplied by any k remains the point at infinity
        if P.is_infinity():
            return P

        # Any point multiplied by zero results in the point at infinity
        if k == 0:
            return Point.at_infinity()

        # bin() function converts an integer to a binary string prefixed with "0b"
        binary_k = bin(k)[2:]
        # Use the double-and-add method for positive k
        return self.double_and_add(P, binary_k)

    # precompute ??
    def double_and_add(self, P: Point, k: int) -> Point:
        """
        double if the bit is 0, double and add if the bit is 1
        we reverse binary_k to start with the least significant bit. E.g. for 13 = 1101, start at 110"1"
        """
        Q = Point.at_infinity()  # Initialize result as the point at infinity
        R = P  # Initialize a temporary point to hold intermediate values

        # Convert k to its binary representation
        binary_k = bin(k)[2:]

        for bit in reversed(binary_k):
            if bit == '1':
                Q = self.point_addition(Q, R)
            R = self.point_double(R)

        return Q


# ECDSA Utils
# (keygen, sign, verify, hash, truncate)
#
#
def hash(message):
    return int(sha256(message.encode('utf-8')).hexdigest(), 16)


# Mathematics
#
#


# 2 ways to find the modulo inverse
# 1 is you flip y, if you don't know the discrete log of. Discrete log of 5G is 5 ()
# dlog is 420G
# 420G = (x, y), (x, y^-1) 
# negative 
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
    Finds x where (a * x) % m = 1, using Extended Euclidean Algorithm
    if the gcd != 1, the numbers aren't coprime and can't be used for modular multiplicative inverse
    used for ecdsa sig gen & verify
    """
    gcd, x, y = extended_euclidean(a, m)
    if gcd != 1:
        return None  # gcd isn't 1 - factors aren't coprime
    else:
        return x % m


def is_prime(number):
    if number < 2:
        return False
    for i in range(2, int(number ** 0.5) + 1):
        if number % i == 0:
            return False
    return True

# Tests
#
#


def find_best_generator_point():
    curve_eq = "2**256-2**32-2**9-2**8-2**7-2**6-2**4-1"
    prime = 97  # A small prime for testing
    generator = Point(68, 81)  # An example point on the curve
    curve = Curve(curve_eq, prime, generator)

    curve.get_best_generator_point()


def test_order_of_point():
    # Define a curve equation, prime, and generator point
    print("here")
    curve_eq = "2**256-2**32-2**9-2**8-2**7-2**6-2**4-1"
    prime = 97  # A small prime for testing
    generator = Point(68, 81)  # An example point on the curve

    # Create a Curve object
    curve = Curve(curve_eq, prime, generator)
    print(curve)

    # Test the order_of_point method
    subgroup = curve.order_of_point(generator)

    print(f"Subgroup generated by {generator}: {subgroup}")
    print(f"Order of the point: {len(subgroup)}")

    # Validate that the order is correct by checking that order * generator = infinity
    # result = curve.scalar_multiplication(generator, order
    # assert result == Point.at_infinity(), "The order is incorrect"

    print("Test passed.")


def test_is_point_on_curve():
    # Initialize the curve
    generator = Point(68, 81)
    curve = Curve("2**256-2**32-2**9-2**8-2**7-2**6-2**4-1", 97)

    # print(curve.order_of_curve())

    # Test with a point known to be on the curve
    P1 = Point(68, 81)
    assert curve.is_point_on_curve(P1) == True

    print(curve.order_of_curve())
    print(len(curve.order_of_curve()))
    # print(curve.generator)
    print(curve.order_of_point(generator))

    # # Test with a point known to not be on the curve
    P2 = Point(3, 7)
    assert curve.is_point_on_curve(P2) == False

    # # Test with the point at infinity
    P_infinity = Point(0, 0)
    assert curve.is_point_on_curve(P_infinity) == True


def test_point_addition():
    # Initialize curve with equation and prime
    curve = Curve("2**256-2**32-2**9-2**8-2**7-2**6-2**4-1",
                  97)  # Using a small prime for simplicity

    # Test points (remember testing x & y)
    # TODO checkout blog modulo
    P1 = Point(12, 38)
    P1_Prime = Point(12, curve.prime - P1.y)
    P2 = Point(71, 52)
    P3 = Point(5, 36)
    P4 = Point(80, 10)
    zero_point = Point(0, 0)

    # Test: Adding point at infinity
    assert curve.point_addition(P1, zero_point) == P1
    assert curve.point_addition(zero_point, P1) == P1

    # Test: Adding point and its negative (should return point at infinity

    # assert curve.point_addition(P1, P2) == Point(0, 0)

    # # Test: Adding two distinct points
    # print(curve.point_addition(P2, P3))

    print(curve.point_addition(P1, P1_Prime))
    # # Test: Doubling a point
    # assert curve.point_addition(P1, P1) == Point(
    #     80, 87)  # Replace with the actual result
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

    # Test Is Point On Curve
    # test_is_point_on_curve()

    # Test Point Addition
    # test_point_addition()
    # test_scalar_multiplication()
    # test_double_and_add()
    # test_order_of_point()
    test_is_point_on_curve()
    # find_best_generator_point()



    # //TODO Shoof
    # TODO miller rabin pairing