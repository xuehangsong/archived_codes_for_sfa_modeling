import numpy as np
import h5py as h5
import glob
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

output_dir = "/Users/song884/remote/reach/Outputs/2007_age/"
results_dir = "/Users/song884/remote/reach/results/"
pt_fname = "/Users/song884/remote/reach/results/" + \
    "HFR_model_test_flux_face_flux.pk"
fig_dir = "/Users/song884/remote/reach/figures/head/"

nx = 304
ny = 268
nz = 40
dx = [250] * nx
dy = [250] * ny
dz = [5] * nz
x = 0 + np.cumsum(dx) - 0.5 * dx[0]
y = 0 + np.cumsum(dy) - 0.5 * dy[0]
z = 0 + np.cumsum(dz) - 0.5 * dz[0]
grids = np.asarray([(x, y, z) for z in range(nz)
                    for y in range(ny) for x in range(nx)])


all_h5 = glob.glob(output_dir + "pflotran*h5")
all_h5 = np.sort(all_h5)


river_loc = np.genfromtxt(
    results_dir + "river_cell_coord.csv", delimiter=",", skip_header=1)
river_loc = np.asarray(river_loc)
# need minus 1 as python index started with 0
river_loc[:, 0] = river_loc[:, 0] - 1

river_cells = np.unique(river_loc[:, 0]).astype(int)
n_river = len(river_cells)
river_index = [grids[i, :] for i in river_cells]

river_face = np.array([], dtype=np.float).reshape(0, 6)
river_coord = np.array([], dtype=np.float).reshape(0, 2)
for i_river in range(n_river):
    temp_faces = river_loc[(river_loc[:, 0] == river_cells[i_river]), 1]
    temp_coord = river_loc[np.where(
        river_loc[:, 0] == river_cells[i_river])[0][0], 2:4]
    temp_coord = np.reshape(temp_coord, (1, 2))
    river_coord = np.concatenate((river_coord, temp_coord), axis=0)
    temp_face_vector = np.array([0, 0, 0, 0, 0, 0]).reshape(1, 6)
    for iface in list(map(int, temp_faces)):
        temp_face_vector[0, iface - 1] = 1
    river_face = np.concatenate(
        (river_face, temp_face_vector), axis=0)

plane_x, plane_y = np.meshgrid(x, y)

unique_xy, unique_index = np.unique(river_coord, return_inverse=True, axis=0)
n_unique = len(unique_xy)
xy_river_index = np.concatenate(
    ([np.where(i == x)[0] for i in unique_xy[:, 0]],
     [np.where(i == y)[0] for i in unique_xy[:, 1]]),
    axis=1)
yx_river = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
for i_xy in range(len(unique_xy)):
    yx_river[xy_river_index[:, 1], xy_river_index[:, 0]] = 1


for i_h5 in all_h5:
    print(i_h5)
    input_h5 = h5.File(i_h5, "r")

    groups = list(input_h5.keys())
    time_index = [s for s, s in enumerate(groups) if "Time:" in s]

    for itime in time_index:
        print(itime)
        temp_wl = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)

        temp_pressure = np.asarray(
            list(input_h5[itime]["Liquid_Pressure [Pa]"]))
        temp_head = (temp_pressure - 101325) / 997.16 / 9.8068
        for ix in range(nx):
            for iy in range(ny):
                positive_head_index = np.where(temp_head[ix, iy, :] > 0)[0]
                if (len(positive_head_index) > 0):
                    iz = positive_head_index[0]
                    temp_wl[iy, ix] = temp_head[ix, iy, iz] + z[iz]
        fig_name = fig_dir + str(itime[7:18]) + ".png"
        gs = gridspec.GridSpec(1, 1)
        fig = plt.figure()
        ax1 = fig.add_subplot(gs[0, 0])
        cf1 = ax1.contourf(x / 1000, y / 1000, temp_wl,
                           cmap=plt.cm.jet,
                           levels=np.arange(100, 130.1, 0.1),
                           vmin=100,
                           vmax=130,
                           extend="both",
                           V=np.arange(100, 130.1, 5)
                           )
        cf2 = ax1.contour(x / 1000, y / 1000, temp_wl,
                          colors="grey",
                          levels=np.arange(100, 130.1, 1.5),
                          linewidths=1,
                          vmin=100,
                          vmax=130)

        ax1.set_xlabel("Easting (km)")
        ax1.set_ylabel("Northing (km)")
        ax1.set_aspect("equal", "datalim")
        ax1.set_xlim([1e1, 6e1])
        ax1.set_ylim([0, 6e1])
        ax1.set_aspect("equal", "datalim")
        cb1 = plt.colorbar(cf1, extend="both")  # ,
#                           orientation="horizontal", shrink=0.8, aspect=25)
        cb1.ax.set_ylabel("Exchange flux (m/d)", rotation=270, labelpad=20)
        fig.tight_layout()
        cf3 = ax1.contourf(x / 1000, y / 1000, yx_river, colors="black")
        fig.set_size_inches(6.5, 5.5)
        fig.savefig(fig_name, dpi=600, transparent=True)
        plt.close(fig)

# input_h5.close()
