setwd("/Users/shua784/Dropbox/PNNL/Projects/Columbia_Basin/")

##----------------------INPUT-------------------------##
source("codes/xuehang_R_functions.R")
# fname_proj_coord='data/proj_coord.dat'
# fname_proj_bank='data/bank_project.csv'
##----------------------OUTPUT-----------------------##
# fname_model_coord="data/model_coord.dat"
# fname_model_bank='data/bank_model.csv'


# angle = 15/180*pi
angle = 0

#hanford reach
td_origin = c(538000, 97000)


model_origin = td_origin
xlen = 76000 #x boundary length
ylen = 67000 #y boundary length
# zlen = 20 #z boundary length
zlen = 300 #z boundary length
z0 = 0 
idx = 1000
idy = 1000
idz = 10

dx = rep(idx, xlen/idx)#dx=4 m
# dx = c(rev(round(0.5*1.09919838^seq(1,44),3)),rep(0.5,(400-350)/0.5))#refine mesh?? need to modify?
dy = rep(idy, ylen/idy)#dy=4 m
# dz = c(rev(round(0.1*1.09505^seq(1,25),3)),rep(0.1,(108-100)/0.1),round(0.1*1.097^seq(1,11),3))
dz = rep(idz, zlen/idz)

nx = length(dx)
ny = length(dy)
nz = length(dz)

#create x,y,z coordinates for each cell center
x = cumsum(dx)-0.5*dx
y = cumsum(dy)-0.5*dy
# z = 90+cumsum(dz)-0.5*dz
z = z0 + cumsum(dz)-0.5*dz

#min and max x,y,z coord
range_x = c(x[1]-0.5*dx[1], x[length(x)]+0.5*dx[length(x)])
range_y = c(y[1]-0.5*dy[1], y[length(y)]+0.5*dy[length(y)])
range_z = c(z[1]-0.5*dz[1], z[length(z)]+0.5*dz[length(z)])

# #store model 4corners
# at_model = rbind(c(range_x[1],range_y[1]),
#                  c(range_x[1],range_y[2]),
#                  c(range_x[2],range_y[2]),
#                  c(range_x[2],range_y[1])         
#                  )
# 
# #convert model 4corners to project 4corners
# at_project = model_to_proj(model_origin,angle,at_model)
# 
# 
# 
# #generate model_coord.dat
# data = read.table(fname_proj_coord,stringsAsFactors=FALSE)
# rownames(data) = data[,3]
# data = as.matrix(data[,1:2])
# model_coord = proj_to_model(model_origin,angle,data)
# write.table(model_coord,file=fname_model_coord, col.names=FALSE)

# #read into old intercept pts
# bank_project = read.table(fname_proj_bank, sep =",", stringsAsFactors=FALSE)
# rownames(bank_project) = bank_project[,1]
# bank_project = as.matrix(bank_project[,2:3])
# bank_model = proj_to_model(model_origin,angle,bank_project)
# write.table(bank_model,file=fname_model_bank, sep =",", col.names=FALSE)


# origin_900_project = c(594186,115943)
# origin_900_model = proj_to_model(model_origin,angle,origin_900_project)

# 
# x_coord = c(700, 1700)
# y_coord = c(1000, 2600)
# at_model = rbind(c(x_coord[1], y_coord[1]), c(x_coord[1], y_coord[2]), c(x_coord[2], y_coord[2]), c(x_coord[2], y_coord[1]))
# 
# at_project = model_to_proj(model_origin,angle,at_model)





