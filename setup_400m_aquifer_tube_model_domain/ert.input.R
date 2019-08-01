rm(list=ls())
load("results/aquifer.grids.r")

grid.in = c()
grid.in = rbind(grid.in,"GRID")
grid.in = rbind(grid.in,"  TYPE structured")
grid.in = rbind(grid.in,paste("  NXYZ",nx,ny,nz))
grid.in = rbind(grid.in,paste("  ORIGIN",range.x[1],range.y[1],range.z[1]))
grid.in = rbind(grid.in,"  DXYZ")

lx = nx %/% 5 +1
for (ilx in 1:(lx-1)) {
    grid.in = rbind(grid.in,paste("    ",paste(dx[((ilx-1)*5+1):(ilx*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dx[(ilx*5+1):nx],collapse=" ")))

ly = ny %/% 5 +1
for (ily in 1:(ly-1)) {
    grid.in = rbind(grid.in,paste("    ",paste(dy[((ily-1)*5+1):(ily*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dy[(ily*5+1):ny],collapse=" ")))


lz = nz %/% 5 +1
for (ilz in 1:(lz-1)) {
    grid.in = rbind(grid.in,paste("    ",paste(dz[((ilz-1)*5+1):(ilz*5)],collapse=" "),"\\"))
}
grid.in = rbind(grid.in,paste("    ",paste(dz[(ilz*5+1):nz],collapse=" ")))

grid.in = rbind(grid.in,"  /")
grid.in = rbind(grid.in,"END")

writeLines(grid.in,"grid.in")
