import numpy as np
import random

# this is the computation
# we need to turn it into a circuit
def doubleOrSquare(x,y):
    assert y == 0 or y == 1
    if y == 0:
        return x * x
    else:
        return 2 * x
    
print("doubleOrSquare(2,0)", doubleOrSquare(3,0))
print("doubleOrSquare(2,1)", doubleOrSquare(3,1))



# out = x^2y + 2x(1-y)... if y = 0, out = 2x. If y = 1, out = 2x. 
# assert y == 0 or y == 1 <==> 0 = y(y-1) == constraint y = y * y

# this is the circuit
x = random.randint(1,1000)
y = 0 # or y = 1

out = x * x * y + 2 * (1 - y)
y = y * y
v1 = x * x
w = np.array([1,out,x,y,v1])

O = np.array([
    [0,0,0,0,1],
    [0,0,0,1,0],
    [-2,1,0,2,0]])

L = np.array([
    [0,0,1,0,0],
    [0,0,0,1,0],
    [0,0,0,0,1]])

R = np.array([
    [0,0,1,0,0],
    [0,0,0,1,0],
    [0,0,0,1,0]]
)

result = O.dot(w) == np.multiply(L.dot(w), R.dot(w))
assert result.all(), "result contains inequality"