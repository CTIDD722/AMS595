import numpy as np
import matplotlib.pyplot as plt

def mandelbrot(xmin=-2.0, xmax=1.0,
               ymin=-1.5, ymax=1.5,
               w=800,     h=800,
               N=100,     threshold=50.0):

    # Create a complex grid
    x, y = np.mgrid[xmin:xmax:complex(w),
                    ymin:ymax:complex(h)]
    c = x + 1j * y
    z = np.zeros_like(c, dtype=complex)
    mask = np.ones(c.shape, dtype=bool)

    # Iteration loop
    for _ in range(N):
        z[mask] = z[mask] * z[mask] + c[mask]
        escaped = np.abs(z) > threshold
        mask[escaped] = False
    return mask
def plot_mandelbrot(mask):

    fig, ax = plt.subplots(figsize=(4, 4), dpi=150)
    im = ax.imshow(
        mask.T,
        extent=[-2, 1, -1.5, 1.5],
        origin="lower",
        cmap="gray"
    )

    ax.set_xlim(-2, 1)
    ax.set_ylim(-1.5, 1.5)
    ax.set_xticks(np.linspace(-2, 1, 7))
    ax.set_yticks(np.linspace(-1.5, 1.5, 7))
    ax.grid(color='blue', linestyle='-', linewidth=0.6, alpha=0.6)
    ax.set_xlabel('')
    ax.set_ylabel('')
    plt.tight_layout()
    plt.savefig("mandelbrot.png", bbox_inches="tight")
    plt.show()
    print("Figure 1: Mandelbrot set, saved as 'mandelbrot.png'")

if __name__ == "__main__":
    mask = mandelbrot()
    plot_mandelbrot(mask)
