import pickle
import h5py as h5
import numpy as np

from pt_parameters import results_dir
from pt_parameters import material_h5
from pt_parameters import simulations_h5
from pt_parameters import results_dir
from pt_parameters import material_type
from pt_parameters import porosity

if __name__ == '__main__':
    pt_fname = results_dir + "all_particles.pickle"
    pickle_file = open(pt_fname, "rb")

    pickle_data = pickle.load(pickle_file)
    pickle_file.close()

    particles = pickle_data["particles"]
    pt_start = pickle_data["pt_start"]

    release_times = np.unique(pt_start)

    simu_file = h5.File(simulations_h5, "r")
    material_file = h5.File(material_h5, "r")

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

    for iface in unique_face_ids


#    for irelease in release_times:
