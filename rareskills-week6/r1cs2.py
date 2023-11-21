from py_ecc.bn128 import G1, multiply, add, neg, eq

# Prover
x = 5

X3 = multiply(G1, 5**3)
X2 = multiply(G1, 5**2)
X = multiply(G1, 5)

# Verifier
left_hand_side = multiply(G1, 39)
i = add(multiply(X3, 1),multiply(neg(X2), 4))
ii = add(multiply(X, 3),multiply(neg(G1), 1))
rhs = add(i, ii)

right_hand_side = add(add(add(multiply(X3, 1),multiply(neg(X2), 4)),multiply(X, 3)),multiply(neg(G1), 1))

assert eq(left_hand_side, rhs), "lhs ≠ rhs"