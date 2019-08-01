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


def locate_cell(coord):
    return ([np.argmin(abs(x - coord[0])),
             np.argmin(abs(y - coord[1])),
             np.argmin(abs(z - coord[2]))])


plot_surface = False

material_file = (
    "../results/bigplume_4mx4mxhalfRes_material_mapped_newRingold_subRiver_17tracer.h5")
pt_fname_template = "../results/selected_160/path.pickle_"
pt_fname_template = "../results/selected_2013/path.pickle_"

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


short_path_points = []
short_path_flag = True
short_path_flag = False
short_path_threshold = 1000
time_min = 0
time_max = 365 * 24
nsection = 14  # 13705
section_time = 1000  # 13705
selected_points = [140]
selected_points = [162]

base_release = 59304
additional_release = 50544


for irelease in [59304, 50544]:
    # for irelease in [50544]:
    # for irelease in [59304]:
    pt_fname = pt_fname_template + str(irelease) + "1"
    file = open(pt_fname, "rb")
    pt_results = pickle.load(file)
    particle_cells = pt_results['particle_cells']
    particles = pt_results['particles']
    particle_status = pt_results['particle_status']
    file.close()

    selected_points = range(len(particles))
##    selected_points = [137]
    for iparticle in selected_points:
        accumlate_dis = []
        print(iparticle)
        temp_ntime = particles[iparticle].shape[0]

#       remove particles not in hanford
        # for itime in range(temp_ntime):
        #     if (material_ids[
        #         np.argmin(abs(x - particles[iparticle][itime, 1])),
        #         np.argmin(abs(y - particles[iparticle][itime, 2])),
        #         np.argmin(abs(z - particles[iparticle][itime, 3]))
        #     ] != 1):
        #         temp_ntime = max(itime, 1)
        #         particles[iparticle] = particles[iparticle][0:temp_ntime, :]
        #         break

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

        fig = plt.figure()
        fig.set_size_inches(4, 4.6)
        ax = fig.add_subplot(111)
        color_index = (particles[iparticle][:, 0] -
                       particles[iparticle][0, 0])
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
        plt.savefig("../figures/single_line/" + str(irelease) +
                    "_particle_" + str(iparticle) +
                    ".jpg", dpi=600)
        plt.close("all")
