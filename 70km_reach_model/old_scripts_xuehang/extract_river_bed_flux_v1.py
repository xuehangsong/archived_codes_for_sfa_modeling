# import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import glob
import pickle

output_dir = "/Users/song884/remote/reach/Outputs/2007_solute/"
results_dir = "/Users/song884/remote/reach/results/"
pt_fname = "/Users/song884/remote/reach/results/face_flux.pk"

nx = 304
ny = 268
nz = 40

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
        x_darcy = np.asarray(list(h5file[itime]["Liquid X-Flux Velocities"]))
        y_darcy = np.asarray(list(h5file[itime]["Liquid Y-Flux Velocities"]))
        z_darcy = np.asarray(list(h5file[itime]["Liquid Z-Flux Velocities"]))

        # get flux on all cell face in river bed cells
        west_flux = [x_darcy[i[0] - 1, i[1], i[2]] for i in river_index]
        east_flux = [x_darcy[i[0], i[1], i[2]] for i in river_index]
        south_flux = [y_darcy[i[0], i[1] - 1, i[2]] for i in river_index]
        north_flux = [y_darcy[i[0], i[1], i[2]] for i in river_index]
        bottom_flux = [z_darcy[i[0], i[1], i[2] - 1] for i in river_index]
        top_flux = [z_darcy[i[0], i[1], i[2]] for i in river_index]

        # get flux on river face of river cells
        river_face_flux = river_face * np.column_stack(
            (west_flux, east_flux, south_flux,
             north_flux, bottom_flux, top_flux))

        # combine x,y,z directions to get outflow flux
        out_flux[itime] = [(-x[0] + x[1] - x[2] + x[3] - x[4] + x[5])
                           for x in river_face_flux]
file = open(pt_fname, "wb")
pickle.dump(out_flux, file)
file.close()
