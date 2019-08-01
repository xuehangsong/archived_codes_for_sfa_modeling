rm(list=ls())
angle = 15/180*pi
x.origin = 594386.880635513
y.origin = 116185.502270774

## x.origin = 594186
## y.origin = 115943

proj.coord = read.table("data/proj.coord.dat")
model.coord = proj.coord

model.coord[,1] = (proj.coord[,1]-x.origin)*cos(angle)+(proj.coord[,2]-y.origin)*sin(angle)
model.coord[,2] = (proj.coord[,2]-y.origin)*cos(angle)-(proj.coord[,1]-x.origin)*sin(angle)    
write.table(model.coord,file = "data/model.coord.dat",col.names = FALSE,row.names = FALSE )    


## proj.coord[1,] = c(594493.2,116214.5)
## model.coord[1,] = c(110.196,0.5)

## x.origin = proj.coord[1,1]-model.coord[1,1]*cos(angle)+model.coord[1,2]*sin(angle)
## y.origin = proj.coord[1,2]-model.coord[1,1]*sin(angle)-model.coord[1,2]*cos(angle)


#model.coord[1,] = c(256.8,182.25)
#model.coord[1,1:2] = c(0,0.5)
model.coord[1,1:2] = c(97.65,0.5)
model.coord[1,1:2] = c(100.95,0.5)
model.coord[1,1:2] = c(109.05,0.5)

proj.coord[1,1] = x.origin+model.coord[1,1]*cos(angle)-model.coord[1,2]*sin(angle)
proj.coord[1,2] = y.origin+model.coord[1,1]*sin(angle)+model.coord[1,2]*cos(angle)



