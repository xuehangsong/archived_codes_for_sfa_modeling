import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas
from scipy.interpolate import UnivariateSpline
from scipy.interpolate import interp1d
from scipy.interpolate import spline


def locate_cell(coord_1):
    return([np.argmin(abs(x - coord_1[0])),
            np.argmin(abs(y - coord_1[1])),
            np.argmin(abs(z - coord_1[2]))])


nbatch = 50
pt_window_min = 1000
flux_weighted = True
plot_start = (366 + 365 + 365 + 365 + 366) * 24
plot_end =   (366 + 365 + 365 + 365 + 366 + 365) * 24



pt_window_min = 1
flux_weighted = True
plot_start = 46776
plot_end =   4673000000


plot_start = 62616
plot_end =   4673000000




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


residence_time = []
pt_start_rt = []
pt_end_rt = []
particles_rt = []
pt_status_rt = []
for iparticle in range(len(particles)):
    if (
        (pt_window[iparticle] > pt_window_min) and 
##        (pt_status[iparticle] == 4 or pt_status[iparticle] == 5) and
        (pt_start[iparticle] == plot_start) and
        (pt_end[iparticle] <= plot_end) 
       ):
        residence_time.extend([particles[iparticle].shape[0]])
        pt_start_rt.extend([pt_start[iparticle]])
        pt_end_rt.extend([pt_end[iparticle]])
        particles_rt.extend([particles[iparticle]])
        pt_status_rt.extend([pt_status[iparticle]])
        print(residence_time[-1],pt_end[iparticle]-pt_start[iparticle])
print(len(residence_time))




    

hist_weights = np.ones_like(residence_time) / len(residence_time)
fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
plt.hist(residence_time, bins=20, fill=False,weights = hist_weights, normed = True,histtype="step")
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Pdf', fontsize=14)
plt.xticks(np.arange(0, 9000, 2000), fontsize=14)
#plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=0.2)
plt.subplots_adjust(left=0.2)
fig.savefig("../figures/residence_temp.jpg", dpi=600)
plt.close("all")


pt_name = "../edison/release_flux.pickle"    
pickle_file = open(pt_name,"rb")
vflux = pickle.load(pickle_file)
pickle_file.close()        

pt_name = "../edison/release_coord.pickle"
pickle_file = open(pt_name,"rb")
release_coord = pickle.load(pickle_file)
pickle_file.close()        


flux_weight = []
for iparticle in range(len(particles_rt)):
    locate_temp = np.equal(release_coord, particles_rt[iparticle][0,1:4]).all(1)
    locate_temp = [i for i, x in enumerate(locate_temp) if x]
    flux_weight_1 = abs(vflux[pt_start_rt[iparticle]][locate_temp[0]])
    flux_weight.extend([flux_weight_1])
hist_weights = flux_weight/sum(flux_weight)
fig, ax = plt.subplots()
fig.set_size_inches(5, 3)
#plt.hist(residence_time, bins=20, fill=False,weights = hist_weights, normed = True,histtype="step")
n, bins, patches = plt.hist(residence_time, bins=20, fill=False,weights = hist_weights,histtype="step",normed = True)
bins = bins[:-1]+(bins[1]-bins[0])/2
bins_new = np.linspace(bins.min(),bins.max(),300)
n_new = spline(bins,1,bins_new)
plt.plot(bins_new,n_new)
# f2 = interp1d(x, y, kind='cubic')
ax.set_xlabel('Residence time (hr)', fontsize=14)
ax.set_ylabel('Pdf', fontsize=14)
# plt.xlim(0, 4000)
# plt.ylim(0, 0.6)
plt.xticks(np.arange(0, 9000, 2000), fontsize=14)
##plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.yaxis.set_ticks_position('left')
ax.xaxis.set_ticks_position('bottom')
plt.subplots_adjust(bottom=0.2)
plt.subplots_adjust(left=0.2)
fig.savefig("../figures/residence_weighted_temp.jpg", dpi=600)
plt.close("all")
print("Done!")



rt_ps = pandas.Series(pt_status_rt)
print(rt_ps.value_counts())


# rt_ps = pandas.Series(pt_start)
# print(rt_ps.value_counts())
print("Hello World!")

# f = UnivariateSpline(n, bins, k=3, s=0)
# plt.plot(bins,f(bins))
