import pathlib
import numpy as np
import matplotlib.pyplot as plt

from read_sweep import(get_data_path, load_sweep, grid_dims, to_grid, grid_axes, DEVICE, W_UM, SWEEP_KEYS, TEMP_C, K_B, Q_E)

if __name__ == "__main__":
    d = load_sweep(get_data_path())
    grid = to_grid(d, grid_dims(d, SWEEP_KEYS))
    axes = grid_axes(grid, SWEEP_KEYS)

    L = axes["l"] * 1e6  # converted into um
    VGS = axes["vgs"]
    ID = grid["id"]
    GM = grid["gm"]
    GDS = grid["gds"]

    # Plots
    plot_dir = pathlib.Path(__file__).resolve().parent.parent / "plots"
    plot_dir.mkdir(exist_ok = True)

    colors = plt.cm.viridis(np.linspace(0, 1, len(L)))   # 17 colours, dark → bright

    GM_ID = GM / ID
    GM_GDS = GM / GDS

    V_thermal = K_B * (TEMP_C + 273.15) / Q_E
    peak = GM_ID.max(axis=1)
    for Li, p in zip(L, peak):
        print(f"L = {Li:5g} um   max gm/ID = {p:5.2f} S/A   n = {1 / (V_thermal * p):.2f}")

    # gm/ID vs VGS
    fig, ax = plt.subplots()
    for i in range(len(L)):
        ax.plot(VGS, GM_ID[i, :], label = f"{L[i]:g}", color=colors[i])
    ax.set_xlabel("VGS (V)")
    ax.set_ylabel("gm/ID (S/A)")
    ax.grid(True)
    ax.legend(title="Lengths (µm)", fontsize=6, title_fontsize=7, ncol=2, loc="upper left", bbox_to_anchor=(1.02, 1))
    ax.set_title(f"{DEVICE}, W = {W_UM} µm, VDS = {d['vds'][0]:g} V, VSB = {d['vsb'][0]:g} V")
    fig.savefig(plot_dir / "gmid_vs_vgs.png", dpi=150, bbox_inches="tight")
    plt.close(fig)

    # gm/gds vs gm/ID
    fig, ax = plt.subplots()
    for i in range(len(L)):
        ax.plot(GM_ID[i, :], GM_GDS[i, :], label = f"{L[i]:g}", color=colors[i])
    ax.set_xlabel("gm/ID (S/A)")
    ax.set_ylabel("gm/gds (V/V)")
    ax.set_xlim(3, 28)
    ax.set_yscale("log")
    ax.grid(True, which="both")
    ax.legend(title="Lengths (µm)", fontsize=6, title_fontsize=7, ncol=2, loc="upper left", bbox_to_anchor=(1.02, 1))
    ax.set_title(f"{DEVICE}, W = {W_UM} µm, VDS = {d['vds'][0]:g} V, VSB = {d['vsb'][0]:g} V")
    fig.savefig(plot_dir / "gmgds_vs_gmid.png", dpi=150, bbox_inches="tight")
    plt.close(fig)