
#This file is used for calculating transient boundary conditions at Hanford-300 area using universal kriging with linear drift
#only the kriged values at the boundaries are generated, when the data at 4 corner wells were available, they are included too

rm(list=ls())
library(geoR)
options(geoR.messages=FALSE)

input_folder = 'headdata4krige_Mar2011_wo121A'
output_folder = 'BC_UK_Mar2011_wo121A_IncludeCorner'
inputfile = paste(output_folder,'/PFLOTRAN_input_Mar2011.txt',sep='')

cov_model_sets = c('gaussian','wave','exponential')
drift_sets = c(0,1)

#nt=521
nt=1585
gridx = 1.0
gridy = 1.0
pred.grid1 = expand.grid(seq(0.5,119.5),c(0.5,119.5)) # for South and North boundaries
domain.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5)) # for the cell centers of entire domain

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
# for inital head surface (choose time =191h, 0.25 hour before injection of Mar2011 experiment
i.initial = 192

linwd1 = 1.5
linwd2 = 1.5
pwidth = 10
pheight = 10
#for(icov in 1:length(cov_model_sets))
for(icov in 3:3)
{
	cov_model = cov_model_sets[icov]
	#for(idrift in 1:length(drift_sets))
	for(idrift in 1:2)
	{
		drift = drift_sets[idrift]
		plotfile = paste(cov_model,'_drift',drift,'_Mar2011.jpg',sep='')

		BC_data = matrix(NA,nt,ngrid)
		Init_data = matrix(NA,nrow(domain.grid),1)
		pred_test_data = matrix(NA,nt,ntest)
		istart = 1

		for (i in istart:nt)
		{
			#data are stored in (Y,X,Head)
			data = read.table(paste(input_folder,'/time',i,'.dat',sep=''),header=F)
			temp = data[,1]
			data[,1] = data[,2]
			data[,2] = temp
			#check if any data is available at the test wells
			if(sum(!is.na(test_data[i,])))
			{
				idx_temp = which(!is.na(test_data[i,]))
				data_temp = matrix(0,length(idx_temp),3)
				data_temp[,1:2] = as.matrix(test_coord[idx_temp,])
				data_temp[,3] = c(test_data[i,idx_temp])
				data = rbind(data,data_temp)
			}
			colnames(data) = c('x','y','z')
			data = as.geodata(data)
			if(drift)
				bin1 = variog(data,uvec=seq(0,250,l=20),trend='1st',bin.cloud=T,estimator.type='modulus')
			if(!drift)
				bin1 = variog(data,uvec=seq(0,300,l=20),trend='cte',bin.cloud=T,estimator.type='modulus')

			#fit variogram model
			wls = variofit(bin1,ini = c(0.001,100), fix.nugget=T,cov.model=cov_model)
			jpeg(paste(output_folder,'/variogram_',(i-1),plotfile, sep = ''), width = 6, height = 5,units="in",res=150,quality=100)
			plot(bin1,main = paste('Time = ',i,'hrs',sep=''))
			lines(wls)
			dev.off()
			#plot.geodata(data)
			if(!drift)
				kc = krige.conv(data, loc = rbind(pred.grid,test_coord), krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
			if(drift)
				kc = krige.conv(data, loc = rbind(pred.grid,test_coord), krige = krige.control(obj.m=wls,type.krige='OK',trend.d='1st',trend.l='1st'))
			coeff1= as.vector(kc$beta.est)
			h_uk = as.vector(kc$predict[1:ngrid])
			BC_data[i,] = h_uk
			pred_test_data[i,] = as.vector(kc$predict[(1+ngrid):(ngrid+ntest)])
			if(i == i.initial)
			{
				if(!drift)
					kc1 = krige.conv(data, loc = domain.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
				if(drift)
					kc1 = krige.conv(data, loc = domain.grid, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='1st',trend.l='1st'))
				Init_data = as.vector(kc1$predict)					
			}
			#cat(iset,'\t',min_error,'\t',ceiling(min_error/400),'\t', min_error%%400,'\n')
			jpeg(paste(output_folder,'/BC_UK_',(i-1),plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
			par(mfrow=c(2,2))
			
			plot(seq(0,119), h_uk[1:ngrid4], main=paste('t=',(i-1),' hour, South',sep=''),xlab = "South Coord (m)", ylab = "Head(m)", xlim=c(0,120),type='l',frame.plot=F)	
			
			plot(seq(0,119), h_uk[(ngrid4+1):(ngrid4*2)], main=paste('t=',(i-1),' hour, North',sep=''),xlab = "North Coord (m)", ylab = "Head(m)", xlim=c(0,120),type='l',frame.plot=F)
			
			plot(seq(0,119), h_uk[(ngrid4*2+1):(ngrid4*3)], main=paste('t=',(i-1),' hour, West',sep=''),xlab = "West Coord (m)", ylab = "Head(m)", xlim=c(0,120),type='l',frame.plot=F)
			
			plot(seq(0,119), h_uk[(ngrid4*3+1):ngrid], main=paste('t=',(i-1),' hour, East',sep=''),xlab = "East Coord (m)", ylab = "Head(m)", xlim=c(0,120),type='l',frame.plot=F)	

			dev.off()
			
		}
		##plot the fitting between the predicted and measured water levels at testing wells
		jpeg(paste(output_folder,'/Validate_krige',plotfile, sep = ''), width = 10, height = 10,units="in",res=150,quality=100)
		par(mfrow = c(2,ceiling(ntest/2)))
		for(i in 1:ntest)
		{
			plot(test_data[,i],pred_test_data[,i],main=test_wells[i],xlab = 'Measured Water Level(m)',ylab = 'Predicted Water Level(m)')
			#add 1:1 line
			lines(c(100,110),c(100,110),col='red',lwd=2)
		}
		dev.off()

		####generate arrays for boundary conditions along each line
		write.table(BC_data,file=paste(output_folder,'/BC_Data_All_',cov_model,'_drift',drift,'.txt',sep=''),row.names=F,col.names=F)
		write.table(pred.grid,file=paste(output_folder,'/Grid_Coord.txt',sep=''),row.names=F,col.names=F)
		###Inital condition
		write.table(Init_data,file=paste(output_folder,'/Initial_Head_Data_',cov_model,'_drift',drift,'.txt',sep=''),row.names=F,col.names=F)
		write.table(domain.grid,file=paste(output_folder,'/Domain_Coord.txt',sep=''),row.names=F,col.names=F)				
	}
}



