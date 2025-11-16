import numpy as np
from scipy.linalg import lstsq, solve

# Data setup
X = np.array([
    [2100, 3, 20],
    [2500, 4, 15],
    [1800, 2, 30],
    [2200, 3, 25]
], dtype=float)
y = np.array([460, 540, 330, 400], dtype=float)
print("X shape:", X.shape)
print("y shape:", y.shape)

# Least squares to solve for β
b_lstsq, residual, rank, s = lstsq(X, y)
print("\nβ (via lstsq) =")
print(b_lstsq)
print("Residual sum of squares (from lstsq):", residual)
# Compute residual sum of squares manually
res_manual = np.linalg.norm(X @ b_lstsq - y) ** 2
print("Manual residual sum of squares:", res_manual)

# Model prediction
x_new = np.array([2400, 3, 20], dtype=float)
pre_price = x_new @ b_lstsq
print("\nPredicted price for [2400 sqft, 3 bedrooms, 20 years]:")
print(f"{pre_price:.2f} (thousands of dollars)")

# 4. Compare with normal equations + scipy.linalg.solve
A = X.T @ X
b = X.T @ y
b_solve = solve(A, b)
print("\nβ (via normal equations + solve) =")
print(b_solve)

# Compare the difference between the two β
diff = np.linalg.norm(b_lstsq - b_solve)
print("\n‖β_lstsq - β_solve‖ =", diff)

# Compare residuals
res_solve = np.linalg.norm(X @ b_solve - y) ** 2
print("Residual sum of squares (solve):", res_solve)

