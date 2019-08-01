import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas

def locate_cell(coord_1):
    return([np.argmin(abs(x - coord_1[0])),
            np.argmin(abs(y - coord_1[1])),
            np.argmin(abs(z - coord_1[2]))])


nbatch = 50
pt_window_min = 1000
flux_weighted = True

result_dir = "../edison/"
particles = []
pt_status = []
pt_end = []
for ibatch in range(nbatch):
    result_files = glob.glob((result_dir + "*_" + str(ibatch+1) + "_*"))
#    print(result_files)
    if (len(result_files)>1):
        pt_name = sorted(result_files)[-2]
        pickle_file = open(pt_name,"rb")
        pickle_data = pickle.load(pickle_file)
        pickle_file.close()        
        particles = particles + pickle_data["particles"]
        pt_status = pt_status + pickle_data["pt_status"]        
        pt_end = pt_end + [
            float(pt_name.split("_")[-1])]*len(pickle_data["particles"])

pt_start = []
for iparticle in range(len(particles)):
    pt_start.extend([particles[iparticle][0,0]])
pt_window = list(map(operator.sub,pt_end,pt_start))


residence_time = []
pt_start_rt = []
pt_end_rt = []
particles_rt = []
flux_weight = []
for iparticle in range(len(particles)):
    if (
        (pt_window[iparticle] > pt_window_min) and 
        (pt_status[iparticle] == 4 or pt_status[iparticle] ==5)
       ):
        residence_time.extend([particles[iparticle].shape[0]])
        pt_start_rt.extend([pt_start[iparticle]])
        pt_end_rt.extend([pt_end[iparticle]])
        particles_rt.extend([particles[iparticle]])                
print(len(residence_time))



if (flux_weighted):
    
    pt_start_unique = np.unique(pt_start)
    hist_weights = np.ones_like(residence_time) 
    simu_file = h5.File((
        "../flow_2008_3/pflotran_bigplume.h5"),
        "r")
    material_file = h5.File((
        "../flow_2008_3/BC_2008_2015/" +
        "bigplume_4mx4mxhalfRes_material_" +
        "mapped_newRingold_subRiver_17tracer.h5"),
        "r")

    x = simu_file["Coordinates"]["X [m]"][:]
    y = simu_file["Coordinates"]["Y [m]"][:]
    z = simu_file["Coordinates"]["Z [m]"][:]

    dx = np.diff(x)
    dy = np.diff(y)
    dz = np.diff(z)

    nx = len(dx)
    ny = len(dy)
    nz = len(dz)

    ox = min(x)
    oy = min(y)
    oz = min(z)

    ex = max(x)
    ey = max(y)
    ez = max(z)

    x = x[0:nx] + 0.5 * dx
    y = y[0:ny] + 0.5 * dy
    z = z[0:nz] + 0.5 * dz

    material_ids = material_file['Materials']['Material Ids'][:].reshape(
        nz, ny, nx).swapaxes(0, 2)
    face_cells = material_file['Regions']['River']["Cell Ids"][:]
    face_ids = material_file['Regions']['River']["Face Ids"][:]
    material_type = {"Hanford": 1,
                     "Ringold Gravel": 4,
                     "Ringold Fine": 9,
                     "River": 0}
    porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

    cell_index = np.transpose(np.concatenate((
        [np.r_[0:nx * ny * nz] % nx],
        [np.r_[0:nx * ny * nz] % (nx * ny) // nx],
        [np.r_[0:nx * ny * nz] // (nx * ny)],
    ), axis=0))
    face_index = cell_index[(face_cells - 1), :]

    face_cell_unique, face_cell_unique_index = np.unique(
        face_cells, return_index=True)
    unique_face_index = cell_index[(face_cell_unique - 1), :]
    unique_face_ids = face_ids[face_cell_unique_index]

    ipt_temp =0
    for ipt_start in pt_start_unique:
        ipt_temp = ipt_temp+1
        print(ipt_temp,len(pt_start_unique))
        groupname = "Time:  " + "{0:.5E}".format(ipt_start) + " h"
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
        for iface in range(len(unique_face_ids)):
            cell_x = unique_face_index[iface, 0]
            cell_y = unique_face_index[iface, 1]
            cell_z = unique_face_index[iface, 2]

            vx1 = x_darcy[cell_x][cell_y][cell_z]
            vx2 = x_darcy[cell_x + 1][cell_y][cell_z]
            vy1 = y_darcy[cell_x][cell_y][cell_z]
            vy2 = y_darcy[cell_x][cell_y + 1][cell_z]
            vz1 = z_darcy[cell_x][cell_y][cell_z]
            vz2 = z_darcy[cell_x][cell_y][cell_z + 1]

            if unique_face_ids[iface] == 1:
                x_darcy[
                    cell_x][cell_y][cell_z] = vx2 - vy1 + vy2 - vz1 + vz2
            elif unique_face_ids[iface] == 2:
                x_darcy[
                    cell_x + 1][cell_y][cell_z] = vx1 + vy1 - vy2 + vz1 - vz2
            elif unique_face_ids[iface] == 3:
                y_darcy[
                    cell_x][cell_y][cell_z] = vy2 - vx1 + vx2 - vz1 + vz2
            elif unique_face_ids[iface] == 4:
                y_darcy[
                    cell_x][cell_y + 1][cell_z] = vy1 + vx1 - vx2 + vz1 - vz2
            elif unique_face_ids[iface] == 5:
                z_darcy[
                    cell_x][cell_y][cell_z] = vz2 - vx1 + vx2 - vy1 + vy2
            elif unique_face_ids[iface] == 6:
                z_darcy[
                    cell_x][cell_y][cell_z + 1] = vz1 + vx1 - vx2 + vy1 - vy2

        darcy_1 = {1:x_darcy[cell_x][cell_y][cell_z],
                   2:x_darcy[cell_x + 1][cell_y][cell_z],
                   3:y_darcy[cell_x][cell_y][cell_z],
                   4:y_darcy[cell_x][cell_y + 1][cell_z],
                   5:z_darcy[cell_x][cell_y][cell_z],
                   6:z_darcy[cell_x][cell_y][cell_z + 1]
        }

        face_1 = face_ids[np.equal(face_index,[cell_x,cell_y,cell_z]).all(1)]
        flux_1 = 0   # no formation information is added as it's all hanford
        flux_2 = 0   # no formation information is added as it's all hanford        
        for iface in face_1:
          flux_1 = flux_2 + darcy_1[iface]
          #        flux_2 = darcy_1[iface]**2 + flux_1
          #        flux_2 = flux_2**0.5            


        hist_weights[pt_start_rt == ipt_start] = flux_1
    material_file.close()
    simu_file.close()
    hist_weights = hist_weights/sum(hist_weights)
else:
    hist_weights = np.ones_like(residence_time) / len(residence_time)





fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
plt.hist(residence_time, bins=10, fill=False,weights = hist_weights)
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Percentage', fontsize=14)
#plt.xlim(0, 15000)
##plt.ylim(0, 0.6)
# plt.xticks(np.arange(0, 18000, 3000), fontsize=14)
# plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=0.2)
plt.subplots_adjust(left=0.2)
fig.savefig("../figures/residence_temp.jpg", dpi=600)
plt.close("all")


hist_weights = np.ones_like(residence_time) / len(residence_time)
fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
plt.hist(residence_time, bins=10, fill=False,weights = hist_weights)
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Percentage', fontsize=14)
#plt.xlim(0, 15000)
##plt.ylim(0, 0.6)
# plt.xticks(np.arange(0, 18000, 3000), fontsize=14)
# plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=0.2)
plt.subplots_adjust(left=0.2)
fig.savefig("../figures/residence_unweighted_temp.jpg", dpi=600)
plt.close("all")




rt_ps = pandas.Series(pt_status)
print(rt_ps.value_counts())
print("Hello World!")

rt_ps = pandas.Series(pt_start)
print(rt_ps.value_counts())
