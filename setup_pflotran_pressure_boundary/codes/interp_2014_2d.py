import numpy as np
import os as os
from scipy.interpolate import griddata
from scipy.interpolate import RegularGridInterpolator
import matplotlib.pyplot as plt

os.chdir("/Users/song884/couple_cfd/")

fid = open("real_river/x.txt", "r")
x = [float(i) for i in fid.read().splitlines()[1:]]
x = np.array(x)
fid.close()

fid = open("real_river/y.txt", "r")
y = [float(i) for i in fid.read().splitlines()[1:]]
y = np.array(y)
fid.close()

fid = open("real_river/z.txt", "r")
z = [float(i) for i in fid.read().splitlines()[1:]]
z = np.array(z)
fid.close()

fid = open("real_river/dx.txt", "r")
dx = [float(i) for i in fid.read().splitlines()[1:]]
dx = np.array(dx)
fid.close()

fid = open("real_river/dy.txt", "r")
dy = [float(i) for i in fid.read().splitlines()[1:]]
dy = np.array(dy)
fid.close()

fid = open("real_river/dz.txt", "r")
dz = [float(i) for i in fid.read().splitlines()[1:]]
dz = np.array(dz)
fid.close()

fid = open("real_river/face_coords_proj.txt", "r")
face_coords = [i.split() for i in fid.read().splitlines()[1:]]
face_coords = np.array(face_coords).astype(np.float)
fid.close()


fid = open("real_river/pressure1.txt", "r")
pressure = [i.split() for i in fid.read().splitlines()[1:]]
pressure = np.array(pressure).astype(np.float)
fid.close()

grid_x, grid_y, grid_z = np.meshgrid(
    np.linspace(min(pressure[:, 2]), max(pressure[:, 2]), num=100),
    np.linspace(min(pressure[:, 3]), max(pressure[:, 3]), num=100),
    np.linspace(min(pressure[:, 4]), max(pressure[:, 4]), num=100))

grid_pressure_linear = griddata(
    pressure[:, 2:5], pressure[:, 0], (grid_x, grid_y, grid_z), method="linear")

grid_pressure_nearest = griddata(
    pressure[:, 2:5], pressure[:, 0], (grid_x, grid_y, grid_z), method="nearest")

grid_pressure = grid_pressure_linear
grid_pressure[np.isnan(grid_pressure_linear)
              ] = grid_pressure_nearest[np.isnan(grid_pressure_linear)]

PressureInterpolator = RegularGridInterpolator(
    (np.linspace(min(pressure[:, 2]), max(pressure[:, 2]), num=100),
     np.linspace(min(pressure[:, 3]), max(pressure[:, 3]), num=100),
     np.linspace(min(pressure[:, 4]), max(pressure[:, 4]), num=100)),
    grid_pressure, method="linear")

# a = PressureInterpolator(face_coords)
# plt.plot(face_coords[:, 2], a)
# plt.show()


# plt.plot(pressure[:, 0], pressure[:, 4], ".")
# plt.show()


# plt.plot(grid_z.flat, grid_pressure.flat, ".")
# plt.show()


plt.plot(grid_z.flat, grid_pressure_linear.flat, ".")
plt.show()


plt.plot(grid_z.flat, grid_pressure_nearest.flat, ".")
plt.show()
