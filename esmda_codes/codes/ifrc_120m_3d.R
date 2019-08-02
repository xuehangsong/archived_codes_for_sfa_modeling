##120 origin
model_origin = c(594239.42,115982.57)
angle = 35/180*pi

west = 0
east = 120
south = 0
north = 120
bottom = 95
top = 110

nx = 120
ny = 120
nz = 30

range_x = c(west,east)
range_y = c(south,north)
range_z = c(bottom,top)

dx = rep((east-west)/nx,nx)
dy = rep((north-south)/ny,ny)
dz = rep((top-bottom)/nz,nz)

x = cumsum(dx)-0.5*dx[1]+west
y = cumsum(dy)-0.5*dy[1]+south
z = cumsum(dz)-0.5*dz[1]+bottom
