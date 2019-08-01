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
import matplotlib
from matplotlib.ticker import FuncFormatter

###import matplotlib.cm as cm

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


residence_time = []
path_length = []
# for iparticle in range(len(particles)) :
for iparticle in range(37 * 42):
    print(iparticle)
    time_min = 0
    time_max = 24 * 365

    temp_ntime = particles[iparticle].shape[0]
    temp_dis = (sum((particles[iparticle][temp_ntime - 1, 1:4] -
                     particles[iparticle][int((temp_ntime - 1) * 19 / 20), 1:4])**2))**0.5

    while temp_dis < 0.005:
        temp_dis = (sum((particles[iparticle][temp_ntime - 1, 1:4] -
                         particles[iparticle][int((temp_ntime - 1) * 19 / 20), 1:4])**2))**0.5
        particle_status[iparticle] = 0
        temp_ntime = int((temp_ntime - 1) * 19 / 20)

    particles[iparticle] = particles[iparticle][0:temp_ntime, :]

    residence_time = np.append(residence_time, temp_ntime * 1)
    temp_path = 0
    for itime in range(temp_ntime - 1):
        temp_path = temp_path + sum((particles[iparticle][itime + 1, 1:4] -
                                     particles[iparticle][itime, 1:4])**2)**0.5
    path_length = np.append(path_length, temp_path)


fig, ax = plt.subplots()
fig.set_size_inches(8, 4.2)
plt.hist(residence_time, bins=20, fill=False,
         weights=np.zeros_like(residence_time) + 1. / residence_time.size)
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Percentage', fontsize=14)
plt.xlim(0, 18000)
plt.ylim(0, 0.12)
plt.xticks(np.arange(0, max(residence_time) + 3000, 3000), fontsize=14)
plt.yticks(np.arange(0, 0.13, 0.04), fontsize=14)
# Hide the right and top spines
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
# Only show ticks on the left and bottom spines
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=20)
fig.savefig("../figures/residence_time.jpg", dpi=600)


fig, ax = plt.subplots()
fig.set_size_inches(6, 4)
plt.hist(path_length, bins=20, fill=False,
         weights=np.zeros_like(path_length) + 1. / path_length.size)
ax.set_xlabel('Residence time (hr)')
ax.set_ylabel('Percentage')
plt.xlim(0, 3000)
plt.ylim(0, 0.5)
# Hide the right and top spines
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
# Only show ticks on the left and bottom spines
ax.set_xlabel('Path length (m)')
ax.set_ylabel('Percentage')
fig.savefig("../figures/path_length.jpg", dpi=600)

# if  particles[iparticle][0,0]==release_times[irelease]:
