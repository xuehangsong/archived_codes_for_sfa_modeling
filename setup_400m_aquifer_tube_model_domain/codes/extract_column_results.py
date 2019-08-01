import h5py as h5
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

thermistor_loc = [366.5181, 214.5487]

# os.chdir("/global/cscratch1/sd/xhsong/flux_estimation")
os.chdir("/Users/song884/flux_estimation/")
output_times = range(8760, (8760 + 100 * 24))
output_times = range(8760, 8770)
output_times = range(8760, 9000)
ntime = len(output_times)


case_name = "homo_2"
pflotran_name = "pflotran_ERT"
pflotran_name = "homo_2_part1"
material_name = "Ert_material"
out_dir = "results/"

datafile = h5.File(case_name + "/" + pflotran_name + ".h5", "r")

x = datafile["Coordinates"]["X [m]"][:]
y = datafile["Coordinates"]["Y [m]"][:]
z = datafile["Coordinates"]["Z [m]"][:]

dx = np.diff(x)
dy = np.diff(y)
dz = np.diff(z)

x = x[0:-1] + 0.5 * dx
y = y[0:-1] + 0.5 * dy
z = z[0:-1] + 0.5 * dz

nx = len(x)
ny = len(y)
nz = len(z)

coordx, coordy, coordz = np.meshgrid(x, y, z, indexing="ij")
# coordx = np.reshape(coordx, np.product(coordx.shape), order="F")
# coordy = np.reshape(coordy, np.product(coordy.shape), order="F")
# coordz = np.reshape(coordz, np.product(coordz.shape), order="F")


thermistor_index = np.argmin(
    abs(x - thermistor_loc[0])), np.argmin(abs(y - thermistor_loc[1]))


materialfile = h5.File(case_name + "/" + material_name + ".h5", "r")
cell_ids = materialfile["Materials"]["Cell Ids"][:]
material_ids = materialfile["Materials"]["Material Ids"][:]
cell_ids = np.reshape(cell_ids, (nx, ny, nz), order="F")
material_ids = np.reshape(material_ids, (nx, ny, nz), order="F")

thermistor_alluvium = (
    material_ids[thermistor_index[0], thermistor_index[1], :] == 5)


thermistor_depth = z[thermistor_alluvium]
ndepth = len(thermistor_depth)
thermistor_depth = thermistor_depth - \
    thermistor_depth[-1] - dz[thermistor_alluvium][-1]

thermistor_data = np.empty([ndepth, ntime])

groupname = "Time:  " + "{0:.5E}".format(output_times[0]) + " h"
group_data = datafile[groupname]
datatype = list(group_data.keys())

for itype in datatype:
    print(itype)
    for itime in range(ntime):
        #        print(str(itime) + " in " + str(ntime))
        groupname = "Time:  " + "{0:.5E}".format(output_times[itime]) + " h"
        group_data = datafile[groupname]
        temperature = group_data["Temperature [C]"]
        thermistor_data[:, itime] = temperature[thermistor_index[0],
                                                thermistor_index[1], :][thermistor_alluvium]
    np.savetxt(out_dir + case_name + "_" + itype + ".txt",
               np.transpose(thermistor_data), fmt="%.6e", delimiter=",")
np.savetxt(out_dir + case_name + "_time.txt",
           np.transpose(output_times), fmt="%.6e",  delimiter=",")
np.savetxt(out_dir + case_name + "_depth.txt",
           np.transpose(thermistor_depth), fmt="%.6e",  delimiter=",")
datafile.close()

# fid = open(out_dir + case_name + "thermistor.txt", "w")
# fid.write(thermistor_data)
# fid.close()
# plt.plot(thermistor_depth, thermistor_data[:, 1])
# plt.show()


# plt.plot(range(ntime), thermistor_data[1, :])
# plt.show()
