###400*400
model_origin = c(594186,115943)
angle = 15/180*pi

west = 0
east = 400
south = 0
north = 400
bottom = 90
top = 110

range_x = c(west,east)
range_y = c(south,north)
range_z = c(bottom,top)

dx = rep(2,(east-west)/2)
dy = rep(2,(north-south)/2)
dz = rep(0.5,(top-bottom)/0.5)

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = cumsum(dx)-0.5*dx[1]+west
y = cumsum(dy)-0.5*dy[1]+south
z = cumsum(dz)-0.5*dz[1]+bottom
