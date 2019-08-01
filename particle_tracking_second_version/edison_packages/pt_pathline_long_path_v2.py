import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas

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

max_length = []
max_time = []
for irelease in release_times:
    print(irelease)
    residence_time = []
    pt_start_rt = []
    pt_end_rt = []
    particles_rt = []
    pt_status_rt = []
    longest_temp = 0
    longest_temp22 = 0    
    for iparticle in range(len(particles)):
        if (pt_start[iparticle] == irelease):
            longest_temp = max(particles[iparticle][-1,4],longest_temp)
            longest_temp22 = max(particles[iparticle][-1,0],longest_temp22)            
    max_length.extend([longest_temp])
    max_time.extend([longest_temp22])    


pt_name = "../edison/release_maxlength.pickle"    
pickle_file = open(pt_name,"wb")
pickle_data = pickle.dump(max_length,pickle_file)
pickle_file.close()        

pt_name = "../edison/release_maxtime.pickle"    
pickle_file = open(pt_name,"wb")
pickle_data = pickle.dump(max_time,pickle_file)
pickle_file.close()        


order = sorted(range(len(max_length)),key=lambda x:max_length[x])



