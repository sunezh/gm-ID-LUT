import pathlib
import numpy as np
import matplotlib.pyplot as plt

# Data file setup
script_dir = pathlib.Path(__file__).resolve().parent
project_dir = script_dir.parent
data_path = project_dir / "build" / "schematic" / "spice" / "sweep_nfet_01v8.txt"
print(data_path, data_path.exists())

# Read header
with open(data_path) as f:
    names = f.readline().split()
print(len(names), names[:2], names[-4:])

# Read data
data = np.loadtxt(data_path, skiprows=1)
print(data.shape)

# Name processor
def short_name(raw):
    """'@m.xm1...[gm]' -> 'gm', '@vgs[dc]' -> 'vgs', 'noise' -> 'noise'"""
    if "[" not in raw:
        return raw
    before, inside = raw.split("[")
    inside = inside.rstrip("]")
    if inside == "dc":
        return before.lstrip("@")
    return inside

short = [short_name(n) for n in names[1:]]
assert len(set(short)) == len(short), "two columns cleaned to the same name"
d = {name: data[:, i + 1] for i, name in enumerate(short)}
print(sorted(d.keys()))

# Grid size
n_l = len(np.unique(d["l"]))
n_vgs = len(np.unique(d["vgs"]))
dimensions = [n_l, n_vgs]
print("Dimensions:", dimensions)
assert n_l * n_vgs == len(d["l"]), "grid does not fill the file"

# Reshape
L_grid = d["l"].reshape(dimensions)
VGS_grid = d["vgs"].reshape(dimensions)
ID = d["id"].reshape(dimensions)
GM = d["gm"].reshape(dimensions)
GDS = d["gds"].reshape(dimensions)
print("Shapes:", L_grid.shape, ID.shape)

assert np.all(L_grid == L_grid[:, :1]), "L not constant along a row: wrong reshape order"
assert np.all(VGS_grid == VGS_grid[:1, :]), "VGS rows differ: wrong reshape order"
print("Reshape checks passed")

L = L_grid[:, 0] * 1e6  # converted into um
VGS = VGS_grid[0, :]
print("L(um):", L)
print("VGS:", VGS[:3], "...", VGS[-1])
print("gm/ID at L=0.15, VGS=0.8:", GM[0, 32] / ID[0, 32])

# Plots
plot_dir = project_dir / "plots"
plot_dir.mkdir(exist_ok = True)

colors = plt.cm.viridis(np.linspace(0, 1, len(L)))   # 17 colours, dark → bright

GM_ID = GM / ID
GM_GDS = GM / GDS

# gm/ID vs VGS
fig, ax = plt.subplots()
for i in range(len(L)):
    ax.plot(VGS, GM_ID[i, :], label = f"{L[i]:g}", color=colors[i])
ax.set_xlabel("VGS (V)")
ax.set_ylabel("gm/ID (S/A)")
ax.grid(True)
ax.legend(title="Lengths (µm)", fontsize=6, title_fontsize=7, ncol=2, loc="upper left", bbox_to_anchor=(1.02, 1))
ax.set_title(f"nfet_01v8, W = 5 µm, VDS = {d['vds'][0]:g} V, VSB = {d['vsb'][0]:g} V")
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
ax.set_title(f"nfet_01v8, W = 5 µm, VDS = {d['vds'][0]:g} V, VSB = {d['vsb'][0]:g} V")
fig.savefig(plot_dir / "gmgds_vs_gmid.png", dpi=150, bbox_inches="tight")
plt.close(fig)

# Checks
print("\n=== Checks ===")

# Weak-inversion ceiling, gm/ID can never exceed 1/V_thermal
k = 1.380649e-23
q = 1.602176634e-19
T = 300.15
V_thermal = k * T / q
peak = GM_ID.max(axis=1)
for Li, p in zip(L, peak):
    print(f"L = {Li:5g} um   max gm/ID = {p:5.2f} S/A   n = {1 / (V_thermal * p):.2f}")
assert np.all(peak < 1 / V_thermal), "gm/ID above the 1/V_thermal physical limit"
print("Ceiling check passed")

# gm/ID should fall (or stay flat) as VGS rises
steps = np.diff(GM_ID, axis=1)
print("Largest increase in gm/ID between VGS steps:", steps.max())
assert np.all(steps < 1e-3), "gm/ID increases with VGS somewhere" # tolerance for noise
print("Monotonic check passed")

# Self-consistency, numerical dID/dVGS should match ngspice's gm
dID = np.gradient(ID, VGS, axis=1)
err = np.abs(dID - GM) / GM
print("Median relative error per L:", np.round(np.median(err, axis=1), 4))
print("Max relative error (ends excluded):", err[:, 1:-1].max())
