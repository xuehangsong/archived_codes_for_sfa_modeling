import numpy as np

# nbatch = 50
# initial_time = (366 + 365 + 365 + 365 + 366) * 24
# batch_length = 24 * 20
# batch_frequency = 24
nbatch = 50
initial_time = 0
batch_length = 24 * 20
batch_frequency = 24


release_times = np.arange(
    initial_time,
    initial_time + nbatch * batch_length,
    batch_frequency)

# simulations_h5 = "../flow_2008_3/pflotran_bigplume.h5"
# material_h5 = ("../flow_2008_3/BC_2008_2015/" +
#                "bigplume_4mx4mxhalfRes_material_" +
#                "mapped_newRingold_subRiver_17tracer.h5")

simulations_h5 = "../data/pflotran_bigplume.h5"
material_h5 = ("../data/" +
               "bigplume_4mx4mxhalfRes_material_" +
               "mapped_newRingold_subRiver_17tracer.h5")

porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

results_dir = "../edison/"


plot_start = (366 + 365 + 365 + 365 + 366) * 24
plot_end = (366 + 365 + 365 + 365 + 366 + 365) * 24
plot_start = 45960


# plot_start = 64512


# pt_end = pt_end + [
#     float(pt_name.split("_")[-1])]*len(pickle_data["particles"])
# for iparticle in range(len(particles)):
#     pt_start.extend([particles[iparticle][0,0]])
# pt_window = list(map(operator.sub,pt_end,pt_start))
