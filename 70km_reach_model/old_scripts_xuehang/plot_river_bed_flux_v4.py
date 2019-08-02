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
import h5py as h5
import glob
from datetime import datetime, timedelta


def batch_delta_to_time(origin, x, time_format, delta_format):
    y = []
    for ix in x:
        if delta_format == "hours":
            temp_y = origin + timedelta(hours=ix)
        elif delta_format == "days":
            temp_y = origin + timedelta(days=ix)
        elif delta_format == "minutes":
            temp_y = origin + timedelta(minutes=ix)
        elif delta_format == "weeks":
            temp_y = origin + timedelta(weeks=ix)
        elif delta_format == "seconds":
            temp_y = origin + timedelta(seconds=ix)
        elif delta_format == "microseconds":
            temp_y = origin + timedelta(microseconds=ix)
        elif delta_format == "milliseconds":
            temp_y = origin + timedelta(milliseconds=ix)
        else:
            print("Sorry, this naive program only solve single time unit")
        y.append(temp_y.strftime(time_format))
    y = np.asarray(y)
    return(y)


case_name = "HFR_100x100x5_6h_bc"


output_dir = "/Users/song884/remote/reach/Outputs/" + case_name + "/"
fig_dir = "/Users/song884/remote/reach/figures/" + case_name + "/face_flux/"

data_dir = "/Users/song884/remote/reach/data/"
date_origin = datetime.strptime("2007-03-28 00:00:00", "%Y-%m-%d %H:%M:%S")
model_origin = np.genfromtxt(
    output_dir + "model_origin.txt", delimiter=" ", skip_header=1)
material_file = h5.File(output_dir + "HFR_material_river.h5", "r")

# read mass1 coordinates
section_coord = np.genfromtxt(
    data_dir + "MASS1/coordinates.csv", delimiter=",", skip_header=1)
section_coord[:, 1] = section_coord[:, 1] - model_origin[0]
section_coord[:, 2] = section_coord[:, 2] - model_origin[1]
mass1_length = section_coord[:, 4] - section_coord[-1, 4]

# add three lines to contour indicating mass1 location
line1 = section_coord[0, 1:3] / 1000
line2 = section_coord[int(len(section_coord[:, 1]) / 2), 1:3] / 1000
line3 = section_coord[-1, 1:3] / 1000
line1_x = [line1[0]] * 2
line1_y = [line1[1] - 5, line1[1] + 5]
line2_x = [line2[0] - 5, line2[0] + 5]
line2_y = [line2[1]] * 2
line3_x = [line3[0] - 5, line3[0] + 5]
line3_y = [line3[1]] * 2


material_h5 = h5.File(output_dir + "HFR_material_river.h5", "r")
pt_fname = output_dir + "face_flux.pk"


pickle_file = open(pt_fname, "rb")
out_flux = pickle.load(pickle_file)
times = np.sort(list(out_flux.keys()))


# read model dimensions
all_h5 = glob.glob(output_dir + "pflotran*h5")
all_h5 = np.sort(all_h5)

input_h5 = h5.File(all_h5[0], "r")
x_grids = list(input_h5["Coordinates"]['X [m]'])
y_grids = list(input_h5["Coordinates"]['Y [m]'])
z_grids = list(input_h5["Coordinates"]['Z [m]'])
input_h5.close()

# x_grids = np.arange(0, 60001, 100)
# y_grids = np.arange(0, 60001, 100)
# z_grids = np.arange(0, 201, 5)

dx = np.diff(x_grids)
dy = np.diff(y_grids)
dz = np.diff(z_grids)

nx = len(dx)
ny = len(dy)
nz = len(dz)
x = x_grids[0] + np.cumsum(dx) - 0.5 * dx[0]
y = y_grids[0] + np.cumsum(dy) - 0.5 * dy[0]
z = z_grids[0] + np.cumsum(dz) - 0.5 * dz[0]

grids = np.asarray([(x, y, z) for z in range(nz)
                    for y in range(ny) for x in range(nx)])

# # read river face information
# river_loc = np.genfromtxt(
#     results_dir + "river_cell_coord.csv", delimiter=",", skip_header=1)
# river_loc = np.asarray(river_loc)
# # need minus 1 as python index started with 0
# river_loc[:, 0] = river_loc[:, 0] - 1

# river_cells = np.unique(river_loc[:, 0]).astype(int)
# n_river = len(river_cells)
# river_index = [grids[i, :] for i in river_cells]

# river_face = np.array([], dtype=np.float).reshape(0, 6)
# river_coord = np.array([], dtype=np.float).reshape(0, 2)
# for i_river in range(n_river):
#     temp_faces = river_loc[(river_loc[:, 0] == river_cells[i_river]), 1]
#     temp_coord = river_loc[np.where(
#         river_loc[:, 0] == river_cells[i_river])[0][0], 2:4]
#     temp_coord = np.reshape(temp_coord, (1, 2))
#     river_coord = np.concatenate((river_coord, temp_coord), axis=0)
#     temp_face_vector = np.array([0, 0, 0, 0, 0, 0]).reshape(1, 6)
#     for iface in list(map(int, temp_faces)):
#         temp_face_vector[0, iface - 1] = 1
#     river_face = np.concatenate(
#         (river_face, temp_face_vector), axis=0)


# read river face information
# read river face information
river_cells = []
river_faces = []
for i_region in list(material_h5['Regions'].keys()):
    river_cells = np.append(river_cells, np.asarray(
        list(material_h5["Regions"][i_region]["Cell Ids"])))
    river_faces = np.append(river_faces, np.asarray(
        list(material_h5["Regions"][i_region]["Face Ids"])))
river_cells = river_cells.astype(int)
river_cells = river_cells - 1  # need minus 1 as python index started with 0
river_faces = river_faces.astype(int)

unique_river_cells = np.unique(river_cells)

unique_river_cells = np.unique(river_cells)

temp_unique_river_cells = unique_river_cells
unique_river_cells = []
for i_cell in temp_unique_river_cells:
    if (grids[i_cell, 0] > 0 and grids[i_cell, 0] < (nx - 1) and
            grids[i_cell, 1] > 0 and grids[i_cell, 1] < (ny - 1) and
            grids[i_cell, 2] > 0 and grids[i_cell, 2] < (nz - 1)):
        unique_river_cells.append(i_cell)

n_unique = len(unique_river_cells)
unique_index = [grids[i, :] for i in unique_river_cells]

unique_xy = [grids[i, 0:2] for i in unique_river_cells]
unique_xy = np.asarray(unique_xy)

for itime in out_flux.keys():
    #    itime = "Time:  " + "{:.5E}".format(itime) + " h"
    real_time = batch_delta_to_time(
        date_origin, [float(itime[7:18])], "%Y-%m-%d %H:%M:%S", "hours")
    real_time = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in real_time]
    print(real_time)
    xy_flux = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
    for i_unique in np.arange(n_unique):
        xy_flux[unique_xy[i_unique, 1],
                unique_xy[i_unique, 0]] = out_flux[itime][i_unique]
    fig_name = fig_dir + str(real_time[0]) + ".png"
    gs = gridspec.GridSpec(1, 1)
    fig = plt.figure()
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.plot(line1_x, line1_y, "black")
    ax1.plot(line2_x, line2_y, "black")
    ax1.plot(line3_x, line3_y, "black")
    cf1 = ax1.imshow(xy_flux * 24 / dx[0] / dy[0],
                     cmap=plt.cm.jet,
                     origin="lower",
                     vmin=-0.1,
                     vmax=0.1,
                     extent=[(x[0] - 0.5 * dx[0]) / 1000,
                             (x[-1] + 0.5 * dx[0]) / 1000,
                             (y[0] - 0.5 * dy[0]) / 1000,
                             (y[-1] + 0.5 * dy[0]) / 1000]
                     )
    ax1.set_xlabel("Easting (km)")
    ax1.set_ylabel("Northing (km)")
    ax1.set_aspect("equal", "datalim")
    ax1.set_xlim([np.min(x_grids) / 1000, np.max(x_grids) / 1000])
    ax1.set_ylim([np.min(x_grids) / 1000, np.max(x_grids) / 1000])
    cb1 = plt.colorbar(cf1, extend="both")
    cb1.ax.set_ylabel("Exchange flux (m/d)", rotation=270, labelpad=20)
    fig.tight_layout()
    fig.set_size_inches(6.5, 5.5)
    fig.savefig(fig_name, dpi=600)
    plt.close(fig)
