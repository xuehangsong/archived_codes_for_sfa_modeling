# the v1 version is written by Xuehang Song on 03/23/2018
# ----------------------------------------------------------
# v2 plot the direct data of flux, instead of intepolated flux
# v2 plot volumetric flux, instead of darcy flux
# revised by Xuehang 03/25/2018
# v3 remove all ticks/lable/title
# revised by Xuehang 03/25/2018
# ----------------------------------------------------------

import pickle
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec


results_dir = "/Users/song884/remote/reach/results/"
fig_dir = "/Users/song884/remote/reach/figures/flux/"

pt_fname = ("/Users/song884/remote/reach/results/" +
            "HFR_model_test_flux_face_flux.pk")

# pt_fname = '/Users/song884/remote/reach/results/face_flux.pk'

pickle_file = open(pt_fname, "rb")
out_flux = pickle.load(pickle_file)
times = np.sort(list(out_flux.keys()))

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

# read river face information
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

selected_times = [238,
                  255,
                  308,
                  328,
                  386,
                  407,
                  450,
                  476,
                  527,
                  550,
                  580,
                  622]

# simu_times = (np.asarray(selected_times) - 1) * 120

# times = ["Time:  " + "{:.5E}".format(i) + " h" for i in simu_times]

for i_index in selected_times:
    itime = (i_index - 1) * 120
    itime = "Time:  " + "{:.5E}".format(itime) + " h"
    print(itime)
    xy_flux = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
    temp_flux = out_flux[itime]
    unique_flux = []
    for i_xy in range(len(unique_xy)):
        unique_flux.append(sum(np.asarray(temp_flux)[unique_index == i_xy]))
    xy_flux[xy_river_index[:, 1], xy_river_index[:, 0]] = unique_flux
    fig_name = fig_dir + str(i_index) + ".png"
    gs = gridspec.GridSpec(1, 1)
    fig = plt.figure()
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.plot([20, 20], [43, 53], "black")
    ax1.plot([41, 51], [48, 48], "black")
    ax1.plot([52, 62], [16, 16], "black")
    cf1 = ax1.imshow(xy_flux * 24 / 250 / 250,
                     cmap=plt.cm.jet,
                     origin="lower",
                     vmin=-0.2,
                     vmax=0.2,
                     extent=[(x[0] - 0.5 * dx[0]) / 1000,
                             (x[-1] + 0.5 * dx[0]) / 1000,
                             (y[0] - 0.5 * dy[0]) / 1000,
                             (y[-1] + 0.5 * dy[0]) / 1000]
                     )
#    ax1.set_title(itime)
    ax1.set_xlabel("")
    ax1.set_ylabel("")
    ax1.set_xticks([])
    ax1.set_yticks([])
    ax1.set_aspect("equal", "datalim")
    ax1.set_xlim([1e1, 6e1])
    ax1.set_ylim([0, 6e1])
    cb1 = plt.colorbar(cf1, extend="both",
                       orientation="horizontal", shrink=0.8, aspect=25)
    cb1.ax.set_xlabel("Exchange flux (m/d)", rotation=0, labelpad=-40)
    plt.box(on=None)
#    fig.tight_layout()
    fig.set_size_inches(6.5, 5.5)
    fig.savefig(fig_name, dpi=600, transparent=True)
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
