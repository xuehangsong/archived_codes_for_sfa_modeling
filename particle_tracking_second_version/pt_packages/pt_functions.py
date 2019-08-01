import numpy as np


def locate_cell(args):
    x = args["x"]
    y = args["y"]
    z = args["z"]
    coord = args["coord"]

    return([np.argmin(abs(x - coord[0])),
            np.argmin(abs(y - coord[1])),
            np.argmin(abs(z - coord[2]))])


def reproduce_cell_face_flux(args):

    nx = args["nx"]
    ny = args["ny"]
    nz = args["nz"]
    simu_snapshot = args["simu_snapshot"]
    unique_face_index = args["unique_face_index"]
    unique_face_ids = args["unique_face_ids"]

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
    return(x_darcy, y_darcy, z_darcy)


def release_particle_from_riverbed_selected(args):
    x = args["x"]
    y = args["y"]
    z = args["z"]
    oy = args["oy"]
    oz = args["oz"]
    ey = args["ey"]
    ez = args["ez"]
    times = args["times"]
    itime = args["itime"]
    material_ids = args["material_ids"]
    river_bed_dy = args["river_bed_dy"]
    river_bed_dz = args["river_bed_dz"]
    unique_face_index = args["unique_face_index"]
    pressure = args["pressure"]
    pressure_threshold = args["pressure_threshold"]

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


def release_particle_from_riverbed_elevation(args):
    x = args["x"]
    y = args["y"]
    z = args["z"]
    oy = args["oy"]
    ey = args["ey"]
    times = args["times"]
    itime = args["itime"]
    material_ids = args["material_ids"]
    river_bed_dy = args["river_bed_dy"]
    river_bed_elevation = args["river_bed_elevation"]
    unique_face_index = args["unique_face_index"]
    pressure = args["pressure"]
    pressure_threshold = args["pressure_threshold"]

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


def release_particle_from_riverbed_all(args):

    x = args["x"]
    y = args["y"]
    z = args["z"]
    times = args["times"]
    itime = args["itime"]
    material_ids = args["material_ids"]
    unique_face_index = args["unique_face_index"]
    pressure = args["pressure"]
    pressure_threshold = args["pressure_threshold"]

    # find saturated zone in hanford to release particles
    new_particles = []
    for iparticle in range(unique_face_index.shape[0]):
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


def clear(keep=("__builtins__", "clear")):
    keeps = {}
    for name, value in globals().iteritems():
        if name in keep:
            keeps[name] = value
            globals().clear()
    for name, value in keeps.iteritems():
        globals()[name] = value
