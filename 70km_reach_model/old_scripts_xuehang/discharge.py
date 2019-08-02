import numpy as np
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

data_dir = "/Users/song884/remote/reach/data/"
fig_dir = "/Users/song884/remote/reach/figures/poster/"

discharge_file = open(data_dir + "USGS_flow_gh_12472800.csv", "r")
discharge_data = discharge_file.readlines()
discharge_data = [x.replace('"', "") for x in discharge_data]
# discharge_data = discharge_file.replace('"', "")

discharge_data = [x.split(",") for x in discharge_data[1:]]
discharge_data = [list(filter(None, x)) for x in discharge_data]
discharge_data = np.asarray(discharge_data)

times = discharge_data[:, 3]
times = [datetime.strptime(x, "%Y-%m-%d") for x in times]
discharge = discharge_data[:, 4]  # .astype(float)

stat_real = [
    "2011-01-01 00:00:00",
    "2012-01-01 00:00:00",
    "2013-01-01 00:00:00",
    "2014-01-01 00:00:00",
    "2015-01-01 00:00:00",
    "2016-01-01 00:00:00"]
stat_real = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in stat_real]
n_segment = len(stat_real) - 1
for i_segment in range(n_segment):
    select_index = []
    for i_index in range(len(times)):
        if (times[i_index] >= stat_real[i_segment] and
                times[i_index] < stat_real[i_segment + 1]):
            select_index.append(i_index)
    sum_discharge = sum(np.asarray([discharge[i]
                                    for i in select_index]).astype(float))
    sum_discharge = sum_discharge * 3600 * 24 * (0.3048**3)
    print("{:.5E}".format(sum_discharge))

plot_time = [
    "2008-01-01 00:00:00",
    "2016-01-01 00:00:00"]
plot_time = [datetime.strptime(x, "%Y-%m-%d %H:%M:%S") for x in plot_time]


fig_name = fig_dir + "discharge.png"
gs = gridspec.GridSpec(1, 1)
fig = plt.figure()
ax1 = fig.add_subplot(gs[0, 0])
ax1.plot(times, discharge, "b")
ax1.set_xlim([plot_time[0], plot_time[1]])
ax1.set_ylim([0, 400000])
ax1.set_ylabel('River discharge ($ft^3$/sec)')
ax1.ticklabel_format(style="sci", axis="y", scilimits=(0, 0))
# fig.tight_layout()
fig.set_size_inches(6, 2.5)
fig.savefig(fig_name, dpi=600, transparent=True)
plt.close(fig)
