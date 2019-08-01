
#This file is used for calculating transient boundary conditions at Hanford-300 area using universal kriging with linear drift, for simulating polyphosphate injection
#only the kriged values at the boundaries are generated

rm(list=ls())
library(geoR)
library(rhdf5)
H5close()
options(geoR.messages=FALSE)

input_folder = 'headdata4krige_Plume_2009_2016'

output_folder = 'BC_Plume'
output_folder1 = 'H_initial_hdf5_OK_2015_2016'
output_folder2 = 'BC_hdf5_OK_2015_2016'
if (!file.exists(output_folder))
  dir.create(file.path('./', output_folder))
if (!file.exists(output_folder1))
  dir.create(file.path('./', output_folder1))
if (!file.exists(output_folder2))
  dir.create(file.path('./', output_folder2))

#check if the output folder exists, if not create one

#cov_model_sets = c('gaussian','wave','exponential','spherical')
drift_sets = c(0,1)
#nt = 5136
#nt=10
gridx = 2.0
gridy = 2.0

pred.grid1 = expand.grid(seq(gridx/2,400-gridx/2,gridx),c(gridx/2,400-gridx/2)) # for South and North boundaries
domain.grid = expand.grid(seq(gridx/2,400-gridx/2,gridx),seq(gridx/2,400-gridx/2,gridy))
pred.grid2 = expand.grid(seq(gridx/2,400-gridx/2,gridx),c(gridx/2,400-gridx/2)) # for West and East boundaries

temp = pred.grid2[,1]
pred.grid2[,1] = pred.grid2[,2]
pred.grid2[,2] = temp
pred.grid = rbind(pred.grid1,pred.grid2)

#x = c(    32.129, 28.953, 26.091, 23.513, 21.189, 
#           19.094, 17.207, 15.506, 13.974, 12.592, 
#           11.348, 10.226, 9.215, 8.305, 7.484, 
#           6.744, 6.077, 5.477, 4.935, 4.448, 
#           4.008, 3.612, 3.255, 2.933, 2.643, 
#           2.382, 2.147, 1.934, 1.743, 1.571, 
#           1.416, 1.276, 1.150, 1.036, 0.934, 
#           0.841, 0.758, 0.683, 0.616, 0.555, rep(0.5,160) )

#x = cumsum(x) - x/2.
#y = seq(1,399,gridy)
#pred.grid1 = expand.grid(x,c(y[1],y[200]))
#pred.grid2 = expand.grid(y,c(x[1],x[200]))
#domain.grid = expand.grid(x,y)
#pred.grid = rbind(pred.grid1,pred.grid2)

# for the cell centers of entire domain

colnames(pred.grid)=c('x','y')
ngrid = dim(pred.grid)[1]
# choose time step for inital head surface
i.initial = 1
nt = 65040
step = 1
BC = array(0,c(nt-i.initial+1,ngrid))
BC2 = array(0,c(nt-i.initial+1))
par(mfrow=c(2,2))
#for(icov in 1:length(cov_model_sets))
for (i in seq(i.initial,nt,step))
{
  data = read.table(paste(input_folder,'/time',i,'.dat',sep=''),header=F,na.strings = "NaN")
  ##
  ## Delete the wrong well data, temporary solution.
  ##
  ##data <- data[-c(7), ]
  temp = data[,1]
  data[,1] = data[,2]
  data[,2] = temp
  colnames(data) = c('x','y','z')
  data = as.geodata(data)
  if (nrow(data$coords)>27)
  {bin1 = variog(data,uvec=c(0,50,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')}
  else
  {bin1 = variog(data,uvec=c(0,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')}
  initial.values <- expand.grid(max(bin1$v),seq(300))
  #initial.values = c(max(bin1$v),300)
  wls = variofit(bin1,ini = initial.values,fix.nugget=T,nugget = 0.00001,fix.kappa=F,cov.model='exponential')
  kc1 = krige.conv(data, loc = pred.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
  kc3 = krige.conv(data, loc = c(218.39,256.76), krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
  if (i==i.initial)
  {
    kc2 = krige.conv(data, loc = domain.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
    h_initial = as.vector(kc2$predict)
    dim(h_initial) = c(400/gridx,400/gridy)
#    write.table(h_initial,file=paste(output_folder,'/Initial_h.txt',sep=''),row.names=F,col.names=F)
  }
  if (i%%10000 == 0)
  {plot(bin1,main = paste('Time = ',i,'hrs',sep=''),col='red', pch = 19, cex = 1, lty = "solid", lwd = 2)
  text(bin1$u,bin1$v,labels=bin1$n, cex= 0.7,pos = 2)
  lines(wls)
  }
  BC[i-i.initial+1,] = as.vector(kc1$predict[1:ngrid])
  BC2[i-i.initial+1] = as.vector(kc3$predict[1])
}

##Generate the initial condition hdf5 file for the domain.
if (file.exists(paste(output_folder1,'/H_initial_OK.h5',sep='')))
  file.remove(paste(output_folder1,'/H_initial_OK.h5',sep=''))
h5createFile(paste(output_folder1,'/H_initial_OK.h5',sep=''))
h5createGroup(paste(output_folder1,'/H_initial_OK.h5',sep=''),'Initial_Head')
fid = H5Fopen(paste(output_folder1,'/H_initial_OK.h5',sep=''))
h5write(t(h_initial),paste(output_folder1,'/H_initial_OK.h5',sep=''),'Initial_Head/Data')
h5g1 = H5Gopen(fid,'/Initial_Head')
h5writeAttribute(attr = 1.0, h5obj = h5g1, name = 'Cell Centered')
h5writeAttribute.character(attr = "XY", h5obj = h5g1, name = 'Dimension')
h5writeAttribute(attr = c(gridx,gridy), h5obj = h5g1, name = 'Discretization')
h5writeAttribute(attr = 500.0, h5obj = h5g1, name = 'Max Buffer Size')
h5writeAttribute(attr = c(0.0,0.0), h5obj = h5g1, name = 'Origin')
H5Gclose(h5g1)
H5Fclose(fid)

##Generate the BC hdf5 file.
timeid = seq(0,nt-i.initial,step)
{if (file.exists(paste(output_folder2,'/BC_OK.h5',sep='')))
  file.remove(paste(output_folder2,'/BC_OK.h5',sep=''))
h5createFile(paste(output_folder2,'/BC_OK.h5',sep=''))
h5createGroup(paste(output_folder2,'/BC_OK.h5',sep=''),'BC_East')
fid = H5Fopen(paste(output_folder2,'/BC_OK.h5',sep=''))
h5write(timeid,paste(output_folder2,'/BC_OK.h5',sep=''),'BC_East/Times')
h5write(BC[,(1+1200/gridx):(1600/gridx)],paste(output_folder2,'/BC_OK.h5',sep=''),'BC_East/Data')
h5g1 = H5Gopen(fid,'/BC_East')
h5createGroup(paste(output_folder2,'/BC_OK.h5',sep=''),'BC_North')
h5g2 = H5Gopen(fid,'/BC_North')
h5createGroup(paste(output_folder2,'/BC_OK.h5',sep=''),'BC_South')
h5g3 = H5Gopen(fid,'/BC_South')
h5createGroup(paste(output_folder2,'/BC_OK.h5',sep=''),'BC_West')
h5g4 = H5Gopen(fid,'/BC_West')
h5writeAttribute(attr = 1.0, h5obj = h5g1, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g1, name = 'Dimension')
h5writeAttribute(attr = gridx, h5obj = h5g1, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g1, name = 'Max Buffer Size')
h5writeAttribute(attr = 0.0, h5obj = h5g1, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g1, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g1, name = 'Transient')

h5write(timeid,paste(output_folder2,'/BC_OK.h5',sep=''),'BC_North/Times')
h5write(BC[,(1+400/gridx):(800/gridx)],paste(output_folder2,'/BC_OK.h5',sep=''),'BC_North/Data')
h5writeAttribute(attr = 1.0, h5obj = h5g2, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g2, name = 'Dimension')
h5writeAttribute(attr = gridx, h5obj = h5g2, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g2, name = 'Max Buffer Size')
h5writeAttribute(attr = 0.0, h5obj = h5g2, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g2, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g2, name = 'Transient')

h5write(timeid,paste(output_folder2,'/BC_OK.h5',sep=''),'BC_South/Times')
h5write(BC[,1:(400/gridx)],paste(output_folder2,'/BC_OK.h5',sep=''),'BC_South/Data')
h5writeAttribute(attr = 1.0, h5obj = h5g3, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g3, name = 'Dimension')
h5writeAttribute(attr = gridx, h5obj = h5g3, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g3, name = 'Max Buffer Size')
h5writeAttribute(attr = 0.0, h5obj = h5g3, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g3, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g3, name = 'Transient')

h5write(timeid,paste(output_folder2,'/BC_OK.h5',sep=''),'BC_West/Times')
h5write(BC[,(1+800/gridx):(1200/gridx)],paste(output_folder2,'/BC_OK.h5',sep=''),'BC_West/Data')
h5writeAttribute(attr = 1.0, h5obj = h5g4, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g4, name = 'Dimension')
h5writeAttribute(attr = gridx, h5obj = h5g4, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g4, name = 'Max Buffer Size')
h5writeAttribute(attr = 0.0, h5obj = h5g4, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g4, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g4, name = 'Transient')
H5Gclose(h5g1)
H5Gclose(h5g2)
H5Gclose(h5g3)
H5Gclose(h5g4)
H5Fclose(fid)
}