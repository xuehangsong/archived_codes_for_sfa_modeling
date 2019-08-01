import numpy as np
import math


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
    return particle_lost  # , pt_lazy_1


def particle_tracking_steady(args):
    x = args["x"]
    y = args["y"]
    z = args["z"]
    ox = args["ox"]
    oy = args["oy"]
    oz = args["oz"]
    ex = args["ex"]
    ey = args["ey"]
    ez = args["ez"]
    dx = args["dx"]
    dy = args["dy"]
    dz = args["dz"]
    x_darcy = args["x_darcy"]
    y_darcy = args["y_darcy"]
    z_darcy = args["z_darcy"]
    times = args["times"]
    itime = args["itime"]
    pressure = args["pressure"]
    pressure_threshold = args["pressure_threshold"]
    particles = args["particles"]
    iparticle = args["iparticle"]
    porosity = args["porosity"]
    material_ids = args["material_ids"]
    material_type = args["material_type"]
    min_dtstep = args["min_dtstep"]
    lazy_interval = args["lazy_interval"]
    lazy_start = args["lazy_start"]
    lazy_threshold = args["lazy_threshold"]
    face_lowest = args["face_lowest"]
    face_eastest = args["face_eastest"]

    current_t = particles[iparticle][len(particles[iparticle]) - 1][0]
    coord_x = particles[iparticle][len(particles[iparticle]) - 1][1]
    coord_y = particles[iparticle][len(particles[iparticle]) - 1][2]
    coord_z = particles[iparticle][len(particles[iparticle]) - 1][3]
    total_dis = particles[iparticle][len(particles[iparticle]) - 1][4]
    rest_dt = times[itime + 1] - current_t

    args = {"x": x,
            "y": y,
            "z": z,
            "coord": [coord_x, coord_y, coord_z]
            }
    cell_x, cell_y, cell_z = locate_cell(args)

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
        args = {"x": x,
                "y": y,
                "z": z,
                "coord": [coord_x, coord_y, coord_z]
                }
        cell_x, cell_y, cell_z = locate_cell(args)

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
            total_dis_old = particles[iparticle][len(
                particles[iparticle]) - 1 - lazy_interval][4]
            if total_dis - total_dis_old < lazy_threshold:
                particle_lost = 5

        if particle_lost > 0:
            return {
                "pt_index": iparticle,
                "pt_status": particle_lost,
                "pt_update": pt_update,
            }

    return {
        "pt_index": iparticle,
        "pt_status": 0,
        "pt_update": pt_update,
    }


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
