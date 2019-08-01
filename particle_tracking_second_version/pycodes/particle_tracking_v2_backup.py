import multiprocessing as mp
import h5py as h5
import numpy as np
import math
import time
import os
import pickle


def locate_cell(coord):
    return ([np.argmin(abs(x - coord[0])),
             np.argmin(abs(y - coord[1])),
             np.argmin(abs(z - coord[2]))])


def eliminate_conditions(
        pt_coord_1,
        pt_cell_1,
        pt_cell_new_1,
    #        pt_lazy_1,
    # lazy_flag
):

    particle_lost = (
        pt_coord_1[0] > ex or
        pt_coord_1[0] < ox or
        pt_coord_1[1] > ey or
        pt_coord_1[1] < oy or
        pt_coord_1[2] > ez or
        pt_coord_1[2] < oz or
        # pt_lazy_1 >= lazy_flag or
        material_ids[
            pt_cell_new_1[0],
            pt_cell_new_1[1],
            pt_cell_new_1[2]] != 1
    )
    # print(str(pt_lazy_1), str(lazy_flag))
# saturation[cell_x][cell_y][cell_z] < 1
    return particle_lost  # , pt_lazy_1


def particle_tracking_steady(iparticle_1):
    current_t = times[itime]
    # retrieve paricle coords
    coord_x = particles[iparticle_1][len(particles[iparticle_1]) - 1][1]
    coord_y = particles[iparticle_1][len(particles[iparticle_1]) - 1][2]
    coord_z = particles[iparticle_1][len(particles[iparticle_1]) - 1][3]

    cell_x, cell_y, cell_z = locate_cell(
        [coord_x, coord_y, coord_z])

    # counting time left
    rest_dt = times[itime + 1] - current_t

    coord_update = []
    while rest_dt > 0:

        # west/south/bottom face of the cell
        x1 = x[cell_x] - 1 / 2 * dx[cell_x]
        y1 = y[cell_y] - 1 / 2 * dy[cell_y]
        z1 = z[cell_z] - 1 / 2 * dz[cell_z]

        # east/north/top face of the cell
        x2 = x[cell_x] + 1 / 2 * dx[cell_x]
        y2 = y[cell_y] + 1 / 2 * dy[cell_y]
        z2 = z[cell_z] + 1 / 2 * dz[cell_z]

        # darcy accross faces
        vx1 = x_darcy[cell_x][cell_y][cell_z]
        vx2 = x_darcy[cell_x + 1][cell_y][cell_z]
        vy1 = y_darcy[cell_x][cell_y][cell_z]
        vy2 = y_darcy[cell_x][cell_y + 1][cell_z]
        vz1 = z_darcy[cell_x][cell_y][cell_z]
        vz2 = z_darcy[cell_x][cell_y][cell_z + 1]

#        print(str(material_ids[cell_x][cell_y][cell_z]))
        # velocity accross faces
        vx1 = vx1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vx2 = vx2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy1 = vy1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy2 = vy2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vz1 = vz1 / porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vz2 = vz2 / porosity[str(material_ids[cell_x][cell_y][cell_z])]

        # weighted parameter
        Ax = (vx2 - vx1) / dx[cell_x]
        Ay = (vy2 - vy1) / dy[cell_y]
        Az = (vz2 - vz1) / dz[cell_z]

        # caculate velocity in the particulal location
        vx = Ax * (coord_x - x1) + vx1
        vy = Ay * (coord_y - y1) + vy1
        vz = Az * (coord_z - z1) + vz1

        print(str(x1) + "====" +
              str(x2) + "====" +
              str(coord_x)
              )

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
                # if dtx < 0:
                # print(str(dtx) + "====" +
                #       str(vx1) + "====" +
                #       str(vx) + "====" +
                #       str(vx2))

                # print(str(x1) + "====" +
                #       str(x2) + "====" +
                #       str(coord_x)
                #       )

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

        # ensure the particle can leave current cell if needed.
        # dtx = dtx + min_dtstep
        # dty = dty + min_dtstep
        # dtz = dtz + min_dtstep
#        print(str(dtx) + "==" + str(dty) + "==" + str(dtz))

        if dtx < min_dtstep:
            dtx = min_dtstep
        if dty < min_dtstep:
            dty = min_dtstep
        if dtz < min_dtstep:
            dtz = min_dtstep

        # find the time particle need to leave the cell
        min_dt = min(dtx, dty, dtz, rest_dt)

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

        # locate new cells
        cell_x_new, cell_y_new, cell_z_new = locate_cell(
            [coord_x, coord_y, coord_z])

        current_t = current_t + min_dt
        rest_dt = times[itime + 1] - current_t
        coord_update.append([current_t, coord_x, coord_y, coord_z])

# particle_lost, pt_lazy_1 = eliminate_conditions(
        # particle_lost = eliminate_conditions(
        #     [coord_x, coord_y, coord_z],
        #     [cell_x, cell_y, cell_z],
        #     [cell_x_new, cell_y_new, cell_z_new],
        #     #            pt_lazy[iparticle],
        #     #            lazy_flag
        # )

        particle_lost = False
        if particle_lost:
            return {
                "pt_index": iparticle_1,
                "pt_status": 0,
                "coord_update": coord_update,
            }

    return {
        "pt_index": iparticle_1,
        "pt_status": 1,
        "coord_update": coord_update,
    }
#            "pt_lazy": pt_lazy_1}


# def collect_results(results, result):
#     results.append(result)


def release_particle_from_river_bed(itime):
    #        river_particle_dy, river_particle_dz):

    # define new particle locations
    # new_particles = [np.array([times[itime],317,99,95]).reshape((1,4)),
    # np.array([times[itime],317,99,100]).reshape((1,4)),
    # np.array([times[itime],317,99,105]).reshape((1,4)),
    # np.array([times[itime],317,99,110]).reshape((1,4))]

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
    # saturation = datagroup["Liquid_Saturation"][:]
    new_particles = []
    for iy in range(river_particle_ny):
        pline_selected = unique_face_index[
            :, unique_face_index[1, :] == river_particle_y_index[iy]
        ]
        for icell in range(pline_selected.shape[1]):
            if (pline_selected[2, icell] in river_particle_z_index):
                new_particle = np.array(
                    [times[itime],
                     x[pline_selected[0, icell]],
                     y[pline_selected[1, icell]],
                     z[pline_selected[2, icell]]]
                ).reshape((1, 4))
                new_particles.append(new_particle)

    return new_particles


if __name__ == '__main__':

    caculate_path = False
    plot_surface = False
    plot_path = True

    caculate_path = True
    plot_path = False
    plot_surface = False

    # minimum time step
    min_dtstep = 0.001
    ##
    ncore = 16

    lazy_flag = 24

    # ------------------------------------------------------------
    # -----------the h5 input file--------------------------------
    nx = 225
    ny = 400
    nz = 40

    ox = -450
    oy = -800
    oz = 90

    dx = [4] * nx
    dy = [4] * ny
    dz = [0.5] * nz

    river_bed_dy = 50
    river_bed_dz = 2

    ex = ox + np.sum(dx)
    ey = oy + np.sum(dy)
    ez = oz + np.sum(dz)

    x = np.cumsum(dx) + ox - 1 / 2 * dx[0]
    y = np.cumsum(dy) + oy - 1 / 2 * dy[0]
    z = np.cumsum(dz) + oz - 1 / 2 * dz[0]

    material_type = {"Hanford": 1, "Ringold_Gravel": 4, "Ringold_Fine": 9}
    porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

    # ------------------------------------------------------------
    # -----------the h5 input file--------------------------------
    simu_file = "./flow_2008_3/pflotran_bigplume.h5"
    material_file = (
        "./flow_2008_3/BC_2008_2015/" +
        "bigplume_4mx4mxhalfRes_material_" +
        "mapped_newRingold_subRiver_17tracer.h5")

    simu_file = "../data/pflotran_bigplume.h5"
    material_file = (
        "../data/bigplume_4mx4mxhalfRes_material_" +
        "mapped_newRingold_subRiver_17tracer.h5")

    times = np.arange((8784 + 240 * 15), 70000, 1)
    release_times = np.r_[(8784 + 240 * 15):70000:2400000]

    times = np.arange(60, 64, 1)
    release_times = np.r_[60:64:1]

    ntime = len(times)

    datafile = h5.File(material_file, "r")
    material_ids = datafile['Materials']['Material Ids'][:].reshape(
        nz, ny, nx).swapaxes(0, 2)
    face_cells = datafile['Regions']['River']["Cell Ids"][:]
    face_ids = datafile['Regions']['River']["Face Ids"][:]

    cell_index = np.concatenate((
        [np.r_[0:nx * ny * nz] % nx],
        [np.r_[0:nx * ny * nz] % (nx * ny) // nx],
        [np.r_[0:nx * ny * nz] // (nx * ny)],
    ), axis=0)
    face_index = cell_index[:, (face_cells - 1)]
    unique_face_index = cell_index[:, (np.unique(face_cells) - 1)]

    # this part is used to defined where to release particles
    pt_fname_template = "../results/path.pickle_15"

    particles = []
    pt_status = []
    pt_lazy = []

    for itime in range(0, ntime - 1):
        pt_fname = pt_fname_template + str(itime % 2)
        groupname = "Time:  " + "{0:.5E}".format(times[itime]) + " h"
        datafile = h5.File(simu_file, "r")

        datagroup = datafile[groupname]
        pressure = datagroup["Liquid_Pressure [Pa]"][:]
        # time to add new particles
        if times[itime] in release_times:

            # define new particle locations
            new_particles = (
                release_particle_from_river_bed(itime))

            # add new particles to database
            particles.extend(new_particles)
            pt_status.extend([1] * len(new_particles))
# pt_lazy.extend([0] * len(new_particles))

        # only run tracking for the alive particles
        active_particles = [i for i, j in enumerate(
            pt_status) if j == 1]

        x_darcy = datagroup["Liquid X-Flux Velocities"][:]
        y_darcy = datagroup["Liquid Y-Flux Velocities"][:]
        z_darcy = datagroup["Liquid Z-Flux Velocities"][:]

        # assign face flux(may need fix)
        x_darcy = np.append(x_darcy[0: 1, :, :], x_darcy, 0)
        x_darcy = np.append(x_darcy, x_darcy[(nx - 1): nx, :, :], 0)
        y_darcy = np.append(y_darcy[:, 0: 1, :], y_darcy, 1)
        y_darcy = np.append(y_darcy, y_darcy[:, (ny - 1): ny, :], 1)
        z_darcy = np.append(z_darcy[:, :, 0: 1], z_darcy, 2)
        z_darcy = np.append(z_darcy, z_darcy[:, :, (nz - 1): nz], 2)

        # let parallel cores execute particle tracking
        print(groupname, "active particles:", len(active_particles))
        time_start = time.time()
        results = []
        pool = mp.Pool(processes=ncore)
        for iparticle in active_particles:
            result = pool.apply_async(
                particle_tracking_steady,
                args=(iparticle,))
            results.append(result)
        pool.close()
        pool.join()
        print(time.time() - time_start)
        # read particle tracking results
        for result in results:
            pt_index = result.get()["pt_index"]

            # particles[pt_index] = np.append(
            #     particles[pt_index],
            #     result.get()["coord_update"],
            #     0)
            # pt_status[pt_index] = result.get()["pt_status"]
#        pt_lazy[pt_index] = result.get()["pt_lazy"]
        # save particle tracking results
        # pt_results = {'pt_cells': pt_cells,
        #               'particles': particles,
        #               'pt_status': pt_status,
        #               'itime': itime
        #               }
        # if os.path.isfile(pt_fname):
        #     os.remove(pt_fname)
        #     file = open(pt_fname, "wb")
        #     pickle.dump(pt_results, file)
        #     file.close()

    # save particle tracking results
    # if os.path.isfile(pt_fname):
    #     os.remove(pt_fname)
    #     file = open(pt_fname, "wb")
    #     pickle.dump(pt_results, file)
    #     file.close()

        # list(datafile.keys())
        # list(datagroup.keys())
