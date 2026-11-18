import pathlib
import numpy as np

DATA_FILE = "sweep_nfet_01v8.txt"
DEVICE = "nfet_01v8"
W_UM = 5
SWEEP_KEYS = ["l", "vgs"] # in loop order -> UPDATE TO 4 KEYS
TEMP_C = 27
K_B = 1.380649e-23
Q_E = 1.602176634e-19

def get_data_path(filename=DATA_FILE):
    """Path to ngpsice output file in build/schematic/spice"""
    project_dir = pathlib.Path(__file__).resolve().parent.parent
    return project_dir / "build" / "schematic" / "spice" / filename

def short_name(raw):
    """'@m.xm1...[gm]' -> 'gm', '@vgs[dc]' -> 'vgs', 'noise' -> 'noise'"""
    if "[" not in raw:
        return raw
    before, inside = raw.split("[")
    inside = inside.rstrip("]")
    if inside == "dc":
        return before.lstrip("@")
    return inside

def load_sweep(path):
    """Reads ngspice wrdata file and outputs a dictionary with header names and corresponding values"""
    with open(path) as f:
        names = f.readline().split()

    data = np.loadtxt(path, skiprows=1)

    short = [short_name(n) for n in names[1:]]
    assert len(set(short)) == len(short), "two columns cleaned to the same name"
    return {name: data[:, i + 1] for i, name in enumerate(short)}

def grid_dims(d, sweep_keys):
    """Gives grid shape in loop order, number of unique values of each sweep variable"""
    dims = [len(np.unique(d[k])) for k in sweep_keys]
    n_rows = len(d[sweep_keys[0]])
    assert np.prod(dims) == n_rows , f"grid {dims} does not fill the file ({n_rows} rows)"
    return dims

def to_grid(d, dims):
    """Reshapes 1-D columns in d into an array of shape dims"""
    return {name: col.reshape(dims) for name, col in d.items()}

def grid_axes(grid, sweep_keys):
    """Checks that each sweep variable varies only along its own axis. Returns axis vectors"""
    axes = {}
    n_dims = len(sweep_keys)
    for a, k in enumerate(sweep_keys):
        idx = [0] * n_dims
        idx[a] = slice(None)
        vec = grid[k][tuple(idx)]

        shape = [1] * n_dims
        shape[a] = -1
        assert np.all(grid[k] == vec.reshape(shape)), f"'{k}' varies along an axis other than {a}: wrong reshape order"
        axes[k] = vec
    return axes

def run_checks(grid, axes, sweep_keys, temp_c=TEMP_C):
    """Physics + self-consistency checks on the gridded table"""
    vgs_ax = sweep_keys.index("vgs")
    ID, GM = grid["id"], grid["gm"]
    gm_id = GM / ID
    V_thermal = K_B * (temp_c + 273.15) / Q_E

    # Ceiling
    peak = gm_id.max(axis=vgs_ax)
    print(f"Max gm/ID: {peak.min():.2f} - {peak.max():.2f} S/A   " f"(n: {1/(V_thermal*peak.max()):.2f} - {1/(V_thermal*peak.min()):.2f})")
    assert np.all(peak < 1 / V_thermal), "gm/ID above the 1/UT physical limit"

    # Monotonic
    steps = np.diff(gm_id, axis=vgs_ax)
    print("Largest gm/ID increase between VGS steps:", steps.max())
    assert np.all(steps < 1e-3), "gm/ID increases with VGS somewhere"

    # Self-consistency
    dID = np.gradient(ID, axes["vgs"], axis=vgs_ax)
    err = np.abs(dID - GM) / GM
    print("Median rel. error:", np.median(err))

    n = err.shape[vgs_ax]
    inner  = np.take(err, range(1, n - 1), axis=vgs_ax)
    print("Max rel. error (ends excluded):", inner.max())



if __name__ == "__main__":
    # Data file setup
    data_path = get_data_path()
    print(data_path, data_path.exists())

    d = load_sweep(data_path)
    print(d["l"].shape)
    print(sorted(d.keys()))

    # Grid size
    dimensions = grid_dims(d, SWEEP_KEYS)
    print("Dimensions:", dimensions)

    # Reshape
    grid = to_grid(d, dimensions)
    ID = grid["id"]
    GM = grid["gm"]
    GDS = grid["gds"]

    axes = grid_axes(grid, SWEEP_KEYS)
    print("Reshape checks passed")
    L = axes["l"] * 1e6  # converted into um
    VGS = axes["vgs"]
    print("L(um):", L)
    print("VGS:", VGS[:3], "...", VGS[-1])
    print("gm/ID at L=0.15, VGS=0.8:", GM[0, 32] / ID[0, 32])

    # Checks
    print("\n=== Checks ===")
    run_checks(grid, axes, SWEEP_KEYS)
