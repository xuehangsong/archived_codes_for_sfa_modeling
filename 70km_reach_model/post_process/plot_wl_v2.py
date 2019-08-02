import numpy as np
import h5py as h5
import glob
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from datetime import datetime, timedelta


def batch_delta_to_time(origin, x, time_format, delta_format):
    y = []
    for ix in x:
        if delta_format == "hours":
            temp_y = origin + timedelta(hours=ix)
        elif delta_format == "days":
            temp_y = origin + timedelta(days=ix)
        elif delta_format == "minutes":
            temp_y = origin + timedelta(minutes=ix)
        elif delta_format == "weeks":
            temp_y = origin + timedelta(weeks=ix)
        elif delta_format == "seconds":
            temp_y = origin + timedelta(seconds=ix)
        elif delta_format == "microseconds":
            temp_y = origin + timedelta(microseconds=ix)
        elif delta_format == "milliseconds":
            temp_y = origin + timedelta(milliseconds=ix)
        else:
            print("Sorry, this naive program only solve single time unit")
        y.append(temp_y.strftime(time_format))
    y = np.asarray(y)
    return(y)


date_origin = datetime.strptime("2007-03-28 00:00:00", "%Y-%m-%d %H:%M:%S")
output_dir = "/Users/song884/remote/reach/Outputs/HFR_100x100x5_6h_bc/"
fig_dir = "/Users/song884/remote/reach/figures/HFR_100x100x5_6h_bc/wl/"
data_dir = "/Users/song884/remote/reach/data/"

model_origin = np.genfromtxt(
    output_dir + "model_origin.txt", delimiter=" ", skip_header=1)

# read mass1 coordinates
section_coord = np.genfromtxt(
    data_dir + "MASS1/coordinates.csv", delimiter=",", skip_header=1)
section_coord[:, 1] = section_coord[:, 1] - model_origin[0]
section_coord[:, 2] = section_coord[:, 2] - model_origin[1]
line1 = section_coord[0, 1:3] / 1000
line2 = section_coord[int(len(section_coord[:, 1]) / 2), 1:3] / 1000
line3 = section_coord[-1, 1:3] / 1000

line1_x = [line1[0]] * 2
line1_y = [line1[1] - 5, line1[1] + 5]
line2_x = [line2[0] - 5, line2[0] + 5]
line2_y = [line2[1]] * 2
line3_x = [line3[0] - 5, line3[0] + 5]
line3_y = [line3[1]] * 2


material_h5 = h5.File(output_dir + "HFR_material_river.h5", "r")

all_h5 = glob.glob(output_dir + "pflotran*h5")
all_h5 = np.sort(all_h5)

input_h5 = h5.File(all_h5[0], "r")
x_grids = list(input_h5["Coordinates"]['X [m]'])
y_grids = list(input_h5["Coordinates"]['Y [m]'])
z_grids = list(input_h5["Coordinates"]['Z [m]'])
input_h5.close()

dx = np.diff(x_grids)
dy = np.diff(y_grids)
dz = np.diff(z_grids)

nx = len(dx)
ny = len(dy)
nz = len(dz)
x = x_grids[0] + np.cumsum(dx) - 0.5 * dx[0]
y = y_grids[0] + np.cumsum(dy) - 0.5 * dy[0]
z = z_grids[0] + np.cumsum(dz) - 0.5 * dz[0]


grids = np.asarray([(x, y, z) for z in range(nz)
                    for y in range(ny) for x in range(nx)])


river_cells = []
for i_region in list(material_h5['Regions'].keys()):
    river_cells = np.append(river_cells, np.asarray(
        list(material_h5["Regions"][i_region]["Cell Ids"])))
river_cells = np.unique(river_cells).astype(int)
river_cells = river_cells - 1  # need minus 1 as python index started with 0

yx_river = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)
for icell in river_cells:
    yx_river[grids[icell, 1], grids[icell, 0]] = 1


for i_h5 in all_h5:
    print(i_h5)
    input_h5 = h5.File(i_h5, "r")

    groups = list(input_h5.keys())
    time_index = [s for s, s in enumerate(groups) if "Time:" in s]

    for itime in time_index:
        print(itime)
        temp_wl = np.asarray([np.nan] * (ny * nx)).reshape(ny, nx)

        temp_pressure = np.asarray(
            list(input_h5[itime]["Liquid_Pressure [Pa]"]))
        temp_head = (temp_pressure - 101325) / 997.16 / 9.8068
        for ix in range(nx):
            for iy in range(ny):
                positive_head_index = np.where(temp_head[ix, iy, :] > 0)[0]
                if (len(positive_head_index) > 0):
                    iz = positive_head_index[0]
                    temp_wl[iy, ix] = temp_head[ix, iy, iz] + z[iz]
        real_itime = batch_delta_to_time(date_origin, [float(
            itime[7:18])], "%Y-%m-%d %H:%M:%S", "hours")
        real_itime = str(real_itime[0])
        fig_name = fig_dir + real_itime + ".png"
        gs = gridspec.GridSpec(1, 1)
        fig = plt.figure()
        ax1 = fig.add_subplot(gs[0, 0])
        ax1.plot(line1_x, line1_y, "black")
        ax1.plot(line2_x, line2_y, "black")
        ax1.plot(line3_x, line3_y, "black")
        cf1 = ax1.contourf(x / 1000, y / 1000, temp_wl,
                           cmap=plt.cm.jet,
                           levels=np.arange(100, 130.1, 0.1),
                           vmin=100,
                           vmax=130,
                           extend="both",
                           V=np.arange(100, 130.1, 5)
                           )
        cf2 = ax1.contour(x / 1000, y / 1000, temp_wl,
                          colors="grey",
                          levels=np.arange(100, 130.1, 1.5),
                          linewidths=1,
                          vmin=100,
                          vmax=130)

        ax1.set_xlabel("Easting (km)")
        ax1.set_ylabel("Northing (km)")
        ax1.set_aspect("equal", "datalim")
        ax1.set_xlim([np.min(x_grids) / 1000, np.max(x_grids) / 1000])
        ax1.set_ylim([np.min(x_grids) / 1000, np.max(x_grids) / 1000])
        ax1.set_aspect("equal", "datalim")
        cb1 = plt.colorbar(cf1, extend="both")  # ,
#                           orientation="horizontal", shrink=0.8, aspect=25)
        cb1.ax.set_ylabel("Groundwater Level (m)", rotation=270, labelpad=20)
        fig.tight_layout()
        cf3 = ax1.contourf(x / 1000, y / 1000, yx_river, colors="black")
        fig.set_size_inches(6.5, 5.5)
        fig.savefig(fig_name, dpi=600, transparent=True)
        plt.close(fig)
    input_h5.close()
material_h5.close()
