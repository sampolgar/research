import numpy as np
import random

O = np.array([
    [0,0,0,0,1,0,0,0],
    [0,0,0,0,0,1,0,0],
    [0,0,0,0,0,0,1,0],
    [0,0,0,0,0,0,0,1],
    [0,1,0,10,-1,-5,0,-13],
    ])

L = np.array([
    [0,0,1,0,0,0,0,0],
    [0,0,0,0,1,0,0,0],
    [0,0,0,1,0,0,0,0],
    [0,0,1,0,0,0,0,0],
    [0,0,0,0,-4,0,0,0],
    ])

R = np.array([
    [0,0,1,0,0,0,0,0],
    [0,0,1,0,0,0,0,0],
    [0,0,0,1,0,0,0,0],
    [0,0,0,0,0,0,1,0],
    [0,0,0,0,0,0,1,0],
    ])

x = random.randint(1,1000)
y = random.randint(1,1000)
out = 5*x**3 - 4*y**2*x**2 + 13*x*y**2 + x**2 - 10*y
v1 = x * x
v2 = x * x * x
v3 = y * y
v4 = x * y * y

w = np.array([1,out,x,y,v1,v2,v3,v4])

result = O.dot(w) == np.multiply(L.dot(w), R.dot(w))
print(O.dot(w))
print("----")
print(np.multiply(L.dot(w), R.dot(w)))
print("----")
print(result)
assert result.all(), "result contains inequality"