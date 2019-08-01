
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
rotate_coord = TRUE
path_prefix = 'TrueData_Mar2011TT/'

well_data = read.table(paste(path_prefix,'well_list_full.txt',sep=''),skip=1) #the columns are well_ID, x,y, elev(m),borehole IDs,top_screen_depth, bot_screen_depth, H/R contact detpth(ft, from Gamma log)
well_data[,1] = paste(well_data[,1]) #convert well IDs to string
wells = well_data[,1]

#rotate and shift the well coordinates
if(rotate_coord)
{
	x0 = 594239.42
	y0 = 115982.57
	z0 = 95
	ang = 35.0/180 *pi # rotation
	xx = (well_data[,2] - x0) * cos(ang) + (well_data[,3] - y0) * sin(ang)
	yy = (well_data[,3] - y0) * cos(ang) - (well_data[,2] - x0) * sin(ang)
	well_data[,2] = round(xx,3)
	well_data[,3] = round(yy,3)
}

if(FALSE)
{
	jpeg(paste(path_prefix,'TrueData_', plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow = c(5,7), mar=c(3, 3, 3, 4) + 0.1)
}
U0Data = array(NA, dim=c(0,3))
wells_temp = array(NA, dim=c(0,1))
for (iw in 1:length(wells))
{
	well_name = substring(wells[iw],5,8)
	truedata = matrix(NA,1,3)
	true_file = paste(path_prefix,'Well_',well_name,'_Mar2011TT.txt',sep='')
	true_exist = file.exists(true_file)
	if(!true_exist)
		next
	truedata = read.table(true_file,skip=1)
	true_t = truedata[,1]
	true_UO2 = truedata[,2]	
	U0 = mean(truedata[which(truedata[,1]<0),2])
	temp = data.frame(well_data[iw,2],well_data[iw,3],U0)
	if(!is.nan(U0))
	{
		U0Data = rbind(U0Data,temp)
		wells_temp = rbind(wells_temp,well_name)
	}
}
U0Data = data.frame(U0Data,wells_temp)
write.table(U0Data,'InitialU_Mar2011Test.txt',row.names=F)
U0Data[,4] = paste(U0Data[,4])
#create 3D data set for conditioning (concentrations assumed to be uniform within screen interval)
#read in screening interval of the wells for the Mar2011 test
obs_well_data = read.table('obs_wells_mar2011.txt')
obs_well_data[,1] = paste(obs_well_data[,1])
gridv = seq(95.25,109.75,0.5)
InitialU_3D = array(NA, dim=c(0,4))
wells_temp = array(NA, dim=c(0,1))
for (iw in 1:nrow(U0Data))
{
	well_name = U0Data[iw,4]
	idx = grep(well_name,obs_well_data[,1])
	elev_top = obs_well_data[idx,4] - 0.3048 * obs_well_data[idx,5]
	elev_bot = obs_well_data[idx,4] - 0.3048 * obs_well_data[idx,6]
	elevs = gridv[which(gridv<=elev_top & gridv>elev_bot)]
	ndata = length(elevs)
	if(ndata>0)
	{
		temp = matrix(NA,ndata,4)
		temp[,1] = U0Data[iw,1]
		temp[,2] = U0Data[iw,2]
		temp[,3] = elevs
		temp[,4] = rep(U0Data[iw,3],ndata)
		InitialU_3D = rbind(InitialU_3D,temp)
		wells_temp = c(wells_temp,rep(well_name,ndata))					   
	}
}
InitialU_3D = data.frame(InitialU_3D,wells_temp)
InitialU_3D[,5] = paste(InitialU_3D[,5])
InitialU_3D[,4] = log(InitialU_3D[,4])
colnames(InitialU_3D) = c('x','y','z','logU','well')

#average the concentrations in well clusters
idx1 = which(U0Data[,4] == '2-26')
idx2 = which(U0Data[,4] == '2-27')
idx3 = which(U0Data[,4] == '2-28')
U0Data[idx1,3] = 0.333 * (U0Data[idx1,3] + U0Data[idx2,3] + U0Data[idx3,3])
U0Data = U0Data[-c(idx2,idx3),]

idx1 = which(U0Data[,4] == '2-29')
idx2 = which(U0Data[,4] == '2-30')
idx3 = which(U0Data[,4] == '2-31')
U0Data[idx1,3] = 0.333 * (U0Data[idx1,3] + U0Data[idx2,3] + U0Data[idx3,3])
U0Data = U0Data[-c(idx2,idx3),]

idx1 = which(U0Data[,4] == '3-30')
idx2 = which(U0Data[,4] == '3-31')
idx3 = which(U0Data[,4] == '3-32')
U0Data[idx1,3] = 0.333 * (U0Data[idx1,3] + U0Data[idx2,3] + U0Data[idx3,3])
U0Data = U0Data[-c(idx2,idx3),]

write.table(U0Data,'InitialU_2D_Mar2011Test.txt',row.names=F)

#log-transform concentration
U0Data[,3] = log(U0Data[,3])

#estimate and fit the variogram model for 2D data
library(geoR)
options(geoR.messages=FALSE)
cov_model_sets = c('gaussian','wave','exponential')
drift_sets = c(0,1)

domain.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5)) # for the cell centers of entire domain
colnames(domain.grid)=c('x','y')

ngrid = dim(domain.grid)[1]


linwd1 = 1.5
linwd2 = 1.5
pwidth = 10
pheight = 10
#for(icov in 1:length(cov_model_sets))
for(icov in 1:1)
{
	cov_model = cov_model_sets[icov]
#for(idrift in 1:length(drift_sets))
	for(idrift in 1:1)
	{
		drift = drift_sets[idrift]
		plotfile = paste(cov_model,'_drift',drift,'_Mar2011.jpg',sep='')
		
		Init_data = matrix(NA,nrow(domain.grid),1)

		data = U0Data[,1:3]
		colnames(data) = c('x','y','z')
		data = as.geodata(data)
		if(drift)
			bin1 = variog(data,uvec=seq(0,100,l=20),trend='1st',bin.cloud=T,estimator.type='modulus')
		if(!drift)
			bin1 = variog(data,uvec=seq(0,100,l=20),trend='cte',bin.cloud=T,estimator.type='modulus')
		
		#fit variogram model
		wls = variofit(bin1,ini = c(0.2,50), fix.nugget=F,cov.model=cov_model)
		jpeg(paste('InitU_variogram_',plotfile, sep = ''), width = 6, height = 5,units="in",res=150,quality=100)
		plot(bin1,main = 'Initial U')
		lines(wls)
		dev.off()
#plot.geodata(data)
		if(!drift)
			kc1 = krige.conv(data, loc = domain.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
		if(drift)
			kc1 = krige.conv(data, loc = domain.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='1st',trend.l='1st'))
		Init_data = as.vector(exp(kc1$predict))					
###Inital condition
		write.table(Init_data,file=paste('Initial_U_Data_',cov_model,'_drift',drift,'.txt',sep=''),row.names=F,col.names=F)
	}
}
write.table(domain.grid,file=paste('Initial_U_Domain_Coord.txt',sep=''),row.names=F,col.names=F)		

#try gstat
library(gstat)
colnames(U0Data) = c('x','y','U','well')
coordinates(U0Data) = ~x+y
v = variogram(U~1,U0Data,cutoff=70,width=6)
m = fit.variogram(v,vgm(0.1,"Gau",20,0))
plot(v,model=m)

#kriging for 3D initial concentration field
domain3D.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,109.75,0.5))
colnames(domain3D.grid)=c('x','y','z')
covm = vgm(0.051,"Gau",15.32,0.01,anis = c(0,0,0,1,0.1))

g <- gstat(formula=logU~1,locations=~x+y+z,data=InitialU_3D,model=covm,nmax = 20)
Initial_U <- predict(g, domain3D.grid)
write.table(Initial_U,file="Kriged_Initial_logU_3D.txt",row.names=F)

BEU_Kd_Data = read.table('BEU_Kd_Data.txt',skip=1)
colnames(BEU_Kd_Data) = c('well','x','y','z','BEU','Kd')
BEU_Kd_Data[,5] = log(BEU_Kd_Data[,5])
BEU_Kd_Data[,6] = log(BEU_Kd_Data[,6])
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

#horizontal variogram
v_BEU = variogram(BEU~1,locations=~x+y+z,BEU_Kd_Data,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 5, cutoff = 70, width = 8)
m_BEU = fit.variogram(v_BEU,vgm(1.2,"Exp",20,0.1))
plot(v_BEU,model=m_BEU)
covm_BEU = vgm(0.774,"Exp",14.34,0.39,anis = c(0,0,0,1,0.1))
#krige for BEU 3D field
g_BEU = gstat(formula=BEU~1,locations=~x+y+z,data=BEU_Kd_Data,model=covm_BEU,nmax = 20)
if(FALSE)
{
	BEU_3D = predict(g_BEU, domain3D.grid)
	write.table(BEU_3D,file="Kriged_logBEU_3D.txt",row.names=F)
}

BEU_3D = predict(g_BEU, domain3D.grid,nsim=150)
write.table(BEU_3D,file="Sim_logBEU_3D.txt",row.names=F)
 

#v_Kd = variogram(Kd~1,locations=~x+y+z,BEU_Kd_Data,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 5, cutoff = 70, width = 10)
#m_Kd = fit.variogram(v_Kd,vgm(1.2,"Gau",20,0.1))
#plot(v_Kd,model=m_Kd)
#covm_Kd = vgm(1.484,"Gau",78.22,0.63,anis = c(0,0,0,1,0.1))
#krige for Kd 3D field
#g_Kd = gstat(formula=Kd~1,locations=~x+y+z,data=BEU_Kd_Data,model=covm_Kd,nmax = 20)
#Kd_3D = predict(g_Kd, domain3D.grid)
#write.table(Kd_3D,file="Kriged_logKd_3D.txt",row.names=F)


