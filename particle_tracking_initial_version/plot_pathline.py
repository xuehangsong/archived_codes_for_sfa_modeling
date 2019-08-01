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
    print(iparticle)
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

# for irelease in range(nrelease):
# for irelease in range(24,40,1) :
for irelease in [4, 11, 15, 25]:
    fig = plt.figure(figsize=(12, 6))
    ax = fig.add_subplot(111, projection='3d')

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for iparticle in range(42 * 40):
        time_min = 0
        time_max = 24 * 365
        if particles[iparticle][0, 0] == release_times[irelease]:

            color_index = particles[iparticle][0:1, 0] - \
                particles[iparticle][0, 0]
            color_index = np.clip(color_index, time_min, time_max)

            sc = ax.scatter(particles[iparticle][0:1, 1],
                            particles[iparticle][0:1, 2],
                            particles[iparticle][0:1, 3],
                            s=10, marker="o",
                            c=color_index,
                            vmin=time_min, vmax=time_max,
                            cmap=plt.cm.rainbow,
                            )

    ax.set_xlim(ox, ex)
    ax.set_ylim(oy, ey)
    ax.set_zlim(oz, ez)
    ax.set_xlabel('Easting (m)')
    ax.set_ylabel('Northing (m)')
    ax.set_zlabel('Elevation (m)')
    plt.colorbar(sc)
    plt.tight_layout()
# fig.savefig("../figures/pathlines"+str(irelease)+".jpg")


#    pp = PdfPages("../figures/pathlines"+str(irelease)+".pdf")
#    pp.savefig()
#    pp.close()

    fig.set_size_inches(8, 10)
    for ii in range(270, 280, 90):
        print(ii)
        ax.view_init(elev=90., azim=ii)
        ax.set_zticks([])
        ax.set_zlabel([])
        fig.savefig("../figures/pathlines" + str(irelease) +
                    "_" + str(ii) + ".jpg", dpi=600)

    plt.close("all")
# plt.close("all")
##endtime = max(particles[len(particles)-1][:,0])

##color_index = (particles[iparticle][:,0]-particles[iparticle][0,0]).astype(int)

#    pl = ax.plot(particles[iparticle][:,1],
#               particles[iparticle][:,2],
#               particles[iparticle][:,3],
#               c="b",)
#    sc.remove()
 # c=colors[color_index],

if plot_surface:
    # create data for plotting river bed
    river_face_x = x[unique_face_index[0, :]]
    river_face_y = y[unique_face_index[1, :]]
    river_face_z = z[unique_face_index[2, :]]
    river_surf_x = np.linspace(river_face_x.min(), river_face_x.max(), 100)
    river_surf_y = np.linspace(river_face_y.min(), river_face_y.max(), 100)
    river_surf_z = griddata((river_face_x, river_face_y), river_face_z,
                            (river_surf_x[None, :], river_surf_y[:, None]), method='cubic')
    river_surf_x_grid, river_surf_y_grid = np.meshgrid(
        river_surf_x, river_surf_y)

    ax.plot_surface(river_surf_x_grid, river_surf_y_grid, river_surf_z,
                    linewidths=0, antialiased=True, alpha=0.3,
                    rstride=1, cstride=1)  # cmap=cm.coolwarm,)

    imaterial = material_type["Hanford"]
    print(imaterial)
    surface_x = np.empty(nx * ny).reshape(nx, ny)
    surface_y = np.empty(nx * ny).reshape(nx, ny)
    surface_z = np.empty(nx * ny).reshape(nx, ny)
    surface_x[:] = np.NAN
    surface_y[:] = np.NAN
    surface_z[:] = np.NAN
    for iy in range(ny):
        for ix in range(nx):
            surface_cells = np.where(material_ids[ix][iy] == imaterial)
            surface_x[ix, iy] = x[ix]
            surface_y[ix, iy] = y[iy]
            if len(surface_cells[0]) > 0:
                surface_z[ix, iy] = z[surface_cells[0][0]]
    ax.plot_surface(surface_x, surface_y,
                    surface_z,
                    linewidths=0, antialiased=True, alpha=0.3,
                    rstride=1, cstride=1)  # cmap=cm.coolwarm,)


#fig = plt.figure()
#ax = fig.add_subplot(111, projection='3d')
#ax.scatter(face_index[0], face_index[1], face_index[2], c="r",s=1)
#ax.set_xlabel('X Label')
#ax.set_ylabel('Y Label')
#ax.set_zlabel('Z Label')
# for ii in range(0,360,30):
#    ax.view_init(elev=105., azim=ii)
#    fig.savefig("movie%d.png" % ii)
# plt.show()
