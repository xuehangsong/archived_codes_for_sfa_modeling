import matplotlib as mpl
import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas



nbatch = 50
time_min = 0
time_max = 13140
nsection = 72
selected_point = 122

nx = 225
ny = 400
nz = 40

ox = -450
oy = -800
oz = 90


dx = [4] * nx
dy = [4] * ny
dz = [0.5] * nz


ex = ox + np.sum(dx)
ey = oy + np.sum(dy)
ez = oz + np.sum(dz)

initial_time = (366 + 365 + 365 + 365 + 366) * 24
batch_length = 24 * 20
batch_frequency = 24

release_times = np.arange(
    initial_time,
    initial_time + nbatch * batch_length,
    batch_frequency)


result_dir = "../edison/"
particles = []
pt_status = []
pt_end = []
for ibatch in range(nbatch):
    result_files = glob.glob((result_dir + "*_" + str(ibatch+1) + "_*"))
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

##for irelease in [47520]:
##for irelease in [46776]:
for irelease in [45960]:            
    residence_time = []
    pt_start_rt = []
    pt_end_rt = []
    particles_rt = []
    pt_status_rt = []
    for iparticle in range(len(particles)):
        if (pt_start[iparticle] == irelease):
            residence_time.extend([particles[iparticle].shape[0]])
            pt_start_rt.extend([pt_start[iparticle]])
            pt_end_rt.extend([pt_end[iparticle]])
            particles_rt.extend([particles[iparticle]])
            pt_status_rt.extend([pt_status[iparticle]])        

    temp_ntime = particles_rt[selected_point].shape[0]    
    section_time = temp_ntime // (nsection - 1)
    for isection in range(nsection):        
        particles_section = particles_rt[selected_point][
            0: min((isection + 1) * section_time, temp_ntime), :]
        fig = plt.figure()
        fig.set_size_inches(4, 4.6)
        ax = fig.add_subplot(111)
        color_index = (particles_section[:, 0] -
                       particles_rt[selected_point][0, 0])

        color_index = np.clip(color_index, time_min, time_max)
        sc = plt.scatter(particles_section[:, 1],
                         particles_section[:, 2],
                         s=1, marker="o",edgecolors="none",
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
        plt.savefig("../figures/sections/" + str(irelease) + "_" + str(isection) +".jpg", dpi=600)
        rt_ps = pandas.Series(pt_status_rt)
        print(rt_ps.value_counts())


        plt.close("all")
            




# rt_ps = pandas.Series(pt_start)
# print(rt_ps.value_counts())
print("Hello World!")
