import pickle
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

results_dir = "/Users/song884/remote/reach/results/"
fig_dir = "/Users/song884/remote/reach/figures/river_flux/"

pt_fname = ("/Users/song884/remote/reach/results/" +
            "river_flux_2007_new_material.pk")

pt_fname = '/Users/song884/remote/reach/results/face_flux.pk'

pickle_file = open(pt_fname, "rb")
out_flux = pickle.load(pickle_file)
times = np.sort(list(out_flux.keys()))

nx = 304
ny = 267
nz = 40
dx = [250] * nx
dy = [250] * ny
dz = [5] * nz
x = 0 + np.cumsum(dx) - 0.5 * dx[0]
y = 0 + np.cumsum(dy) - 0.5 * dy[0]
z = 0 + np.cumsum(dz) - 0.5 * dz[0]

grids = np.asarray([(x, y, z) for z in range(nz)
                    for y in range(ny) for x in range(nx)])

# read river face information
river_loc = np.genfromtxt(
    results_dir + "river_cell_coord.csv", delimiter=",", skip_header=1)
river_loc = np.asarray(river_loc)

river_cells = np.unique(river_loc[:, 0]).astype(int)
n_river = len(river_cells)
river_index = np.asarray([grids[i - 1, :] for i in river_cells])
river_index = [grids[i - 1, :] for i in river_cells]

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

xy_river_index = np.concatenate(
    ([np.where(i == x)[0] for i in river_coord[:, 0]],
     [np.where(i == y)[0] for i in river_coord[:, 1]]),
    axis=1)

for itime in times:
    print(itime)
    xy_flux = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
    xy_flux[xy_river_index[:, 1], xy_river_index[:, 0]] = out_flux[itime]

    fig_name = fig_dir + itime[7:18] + ".png"
    gs = gridspec.GridSpec(1, 1)
    fig = plt.figure()

    ax1 = fig.add_subplot(gs[0, 0])
    cf1 = ax1.contourf(x, y, xy_flux,
                       cmap=plt.cm.jet,
                       levels=np.arange(-0.03, 0.031, 0.01),
                       extend="both",
                       vmin=-0.03,
                       vmax=0.03
                       )
    ax1.set_title(itime)
    ax1.set_xlabel("Easting (m)")
    ax1.set_ylabel("Northing (m)")
    ax1.set_aspect("equal", "datalim")
    ax1.set_xlim([1e4, 6e4])
    ax1.set_ylim([0, 6e4])
    cb1 = plt.colorbar(cf1)  # , cax=ax1)
    cb1.set_ticks(np.arange(-0.03, 0.031, 0.005))
    cb1.ax.set_ylabel("Darcy flux (m/h)", rotation=270, labelpad=20)

    fig.set_size_inches(6.5, 6.5)
    fig.savefig(fig_name, dpi=600)
    plt.close(fig)

    # pl_x = np.arange(1e4, 6e4 + 1, 1.2e4)
    # pl_y = np.arange(0e4, 7e4 + 1, 1.4e4)

    # ax2 = fig.add_subplot(gs[0, 1])
    # ax2.contourf(x, y, xy_flux,
    #              cmap=plt.cm.jet,
    #              levels=np.arange(-0.03, 0.031, 0.005),
    #              extend="both",
    #              vmin=-0.03,
    #              vmax=0.03
    #              )
    # ax2.set_title("(a) Entire Reach")
    # ax2.set_xlabel("Easting (m)")
    # ax2.set_ylabel("Northing (m)")
    # ax2.set_aspect("equal", "datalim")
    # ax2.set_xlim([1.2e4, 2.4e4])
    # ax2.set_ylim([4e4, 6e4])
