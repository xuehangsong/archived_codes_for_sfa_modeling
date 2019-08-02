# the v1 version is written by Xuehang Song on 03/23/2018
# ----------------------------------------------------------
# the problem of v1 is it caculated darcy flux, not actual volume
# v2 use actual volume accross bed,
# revised by Xuehang 03 / 25 / 2018
# v3 is revised based on v2,the simulation is conducted using fixed
# pflotran flux output
# v4 read dimension from material file revised by Xuehang 03 / 25 / 2018
# v5 exclude external river cells, revised by Xuehang 04 / 14 / 2018
# ----------------------------------------------------------

import numpy as np
import h5py as h5
import glob
import pickle

output_dir = "/Users/song884/remote/reach/Outputs/HFR_200x200x2_1w_bc/"
pt_fname = output_dir + "face_flux.pk"

material_h5 = h5.File(output_dir + "HFR_material_river.h5", "r")

all_h5 = glob.glob(output_dir + "pflotran*h5")
all_h5 = np.sort(all_h5)

input_h5 = h5.File(all_h5[0], "r")
x_grids = list(input_h5["Coordinates"]['X [m]'])
y_grids = list(input_h5["Coordinates"]['Y [m]'])
z_grids = list(input_h5["Coordinates"]['Z [m]'])
input_h5.close()

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

west_area = dy[0] * dz[0]
east_area = dy[0] * dz[0]
south_area = dx[0] * dz[0]
north_area = dx[0] * dz[0]
top_area = dx[0] * dy[0]
bottom_area = dx[0] * dy[0]

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

temp_unique_river_cells = unique_river_cells
unique_river_cells = []
for i_cell in temp_unique_river_cells:
    if (grids[i_cell, 0] > 0 and grids[i_cell, 0] < (nx - 1) and
            grids[i_cell, 1] > 0 and grids[i_cell, 1] < (ny - 1) and
            grids[i_cell, 2] > 0 and grids[i_cell, 2] < (nz - 1)):
        unique_river_cells.append(i_cell)

n_unique = len(unique_river_cells)
unique_index = [grids[i, :] for i in unique_river_cells]


river_face_array = np.array([], dtype=np.float).reshape(0, 6)
for i_cell in unique_river_cells:
    temp_face_vector = np.array([0] * 6).reshape(1, 6)
    temp_faces = river_faces[river_cells == i_cell]
    for iface in list(map(int, temp_faces)):
        temp_face_vector[0, iface - 1] = 1
    river_face_array = np.concatenate(
        (river_face_array, temp_face_vector), axis=0)


out_flux = {}
all_h5 = glob.glob(output_dir + "pflotran*h5")
for i_h5 in all_h5:
    print(i_h5)
    h5file = h5.File(i_h5, "r")
    groups = list(h5file.keys())
    time_index = [i for i, s in enumerate(groups) if "Time:" in s]
    times = [groups[i] for i in time_index]
    for itime in times:
        print(itime)

        # get dict of all flux
        x_darcy = np.asarray(list(h5file[itime]["Liquid X-Flux Velocities"]))
        y_darcy = np.asarray(list(h5file[itime]["Liquid Y-Flux Velocities"]))
        z_darcy = np.asarray(list(h5file[itime]["Liquid Z-Flux Velocities"]))

        # get flux on all cell face in river bed cells
        west_flux = [x_darcy[i[0] - 1, i[1], i[2]] for i in unique_index]
        east_flux = [x_darcy[i[0], i[1], i[2]] for i in unique_index]
        south_flux = [y_darcy[i[0], i[1] - 1, i[2]] for i in unique_index]
        north_flux = [y_darcy[i[0], i[1], i[2]] for i in unique_index]
        bottom_flux = [z_darcy[i[0], i[1], i[2] - 1] for i in unique_index]
        top_flux = [z_darcy[i[0], i[1], i[2]] for i in unique_index]

        # get volumeric flux
        west_flux = [x * west_area for x in west_flux]
        east_flux = [x * east_area for x in east_flux]
        south_flux = [x * south_area for x in south_flux]
        north_flux = [x * north_area for x in north_flux]
        bottom_flux = [x * bottom_area for x in bottom_flux]
        top_flux = [x * top_area for x in top_flux]

        # get flux on river face of river cells
        river_face_flux = river_face_array * np.column_stack(
            (west_flux, east_flux, south_flux,
             north_flux, bottom_flux, top_flux))

        # combine x,y,z directions to get outflow flux
        out_flux[itime] = [(-x[0] + x[1] - x[2] + x[3] - x[4] + x[5])
                           for x in river_face_flux]
file = open(pt_fname, "wb")
pickle.dump(out_flux, file)
file.close()

material_h5.close()
