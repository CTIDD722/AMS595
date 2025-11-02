import time
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sympy as sp
from math import factorial

def Q1(func, start, end, degree, fix_c, num=100):
    x = sp.Symbol('x')
    xs = np.linspace(start, end, num)

    # Store derivatives evaluated at c
    c = []
    f = func
    for k in range(degree + 1):
        f_k_at_c = f.subs(x, fix_c)
        c.append(float(f_k_at_c))
        f = sp.diff(f, x)

    # Taylor polynomial
    values = []
    for xv in xs:
        s = sum(
            c[k] * ((xv - fix_c) ** k) / factorial(k)
            for k in range(degree + 1)
        )
        values.append(s)
    values = np.array(values, dtype=float)
    fl = sp.lambdify(x, func, 'numpy')
    vals = fl(xs)
    return xs, values, vals

def Q2():
    x = sp.Symbol('x')
    func = x * sp.sin(x)**2 + sp.cos(x)
    start, end, num = -10.0, 10.0, 100
    degree, fixed_c = 99, 0.0
    xs, approx_vals, true_vals = Q1(func, start, end, degree, fixed_c, num)

    # Plot
    plt.figure(figsize=(6, 4))
    plt.plot(xs, true_vals, 'k-', label='Actual')
    plt.plot(xs, approx_vals, 'ro', markersize=3, label='Taylor Approximation')
    plt.title('Example Taylor series approximation plot')
    plt.xlabel('x')
    plt.ylabel(r'$x\sin^2(x) + \cos(x)$')
    plt.legend()
    plt.grid(alpha=0.3)
    plt.tight_layout()
    plt.savefig('taylor_example.png', dpi=200)
    plt.show()

def Q3(func, start, end, fix, initial, final, step, num = 100, csv = 'taylor_values.csv'):
    x = sp.Symbol('x')
    f_lamb = sp.lambdify(x, func, 'numpy')
    xs = np.linspace(start, end, num)
    vals = f_lamb(xs)

    records = []
    for m in range(initial, final + 1, step):
        t0 = time.time()
        _, approx_vals, _ = Q1(func, start, end, m, fix, num)
        abs_error = np.abs(vals - approx_vals)
        error_sum = abs_error.sum()
        elapsed = time.time() - t0
        records.append({
            'degree': m,
            'error_sum': error_sum,
            'time_sec': elapsed
        })

        print(f"[INFO] m = {m:3d}, error_sum = {error_sum:.6e}, time = {elapsed:.4f}s")
    df = pd.DataFrame(records, columns=['degree', 'error_sum', 'time_sec'])
    df.to_csv(csv, index=False)
    print(f"[INFO] Results written to {csv}")
    return df

if __name__ == '__main__':
    Q2()
    x = sp.Symbol('x')
    func = x * sp.sin(x)**2 + sp.cos(x)

    ini_degree = 50
    fin_degree = 100
    deg = 10

    df = Q3(func=func, start=-10.0, end=10.0, fix=0.0, initial=ini_degree, final=fin_degree, step=deg, num=100,
            csv='taylor_values.csv')
    print("\nFinal DataFrame:")
    print(df)
