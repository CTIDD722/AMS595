import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt

# random initialization
m, n = 100, 50
np.random.seed(0)
A = np.random.randn(m, n)
X = np.random.randn(m, n)
A_flat = A.ravel()
x_flat = X.ravel()

# Loss function f(X)
def loss(x):
    diff = x - A_flat
    return 0.5 * np.dot(diff, diff)

# 2. Gradient ∇f(X) = X - A
def grad(x):
    return x - A_flat
method = "BFGS"
# method = "CG" as an alternative

# Stopping criteria
tol = 1e-6
max_I = 1000
loss_box = []
pre_loss = loss(x_flat)
loss_box.append(pre_loss)

for k in range(1, max_I + 1):
    res = minimize(
        fun=loss,
        x0=x_flat,
        jac=grad,
        method=method,
        options={'maxiter': 1, 'disp': False}
    )
    x_flat = res.x
    curr_loss = loss(x_flat)
    loss_box.append(curr_loss)
    # Difference between two consecutive losses
    if abs(curr_loss - pre_loss) < tol:
        stop = f"Loss change {abs(curr_loss - pre_loss):.3e} < tol = {tol:.1e}"
        break
    pre_loss = curr_loss
else:
    stop = f"Reached maximum iteration = {max_I}"

X_opt = x_flat.reshape(m, n)

print("Optimization finished.")
print("Method used:", method)
print("Stop reason:", stop)
print("Total iterations:", len(loss_box) - 1)
print("\nInitial loss:", loss_box[0])
print("Final   loss:", loss_box[-1])
print("Frobenius norm ||X* - A||:", np.linalg.norm(X_opt - A))

# Visualize the loss at each iteration
plt.figure(figsize=(6, 4))
plt.plot(range(len(loss_box)), loss_box, marker='o', markersize=2)
plt.xlabel("Iteration")
plt.ylabel("Loss f(X)")
plt.title(f"Gradient Descent via scipy.optimize.minimize ({method})")
plt.grid(True)
plt.tight_layout()
plt.show()
