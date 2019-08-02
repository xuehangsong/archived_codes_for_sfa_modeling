# the v1 version is written by Xuehang Song on 03/23/2018
# ----------------------------------------------------------
# v2 plot the direct data of flux, instead of intepolated flux
# v2 plot volumetric flux, instead of darcy flux
# revised by Xuehang 03/25/2018
# ----------------------------------------------------------

import pickle
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec
from datetime import datetime, timedelta


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


results_dir = "/Users/song884/remote/reach/results/"
fig_dir = "/Users/song884/remote/reach/figures/poster/"

pt_fname = ("/Users/song884/remote/reach/results/" +
            "river_flux_2007_new_material.pk")

# pt_fname = '/Users/song884/remote/reach/results/face_flux.pk'

pickle_file = open(pt_fname, "rb")
out_flux = pickle.load(pickle_file)
times = np.sort(list(out_flux.keys()))
simu_time = np.sort([np.float(i[5:19]) for i in times])

date_origin = datetime.strptime("2007-03-28 00:00:00", "%Y-%m-%d %H:%M:%S")
real_time = batch_delta_to_time(
    date_origin, simu_time, "%Y-%m-%d %H:%M:%S", "hours")


stat_real = [
    "2011-01-01 00:00:00",
    "2012-01-01 00:00:00",
    "2013-01-01 00:00:00",
    "2014-01-01 00:00:00",
    "2015-01-01 00:00:00",
    "2016-01-01 00:00:00"]

# stat_real = [
#     "2008-01-01 00:00:00",
#     "2009-01-01 00:00:00",
#     "2010-01-01 00:00:00",
#     "2011-01-01 00:00:00",
#     "2012-01-01 00:00:00",
#     "2013-01-01 00:00:00",
#     "2014-01-01 00:00:00",
#     "2015-01-01 00:00:00",
#     "2016-01-01 00:00:00"]

stat_model = batch_time_to_delta(
    date_origin, stat_real, "%Y-%m-%d %H:%M:%S") / 3600

n_segment = len(stat_real) - 1
sum_flow = np.array([0.] * n_segment)
abs_flow = np.array([0.] * n_segment)
out_flow = np.array([0.] * n_segment)
in_flow = np.array([0.] * n_segment)
for i_segment in range(n_segment):
    select_index = np.asarray(np.where(
        (simu_time >= stat_model[i_segment]) *
        (simu_time < stat_model[i_segment + 1]))).flatten()
    for i_index in select_index:
        temp_flux = np.asarray(out_flux[times[i_index]])
        sum_flow[i_segment] = sum_flow[i_segment] + np.sum(temp_flux)
        abs_flow[i_segment] = abs_flow[i_segment] + np.sum(np.abs(temp_flux))
        out_flow[i_segment] = out_flow[i_segment] + \
            sum(temp_flux[temp_flux >= 0])
        in_flow[i_segment] = in_flow[i_segment] + \
            sum(temp_flux[temp_flux <= 0])
    sum_flow[i_segment] = sum_flow[i_segment] / len(select_index)
    abs_flow[i_segment] = abs_flow[i_segment] / len(select_index)
    out_flow[i_segment] = out_flow[i_segment] / len(select_index)
    in_flow[i_segment] = in_flow[i_segment] / len(select_index)

sum_flow = sum_flow * 365.25 * 24
abs_flow = abs_flow * 365.25 * 24
out_flow = out_flow * 365.25 * 24
in_flow = in_flow * 365.25 * 24

start_year = 2011
fig_name = fig_dir + "flux_bar.png"
gs = gridspec.GridSpec(1, 4)
fig = plt.figure()

ax1 = fig.add_subplot(gs[0, 0])
ax1.bar(start_year + np.arange(n_segment), out_flow, color="blue")
ax1.set_ylim([0, 2e9])
ax1.set_xlabel('Time (year)')
ax1.set_ylabel('Exchange flux ($m^3$/year)')
ax1.set_title("(a) River Gaining Volume", y=1.05)

ax2 = fig.add_subplot(gs[0, 1])
ax2.bar(start_year + np.arange(n_segment), -in_flow, color="red")
ax2.set_ylim([0, 2e9])
ax2.set_xlabel('Time (year)')
ax2.set_ylabel('Exchange flux ($m^3$/year)')
ax2.set_title("(b) River Losing Volume", y=1.05)

ax3 = fig.add_subplot(gs[0, 2])
ax3.bar(start_year + np.arange(n_segment), sum_flow, color="purple")
ax3.set_ylim([0, 2e9])
ax3.set_xlabel('Time (year)')
ax3.set_ylabel('Exchange flux ($m^3$/year)')
ax3.set_title("(c) River Net Gaining Volume", y=1.05)

ax4 = fig.add_subplot(gs[0, 3])
ax4.bar(start_year + np.arange(n_segment), abs_flow, color="brown")
ax4.set_ylim([0, 2e9])
ax4.set_xlabel('Time (year)')
ax4.set_ylabel('Exchange flux ($m^3$/year)')
ax4.set_title("(d) Abosulte Exchange", y=1.05)

fig.tight_layout()
fig.subplots_adjust(left=0.1,
                    right=0.95,
                    bottom=0.07,
                    top=0.85,
                    wspace=0.30,
                    hspace=0.38
                    )
fig.set_size_inches(14, 3)
fig.savefig(fig_name, dpi=600, transparent=True)
plt.close(fig)


# select_flux = []
# select_flux = np.asarray(select_flux) / 3600 / 250 / 250
