# the v1 version is written by Xuehang Song on 03/25/2018
# ----------------------------------------------------------
# this file is to readin pflotran mass balance outpout
# ----------------------------------------------------------
import numpy as np
import matplotlib.pyplot as plt
import h5py as h5
import glob
import matplotlib.gridspec as gridspec
from datetime import datetime, timedelta
from scipy import interpolate


def batch_time_to_delta(origin, x, time_format):
    nx = len(x)
    y = []
    for ix in range(nx):
        temp_y = abs(datetime.strptime(
            x[ix], time_format) - origin).total_seconds()
        y.append(temp_y)
    y = np.asarray(y)
    return(y)


def batch_delta_to_time(origin, x, time_format, delta_format):
    nx = len(x)
    y = []
    for ix in range(nx):
        if delta_format == "hours":
            temp_y = origin + timedelta(hours=x[ix])
        elif delta_format == "days":
            temp_y = origin + timedelta(days=x[ix])
        elif delta_format == "minutes":
            temp_y = origin + timedelta(minutes=x[ix])
        elif delta_format == "weeks":
            temp_y = origin + timedelta(weeks=x[ix])
        elif delta_format == "seconds":
            temp_y = origin + timedelta(seconds=x[ix])
        elif delta_format == "microseconds":
            temp_y = origin + timedelta(microseconds=x[ix])
        elif delta_format == "milliseconds":
            temp_y = origin + timedelta(milliseconds=x[ix])
        else:
            print("Sorry, this naive program only solve single time unit")
        y.append(temp_y.strftime(time_format))
    y = np.asarray(y)
    return(y)


model_origin = [538000, 97000]

nx = 304
ny = 268
nz = 40
dx = 250.
dy = 250.
dz = 5.
west_area = dy * dz
east_area = dy * dz
south_area = dx * dz
north_area = dx * dz
top_area = dx * dy
bottom_area = dx * dy

output_dir = "/Users/song884/remote/reach/Outputs/2007_solute/"
results_dir = "/Users/song884/remote/reach/results/"
data_dir = "/Users/song884/remote/reach/data/"
date_origin = datetime.strptime("2007-03-28 00:00:00", "%Y-%m-%d %H:%M:%S")
fig_dir = "/Users/song884/remote/reach/figures/mass_balance/"


# # xy_river_index = np.concatenate(
# #     ([np.where(i == x)[0] for i in river_coord[:, 0]],
# #      [np.where(i == y)[0] for i in river_coord[:, 1]]),
# #     axis=1)

# read river section information
material_file = glob.glob(output_dir + "HFR_material*h5")[0]
h5_file = h5.File(material_file, "r")
mass1_sections = [s for s, s in enumerate(
    list(h5_file["Regions"].keys())) if "Mass1" in s]
group_order = np.argsort(np.asarray(
    [x[6:] for x in mass1_sections]).astype(float))
mass1_sections = [mass1_sections[i] for i in group_order]
nsection = len(mass1_sections)
section_area = []
for isection in mass1_sections:
    faces = list(h5_file["Regions"][isection]['Face Ids'])
    iarea = faces.count(1) * west_area + faces.count(2) * east_area + \
        faces.count(3) * south_area + faces.count(4) * north_area + \
        faces.count(5) * bottom_area + faces.count(6) * bottom_area
    section_area.append(iarea)
section_area = np.asarray(section_area)

# read mass1 coordinates
section_coord = np.genfromtxt(
    data_dir + "MASS1/coordinates.csv", delimiter=",", skip_header=1)
section_coord[:, 1] = section_coord[:, 1] - model_origin[0]
section_coord[:, 2] = section_coord[:, 2] - model_origin[1]
mass1_length = section_coord[:, 4] - section_coord[-1, 4]

# read mass balance data
mass_file = open(glob.glob(output_dir + "*mas.dat")[0], "r")
mass_data = mass_file.readlines()
mass_header = mass_data[0].replace('"', '').split(",")
mass_header = list(filter(None, mass_header))
mass_data = [x.split(" ") for x in mass_data[1:]]
mass_data = [list(filter(None, x)) for x in mass_data]
mass_data = np.asarray(mass_data).astype(float)

# find columns of desired mass1 colmns
mass_index = [i for i, s in enumerate(mass_header) if (
    "River" in s and "Water" in s and "kg]" in s)]
flux_index = [i for i, s in enumerate(mass_header) if (
    "River" in s and "Water" in s and "kg/h" in s)]

# get total river mass/flux across the river bed
total_mass = np.sum(mass_data[:, mass_index], axis=1).flatten()
total_flux = np.sum(mass_data[:, flux_index], axis=1).flatten()


# plot fingerprint plots
simu_time = mass_data[:, 0]
real_time = batch_delta_to_time(
    date_origin, simu_time, "%Y-%m-%d %H:%M:%S", "hours")
real_time = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in real_time]
plot_time = [
    "2011-01-01 00:00:00",
    "2016-01-01 00:00:00"]
plot_time = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in plot_time]
time_ticks = [
    "2011-01-01 00:00:00",
    "2012-01-01 00:00:00",
    "2013-01-01 00:00:00",
    "2014-01-01 00:00:00",
    "2015-01-01 00:00:00",
    "2016-01-01 00:00:00"]
time_ticks = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in time_ticks]
select_index = []
for i_index in range(len(real_time)):
    if (real_time[i_index] >= plot_time[0] and
            real_time[i_index] < plot_time[1]):
        select_index.append(i_index)

# select_time = [real_time[i] for i in select_index]
flux_array = mass_data[:, flux_index]
# flux_array = [flux_array[i, :] for i in select_index]
flux_array = np.asarray(flux_array) / 1000 * 24
for itime in range(len(real_time)):
    flux_array[itime, :] = flux_array[itime, :] / section_area

fig_name = fig_dir + "finger_flux.png"
gs = gridspec.GridSpec(1, 1)
fig = plt.figure()
ax1 = fig.add_subplot(gs[0, 0])
cf1 = ax1.contourf(real_time,
                   0.5 * (mass1_length[1:] + mass1_length[:-1]),
                   -np.transpose(flux_array),
                   cmap=plt.cm.jet,
                   levels=np.arange(-0.2, 0.21, 0.01),
                   extend="both",
                   )
ax1.set_ylabel("")
ax1.set_ylabel("Distance to Downstream Location (km)")
ax1.set_xticks(time_ticks)
ax1.set_ylim([0, 7.3e1])
ax1.set_xlim([time_ticks[0], time_ticks[-1]])
cb1 = plt.colorbar(cf1, extend="both")
cb1.ax.set_ylabel("Exchange flux (m/d)", rotation=270, labelpad=20)
fig.tight_layout()
fig.set_size_inches(10, 3.5)
fig.savefig(fig_name, dpi=600, transparent=True)
plt.close(fig)

n_segment = len(time_ticks) - 1
sum_mass = np.array([0.] * n_segment)
for i_segment in range(n_segment):
    select_index = []
    for i_index in range(len(real_time)):
        if (real_time[i_index] >= time_ticks[i_segment] and
                real_time[i_index] < time_ticks[i_segment + 1]):
            select_index.append(i_index)
    sum_mass[i_segment] = total_mass[select_index[-1]] - \
        total_mass[select_index[0] - 1]
    time_inverval = real_time[select_index[-1]
                              ] - real_time[select_index[0] - 1]
    time_scale = 365.25 * 24 * 3600 / time_inverval.total_seconds()
    sum_mass[i_segment] = sum_mass[i_segment] * time_scale / 1000

start_year = 2011
fig_name = fig_dir + "massbalance_flux_bar.png"
gs = gridspec.GridSpec(1, 1)
fig = plt.figure()
ax0 = fig.add_subplot(gs[0, 0])
ax0.bar(start_year + np.arange(n_segment), -sum_mass, color="blue")
ax0.set_ylim([0, 2e8])
ax0.set_xlabel('Time (year)')
ax0.set_ylabel('Exchange flux ($m^3$/year)')
# ax0.set_ylabel('River Discharge ($m^3$/year)')
ax0.set_title("River Net Gaining Volume", y=1.05)
fig.tight_layout()
fig.subplots_adjust(left=0.2,
                    right=0.95,
                    bottom=0.08,
                    top=0.85,
                    wspace=0.30,
                    hspace=0.38
                    )
fig.set_size_inches(4, 3)
fig.savefig(fig_name, dpi=600, transparent=True)
plt.close(fig)


nx = 304
ny = 268
nz = 40
dx = [250] * nx
dy = [250] * ny
dz = [5] * nz
x = 0 + np.cumsum(dx) - 0.5 * dx[0]
y = 0 + np.cumsum(dy) - 0.5 * dy[0]
z = 0 + np.cumsum(dz) - 0.5 * dz[0]
grids = np.asarray([(x, y, z) for z in range(nz)
                    for y in range(ny) for x in range(nx)])


selected_times = [238,
                  255,
                  308,
                  328,
                  386,
                  407,
                  450,
                  476,
                  527,
                  550,
                  580,
                  622]

selected_times = [328,
                  407,
                  476,
                  550,
                  622]

selected_times = np.asarray(selected_times) - 1
# real_time[i_index] < time_ticks[i_segment + 1]):

# for itime in range(len(real_time)):
for itime in selected_times:
    print(itime)
    yx_flux = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
    for isection in range(len(mass1_sections)):
        # need minus 1 as python index started with 0
        cell_ids = list(h5_file["Regions"]
                        [mass1_sections[isection]]['Cell Ids'])
        cell_ids = np.asarray(cell_ids) - 1
        xy_cell_index = [grids[i, 0:2] for i in cell_ids]
        xy_cell_index = np.unique(xy_cell_index, axis=0)
        for iindex in range(len(xy_cell_index)):
            yx_flux[xy_cell_index[iindex][1],
                    xy_cell_index[iindex][0]] = flux_array[itime, isection]
#    fig_name = fig_dir + str(int(simu_time[itime])) + ".png"
    fig_name = fig_dir + str(itime) + ".png"
    gs = gridspec.GridSpec(1, 1)
    fig = plt.figure()
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.plot([20, 20], [43, 53], "black")
    ax1.plot([41, 51], [48, 48], "black")
    ax1.plot([52, 62], [16, 16], "black")
    cf1 = ax1.imshow(-yx_flux,
                     cmap=plt.cm.jet,
                     origin="lower",
                     vmin=-0.2,
                     vmax=0.2,
                     extent=[(x[0] - 0.5 * dx[0]) / 1000,
                             (x[-1] + 0.5 * dx[0]) / 1000,
                             (y[0] - 0.5 * dy[0]) / 1000,
                             (y[-1] + 0.5 * dy[0]) / 1000]
                     )
#    ax1.set_title(itime)
    ax1.set_xlabel("")
    ax1.set_ylabel("")
    ax1.set_xticks([])
    ax1.set_yticks([])
    ax1.set_aspect("equal", "datalim")
    ax1.set_xlim([1e1, 6e1])
    ax1.set_ylim([0, 6e1])
    cb1 = plt.colorbar(cf1, extend="both",
                       orientation="horizontal", shrink=0.8, aspect=25)
    cb1.ax.set_xlabel("Exchange flux (m/d)", rotation=0, labelpad=-40)
    plt.box(on=None)
#    fig.tight_layout()
    fig.set_size_inches(6.5, 5.5)
    fig.savefig(fig_name, dpi=600, transparent=True)
    plt.close(fig)


 for itime in range(len(real_time)):
    print(itime)
    yx_flux = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
    for isection in range(len(mass1_sections)):
        # need minus 1 as python index started with 0
        cell_ids = list(h5_file["Regions"]
                        [mass1_sections[isection]]['Cell Ids'])
        cell_ids = np.asarray(cell_ids) - 1
        xy_cell_index = [grids[i, 0:2] for i in cell_ids]
        xy_cell_index = np.unique(xy_cell_index, axis=0)
        for iindex in range(len(xy_cell_index)):
            yx_flux[xy_cell_index[iindex][1],
                    xy_cell_index[iindex][0]] = flux_array[itime, isection]
    fig_name = fig_dir + str(int(simu_time[itime])) + ".png"
    gs = gridspec.GridSpec(1, 1)
    fig = plt.figure()
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.plot([20, 20], [43, 53], "black")
    ax1.plot([41, 51], [48, 48], "black")
    ax1.plot([52, 62], [16, 16], "black")
    cf1 = ax1.imshow(-yx_flux,
                     cmap=plt.cm.jet,
                     origin="lower",
                     vmin=-0.2,
                     vmax=0.2,
                     extent=[(x[0] - 0.5 * dx[0]) / 1000,
                             (x[-1] + 0.5 * dx[0]) / 1000,
                             (y[0] - 0.5 * dy[0]) / 1000,
                             (y[-1] + 0.5 * dy[0]) / 1000]
                     )
#    ax1.set_title(itime)
    ax1.set_xlabel("Easting (km)")
    ax1.set_ylabel("Northing (km)")
    ax1.set_aspect("equal", "datalim")
    ax1.set_xlim([1e1, 6e1])
    ax1.set_ylim([0, 6e1])
    cb1 = plt.colorbar(cf1, extend="both")
    cb1.ax.set_ylabel("Exchange flux (m/d)", rotation=270, labelpad=20)
    fig.tight_layout()
    fig.set_size_inches(6.5, 5.5)
    fig.savefig(fig_name, dpi=600)
    plt.close(fig)

# plane_x, plane_y = np.meshgrid(x, y)
# unique_xy, unique_index = np.unique(river_coord, return_inverse=True, axis=0)
# n_unique = len(unique_xy)
# xy_river_index = np.concatenate(
#     ([np.where(i == x)[0] for i in unique_xy[:, 0]],
#      [np.where(i == y)[0] for i in unique_xy[:, 1]]),
#     axis=1)

# mass1_x = 0.5 * (section_coord[1:, 1] + section_coord[:-1, 1])
# mass1_y = 0.5 * (section_coord[1:, 2] + section_coord[:-1, 2])


# # read river face information
# river_loc = np.genfromtxt(
#     results_dir + "river_cell_coord.csv", delimiter=",", skip_header=1)
# river_loc = np.asarray(river_loc)
# # need minus 1 as python index started with 0
# river_loc[:, 0] = river_loc[:, 0] - 1
# river_cells = np.unique(river_loc[:, 0]).astype(int)
# n_river = len(river_cells)
# river_index = [grids[i, :] for i in river_cells]
# plane_x, plane_y = np.meshgrid(x, y)

# river_face = np.array([], dtype=np.float).reshape(0, 6)
# river_coord = np.array([], dtype=np.float).reshape(0, 2)
# for i_river in range(n_river):
#     temp_faces = river_loc[(river_loc[:, 0] == river_cells[i_river]), 1]
#     temp_coord = river_loc[np.where(
#         river_loc[:, 0] == river_cells[i_river])[0][0], 2:4]
#     temp_coord = np.reshape(temp_coord, (1, 2))
#     river_coord = np.concatenate((river_coord, temp_coord), axis=0)
#     temp_face_vector = np.array([0, 0, 0, 0, 0, 0]).reshape(1, 6)
#     for iface in list(map(int, temp_faces)):
#         temp_face_vector[0, iface - 1] = 1
#     river_face = np.concatenate(
#         (river_face, temp_face_vector), axis=0)

# for i_index in range(len(select_time)):
#     interp_f = interpolate.interp2d(
#         x=mass1_x, y=mass1_y, z=flux_array[i_index, :])
#     print(itime)

#     for i_index in select_index:
#     temp_flux = np.asarray(flux_array[i_index, :])
#     sum_mass[i_segment] = sum_mass[i_segment] + np.sum(temp_flux)
# sum_flow[i_segment] = sum_flow[i_segment] / len(select_index)
# ax1.set_yticks([])
# ax1.set_aspect("equal", "datalim")
# ax1.set_xlim([1e1, 6e1])
# plt.box(on=None)

# n_segment = len(stat_real) - 1
# sum_flow = np.array([0.] * n_segment)
# for i_segment in range(n_segment):
#     select_index = np.asarray(np.where(
#         (simu_time >= stat_model[i_segment]) *
#         (simu_time < stat_model[i_segment + 1]))).flatten()
#     print(real_time[select_index[-1]])
#     print(real_time[select_index[0] - 1])
#     sum_flow[i_segment] = total_mass[select_index[-1]] -
#         total_mass[select_index[0] - 1]

# plt.bar(range(n_segment), -sum_flow / 1000)
# plt.show()

# n_segment = len(stat_real) - 1
# mean_flow = np.array([0.] * n_segment)
# for i_segment in range(n_segment):
#     select_index = np.asarray(np.where(
#         (simu_time >= stat_model[i_segment]) *
#         (simu_time < stat_model[i_segment + 1]))).flatten()
#     print(real_time[select_index[-1]])
#     print(real_time[select_index[0] - 1])
#     mean_flow[i_segment] = np.mean(
#         total_flux[select_index])

# global_mass = mass_data[:, 3]

# plt.plot(simu_time, global_mass)
# plt.plot(simu_time, global_mass - total_mass)

# plt.plot(simu_time[1:], global_mass[1:] - global_mass[:-1])
# plt.plot(simu_time[1:], total_mass[1:] - total_mass[:-1])

# plt.bar(range(n_segment), -mean_flow / 1000 * 24 * 365)
# plt.show()


# aaa = [s for s, s in enumerate(mass_header) if (
#     "River" in s and "Water" in s and "kg]" in s)]

# bbb = [s for s, s in enumerate(mass_header) if (
#     "River" in s and "Water" in s and "kg/h" in s)]
