import numpy as np
import random

O = np.array([
    [0,0,0,0,1,0],
    [0,0,0,0,0,1],
    [-3,1,1,2,0,-3]])

L = np.array([
    [0,0,1,0,0,0],
    [0,0,0,0,1,0],
    [0,0,5,0,0,0]])

R = np.array([
    [0,0,1,0,0,0],
    [0,0,0,1,0,0],
    [0,0,0,1,0,0]]
)

x = random.randint(1,1000)
y = random.randint(1,1000)

out = 3 * x * x * y + 5 * x * y - x - 2 * y + 3

v1 = x * x
v2 = v1 * y
w = np.array([1,out,x,y,v1,v2])

result = O.dot(w) == np.multiply(L.dot(w), R.dot(w))
assert result.all(), "result contains inequality"