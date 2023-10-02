Point
- x,y
- Zero
- set inf point

Curve
- 


Curve
- Attributes (x, y, cls)
- Methods (secp256k1, cls (constructor), )

Functions (discrimanint, order, generate(all points on curve), double, multiply, double-and-add, showpoints)
Number Theoretic (multiplicative inverse, extended euclids, divisors???)
ECDSA (keygen, sign, verify, hash, truncate)


# class Curve(object):
class Point(object):
    # create point
    def __init__(self, x, y):
        self.x, self.y = x, y
        # self.x = False

    # create zero point
    @classmethod
    def atInfinity(cls):
        P = cls(0, 0)
        P.inf = True
        return P

    # create generator point for secp256k1
    @classmethod
    def secp256k1_generator(cls):
        return cls(55066263022277343669578718895168534326250603453777594175500187360389116729240, 32670510020758816978083085130507043184471273380659243275938904335757337482424)

    def __str__(self):
        if self.inf:
            return 'Inf'
        else:
            return '(' + str(self.x) + ',' + str(self.y) + ')'

    def __eq__(self, other):
        if self.inf:
            return other.inf
        elif other.inf:
            return self.inf
        else:
            return self.x == other.x and self.y == other.y

    def is_infinite(self):
        return self.inf

class Curve(object):
    def __init__(self, a, b, c, char, exp):
        self.a, self.b, self.c = a, b, c
        self.char, self.exp = char, exp
        print(self)
