import os
import pickle
import glob
import operator
import matplotlib.pyplot as plt
import numpy as np
import h5py as h5
import pandas

nbatch = 50
initial_time = (366 + 365 + 365 + 365 + 366) * 24
batch_length = 24 * 20
batch_frequency = 24

release_times = np.arange(
    initial_time,
    initial_time + nbatch * batch_length,
    batch_frequency)



pt_name = "../edison/release_maxlength.pickle"
pickle_file = open(pt_name,"rb")
max_length = pickle.load(pickle_file)
pickle_file.close()        

pt_name = "../edison/release_maxtime.pickle"
pickle_file = open(pt_name,"rb")
max_time = pickle.load(pickle_file)
pickle_file.close()        

##for irelease in range(46728,46729):
##for irelease in range(49500,51500):
for irelease in [46776,62616]:
    indices = []
    indices = [i for i , x in enumerate(release_times) if x== irelease]
    if len(indices) > 0:
        if max_length[indices[0]]>1:
            print(irelease, max_length[indices[0]],max_time[indices[0]]-irelease)


length_order = sorted(range(len(max_length)),key=lambda x:max_length[x])
print("Hello World")
