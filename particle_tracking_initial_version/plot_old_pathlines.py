import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import multiprocessing as mp
import h5py as h5
import numpy as np
import math
import sys
import os
import pickle
from scipy.interpolate import griddata
from matplotlib.backends.backend_pdf import PdfPages
# import matplotlib.cm as cm

plot_surface = False

material_file = "../results/bigplume_4mx4mxhalfRes_material_mapped_newRingold_subRiver_17tracer.h5"
pt_fname = "../results/path.pickle.240"

times = np.arange(8784, 27172, 1)
release_times = np.r_[8784:27172:240]

material_type = {"Hanford": 1, "Ringold_Gravel": 4, "Ringold_Fine": 9}
porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

# minimum time step
min_dtstep = 0.001

ncore = 4

nx = 225
ny = 400
nz = 40

ox = -450
oy = -800
oz = 90


dx = [4] * nx
dy = [4] * ny
dz = [0.5] * nz

river_particle_dy = 100
river_particle_dz = 5

ntime = len(times)

ex = ox + np.sum(dx)
ey = oy + np.sum(dy)
ez = oz + np.sum(dz)

x = np.cumsum(dx) + ox - 1 / 2 * dx[0]
y = np.cumsum(dy) + oy - 1 / 2 * dy[0]
z = np.cumsum(dz) + oz - 1 / 2 * dz[0]

datafile = h5.File(material_file, "r")
material_ids = datafile['Materials']['Material Ids'][:].reshape(
    nz, ny, nx).swapaxes(0, 2)
face_cells = datafile['Regions']['River']["Cell Ids"][:]
face_ids = datafile['Regions']['River']["Face Ids"][:]

cell_index = np.concatenate((
                            [np.r_[0:nx * ny * nz] % nx],
                            [np.r_[0:nx * ny * nz] % (nx * ny) // nx],
                            [np.r_[0:nx * ny * nz] // (nx * ny)],
                            ), axis=0)
face_index = cell_index[:, (face_cells - 1)]
unique_face_index = cell_index[:, (np.unique(face_cells) - 1)]


file = open(pt_fname, "rb")
pt_results = pickle.load(file)


file = open(pt_fname, "rb")
pt_results = pickle.load(file)
particle_cells = pt_results['particle_cells']
particles = pt_results['particles']
particle_status = pt_results['particle_status']
file.close()


for iparticle in range(len(particles)):
    time_min = 0
    time_max = 24 * 365
# print(iparticle)
    temp_ntime = particles[iparticle].shape[0]
    temp_dis = (sum((particles[iparticle][temp_ntime - 1, 1:4] -
                     particles[iparticle][int((temp_ntime - 1) * 19 / 20), 1:4])**2))**0.5

    while temp_dis < 0.005:
        temp_dis = (sum((particles[iparticle][temp_ntime - 1, 1:4] -
                         particles[iparticle][int((temp_ntime - 1) * 19 / 20), 1:4])**2))**0.5
        particle_status[iparticle] = 0
        temp_ntime = int((temp_ntime - 1) * 19 / 20)

    particles[iparticle] = particles[iparticle][0:temp_ntime, :]


nrelease = 40


print("wwww")

for irelease in [15, 25]:
    itemp = 0

    fig = plt.figure()
    fig.set_size_inches(4.4, 5)
    ax = fig.add_subplot(111)
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for iparticle in range(42 * 40):
        time_min = 0
        time_max = 24 * 365

        if particles[iparticle][0, 0] == release_times[irelease]:
            itemp = itemp + 1
            temp_ntime = particles[iparticle].shape[0]

            while ((material_ids[
                    np.argmin(
                        abs(x - particles[iparticle][temp_ntime - 1, 1])),
                    np.argmin(
                        abs(y - particles[iparticle][temp_ntime - 1, 2])),
                    np.argmin(
                        abs(z - particles[iparticle][temp_ntime - 2, 3]))
            ] != 1
            ) or (
                    [np.argmin(
                        abs(x - particles[iparticle][temp_ntime - 1, 1])),
                     np.argmin(
                         abs(y - particles[iparticle][temp_ntime - 1, 2])),
                     np.argmin(
                         abs(z - particles[iparticle][temp_ntime - 2, 3]))]
                    in np.transpose(unique_face_index).tolist()
            )) and (
                    temp_ntime > 1
            ):

                temp_ntime = max(int((temp_ntime - 1) * 19 / 20), 1)
                temp_ntime = int(max((temp_ntime - 1), 1))
                particles[iparticle] = particles[iparticle][0:temp_ntime, :]
                # print(str(iparticle) + "_" + str(temp_ntime))

            print(str(itemp) + "_" + str(temp_ntime))

            if temp_ntime > 1:
                if itemp < 41:
                    color_index = particles[
                        iparticle][:, 0] - particles[iparticle][0, 0]
                    color_index = np.clip(color_index, time_min, time_max)

                    sc = plt.scatter(particles[iparticle][:, 1],
                                     particles[iparticle][:, 2],
                                     s=1, marker="o",
                                     c=color_index,
                                     vmin=time_min, vmax=time_max,
                                     cmap=plt.cm.rainbow,
                                     )

    ax.set_xlim(ox, ex)
    ax.set_ylim(oy, ey)
    ax.set_xlabel('Easting (m)')
    ax.set_ylabel('Northing (m)')
    plt.colorbar(sc)
    plt.tight_layout()
    plt.axes().set_aspect('equal')
    plt.savefig("../figures/" + str(irelease) + ".jpg", dpi=600)
    plt.close("all")
