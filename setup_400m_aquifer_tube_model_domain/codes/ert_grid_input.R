rm(list=ls())
source("codes/ert_parameters.R")

grid.in = c()
grid.in = rbind(grid.in,"GRID")
grid.in = rbind(grid.in,"  TYPE structured")
grid.in = rbind(grid.in,paste("  NXYZ",nx,ny,nz))
grid.in = rbind(grid.in,paste("  ORIGIN",range_x[1],range_y[1],range_z[1]))
grid.in = rbind(grid.in,"  DXYZ")

lx = nx %/% 5 +1
for (ilx in 1:(lx-2)) {
    grid.in = rbind(grid.in,paste("    ",paste(dx[((ilx-1)*5+1):(ilx*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dx[(ilx*5+1):nx],collapse=" ")))


ly = ny %/% 5 +1
for (ily in 1:(ly-2)) {
    grid.in = rbind(grid.in,paste("    ",paste(dy[((ily-1)*5+1):(ily*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dy[(ily*5+1):ny],collapse=" ")))



lz = nz %/% 5 +1
for (ilz in 1:(lz-2)) {
    grid.in = rbind(grid.in,paste("    ",paste(dz[((ilz-1)*5+1):(ilz*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dz[(ilz*5+1):nz],collapse=" ")))



grid.in = rbind(grid.in,"  /")
grid.in = rbind(grid.in,"END")

writeLines(grid.in,"results/grid.in")
