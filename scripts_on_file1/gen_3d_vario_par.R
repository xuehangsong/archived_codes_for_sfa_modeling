#This file is used for generating 3d variogram parameters

rm(list=ls())

#set the path to the files
rotate_coord = TRUE
path_prefix = ''

#read in location data
loc_data = read.table(paste(path_prefix,'loc3d.txt',sep='')) #the columns are x,y,z
ndata = nrow(loc_data)

#read in conditioing data
cond_data = read.table(paste(path_prefix,'logK_samples.txt',sep='')) #the columns are values at loc3d, rows are realizations
npar = nrow(cond_data)
#rotate and shift the well coordinates
if(rotate_coord)
{
	x0 = 594239.42
	y0 = 115982.57
	z0 = 95
	ang = 35.0/180 *pi # rotation
	xx = (loc_data[,1] - x0) * cos(ang) + (loc_data[,2] - y0) * sin(ang)
	yy = (loc_data[,2] - y0) * cos(ang) - (loc_data[,1] - x0) * sin(ang)
	loc_data[,1] = round(xx,3)
	loc_data[,2] = round(yy,3)
}
#co-locate the conditioing points to the grid center
if(FALSE){
	loc_data_grid = loc_data
	loc_data_grid[,1] = 0.5*(round(loc_data[,1]-0.5)+round(loc_data[,1]+0.5))
	loc_data_grid[,2] = 0.5*(round(loc_data[,2]-0.5)+round(loc_data[,2]+0.5))
}
#grids for 3D domain
domain3D.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,109.75,0.5))
colnames(domain3D.grid)=c('x','y','z')
ngrid = nrow(domain3D.grid)
nsamp = 1 ## of samples generated for each par

#try gstat
library(gstat)

if(FALSE)
{
jpeg(paste(path_prefix,'plots_variogram.jpg',sep = ''), width = 26, height = 17,units="in",res=150,quality=100)
par(mfrow = c(5,7), mar=c(3, 3, 3, 4) + 0.1)
}

sim_samp = matrix(0,ngrid,nsamp*npar)
for(ipar in 1:npar){
	cat(ipar,'\n')
	data3d = cbind(loc_data,t(cond_data[ipar,]))
	colnames(data3d) = c('x','y','z','logK')
	vario_x = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 2.5, cutoff = 70, width = 6)
#	vario_x = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 90, beta = 0,tol.hor = 45, tol.ver = 5, cutoff = 70, width = 8)
#	vario_y = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 0, beta = 0,tol.hor = 40, tol.ver = 5, cutoff = 70, width = 8)
#	vario_xy1 = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 45, beta = 0,tol.hor = 45, tol.ver = 5, cutoff = 70, width = 8)
#	vario_xy2 = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 135, beta = 0,tol.hor = 45, tol.ver = 5, cutoff = 70, width = 8)
	
	vario_z = variogram(logK ~ 1,locations=~x+y+z,data3d,alpha = 0, beta = 90,tol.hor = 2.5, tol.ver = 5, cutoff = 6, width = 0.5)
	
#	fit_x = fit.variogram(vario_x,vgm(2.0,"Exp",20,0.1))
#	fit_y = fit.variogram(vario_y,vgm(2.0,"Exp",20,0.1))	
#	fit_xy1 = fit.variogram(vario_xy1,vgm(2.0,"Exp",20,0.1))
#	fit_xy2 = fit.variogram(vario_xy2,vgm(2.0,"Exp",20,0.1))
	fit_z = fit.variogram(vario_z,vgm(2.0,"Exp",2,0.1))
	fit_x = fit.variogram(vario_x,vgm(fit_z$psill[2],"Exp",20,fit_z$psill[1]),fit.sills=F)
	
	plot(vario_x,model=fit_x)
#	plot(vario_y,model=fit_y)
#	plot(vario_xy1,model=fit_xy1)
#	plot(vario_xy2,model=fit_xy2)
	plot(vario_z,model=fit_z)
	#sequentially simulate for the 3D field
	anis_ratio = fit_z$range[2]/fit_x$range[2]
	cov_model = vgm(fit_x$psill[2],"Exp",fit_x$range[2],fit_x$psill[1],anis = c(0,0,0,1,anis_ratio))
	g_logK = gstat(formula=logK~1,locations=~x+y+z,data=data3d,model=cov_model,nmax = 20)
	logK_3d = predict(g_logK,domain3D.grid,nsim=nsamp)
	sim_samp[,((ipar-1)*nsamp+1):(ipar*nsamp)] = logK_3d[,4:(nsamp+3)]
}	

write.table(sim_samp,file="logK_3D_CondSim_Samples.txt",row.names=F,col_names=F)
