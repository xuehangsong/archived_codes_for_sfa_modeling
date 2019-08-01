
#This file is used for calculating transient boundary conditions at Hanford-300 area using conditional simulations
#only the kriged values at the boundaries are generated

rm(list=ls())
library(gstat)

create_initial = F
write_data = T 
input_folder = 'headdata4krige_Mar2011_wo121A'
output_folder = 'BC_CondSim_Mar2011_wo121A'

subdir_plot = 'plots'
subdir_data = 'data'

#create the folders if they do not exist
if (!file.exists(output_folder))
    dir.create(output_folder)
if (!file.exists(file.path(output_folder,subdir_plot)))
    dir.create(file.path(output_folder, subdir_plot))
if (!file.exists(file.path(output_folder,subdir_data)))
    dir.create(file.path(output_folder, subdir_data))

cov_model_sets = c('Gau','Sph','Exp')
drift_sets = c(0,1)

gridx = 1.0
gridy = 1.0
pred.grid1 = expand.grid(seq(0.5,119.5),c(0.5,119.5)) # for South and North boundaries
domain.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5)) # for the cell centers of entire domain
nsamp = 500 # no of realizations

pred.grid2 = pred.grid1 # for West and East boundaries
pred.grid2[,1] = pred.grid1[,2]
pred.grid2[,2] = pred.grid1[,1]
pred.grid = rbind(pred.grid1,pred.grid2)
colnames(pred.grid)=c('x','y')

ngrid = dim(pred.grid)[1]
ngrid4 = ngrid/4 #number of cells along each boundary 

#read in the data and coordinates for testing data points
test_wells = read.table(paste(input_folder,'/testwell_names.txt',sep=''),header=F)
test_wells = paste(test_wells[,1])
test_coord = read.table(paste(input_folder,'/testwell_coordinates.txt',sep=''),header=F)
colnames(test_coord)=c('x','y')
test_data = read.table(paste(input_folder,'/testwell_data.txt',sep=''),header=F)
ntest = nrow(test_coord)
loc_sim = rbind(pred.grid,test_coord)
# for inital head surface (choose time =191h, 0.25 hour before injection of Mar2011 experiment)
i.initial = 192  #start of time
#istart = i.initial
istart = 192
iend = 291     #end of time
nt = (iend - istart) + 1
linwd1 = 1.5
linwd2 = 1.5
pwidth = 10
pheight = 10
#for(icov in 1:length(cov_model_sets))
for(icov in 1:3)
{
	cov_model = cov_model_sets[icov]
	#for(idrift in 1:length(drift_sets))
	for(idrift in 1:2)
	{
		drift = drift_sets[idrift]
		plotfile = paste(cov_model,'_drift',drift,'_Mar2011_',istart,'to',iend,'h.jpg',sep='')
		datafile = paste(cov_model,'_drift',drift,'_Mar2011_',istart,'to',iend,'h.txt',sep='')
		datafile_initial = paste(cov_model,'_drift',drift,'_Mar2011_',i.initial,'h.txt',sep='')
		BC_data = array(0,c(ngrid,nsamp,nt))
		BC_data_krige = matrix(0,ngrid,nt)
		if(create_initial)
			Init_data = matrix(NA,nrow(domain.grid),nsamp)
		Sim_test_data = array(0,c(ntest,nsamp,nt))
		krige_test_data = matrix(0,ntest,nt)

		kk = 0
		for (i in istart:iend)
		{
			kk = kk + 1
			#data are stored in (Y,X,Head)
			data2d = read.table(paste(input_folder,'/time',i,'.dat',sep=''),header=F)
			temp = data2d[,1]
			data2d[,1] = data2d[,2]
			data2d[,2] = temp
			colnames(data2d) = c('x','y','H')
			if(drift)
				vario_x = variogram(H ~ x+y,locations=~x+y,data2d,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 0, cutoff = 250, width = 12)
			if(!drift)
				vario_x = variogram(H ~ 1,locations=~x+y,data2d,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 0, cutoff = 250, width = 12)
			#fit variogram model
			fit_vario = fit.variogram(vario_x,vgm(0.001,cov_model,30,0.0001))
			if(length(grep('Gau',cov_model))>0)  # this is a bug in gstat: nugget cannot be zero using gaussian variogram for conditional simulation
				fit_vario$psill[1] = max(fit_vario$psill[1],0.00000000001)
			jpeg(paste(file.path(output_folder,subdir_plot),'/variogram_',(i-1),plotfile, sep = ''), width = 6, height = 5,units="in",res=150,quality=100)
			plot(vario_x,model=fit_vario,main = paste('Time = ',i,'hrs',sep=''))
			dev.off()
			#conditional simulations
			if(drift)
				g_H = gstat(formula=H~x+y,locations=~x+y,data=data2d,model=fit_vario,nmax = 20)
			if(!drift)
				g_H = gstat(formula=H~1,locations=~x+y,data=data2d,model=fit_vario,nmax = 20)
				
			H_2d = predict(g_H,loc_sim,nsim=nsamp)	
			H_2d_krige = predict(g_H,loc_sim)
			BC_data[1:ngrid,1:nsamp,kk] = as.matrix(H_2d[1:ngrid,3:(2+nsamp)])
			Sim_test_data[,,kk] = as.matrix(H_2d[(1+ngrid):(ngrid+ntest),3:(2+nsamp)])	
			BC_data_krige[,kk] = H_2d_krige[1:ngrid,3]
			krige_test_data[,kk] = H_2d_krige[(1+ngrid):(ngrid+ntest),3]
			#whether to generate inital H field				
			if(i == i.initial && create_initial)
				Init_data = predict(g_H,domain.grid,nsim=nsamp)					
			if(FALSE)
			{
				#cat(iset,'\t',min_error,'\t',ceiling(min_error/400),'\t', min_error%%400,'\n')
				jpeg(paste(file.path(output_folder,subdir_plot),'/BC_CondSim_',(i-1),plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
				par(mfrow=c(2,2))
				H_lim = c(min(H_2d[,3:(2+nsamp)],na.rm=T),max(H_2d[,3:(2+nsamp)],na.rm=T))
				#South boundary
				plot(seq(0,119), H_2d[1:ngrid4,3],  main=paste('t=',(i-1),' hour, South',sep=''),xlab = "South Coord (m)", ylab = "Elevation(m)", xlim=c(0,120),ylim=H_lim,type='l',frame.plot=F)	
				for (isamp in 2:nsamp)
					lines(seq(0,119),H_2d[1:ngrid4,2+isamp])
				#add average line
				lines(seq(0,119),rowMeans(H_2d[1:ngrid4,3:(2+nsamp)]),col='red')
				
				#north boundary
				plot(seq(0,119),H_2d[(ngrid4+1):(ngrid4*2),3], main=paste('t=',(i-1),' hour, North',sep=''),xlab = "North Coord (m)", ylab = "Elevation(m)", xlim=c(0,120),ylim=H_lim,type='l',frame.plot=F)	
				for (isamp in 2:nsamp)
					lines(seq(0,119),H_2d[(ngrid4+1):(ngrid4*2),2+isamp])
				#add average line
				lines(seq(0,119),rowMeans(H_2d[(ngrid4+1):(ngrid4*2),3:(2+nsamp)]),col='red')
				
				#west boundary
				plot(H_2d[(ngrid4*2+1):(ngrid4*3),3], seq(0,119), main=paste('t=',(i-1),' hour, West',sep=''),ylab = "West Coord (m)", xlab = "Elevation(m)", ylim=c(0,120),xlim=H_lim,type='l',frame.plot=F)	
				for (isamp in 2:nsamp)
					lines(H_2d[(ngrid4*2+1):(ngrid4*3),2+isamp], seq(0,119))
				#add average line
				lines(rowMeans(H_2d[(ngrid4*2+1):(ngrid4*3),3:(2+nsamp)]), seq(0,119),col='red')	

				#East boundary
				plot(H_2d[(ngrid4*3+1):ngrid,3], seq(0,119), main=paste('t=',(i-1),' hour, East',sep=''),ylab = "East Coord (m)", xlab = "Elevation(m)", ylim=c(0,120),xlim=H_lim,type='l',frame.plot=F)	
				for (isamp in 2:nsamp)
					lines(H_2d[(ngrid4*3+1):ngrid,2+isamp], seq(0,119))
				#add average line
				lines(rowMeans(H_2d[(ngrid4*3+1):ngrid,3:(2+nsamp)]), seq(0,119),col='red')		
				dev.off()
			}
			rm(H_2d)
			
		}
		##plot the fitting between the predicted and measured water levels at testing wells
		jpeg(paste(file.path(output_folder,subdir_plot),'/Validate_CondSim',plotfile, sep = ''), width = 26, height = 17,units="in",res=150,quality=100)
		par(mfrow = c(2,ceiling(ntest/2)))
		for(i in 1:ntest)
		{
			H_lim = c(min(Sim_test_data[i,,],na.rm=T),max(Sim_test_data[i,,],na.rm=T))
			if(sum(is.na(H_lim))>0)
				next
			plot(istart:iend, test_data[istart:iend,i],type='l',col='black',main=test_wells[i],xlab = 'Time (Hr)',ylab = 'Water Level(m)',ylim=H_lim)
			#add boxplots
			kk = 0
			for(jj in istart:iend)
			{
				kk = kk + 1
				boxplot(Sim_test_data[i,,kk],at=jj,add=T)
				#add mean points
				points(jj,mean(Sim_test_data[i,,kk]),pch=1,col='red')
			}
			lines(istart:iend, test_data[istart:iend,i],type='l')
			lines(istart:iend,krige_test_data[i,],type='l',col='DarkGreen')

		}
		dev.off()
		if(write_data)
		{
			#write the locations of each point
			write.table(pred.grid,file=paste(file.path(output_folder,subdir_data),'/Grid_Coord.txt',sep=''),row.names=F,col.names=F)
			if(create_initial)
				write.table(domain.grid,file=paste(file.path(output_folder,subdir_data),'/Domain_Coord.txt',sep=''),row.names=F,col.names=F)	
			
			for(isamp in 1:nsamp)
			{
				BC_filename = paste(file.path(output_folder,subdir_data),'/BC_Data_Rel',isamp,'_',datafile,sep='')
				write.table(BC_data[,isamp,],file=BC_filename,row.names=F,col.names=F)
				###Inital condition
				if(create_initial)
				{
					init_filename = paste(file.path(output_folder,subdir_data),'/Initial_H_Rel',isamp,'_',datafile_intial,sep='')
					write.table(Init_data[,isamp],file=init_filename,row.names=F,col.names=F)
				}			
			}
		}
	}
}



