import numpy as np
import scipy.io

fourD = np.arange(24).reshape(2, 3, 4, 1)
bias = np.arange(6)
print("Original")
print("fourD: ", fourD.shape)
print("bias: ", bias.shape)

scipy.io.savemat("test.mat", {"fourD": fourD, "bias": bias})
data = scipy.io.loadmat("test.mat")

print("\nProcessed")
print(data.keys())
print("fourD shape: ", data["fourD"].shape, "    Is unchanged: ", np.array_equal(fourD, data["fourD"]))
print("bias shape: ", data["bias"].flatten().shape, "    Is unchanged: ", np.array_equal(bias, data["bias"].flatten()))
