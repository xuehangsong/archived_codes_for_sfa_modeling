import multiprocessing as mp
import h5py as h5
import numpy as np
import math
import time
import pickle
import sys


def locate_cell(coord_1):
    return([np.argmin(abs(x - coord_1[0])),
            np.argmin(abs(y - coord_1[1])),
            np.argmin(abs(z - coord_1[2]))])


def eliminate_conditions(
        pt_coord_1,
        pt_coord_1_new,
        pt_cell_1,
        pt_cell_1_new,
        pt_dis_1
):

    particle_lost = any([
        pt_coord_1[0] > ex or
        pt_coord_1[0] < ox or
        pt_coord_1[1] > ey or
        pt_coord_1[1] < oy or
        pt_coord_1[2] > ez or
        pt_coord_1[2] < oz or
        material_ids[
            pt_cell_1[0],
            pt_cell_1[1],
            pt_cell_1[2]] != 1 or
        pressure[
            pt_cell_1[0],
            pt_cell_1[1],
            pt_cell_1[2]] <= pressure_threshold

    ])
    # print(str(pt_lazy_1), str(lazy_flag))
# saturation[cell_x][cell_y][cell_z] < 1
    return particle_lost  # , pt_lazy_1


def particle_tracking_steady(iparticle_1):

    current_t = particles[iparticle_1][len(particles[iparticle_1]) - 1][0]
    coord_x = particles[iparticle_1][len(particles[iparticle_1]) - 1][1]
    coord_y = particles[iparticle_1][len(particles[iparticle_1]) - 1][2]
    coord_z = particles[iparticle_1][len(particles[iparticle_1]) - 1][3]
    total_dis = particles[iparticle_1][len(particles[iparticle_1]) - 1][4]
    rest_dt = times[itime + 1] - current_t

    cell_x, cell_y, cell_z = locate_cell(
        [coord_x, coord_y, coord_z])

    pt_update = []
    while rest_dt > 0:

        x1 = x[cell_x] - 1 / 2 * dx[cell_x]
        y1 = y[cell_y] - 1 / 2 * dy[cell_y]
        z1 = z[cell_z] - 1 / 2 * dz[cell_z]

        x2 = x[cell_x] + 1 / 2 * dx[cell_x]
        y2 = y[cell_y] + 1 / 2 * dy[cell_y]
        z2 = z[cell_z] + 1 / 2 * dz[cell_z]

        vx1 = x_darcy[cell_x][cell_y][cell_z]
        vx2 = x_darcy[cell_x + 1][cell_y][cell_z]
        vy1 = y_darcy[cell_x][cell_y][cell_z]
        vy2 = y_darcy[cell_x][cell_y + 1][cell_z]
        vz1 = z_darcy[cell_x][cell_y][cell_z]
        vz2 = z_darcy[cell_x][cell_y][cell_z + 1]

        vx1 = vx1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vx2 = vx2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy1 = vy1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy2 = vy2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vz1 = vz1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vz2 = vz2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]

        Ax = (vx2 - vx1) / dx[cell_x]
        Ay = (vy2 - vy1) / dy[cell_y]
        Az = (vz2 - vz1) / dz[cell_z]

        vx = Ax * (coord_x - x1) + vx1
        vy = Ay * (coord_y - y1) + vy1
        vz = Az * (coord_z - z1) + vz1

        # find time for particle reaching east or west face
        if vx > 0:
            if vx1 == vx2:
                dtx = (x2 - coord_x) / vx
            elif vx2 > 0:
                dtx = 1 / Ax * math.log(vx2 / vx)
            else:
                dtx = rest_dt
        elif vx == 0:
            dtx = rest_dt
        else:
            if vx1 == vx2:
                dtx = (x1 - coord_x) / vx
            elif vx1 < 0:
                dtx = 1 / Ax * math.log(vx1 / vx)
            else:
                dtx = rest_dt

        # find time for particle reaching south or north face
        if vy > 0:
            if vy1 == vy2:
                dty = (y2 - coord_y) / vy
            elif vy2 > 0:
                dty = 1 / Ay * math.log(vy2 / vy)
            else:
                dty = rest_dt
        elif vy == 0:
            dty = rest_dt
        else:
            if vy1 == vy2:
                dty = (y1 - coord_y) / vy
            elif vy1 < 0:
                dty = 1 / Ay * math.log(vy1 / vy)
            else:
                dty = rest_dt

        # find time for particle reaching top or bottom face
        if vz > 0:
            if vz1 == vz2:
                dtz = (z2 - coord_z) / vz
            elif vz2 > 0:
                dtz = 1 / Az * math.log(vz2 / vz)
            else:
                dtz = rest_dt
        elif vz == 0:
            dtz = rest_dt
        else:
            if vz1 == vz2:
                dtz = (z1 - coord_z) / vz
            elif vz1 < 0:
                dtz = 1 / Az * math.log(vz1 / vz)
            else:
                dtz = rest_dt

        # ensure the particle can leave currrent cell
        dtx = dtx + min_dtstep
        dty = dty + min_dtstep
        dtz = dtz + min_dtstep
        min_dt = min(dtx, dty, dtz, rest_dt)

        coord_x_old = coord_x
        coord_y_old = coord_y
        coord_z_old = coord_z

        # caculate particel locations
        if Ax == 0:
            coord_x = coord_x + vx * min_dt
        else:
            coord_x = x1 + 1 / Ax * (vx * math.exp(Ax * min_dt) - vx1)
        if Ay == 0:
            coord_y = coord_y + vy * min_dt
        else:
            coord_y = y1 + 1 / Ay * (vy * math.exp(Ay * min_dt) - vy1)
        if Az == 0:
            coord_z = coord_z + vz * min_dt
        else:
            coord_z = z1 + 1 / Az * (vz * math.exp(Az * min_dt) - vz1)
        total_dis = total_dis + ((coord_x - coord_x_old)**2 +
                                 (coord_y - coord_y_old)**2 +
                                 (coord_z - coord_z_old)**2)**0.5
        # locate new cells
        cell_x, cell_y, cell_z = locate_cell(
            [coord_x, coord_y, coord_z])
        current_t = current_t + min_dt
        rest_dt = times[itime + 1] - current_t
        pt_update.append([current_t, coord_x, coord_y, coord_z, total_dis])

        particle_lost = 0
        if any([coord_x > ex,
                coord_x < ox,
                coord_y > ey,
                coord_y < oy,
                coord_z > ez,
                coord_z < oz]):
            particle_lost = 1
        if pressure[cell_x, cell_y, cell_z] <= pressure_threshold:
            particle_lost = 2
        if material_ids[cell_x, cell_y, cell_z] != material_type["Hanford"]:
            particle_lost = 3
        if material_ids[cell_x, cell_y, cell_z] == material_type["River"]:
            particle_lost = 4
        if all([(itime > lazy_interval),
                (itime > lazy_start),
                (coord_z <= face_lowest[cell_y]),
                (coord_x >= face_eastest[cell_y])]):
            total_dis_old = particles[iparticle_1][len(
                particles[iparticle_1]) - 1 - lazy_interval][4]
            if total_dis - total_dis_old < lazy_threshold:
                particle_lost = 5

        if particle_lost > 0:
            return {
                "pt_index": iparticle_1,
                "pt_status": particle_lost,
                "pt_update": pt_update,
            }

    return {
        "pt_index": iparticle_1,
        "pt_status": 0,
        "pt_update": pt_update,
    }


def release_particle_from_riverbed_selected(itime):
    # find y coords for release particles
    river_particle_ny = int((ey - oy) // river_bed_dy)
    river_particle_dy = [river_bed_dy] * river_particle_ny
    river_particle_y = np.cumsum(
        river_particle_dy) + oy - 1 / 2 * river_particle_dy[0]
    river_particle_y_index = [0] * river_particle_ny
    for iy in range(river_particle_ny):
        river_particle_y_index[iy] = np.argmin(abs(y - river_particle_y[iy]))

    river_particle_nz = int((ez - oz) // river_bed_dz)
    river_particle_dz = [river_bed_dz] * river_particle_nz
    river_particle_z = np.cumsum(
        river_particle_dz) + oz - 1 / 2 * river_particle_dz[0]
    river_particle_z_index = [0] * river_particle_nz
    for iz in range(river_particle_nz):
        river_particle_z_index[iz] = np.argmin(abs(z - river_particle_z[iz]))

    # find saturated zone to release particles
    new_particles = []
    for iy in range(river_particle_ny):
        pline_selected = unique_face_index[
            unique_face_index[:, 1] == river_particle_y_index[iy], :]
        for icell in range(pline_selected.shape[0]):
            if ((pline_selected[icell, 2] in river_particle_z_index) and
                    ((pressure[
                        pline_selected[icell, 0],
                        pline_selected[icell, 1],
                        pline_selected[icell, 2]
                    ] > pressure_threshold)) and
                    (material_ids[
                        pline_selected[icell, 0],
                        pline_selected[icell, 1],
                        pline_selected[icell, 2]
                    ] == 1)):
                new_particle = np.array(
                    [times[itime],
                     x[pline_selected[icell, 0]],
                        y[pline_selected[icell, 1]],
                        z[pline_selected[icell, 2]],
                        0,
                     ]
                ).reshape((1, 5))
                new_particles.append(new_particle)
    return new_particles


def release_particle_from_riverbed_elevation(itime):
    # find y coords for release particles
    river_particle_ny = int((ey - oy) // river_bed_dy)
    river_particle_dy = [river_bed_dy] * river_particle_ny
    river_particle_y = np.cumsum(
        river_particle_dy) + oy - 1 / 2 * river_particle_dy[0]
    river_particle_y_index = [0] * river_particle_ny
    for iy in range(river_particle_ny):
        river_particle_y_index[iy] = np.argmin(abs(y - river_particle_y[iy]))

    river_particle_z_index = [np.argmin(abs(z - river_bed_elevation))]

    # find saturated zone to release particles
    new_particles = []
    for iy in range(river_particle_ny):
        pline_selected = unique_face_index[
            unique_face_index[:, 1] == river_particle_y_index[iy], :]
        for icell in range(pline_selected.shape[0]):
            if ((pline_selected[icell, 2] in river_particle_z_index) and
                    ((pressure[
                        pline_selected[icell, 0],
                        pline_selected[icell, 1],
                        pline_selected[icell, 2]
                    ] > pressure_threshold)) and
                    (material_ids[
                        pline_selected[icell, 0],
                        pline_selected[icell, 1],
                        pline_selected[icell, 2]
                    ] == 1)):
                new_particle = np.array(
                    [times[itime],
                     x[pline_selected[icell, 0]],
                        y[pline_selected[icell, 1]],
                        z[pline_selected[icell, 2]],
                        0,
                     ]
                ).reshape((1, 5))
                new_particles.append(new_particle)
                break  # only need one point on one curve
    return new_particles


def release_particle_from_riverbed_all(itime):

    # find saturated zone in hanford to release particles
    new_particles = []
    for iparticle in range(len(unique_face_index.shape[1])):
        if ((pressure[
                unique_face_index[iparticle, 0],
                unique_face_index[iparticle, 1],
                unique_face_index[iparticle, 2]
        ] > pressure_threshold) and
                (material_ids[
                unique_face_index[iparticle, 0],
                unique_face_index[iparticle, 1],
                unique_face_index[iparticle, 2]
                ] == 1)):
            new_particle = np.array(
                [times[itime],
                 x[unique_face_index[iparticle, 0]],
                 y[unique_face_index[iparticle, 1]],
                 z[unique_face_index[iparticle, 2]],
                 0,
                 ]
            ).reshape((1, 5))
            new_particles.append(new_particle)
    return new_particles


if __name__ == '__main__':
    time_start = time.time()

    # -----------where to release particle?--------------------

    release_function = {
        0: release_particle_from_riverbed_selected,
        1: release_particle_from_riverbed_elevation,
        2: release_particle_from_riverbed_all
    }
    release_option = 1

    # option 0 parameter
    river_bed_dy = 1
    river_bed_dz = 1

    # option 1 parameter
    river_bed_dy = 10
    river_bed_elevation = 103.5

    # -----------when to release particle?--------------------

    ibatch = 0
    if(len(sys.argv) > 1):
        ibatch = int(sys.argv[1])
    initial_time = (366 + 365 + 365 + 365 + 366) * 24
    batch_length = 24 * 20
    batch_frequency = 24
    times = np.arange(
        (initial_time + (ibatch - 1) * batch_length),
        (initial_time + ibatch * batch_length + 365 * 24 * 10),
        1)
    release_times = np.arange(
        initial_time + (ibatch - 1) * batch_length,
        initial_time + ibatch * batch_length,
        batch_frequency)

    pt_fname_template = "./batch/path_pickle"
    # times = np.arange((8784 + 240 * 15), 70000, 1)
    # release_times = np.r_[(8784 + 240 * 15):70000:2400000]

    # times = np.arange(0, 80, 1)
    # release_times = np.r_[0:1:1]

    #
    #

    # -----------h5 input files--------------------------------

    simu_file = h5.File((
        "./flow_2008_3/pflotran_bigplume.h5"),
        "r")
    material_file = h5.File((
        "./flow_2008_3/BC_2008_2015/" +
        "bigplume_4mx4mxhalfRes_material_" +
        "mapped_newRingold_subRiver_17tracer.h5"),
        "r")

    # simu_file = h5.File((
    #     "../data/pflotran_bigplume.h5"),
    #     "r")
    # material_file = h5.File((
    #     "../data/bigplume_4mx4mxhalfRes_material_" +
    #     "mapped_newRingold_subRiver_17tracer.h5"),
    #     "r")

    # -----------default setup ----------------------------------
    min_dtstep = 0.001     # minimum time step
    pressure_threshold = 101325.0  # threshold for saturation
    ncore = 64  # core used fixed for cori
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

            new_particles = (
                release_function[release_option](itime))

            particles.extend(new_particles)
            pt_status.extend([0] * len(new_particles))

        active_particles = [i for i, j in enumerate(
            pt_status) if j == 0]

        print(ibatch, groupname, "active particles:", len(active_particles))
        if (len(active_particles) == 0 and times[itime] > max(release_times)):
            break

        x_darcy = simu_snapshot["Liquid X-Flux Velocities"][:]
        y_darcy = simu_snapshot["Liquid Y-Flux Velocities"][:]
        z_darcy = simu_snapshot["Liquid Z-Flux Velocities"][:]

        # assign face flux(may need fix)
        x_darcy = np.append(x_darcy[0: 1, :, :], x_darcy, 0)
        x_darcy = np.append(x_darcy, x_darcy[(nx - 1): nx, :, :], 0)
        y_darcy = np.append(y_darcy[:, 0: 1, :], y_darcy, 1)
        y_darcy = np.append(y_darcy, y_darcy[:, (ny - 1): ny, :], 1)
        z_darcy = np.append(z_darcy[:, :, 0: 1], z_darcy, 2)
        z_darcy = np.append(z_darcy, z_darcy[:, :, (nz - 1): nz], 2)

        # for east boundary
        x_darcy[0, :, :] = (+ x_darcy[1, :, :]
                            - y_darcy[0, 0:ny, :]
                            + y_darcy[0, 1:(ny + 1), :]
                            - z_darcy[0, :, 0:nz]
                            + z_darcy[0, :, 1:(nz + 1)])
        # for south boundary
        y_darcy[:, 0, :] = (-x_darcy[0:nx, 0, :]
                            + x_darcy[1:(nx + 1), 0, :]
                            + y_darcy[:, 1, :]
                            - z_darcy[:, 0, 0:nz]
                            + z_darcy[:, 0, 1:(nz + 1)])
        # for north boundary
        y_darcy[:, ny, :] = (+ x_darcy[0:nx, (ny - 1), :]
                             - x_darcy[1:(nx + 1), (ny - 1), :]
                             + y_darcy[:, (ny - 1), :]
                             + z_darcy[:, (ny - 1), 0:nz]
                             - z_darcy[:, (ny - 1), 1:(nz + 1)])

        # for river_face
        for iface in range(len(unique_face_ids)):
            cell_x = unique_face_index[iface, 0]
            cell_y = unique_face_index[iface, 1]
            cell_z = unique_face_index[iface, 2]

            vx1 = x_darcy[cell_x][cell_y][cell_z]
            vx2 = x_darcy[cell_x + 1][cell_y][cell_z]
            vy1 = y_darcy[cell_x][cell_y][cell_z]
            vy2 = y_darcy[cell_x][cell_y + 1][cell_z]
            vz1 = z_darcy[cell_x][cell_y][cell_z]
            vz2 = z_darcy[cell_x][cell_y][cell_z + 1]

            if unique_face_ids[iface] == 1:
                x_darcy[
                    cell_x][cell_y][cell_z] = vx2 - vy1 + vy2 - vz1 + vz2
            elif unique_face_ids[iface] == 2:
                x_darcy[
                    cell_x + 1][cell_y][cell_z] = vx1 + vy1 - vy2 + vz1 - vz2
            elif unique_face_ids[iface] == 3:
                y_darcy[
                    cell_x][cell_y][cell_z] = vy2 - vx1 + vx2 - vz1 + vz2
            elif unique_face_ids[iface] == 4:
                y_darcy[
                    cell_x][cell_y + 1][cell_z] = vy1 + vx1 - vx2 + vz1 - vz2
            elif unique_face_ids[iface] == 5:
                z_darcy[
                    cell_x][cell_y][cell_z] = vz2 - vx1 + vx2 - vy1 + vy2
            elif unique_face_ids[iface] == 6:
                z_darcy[
                    cell_x][cell_y][cell_z + 1] = vz1 + vx1 - vx2 + vy1 - vy2

        results = []
        pool = mp.Pool(processes=ncore)
        for iparticle in active_particles:
            result = pool.apply_async(
                particle_tracking_steady,
                args=(iparticle,))
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
