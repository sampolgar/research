import numpy as np
import random

# y = random.randint(1, 1000)
y = 5
# x = random.randint(1, 1000)
x = 10
# out = 5*x**3 - 4*y**2*x**2 + 13*x*y**2 + x**2 - 10*y
# out = 5x^3 - 4y^2x^2 + 13xy^2 + x^2 - 10y

v1 = x * x  # x^2
v2 = 5 * x * v1  # 5x^3
v3 = y * y  # y^2
v4 = 4 * v1 * v3  # 4x^2y^2
out = 5*x**3 - 4*y**2*x**2 + 13*x*y**2 + x**2 - 10*y
# out = 13 * x * v3 - 10 * y + v1 + v2 - v4

w = np.array([1, x, y, v1, v2, v3, v4, out])

#   1,x,y,v1,v2,v3,v4,out
L = np.array([
    [0, 1, 0, 0, 0, 0, 0, 0],  # x
    [0, 5, 0, 0, 0, 0, 0, 0],  # 5x
    [0, 0, 1, 0, 0, 0, 0, 0],  # y
    [0, 0, 0, 4, 0, 0, 0, 0],  # 4v1
    [0, 13, 0, 0, 0, 0, 0, 0],  # 13x
])

R = np.array([
    [0, 1, 0, 0, 0, 0, 0, 0],  # x
    [0, 0, 0, 1, 0, 0, 0, 0],  # v1
    [0, 0, 1, 0, 0, 0, 0, 0],  # y
    [0, 0, 0, 0, 0, 1, 0, 0],  # v3
    [0, 0, -10, 1, 1, 1, -1, 0],  # v3 - 10y + v1 + v2 - v4
])


O = np.array([
    [0, 0, 0, 1, 0, 0, 0, 0],  # v1
    [0, 0, 0, 0, 1, 0, 0, 0],  # v2
    [0, 0, 0, 0, 0, 1, 0, 0],  # v3
    [0, 0, 0, 0, 0, 0, 1, 0],  # v4
    [0, 0, 0, 0, 0, 0, 0, 1],  # out3
])


print("L", L.dot(w))
print("R", R.dot(w))
print("LR", np.multiply(L.dot(w), R.dot(w)))
print("O", O.dot(w))
# result = O.dot(w) == np.multiply(L.dot(w), R.dot(w))
# assert result.all(), "result contains an inequality"
