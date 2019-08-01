
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
rotate_coord = TRUE
path_prefix = 'TrueData_Mar2011TT/'
nsamp = 200

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
InitialU_3D = array(NA, dim=c(0,3+nsamp))
wells_temp = array(NA, dim=c(0,1))
#generate random seeds
rand_seeds = sample(100000000,size=nsamp)
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
		temp = matrix(NA,ndata,3+nsamp)
		temp[,1] = U0Data[iw,1]
		temp[,2] = U0Data[iw,2]
		temp[,3] = elevs
		for(isamp in 1:nsamp)
		{
			set.seed(rand_seeds[isamp])
			temp[,3+isamp] = U0Data[iw,3] + rnorm(ndata,0,0.15*abs(U0Data[iw,3]))
			temp[which(temp[,3+isamp]<20),3+isamp] = 20.0 + abs(rnorm(length(which(temp[,3+isamp]<20)),0,0.1))
		}
		InitialU_3D = rbind(InitialU_3D,temp)
		wells_temp = c(wells_temp,rep(well_name,ndata))					   
	}
}
InitialU_3D = data.frame(InitialU_3D,wells_temp)
InitialU_3D[,4+nsamp] = paste(InitialU_3D[,4+nsamp])
#load gstat
library(gstat)
#kriging for 3D initial concentration field
domain3D.grid.all = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,109.75,0.5))
domain3D.grid.sim = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,105.75,0.5))
ngrid.sim = nrow(domain3D.grid.sim)
colnames(domain3D.grid.sim)=c('x','y','z')

#covm = vgm(0.051,"Gau",15.32,0.01,anis = c(0,0,0,1,0.1))
InitialU = matrix(0,ngrid.sim,nsamp)
for(isamp in 1:nsamp)
{
	cat(isamp,'\n')
	#set conditioning data
	Cond_Data = data.frame(InitialU_3D[,1:3],log(InitialU_3D[,3+isamp]))
	colnames(Cond_Data) = c('x','y','z','logU')
	#fit for variogram
	vx_U = variogram(logU~1,locations=~x+y+z,Cond_Data,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 5, cutoff = 45, width = 5)
	vz_U = variogram(logU~1,locations=~x+y+z,Cond_Data,alpha = 0, beta = 90,tol.hor =2.5, tol.ver = 5, cutoff = 3.0 , width = 0.5)
	#fit_vz = fit.variogram(vz_U,vgm(0.5,"Exp",2,0.01))
	
	#fit_vx = fit.variogram(vx_U,vgm(fit_vz$psill[2],"Exp",fit_vz$range[2]*10,fit_vz$psill[1]))
	fit_vx = fit.variogram(vx_U,vgm(1.0,"Exp",40,0.01))
#	anis_ratio = fit_vz$range[2]/fit_vx$range[2]
	anis_ratio = 0.1
	plot(vx_U,model=fit_vx)
	covm_U = vgm(fit_vx$psill[2],"Exp",fit_vx$range[2],fit_vx$psill[1],anis = c(0,0,0,1,anis_ratio))
	g <- gstat(formula=logU~1,locations=~x+y+z,data=Cond_Data,model=covm_U,nmax = 30)
	sim_data <- predict(g, domain3D.grid.sim, nsim = 1)
	InitialU[,isamp] = sim_data[,4]
	rm(sim_data)
}
write.table(InitialU,file="InitalU_Prior_Samples.txt",row.names=F,col.names=F)

