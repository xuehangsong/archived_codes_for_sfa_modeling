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

for irelease in [50544, 59304]:
    # for irelease in [50544]:
    residence_time = []
    pt_fname = "../results/filtered_2013_2015/pickle." + str(irelease)
    file = open(pt_fname, "rb")
    particles = pickle.load(file)
    file.close()
    for iparticle in range(len(particles)):
        if(particles[iparticle].shape[0] > 1):
            residence_time = np.append(
                residence_time, particles[iparticle].shape[0])

    print(irelease)
    fig, ax = plt.subplots()
    fig.set_size_inches(5, 3)
    plt.hist(residence_time, bins=10, fill=False,
             weights=np.ones_like(residence_time) / len(residence_time))
    ax.set_xlabel('Residence time (hr)', fontsize=14)
    ax.set_ylabel('Percentage', fontsize=14)
    plt.xlim(0, 15000)
    plt.ylim(0, 0.6)
    plt.xticks(np.arange(0, 18000, 3000), fontsize=14)
    plt.yticks(np.arange(0, 0.7, 0.1), fontsize=14)
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.yaxis.set_ticks_position('left')
    ax.xaxis.set_ticks_position('bottom')
    plt.subplots_adjust(bottom=0.2)
    plt.subplots_adjust(left=0.2)
    fig.savefig("../figures/residence_time" +
                str(irelease) + ".jpg", dpi=600)
    plt.close("all")
