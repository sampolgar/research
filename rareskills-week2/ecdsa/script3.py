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

    def __repr__(self):
        return f"Point({self.x}, {self.y})"


class Curve(object):
    def __init__(self, curve_eq):
        self.curve_eq = curve_eq
        self.zero_point = Point(0, 0)
        self.generator_point = Point(55066263022277343669578718895168534326250603453777594175500187360389116729240,
                                     32670510020758816978083085130507043184471273380659243275938904335757337482424)
        print(self)

    def __repr__(self):
        return f"Curve({self.curve_eq})"


# Test cases
if __name__ == "__main__":
    # Test Point class
    p1 = Point(1, 2)
    print(f"Created point: {p1}")

    # Test Curve class
    curve1 = Curve("y^2 = x^3 + 7")
    print(f"Created curve: {curve1}")
