
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
path_prefix = 'TrueData_Mar2011TT/'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 17
pheight = 11
plotfile = '_Mar2011.jpg'
separate = TRUE  

NormTime_True = 1.0 #normalization factor for time of true data
NormUO2_True = 1.0
NormTracer_True = 210.0
#time_start = 255.5 # for Oct2009 test
time_start = 191.25 # for Mar2011 test

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

#read in river stage data
waterlevel =  read.table(paste(path_prefix,'WL_2-10_Mar2011TT.txt',sep=''),skip=1)
#normalize water level data
WL_min = min(waterlevel[,2])
WL_max = max(waterlevel[,2])
waterlevel[,2] = (waterlevel[,2] - WL_min)/(WL_max - WL_min)

if(!separate)
{
	jpeg(paste(path_prefix,'TrueData_', plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow = c(5,7))
}
for (iw in 1:length(wells))
{
	well_name = substring(wells[iw],5,8)
	truedata = matrix(NA,1,3)
	true_file = paste(path_prefix,'Well_',well_name,'_Mar2011TT.txt',sep='')
	true_exist = file.exists(true_file)
	if(!true_exist)
		next
	truedata = read.table(true_file,skip=1)
	true_t = truedata[,1]/NormTime_True #time units converted to hours
	true_UO2 = truedata[,2]/NormUO2_True	
	true_tracer = (truedata[,3]-mean(truedata[which(truedata[,1]<0),3]))/NormTracer_True
	if(separate)
	{
		jpeg(paste(path_prefix,'TrueData_', well_name, plotfile, sep = ''), width = 7, height = 5,units="in",res=150,quality=100)
		par(mar=c(5, 4, 4, 6) + 0.1)
	}
	plot(true_t,true_tracer,main=well_name,xlab="",ylab="",xlim=c(-50,1200),ylim=c(0,1),col='black',type = 'b',lty='solid',lwd=linwd1,pch=1,axes=FALSE)
	lines(waterlevel[,1],waterlevel[,2],col='blue')
	grid(54,NA)
	axis(2,col="black",las=1)  ## las=1 makes horizontal labels
	mtext('Normalized Tracer, WL',side=2,line=2.5)
	## Allow a second plot on the same graph
	par(new=TRUE)
	## Plot the second plot and put axis scale on right
	plot(true_t, true_UO2, xlab="", ylab="",xlim=c(-50,1200),ylim=c(0,max(true_UO2,na.rm=T)+1),axes=FALSE, type="l", col="chocolate")	
 
	## a little farther out (line=4) to make room for labels
	mtext("UVI [ug/L]",side=4,col="chocolate",line=4) 
	axis(4, col="chocolate",col.axis="chocolate",las=1)
 
	## Draw the time axis
	axis(1,at=seq(-50,1200,50))
	mtext("Time [Hours]",side=1,col="black",line=2.5) 
	if(separate) 
		dev.off() 	
	
}

if(!separate) 
	dev.off() 	
