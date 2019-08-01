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


tracking_time = 365 * 24

pt_fname = "../results/no_restart/path.pickle.240"
file = open(pt_fname, "rb")
pickle_file = pickle.load(file)
file.close()
particles = pickle_file["particles"]

# find final time
final_time = 0
for iparticle in range(len(particles)):
    final_time = max(
        final_time,
        particles[iparticle][particles[iparticle].shape[0] - 1, 0])

particles_temp = []
for iparticle in range(len(particles)):
    if (particles[iparticle][0, 0] + tracking_time) <= final_time:
        particles_temp.append(particles[iparticle][
            0:min((particles[iparticle].shape[0]), tracking_time), :])
#        particles_temp.append(particles[iparticle])
        print(len(particles_temp[iparticle]))
particles = particles_temp

residence_time = []
for iparticle in range(len(particles)):
    if(particles[iparticle].shape[0] > 1):
        residence_time = np.append(
            residence_time, particles[iparticle].shape[0])


material_file = (
    "../results/bigplume_4mx4mxhalfRes_material_mapped_newRingold_subRiver_17tracer.h5")
material_type = {"Hanford": 1, "Ringold_Gravel": 4, "Ringold_Fine": 9}
porosity = {"1": 0.2, "4": 0.25, "9": 0.43}
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

cell_index = np.transpose(np.concatenate((
    [np.r_[0:nx * ny * nz] % nx],
    [np.r_[0:nx * ny * nz] % (nx * ny) // nx],
    [np.r_[0:nx * ny * nz] // (nx * ny)],
), axis=0))
face_index = cell_index[(face_cells - 1), :]
unique_face_index = cell_index[(np.unique(face_cells) - 1), :]

face_lowest = []
face_eastest = []
for iy in range(ny):
    pline_selected = unique_face_index[
        unique_face_index[:, 1] == iy, :]
    pline_lowest_cell = min(pline_selected[:, 2])
    face_lowest.append((z[pline_lowest_cell] + 0.5 * dz[pline_lowest_cell]))
    pline_eastest_cell = min(pline_selected[:, 0])
    face_eastest.append(
        (x[pline_eastest_cell] - 0.5 * dx[pline_eastest_cell]))


for iparticle in range(len(particles)):
    # for iparticle in range(10):
    accumlate_dis = []
    print(iparticle)
    temp_ntime = particles[iparticle].shape[0]

    # remove particles not in hanford
    for itime in range(temp_ntime):
        if (material_ids[
                np.argmin(abs(x - particles[iparticle][itime, 1])),
                np.argmin(abs(y - particles[iparticle][itime, 2])),
                np.argmin(abs(z - particles[iparticle][itime, 3]))
        ] != 1):
            temp_ntime = max(itime, 1)
            particles[iparticle] = particles[iparticle][0:temp_ntime, :]
            break

    time_start = 1
    time_interval = 1
    accumlate_dis.append(0)
    if temp_ntime >= time_interval:
        for itime in np.arange(time_start, temp_ntime, time_interval):
            coord_old = particles[iparticle][itime - time_interval, 1:4]
            coord_new = particles[iparticle][itime, 1:4]
            temp_dis = (sum(coord_old - coord_new)**2)**0.5
            accumlate_dis.append((temp_dis + accumlate_dis[itime - 1]))
            # if temp_dis < 5e-7:
            #     temp_ntime = itime
            #     particles[iparticle] = particles[iparticle][0:temp_ntime, :]
            #     break
    time_start = 24
    time_interval = 24
    for itime in np.arange(time_start, temp_ntime):
        if (
                (particles[iparticle][itime, 2] <=
                 face_lowest[
                     np.argmin(abs(y - particles[iparticle][itime, 1]))]) and
                (particles[iparticle][itime, 0] >=
                 face_eastest[
                     np.argmin(abs(y - particles[iparticle][itime, 1]))]) and
                ((accumlate_dis[itime] -
                  accumlate_dis[itime - time_interval]) < 0.05)
        ):
            temp_ntime = itime
            particles[iparticle] = particles[iparticle][0:temp_ntime, :]
            break


fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
plt.hist(residence_time, bins=10, fill=False,
         weights=np.ones_like(residence_time) / len(residence_time))
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Percentage', fontsize=14)
plt.xlim(0, 15000)
##plt.ylim(0, 0.6)
plt.xticks(np.arange(0, 18000, 3000), fontsize=14)
plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=0.2)
plt.subplots_adjust(left=0.2)
fig.savefig("../figures/residence_time_240.jpg", dpi=600)
plt.close("all")
