
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#whether to rotate the coordinates
rotate_coord = TRUE
nsim = 200
#try gstat
library(gstat)
#kriging for 3D initial concentration field
domain3D.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,109.75,0.5))
colnames(domain3D.grid)=c('x','y','z')

BEU_Kd_Data = read.table('BEU_Kd_Data.txt',skip=1)
colnames(BEU_Kd_Data) = c('well','x','y','z','BEU','Kd') 
ndata = nrow(BEU_Kd_Data)
#generate samples for BEU conditioning points
BEU_sample = matrix(0,ndata,nsim)
for(i in 1:ndata)
	BEU_sample[i,]=BEU_Kd_Data[i,5] + rnorm(nsim,0,max(0.1*BEU_Kd_Data[i,5],0.001))
BEU_sample[which(BEU_sample<0.0000001] = 0.0000001
BEU_sample = log(BEU_sample)
#shift and rotate coordinates
if(rotate_coord)
{
	x0 = 594239.42
	y0 = 115982.57
	z0 = 95
	ang = 35.0/180 *pi # rotation
	xx = (BEU_Kd_Data[,2] - x0) * cos(ang) + (BEU_Kd_Data[,3] - y0) * sin(ang)
	yy = (BEU_Kd_Data[,3] - y0) * cos(ang) - (BEU_Kd_Data[,2] - x0) * sin(ang)
	BEU_Kd_Data[,2] = round(xx,3)
	BEU_Kd_Data[,3] = round(yy,3)
}
sim_samp = matrix(0,ngrid,nsim)
BEU_Kd_Data1 = BEU_Kd_Data
for(i in 1:nsim)
{
	BEU_Kd_Data[,5] = BEU_sample[,i]
	#horizontal variogram
	vx_BEU = variogram(BEU~1,locations=~x+y+z,BEU_Kd_Data,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 5, cutoff = 70, width = 8)
	vz_BEU = variogram(BEU~1,locations=~x+y+z,BEU_Kd_Data,alpha = 0, beta = 90,tol.hor =2.5, tol.ver = 5, cutoff = 6 , width = 0.5)
	fit_vz = fit.variogram(vz_BEU,vgm(2.0,"Exp",2,0.1)) 
	fit_vx = fit.variogram(vario_vx,vgm(fit_vz$psill[2],"Exp",20,fit_vz$psill[1]),fit.sills=F)
	anis_ratio = fit_vz$range[2]/fit_vx$range[2]
	plot(vx_BEU,model=fit_vx)
	covm_BEU = vgm(fit_vx$psill[2],"Exp",fit_vx$range[2],fit_vx$psill[1],anis = c(0,0,0,1,anis_ratio))

	#krige for BEU 3D field
	g_BEU = gstat(formula=BEU~1,locations=~x+y+z,data=BEU_Kd_Data,model=covm_BEU,nmax = 20)
	BEU_3D = predict(g_BEU, domain3D.grid,nsim=1)
	BEU_temp = BEU_3D[,4]
	BEU_temp[which(BEU_temp>2.1)] = 2.1+rnorm(length(which(BEU_temp>2.1)),0,0.01)
	BEU_3D[,4:203] = BEU_temp
	rm(BEU_temp)
}
write.table(BEU_3D,file="Sim_logBEU_3D.txt",row.names=F)
