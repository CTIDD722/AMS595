import numpy as np

def stochastic_matrix(n=5, rng=None):
    if rng is None:
        rng = np.random.default_rng()
    P = rng.random((n, n))
    P = P / P.sum(axis=1, keepdims=True)
    return P

def vector(n=5, rng=None):
    if rng is None:
        rng = np.random.default_rng()
    p = rng.random(n)
    p = p / p.sum()
    return p

def markov(P, p0, steps=50):
    p = p0.copy()
    PT = P.T
    for _ in range(steps):
        p = PT @ p
    return p

def stat_dis(P):
    PT = P.T
    vals, vecs = np.linalg.eig(PT)
    idx = np.argmin(np.abs(vals - 1.0))
    v = vecs[:, idx].real
    if v.sum() < 0:
        v = -v
    v = v / v.sum()
    return v

def main():
    n = 5
    rng = np.random.default_rng()

    # Random 5x5 matrix
    P = stochastic_matrix(n, rng=rng)

    # Random initial vector
    p0 = vector(n, rng=rng)

    # 50 transitions
    p_50 = markov(P, p0, steps=50)

    # Compute stationary distribution
    pi = stat_dis(P)

    # Compare
    diff = np.abs(p_50 - pi)
    tol = 1e-5
    match = np.all(diff < tol)

    # print results
    np.set_printoptions(precision=6, suppress=True)
    print("Random 5x5 transition matrix P (rows sum to 1):")
    print(P)
    print("\nInitial probability vector p0 (sum = 1):")
    print(p0, "  (sum =", p0.sum(), ")")
    print("\nProbability vector after 50 transitions p_50:")
    print(p_50, "  (sum =", p_50.sum(), ")")
    print("\nStationary distribution (eigenvector of P^T, scaled):")
    print(pi, "  (sum =", pi.sum(), ")")
    print("\nComponent-wise absolute difference |p50 - pi|:")
    print(diff)
    print(f"\nDo they match within {tol} -> {match}")

if __name__ == "__main__":
    main()
