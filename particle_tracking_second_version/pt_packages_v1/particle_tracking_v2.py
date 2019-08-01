import multiprocessing as mp
import h5py as h5
import numpy as np
import time
import pickle
import sys
import argparse
import math

from pt_functions import reproduce_cell_face_flux
from pt_functions import particle_tracking_steady
from pt_functions import release_particle_from_riverbed_selected
from pt_functions import release_particle_from_riverbed_elevation
from pt_functions import release_particle_from_riverbed_all

from pt_parameters import initial_time
from pt_parameters import batch_frequency
from pt_parameters import batch_length
from pt_parameters import results_dir
from pt_parameters import simulations_h5
from pt_parameters import material_h5

if __name__ == '__main__':
    time_start = time.time()

    # -----------where to release particle?--------------------

    release_function = {
        0: release_particle_from_riverbed_selected,
        1: release_particle_from_riverbed_elevation,
        2: release_particle_from_riverbed_all
    }
    release_option = 0

    # option 0 parameter
    if (release_option == 0):
        river_bed_dy = 100
        river_bed_dz = 10

    # option 1 parameter
    if (release_option == 1):
        river_bed_dy = 10
        river_bed_elevation = 103.5

    # -----------when to release particle?--------------------
    try:
        ibatch = int(sys.argv[1])
    except:
        ibatch = 1

    print(ibatch)

    times = np.arange(
        (initial_time + (ibatch - 1) * batch_length),
        (initial_time + ibatch * batch_length + 365 * 24 * 10),
        1)
    release_times = np.arange(
        initial_time + (ibatch - 1) * batch_length,
        initial_time + ibatch * batch_length,
        batch_frequency)

    # -----------where to store output?-----------------------
    pt_fname_template = (results_dir + "path_pickle")
    # -----------h5 input files--------------------------------

    simu_file = h5.File(simulations_h5, "r")
    material_file = h5.File(material_h5, "r")

    # -----------default setup ----------------------------------
    min_dtstep = 0.001     # minimum time step
    pressure_threshold = 101325.0  # threshold for saturation
    ncore = 48  # core used fixed for edison
    pickle_interval = 60 * 9

    lazy_start = 24
    lazy_interval = 24
    lazy_threshold = 0.05

    # -----------configuration ends here-------------------------
    ntime = len(times)
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
    material_type = {"Hanford": 1,
                     "Ringold Gravel": 4,
                     "Ringold Fine": 9,
                     "River": 0}
    porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

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

    # this is to locate the possiable low-flow zone in our concept model
    face_lowest = []
    face_eastest = []
    for iy in range(ny):
        pline_selected = unique_face_index[
            unique_face_index[:, 1] == iy, :]
        pline_lowest_cell = min(pline_selected[:, 2])
        face_lowest.append(
            (z[pline_lowest_cell] + 0.5 * dz[pline_lowest_cell]))
        pline_eastest_cell = min(pline_selected[:, 0])
        face_eastest.append(
            (x[pline_eastest_cell] - 0.5 * dx[pline_eastest_cell]))

    particles = []
    pt_status = []
    pickle_time = pickle_interval
    for itime in range(0, ntime - 1):
        pt_fname = pt_fname_template + str(itime % 2)
        groupname = "Time:  " + "{0:.5E}".format(times[itime]) + " h"
        simu_snapshot = simu_file[groupname]
        pressure = simu_snapshot["Liquid_Pressure [Pa]"][:]
        if times[itime] in release_times:
            if (release_option == 0):
                args = {"x": x,
                        "y": y,
                        "z": z,
                        "oy": oy,
                        "oz": oz,
                        "ey": ey,
                        "ez": ez,
                        "times": times,
                        "itime": itime,
                        "material_ids": material_ids,
                        "river_bed_dy": river_bed_dy,
                        "river_bed_dz": river_bed_dz,
                        "unique_face_index": unique_face_index,
                        "pressure": pressure,
                        "pressure_threshold": pressure_threshold}
            if (release_option == 1):
                args = {"x": x,
                        "y": y,
                        "z": z,
                        "oy": oy,
                        "ey": ey,
                        "times": times,
                        "itime": itime,
                        "material_ids": material_ids,
                        "river_bed_dy": river_bed_dy,
                        "river_bed_elevation": river_bed_elevation,
                        "unique_face_index": unique_face_index,
                        "pressure": pressure,
                        "pressure_threshold": pressure_threshold}
            if (release_option == 2):
                args = {"x": x,
                        "y": y,
                        "z": z,
                        "times": times,
                        "itime": itime,
                        "material_ids": material_ids,
                        "unique_face_index": unique_face_index,
                        "pressure": pressure,
                        "pressure_threshold": pressure_threshold}

            new_particles = (
                release_function[release_option](args))

            particles.extend(new_particles)
            pt_status.extend([0] * len(new_particles))

        active_particles = [i for i, j in enumerate(
            pt_status) if j == 0]

        print(ibatch, groupname, "active particles:", len(active_particles))
        if (len(active_particles) == 0 and times[itime] > max(release_times)):
            break

        args = {"nx": nx,
                "ny": ny,
                "nz": nz,
                "simu_snapshot": simu_snapshot,
                "unique_face_index": unique_face_index,
                "unique_face_ids": unique_face_ids
                }
        x_darcy, y_darcy, z_darcy = reproduce_cell_face_flux(args)

        results = []
        pool = mp.Pool(processes=ncore)
        for iparticle in active_particles:
            args = {"x": x,
                    "y": y,
                    "z": z,
                    "ox": ox,
                    "oy": oy,
                    "oz": oz,
                    "ex": ex,
                    "ey": ey,
                    "ez": ez,
                    "dx": dx,
                    "dy": dy,
                    "dz": dz,
                    "x_darcy": x_darcy,
                    "y_darcy": y_darcy,
                    "z_darcy": z_darcy,
                    "times": times,
                    "itime": itime,
                    "pressure": pressure,
                    "pressure_threshold": pressure_threshold,
                    "particles": particles,
                    "iparticle": iparticle,
                    "porosity": porosity,
                    "material_ids": material_ids,
                    "material_type": material_type,
                    "min_dtstep": min_dtstep,
                    "lazy_interval": lazy_interval,
                    "lazy_start": lazy_start,
                    "lazy_threshold": lazy_threshold,
                    "face_lowest": face_lowest,
                    "face_eastest": face_eastest,
                    }

            result = pool.apply_async(
                particle_tracking_steady,
                args=(args,))
            results.append(result)
        pool.close()
        pool.join()

        wall_time = time.time() - time_start
        # read particle tracking results
        for result in results:
            pt_index = result.get()["pt_index"]
            pt_status[pt_index] = result.get()["pt_status"]
            particles[pt_index] = np.append(
                particles[pt_index],
                result.get()["pt_update"],
                0)
        if wall_time >= pickle_time:
            pt_results = {'particles': particles,
                          'pt_status': pt_status}
            pt_fname = (pt_fname_template + "_" +
                        str(ibatch) + "_" + str(times[itime]))
            file = open(pt_fname, "wb")
            pickle.dump(pt_results, file)
            file.close()
            pickle_time = pickle_time + pickle_interval

    material_file.close()
    simu_file.close()
    pt_results = {'particles': particles,
                  'pt_status': pt_status}
    pt_fname = (pt_fname_template + "_" +
                str(ibatch) + "_" + str(times[itime]))
    file = open(pt_fname, "wb")
    pickle.dump(pt_results, file)
    file.close()
    pickle_time = pickle_time + pickle_interval
