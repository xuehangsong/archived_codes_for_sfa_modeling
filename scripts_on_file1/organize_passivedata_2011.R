
#This file is used to analyze passive experimental data in 2010 and 2011 at Hanford IFRC 

rm(list=ls())
library(fields)
include_inj = TRUE
U_data = read.table('U_Conc_2011.csv',skip=1,sep=",") # the columns are: date, U_Conc in multiple wells
U_data[,1]=paste(U_data[,1])
a1 = readLines('U_Conc_2011.csv',n=1)
headers1 = unlist(strsplit(a1,','))
meas_time = read.table('MeasTime_Passive_2011.csv',skip=1,sep=",")
meas_time[,1] = paste(meas_time[,1])
#remove unnecessary 0
n_time = length(meas_time[,1])
for(i in 1:n_time)
{
	char_temp = meas_time[i,1]
	a1 = unlist(strsplit(char_temp,'/'))
	a1 = as.integer(a1)
	meas_time[i,1] = paste(a1[1],'/',a1[2],'/',a1[3],sep='')
}
	
	
meas_time[,2] = paste(meas_time[,2])
path_prefix = '../Mar2011/TrueData_Mar2011TT/'
output_prefix = 'U_data_2011/'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
plot_ext = '.jpg'
separate = 1  
plot_cols = c('red','blue')

time_upper = 3200
time_low = -50
NormTime_True = 1.0 #normalization factor for time of true data
NormUO2_True = 1.0
NormTracer_True = 210.0

well_data = read.table(paste(path_prefix,'well_list_full.txt',sep=''),skip=1) #the columns are well_ID, x,y, elev(m),borehole IDs,top_screen_depth, bot_screen_depth, H/R contact detpth(ft, from Gamma log)
well_data[,1] = paste(well_data[,1]) #convert well IDs to string
wells = well_data[,1]
# to force the well IDs to have the same format, e.g., change 399-2-5 to 399-2-05 
idx = which(nchar(wells) < 8)
if(length(idx)>0)
{
	for (i in idx)
	{
		ctemp = substring(wells[i],nchar(wells[i]),nchar(wells[i]))
		wells[i] = paste(wells[i],'0',sep='')
		substring(wells[i],7,7)='0'
		substring(wells[i],8,8)=ctemp	
	}
}

	
#read in BEU data 
BEU_data = read.table('BEU_Data.txt',skip=1) #columns are name,x,y,z,BEU
BEU_data[,1] = paste(BEU_data[,1]) 
BEU_min = 0
BEU_max = 8

####read in lithology data
#columns are wells,	y,x,TopDepth(ft),BotDepth(ft),Lithofacies
Litho_data = read.table('lithofacies.txt',skip = 1)
Litho_data[,1] = paste(Litho_data[,1])

#convert the depth to elevation
for (i in 1:length(Litho_data[,1]))
{
	elev = well_data[grep(Litho_data[i,1],wells),4]
	Litho_data[i,4] = elev - 0.3048 * Litho_data[i,4]
	Litho_data[i,5] = elev - 0.3048 * Litho_data[i,5]
}


#read in river stage data
waterlevel_210 =  read.table(paste(path_prefix,'WL_2-10_Mar2011TT.txt',sep=''),skip=1)

WL_min = 103
WL_max = 109

#combine the injection test data with passive monitoring data for each well
for (iw in 1:length(wells))
{
	well_name = substring(wells[iw],5,8)
	#input injection data if available
	truedata = matrix(NA,1,3)
	true_file = paste(path_prefix,'Well_',well_name,'_Mar2011TT.txt',sep='')
	true_exist = file.exists(true_file)
	#input passive data if available
	passive_exist = F
	idx1 = grep(well_name,headers1)
	if(length(idx1)>0)
		passive_exist = T
	if(!true_exist && !passive_exist)
		next
	true_t = array(0,c(0,1))
	true_UO2 = array(0,c(0,1))
	if(true_exist)
	{
		truedata = read.table(true_file,skip=1)
		true_t = truedata[,1]/NormTime_True #time units converted to hours
		true_UO2 = truedata[,2]/NormUO2_True	
	}
	if(passive_exist)
	{
		passive_date = U_data[,1]
		passive_t = matrix(NA,length(passive_date),1)
		for (idate in 1:length(passive_date))
		{
			idx2 = intersect(grep(well_name,meas_time[,2]),grep(passive_date[idate],meas_time[,1]))
			if(length(idx2)<1)
				next
			passive_t[idate] = meas_time[idx2,3]
		}
		passive_UO2 = U_data[,idx1]/NormUO2_True	
		true_t = c(true_t,passive_t)
		true_UO2 = c(true_UO2,passive_UO2)

	}
	
	waterlevel = waterlevel_210
	#interpolate water levels at the measurement times
	ids = which(is.na(waterlevel[,2]) == 0) #the points used for interpolation
	WL_interp = approx(waterlevel[ids,1],waterlevel[ids,2],xout = true_t,rule = 1)$y
	temp_data = data.frame(true_t,WL_interp,true_UO2)
	colnames(temp_data) = c('Elapsed_Time[hr]','WL[m]','UO2[ug/L]')
	write.table(temp_data,file=paste(output_prefix,'Well_',well_name,'_Mar2011UO2.txt',sep=""),row.names=F,col.names=T)
	#generate time series plots
	jpeg(paste('UTimeSeries_2011_',well_name,plot_ext,sep=''), width = 15, height = 10,units="in",res=200,quality=100)
	split.screen(rbind(c(0.03, 0.8,0.1, 0.98), c(0.81,0.98, 0.1, 0.98)))
	screen(1)
	plot(true_t,true_UO2,xlim=c(time_low,time_upper),xlab="", ylab="",main=well_name,type='b',pch=2,col=plot_cols[1],axes=FALSE)
	#axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	axis(side = 1, cex.axis = 1.0)
	mtext("Elapsed Time [hr]",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	
	#add another axis for water levels

	par(new=TRUE)
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	plot(true_t, WL_interp, xlab="", ylab="",xlim=c(time_low,time_upper),ylim = c(WL_min,WL_max),axes=FALSE, type="l",lty='dashed', col=plot_cols[2])
	axis(4, col=plot_cols[2],col.axis=plot_cols[2],line=-1)
	mtext("Elevations[m]",side=4,col=plot_cols[2],line=1) 
	legend("topleft",c('U2011','WL2011'), lty=c('solid','dashed'),pch=c(2,-1),col=plot_cols,cex=1.2, bty='n')
	screen(2)
	
	#plot BEU profiles when available
	idx = grep(well_name,BEU_data[,1]) 
	if(length(grep('3-30',well_name)))
		idx = grep('3-31',BEU_data[,1])	
	if(length(grep('2-29',well_name)))
		idx = grep('3-30',BEU_data[,1])	
		
	idx.sort = sort(BEU_data[idx,4],index.return=T)$ix
	idx = idx[idx.sort]
	#columns are wells,	y,x,TopDepth(ft),BotDepth(ft),Lithofacies
	lithodata = matrix(NA,1,3)
	ik.litho = grep(well_name,Litho_data[,1])
	if(length(ik.litho) > 0)
	{
		lithodata = matrix(0,length(ik.litho),3)
		lithodata[,1] = Litho_data[ik.litho,4]
		lithodata[,2] = Litho_data[ik.litho,5]
		lithodata[,3] = Litho_data[ik.litho,6]
		litho_loc = BEU_max - 1.5
		plot(BEU_data[idx,5],BEU_data[idx,4],xlim=c(BEU_min,BEU_max),ylim=c(WL_min,WL_max),type='b',pch=1,col="Chocolate",ylab = '',xlab='BEU[ug/g]',main=well_name,bty='n')
		for (kk in 1:length(ik.litho))
		{
			rect(litho_loc,lithodata[kk,2],litho_loc+1.5,lithodata[kk,1],border='DarkGreen')
			text(litho_loc+0.5,0.5*(lithodata[kk,1]+max(lithodata[kk,2],WL_min+0.5)),Litho_data[ik.litho[kk],6])
		}
		
	}
	else
		plot(BEU_data[idx,5],BEU_data[idx,4],xlim=c(BEU_min,BEU_max),ylim=c(WL_min,WL_max),type='b',pch=1,col="Chocolate",ylab = '',xlab='BEU[ug/g]',main=well_name)
	close.screen(all.screens = TRUE)
	dev.off()

}


