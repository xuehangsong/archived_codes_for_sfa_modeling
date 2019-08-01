import pickle
import glob
import h5py as h5

from pt_functions import locate_cell
from pt_parameters import simulations_h5

from pt_parameters import nbatch
from pt_parameters import results_dir
if __name__ == '__main__':
    simu_file = h5.File(simulations_h5, "r")

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

    particles = []
    pt_status = []
    for ibatch in range(nbatch):
        #    print(ibatch, "finished in", nbatch)
        result_files = glob.glob((results_dir + "*_" + str(ibatch + 1) + "_*"))
        if (len(result_files) > 1):
            pt_name = sorted(result_files)[-2]
            pickle_file = open(pt_name, "rb")
            pickle_data = pickle.load(pickle_file)
            pickle_file.close()
            particles = particles + pickle_data["particles"]
            pt_status = pt_status + pickle_data["pt_status"]

    pt_start = []
    pt_end = []
    pt_length = []
    pt_release_coord = []
    pt_release_cell = []
    for iparticle in range(len(particles)):
        pt_start.extend([particles[iparticle][0, 0]])
        pt_end.extend([particles[iparticle][-1, 0]])
        pt_length.extend([particles[iparticle][-1, 4]])
        pt_release_coord.append(locate_cell(particles[iparticle][0, 1:4]))
        args = {"x": x,
                "y": y,
                "z": z,
                "coord": particles[iparticle][0, 1:4]
                }
        pt_release_cell.append(locate_cell(args))

    pt_results = {'particles': particles,
                  'pt_status': pt_status,
                  'pt_start': pt_start,
                  'pt_end': pt_end,
                  'pt_length': pt_length,
                  'pt_release_coord': pt_release_coord,
                  'pt_release_cell': pt_release_cell,
                  }
    pt_fname = results_dir + "all_particles.pickle"
    file = open(pt_fname, "wb")
    pickle.dump(pt_results, file)
    file.close()
