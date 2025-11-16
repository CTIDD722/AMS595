import numpy as np
from scipy.linalg import eig

# Define the matrix
M = np.array([
    [0,   0,   1/2, 0   ],
    [1/3, 0,   0,   1/2 ],
    [1/3, 1/2, 0,   1/2 ],
    [1/3, 1/2, 1/2, 0   ]
], dtype=float)

n = M.shape[0]

# Compute the dominant eigenvector
eigvals, eigvecs = eig(M)
idx_max = np.argmax(eigvals.real)
v_dom = eigvecs[:, idx_max].real  # Take the real part of the dominant eigenvector
v_dom = v_dom / v_dom.sum()      # Normalize
print("Dominant eigenvalue (should be 1):", eigvals[idx_max])
print("PageRank from eigenvector (normalized):", v_dom)
print("Sum of ranks:", v_dom.sum())

# Power iteration
v = np.ones(n)
v = v / v.sum()
tol = 1e-10
max_I = 1000
for k in range(max_I):
    v_new = M @ v
    diff = np.linalg.norm(v_new - v, 1)  # L1 norm
    if diff < tol:
        print(f"Power iteration converged in {k+1} iterations")
        v = v_new
        break
    v = v_new

# Cross-check
print("PageRank from power iteration  :", v)
print("Difference between two methods :", np.linalg.norm(v - v_dom, 1))

# Output scores
for i, score in enumerate(v, start=1):
    print(f"Page {i}: PageRank score = {score:.6f}")

# Ranking
best_score = np.max(v)
best_pages = [i+1 for i, s in enumerate(v) if abs(s - best_score) < 1e-12]
print("\nHighest PageRank score:", best_score)
print("Page(s) with highest rank:", best_pages)
