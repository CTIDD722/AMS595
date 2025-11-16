import numpy as np
import pandas as pd
from scipy.linalg import eigh
import matplotlib.pyplot as plt

# 0. Load data
df = pd.read_csv("data.csv")
X = df[["Height", "Weight"]].values
n_samples, n_features = X.shape
print(f"Loaded data shape: {X.shape}  (samples x features)")

# Compute covariance matrix
X_mean = X.mean(axis=0)
X_cent = X - X_mean
cov_mat = np.cov(X_cent, rowvar=False)
print("\nCovariance matrix:")
print(cov_mat)


# 2. Eigen-decomposition
eigval, eigvec = eigh(cov_mat)
idx = np.argsort(eigval)[::-1]
eigval = eigval[idx]
eigvec = eigvec[:, idx]
print("\nEigenvalues:")
print(eigval)
print("\nEigenvectors:")
print(eigvec)

# Principal components and explained variance
tot_var = eigval.sum()
var_r = eigval / tot_var
print("\nExplained variance ratio of each principal component:")
for i, ratio in enumerate(var_r, start=1):
    print(f"PC{i}: {ratio:.4f}  ({ratio*100:.2f}% of total variance)")
pc1 = eigvec[:, 0]
pc2 = eigvec[:, 1]
print("\nFirst principal component (PC1):", pc1)
print("Second principal component (PC2):", pc2)

# Project to 1D
scores_1d = X_cent @ pc1
X_proj = np.outer(scores_1d, pc1) + X_mean

# Plot
plt.figure(figsize=(10, 4))

# Original data + first principal component direction
ax1 = plt.subplot(1, 2, 1)
ax1.scatter(X[:, 0], X[:, 1], alpha=0.6, label="Original data")
pc1_line = np.array([-3, 3])
line_points = X_mean + np.outer(pc1_line, pc1)
ax1.plot(line_points[:, 0], line_points[:, 1],
         linewidth=2, label="PC1 direction")
ax1.set_xlabel("Height")
ax1.set_ylabel("Weight")
ax1.set_title("Original data and PC1 direction")
ax1.legend()
ax1.axis("equal")

# 1D projection
ax2 = plt.subplot(1, 2, 2)
ax2.scatter(scores_1d, np.zeros_like(scores_1d), alpha=0.6)
ax2.set_xlabel("PC1 score")
ax2.set_yticks([])
ax2.set_title("1D projection onto PC1")
plt.tight_layout()
plt.show()

print("\nSummary:")
print(f"- PC1 explains {var_r[0] * 100:.2f}% of the total variance.")
print(f"- PC2 explains {var_r[1] * 100:.2f}% of the total variance.")
print("- The data reduced to 1D by projecting onto PC1 are stored in `scores_1d`.")
