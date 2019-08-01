import os
import pickle
import glob
import operator
import numpy as np
import h5py as h5

from pt_parameters import nbatch
from pt_parameters import initial_time
from pt_parameters import results_dir

from pt_functions import locate_cell


particles = []
pt_status = []
pt_end = []
for ibatch in range(nbatch):
    print(ibatch, "finished in", nbatch)
    result_files = glob.glob((results_dir + "*_" + str(ibatch + 1) + "_*"))
    if (len(result_files) > 1):
        pt_name = sorted(result_files)[-2]
        pickle_file = open(pt_name, "rb")
        pickle_data = pickle.load(pickle_file)
        pickle_file.close()
        particles = particles + pickle_data["particles"]
        pt_status = pt_status + pickle_data["pt_status"]
