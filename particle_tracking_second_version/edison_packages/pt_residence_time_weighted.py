import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np

nbatch = 20*24
pt_window_min = 6000


result_dir = "../results/"
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


residence_time = []
for iparticle in range(len(particles)):
    if (
        (pt_window[iparticle] > pt_window_min) and 
        (pt_status[iparticle] == 4 or pt_status[iparticle] ==5)
       ):
        residence_time.extend([particles[iparticle].shape[0]])
print(len(residence_time))


fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
plt.hist(residence_time, bins=10, fill=False,
         weights=np.ones_like(residence_time) / len(residence_time))
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


print("Hello_word")
