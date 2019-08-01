
#This file is used for plotting Oct 2011 tracer and high U tests data

rm(list=ls())

#set the path to the files
path_prefix = './'
WL_path = '/Users/chen737/work/Data/'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
separate = 0  
plot_cols = c('black','darkgreen','magenta4','chocolate')

time_upper = 600
time_low = -150
NormTime_True = 1.0 #normalization factor for time of true data
NormUO2_True = 1.0
NormTracer_True = 100.0
#time_start = 255.5 # for Oct2009 test
time_start = 191.25 # for Mar2011 test
plotfile = paste('Oct2011_upto',time_upper,'hr.jpg',sep='')

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

#read in test data
data_all = read.csv(paste(path_prefix,'TracerData_Oct2011.csv',sep=''),header=T)
# the columns are Well Name[1],Sample Time PDT[2],Elapsed Hr T1[3],Elapsed Hr T2[4],Temp- C[5],SpC- mS/cm[6],pH[7],U (ug/L)[8],F (mg/L)[9],Cl (mg/L)[10],
# NO2 (mg/L)[11],Br (mg/L)[12],SO4 (mg/L)[13],NO3 (mg/L)[14],Ca (ug/L)[15]
#filter data between time_low and time_upper
data_all = data_all[which(data_all[,3]<=time_upper & data_all[,3]>=time_low),]


#convert the character strings
data_all[,1] = paste(data_all[,1]) # well names
data_all[,2] = paste(data_all[,2]) # sample time
# to force the well IDs to have the same format, e.g., change 2-5 to 2-05 
idx = which(nchar(data_all[,1]) < 4)
if(length(idx)>0)
{
	for (i in idx)
	{
		ctemp = substring(data_all[i,1],nchar(data_all[i,1]),nchar(data_all[i,1]))
		data_all[i,1] = paste(data_all[i,1],'0',sep='')
		substring(data_all[i,1],3,3)='0'
		substring(data_all[i,1],4,4)=ctemp	
	}
}
library(timeDate)
#convert the format of measurement time
meas_time_1 = as.Date(data_all[,2], format = '%m/%d/%y %H:%M')
meas_time = timeDate(meas_time_1, format = '%m/%d/%y %H:%M')
doy = dayOfYear(meas_time)
#the wells that have measurements
data_wells = sort(unique(data_all[,1]))
# U concentration
U_data = data_all[,8]
Br_data = data_all[,12]
Cl_data = data_all[,10]
Fl_data = data_all[,9]
SpC_data =data_all[,6]*1000.0  #convert to uS/cm


#read in river stage data
data_WL =  read.csv(paste(WL_path,'2-10_WLData_2011.csv',sep=''),header=T)
data_WL[,1] = paste(data_WL[,1])

date_WL = as.Date(data_WL[,1],format = '%d-%b-%Y %H:%M:%S')
datetime_WL = timeDate(data_WL[,1],format = '%d-%b-%Y %H:%M:%S')

#find the water elevation data at the measured times
n_meas = nrow(data_all)
H_data = matrix(0,n_meas,1)

for ( i in 1:n_meas)
	H_data[i] = data_WL[which(datetime_WL == round(meas_time[i],"h")),2]

#normalize water level data
H_min = min(H_data,na.rm=T)
H_max = max(H_data,na.rm=T)
H_scaled = (H_data - H_min)/(H_max - H_min)

#plots
if(!separate)
{
	jpeg(paste(path_prefix,'TrueData_', plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow = c(6,7), mar=c(3, 3, 3, 4) + 0.1)
}
yy_at = seq(0,1.0,0.2)
for (iw in 1:length(data_wells))
{
	well_name = data_wells[iw]
	idx = grep(well_name,data_all[,1])
	if(separate)
	{
		jpeg(paste(path_prefix,'TrueData_', well_name, plotfile, sep = ''), width = 4, height = 3.6,units="in",res=250,quality=100)
		par(mar=c(3.5, 3, 3, 3.5) + 0.1)
	}
	plot(data_all[idx,3],Br_data[idx]/NormTracer_True,main=well_name,xlab="",ylab="",xlim=c(time_low,time_upper),ylim=c(0,1.1),col=plot_cols[1],type = 'b',lty='solid',lwd=linwd1,pch=1,axes=FALSE)
	lines(data_all[idx,3],Cl_data[idx]/NormTracer_True,type='b',pch=1,col=plot_cols[2])
	lines(data_all[idx,3],Fl_data[idx]/NormTracer_True,type='b',pch=3,col=plot_cols[3])	
#	lines(data_all[idx,3],H_scaled[idx],col='blue')
#	add vertical lines that indicate the injections
	abline(v=0,col=plot_cols[2],lwd=1.5)
	abline(v=191.6,col=plot_cols[1],lwd=1.5)
	abline(v=694,col=plot_cols[3],lwd=1.5)
#	grid(62,NA)
	axis(2,col="black",las=1, at=yy_at)  ## las=1 makes horizontal labels
#	axis(2,col='blue',las=1,line=2.5,at=yy_at)
	mtext('Normalized Tracer',side=2,line=2.5)
	## Allow a second plot on the same graph
	par(new=TRUE)
	## Plot the second plot and put axis scale on right
	yticks2 = pretty(0:max(max(U_data[idx],na.rm=T)+1,50))
	plot(data_all[idx,3], U_data[idx], xlab="", ylab="",xlim=c(time_low,time_upper),ylim=c(min(yticks2),max(yticks2)),axes=FALSE, type="b",pch=2, col=plot_cols[4])
	#lines(c(time_low-100,time_upper+100),c(30,30),lty='dashed',col = 'red')	
 
	## a little farther out (line=4) to make room for labels
	#mtext("U(VI) [ug/L]",side=4,col="chocolate",line=2.5) 
	axis(4, col="chocolate",col.axis="chocolate",las=1,at=yticks2)

	## Draw the time axis
	axis(1,at=seq(time_low,time_upper,100))
	mtext("Time [Hours]",side=1,col="black",line=2.5) 
	if(separate){ 
		legend("topright",c('Br','Cl','Fl','U(VI)'), lty=c('solid','solid','solid','solid'),pch=c(1,1,3,2),col = plot_cols,cex=1.2, bty='n')
		dev.off() 
	}	
	
}

if(!separate){
	legend("topright",c('Br','Cl','Fl','U(VI)'), lty=c('solid','solid','solid','solid'),pch=c(1,1,3,2),col = plot_cols,cex=1.2, bty='n')
	dev.off() 
}	
