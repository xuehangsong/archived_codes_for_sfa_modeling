# the file is to

import h5py as h5
import glob
import numpy as np


#output_dir = "/Users/song884/remote/reach/Outputs/2007_age/"
output_dir = "/Users/shua784/Paraview/HFR/test_2007_age/"

# output_h5.close()
output_file = output_dir + "all_age_flux.h5"
output_h5 = h5.File(output_file, "w")


all_h5 = glob.glob(output_dir + "pflotran*h5")
all_h5 = np.sort(all_h5)


i_h5 = all_h5[0]
print(i_h5)
input_h5 = h5.File(i_h5, "r")

groups = list(input_h5.keys())
for i_group in groups:
    print(i_group)
    group_id = output_h5.require_group(i_group)
    datasets = list(input_h5[i_group].keys())
    for i_dataset in datasets:
        input_h5.copy("/" + i_group + "/" + i_dataset,
                      group_id, name=i_dataset)
input_h5.close()

for i_h5 in all_h5[1:]:
    print(i_h5)
    input_h5 = h5.File(i_h5, "r")
    groups = list(input_h5.keys())
    groups = [s for s,  s in enumerate(groups) if "Time:" in s]
    for i_group in groups:
        print(i_group)
        group_id = output_h5.require_group(i_group)
        datasets = list(input_h5[i_group].keys())
        for i_dataset in datasets:
            input_h5.copy("/" + i_group + "/" + i_dataset,
                          group_id, name=i_dataset)
    input_h5.close()

output_h5.close()
