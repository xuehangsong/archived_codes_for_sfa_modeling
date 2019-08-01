import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas


#vflux = [[0 for x in range(len(release_times))] for y in range(len(release_coord))]
vflux = {}
ipt_temp = 0
for irelease in release_times:
    ipt_temp = ipt_temp + 1
    print(ipt_temp, len(release_times))
    groupname = "Time:  " + "{0:.5E}".format(irelease) + " h"
    simu_snapshot = simu_file[groupname]

    x_darcy = simu_snapshot["Liquid X-Flux Velocities"][:]
    y_darcy = simu_snapshot["Liquid Y-Flux Velocities"][:]
    z_darcy = simu_snapshot["Liquid Z-Flux Velocities"][:]

    x_darcy = np.append(x_darcy[0: 1, :, :], x_darcy, 0)
    x_darcy = np.append(x_darcy, x_darcy[(nx - 1): nx, :, :], 0)
    y_darcy = np.append(y_darcy[:, 0: 1, :], y_darcy, 1)
    y_darcy = np.append(y_darcy, y_darcy[:, (ny - 1): ny, :], 1)
    z_darcy = np.append(z_darcy[:, :, 0: 1], z_darcy, 2)
    z_darcy = np.append(z_darcy, z_darcy[:, :, (nz - 1): nz], 2)

    # for east boundary
    x_darcy[0, :, :] = (+ x_darcy[1, :, :]
                        - y_darcy[0, 0:ny, :]
                        + y_darcy[0, 1:(ny + 1), :]
                        - z_darcy[0, :, 0:nz]
                        + z_darcy[0, :, 1:(nz + 1)])

    # for south boundary
    y_darcy[:, 0, :] = (-x_darcy[0:nx, 0, :]
                        + x_darcy[1:(nx + 1), 0, :]
                        + y_darcy[:, 1, :]
                        - z_darcy[:, 0, 0:nz]
                        + z_darcy[:, 0, 1:(nz + 1)])
    # for north boundary
    y_darcy[:, ny, :] = (+ x_darcy[0:nx, (ny - 1), :]
                         - x_darcy[1:(nx + 1), (ny - 1), :]
                         + y_darcy[:, (ny - 1), :]
                         + z_darcy[:, (ny - 1), 0:nz]
                         - z_darcy[:, (ny - 1), 1:(nz + 1)])
    # for river_face
    vflux_1 = []
    for iparticle in range(len(release_cell)):

        cell_x = release_cell[iparticle][0]
        cell_y = release_cell[iparticle][1]
        cell_z = release_cell[iparticle][2]

        face_id_1 = face_ids[
            np.equal(face_index, [cell_x, cell_y, cell_z]).all(1)][0]

        vx1 = x_darcy[cell_x][cell_y][cell_z]
        vx2 = x_darcy[cell_x + 1][cell_y][cell_z]
        vy1 = y_darcy[cell_x][cell_y][cell_z]
        vy2 = y_darcy[cell_x][cell_y + 1][cell_z]
        vz1 = z_darcy[cell_x][cell_y][cell_z]
        vz2 = z_darcy[cell_x][cell_y][cell_z + 1]

        if face_id_1 == 1:
            vflux_temp = vx2 - vy1 + vy2 - vz1 + vz2
        elif face_id_1 == 2:
            vflux_temp = vx1 + vy1 - vy2 + vz1 - vz2
        elif face_id_1 == 3:
            vflux_temp = vy2 - vx1 + vx2 - vz1 + vz2
        elif face_id_1 == 4:
            vflux_temp = vy1 + vx1 - vx2 + vz1 - vz2
        elif face_id_1 == 5:
            vflux_temp = vz2 - vx1 + vx2 - vy1 + vy2
        elif face_id_1 == 6:
            vflux_temp = vz1 + vx1 - vx2 + vy1 - vy2

        vflux_1.append(vflux_temp)
    vflux.update({irelease: vflux_1})

pt_name = "../edison/release_flux.pickle"
pickle_file = open(pt_name, "wb")
pickle_data = pickle.dump(vflux, pickle_file)
pickle_file.close()

pt_name = "../edison/release_cell.pickle"
pickle_file = open(pt_name, "wb")
pickle_data = pickle.dump(release_cell, pickle_file)
pickle_file.close()

pt_name = "../edison/release_coord.pickle"
pickle_file = open(pt_name, "wb")
pickle_data = pickle.dump(release_coord, pickle_file)
pickle_file.close()


material_file.close()
simu_file.close()
