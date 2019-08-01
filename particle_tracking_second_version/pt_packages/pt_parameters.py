import numpy as np

# --------------------- when to release particles-------
# ======================================================
# nbatch = 50
# initial_time = (366 + 365 + 365 + 365 + 366) * 24
# batch_length = 24 * 20
# batch_frequency = 24

nbatch = 50
initial_time = 0
batch_length = 24 * 20
batch_frequency = 24

# --------------------- where the h5 output store-------
# ======================================================

# simulations_h5 = "../flow_2008_3/pflotran_bigplume.h5"
# material_h5 = ("../flow_2008_3/BC_2008_2015/" +
#                "bigplume_4mx4mxhalfRes_material_" +
#                "mapped_newRingold_subRiver_17tracer.h5")

simulations_h5 = "../data/pflotran_bigplume.h5"
material_h5 = ("../data/" +
               "bigplume_4mx4mxhalfRes_material_" +
               "mapped_newRingold_subRiver_17tracer.h5")

# --------------------- where to save the pt output ----
# ======================================================
results_dir = "../edison/"


# -----------------------material information-----------
# ======================================================
material_type = {"Hanford": 1,
                 "Ringold Gravel": 4,
                 "Ringold Fine": 9,
                 "River": 0}
porosity = {"1": 0.2, "4": 0.25, "9": 0.43}

# -----------other setup -------------------------------
# ======================================================
ncore = 48                    # how many cores used for simulations
min_dtstep = 0.001            # minimum time step
pressure_threshold = 101325   # threshold for saturation
pickle_interval = 10          # periodically store the pt results
lazy_start = 24               # the "lazy" criteria is meant to
lazy_interval = 24            # remove the particles which may trapped
lazy_threshold = 0.05         # below the river face boundary


# not used
plot_start = (366 + 365 + 365 + 365 + 366) * 24
plot_end = (366 + 365 + 365 + 365 + 366 + 365) * 24
plot_start = 45960


# pt_end = pt_end + [
#     float(pt_name.split("_")[-1])]*len(pickle_data["particles"])
# pt_start = []
# for iparticle in range(len(particles)):
#     pt_start.extend([particles[iparticle][0,0]])
# pt_window = list(map(operator.sub,pt_end,pt_start))
