
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
path_prefix = '/files1/scratch/chenxy/120x120x30/Oct2009/A_MR_0/'

#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 8
pheight = 5
plotfile = '.jpg'


#read in river stage data
riverstage =  read.table('RiverStage_Oct2009.txt',skip=1)
stage.t = riverstage[,1]/60.0
stage = riverstage[,2]

#read the headers in the first file and determine what variables are available
a = readLines(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),n=1)
b = unlist(strsplit(a,','))
nvar = length(b)-1 #the first column is time
varnames = b[-1]

#######plots#################
for (ivar in 1:nvar)
{
	varsplit = unlist(strsplit(varnames[ivar],' '))
	well_name = varsplit[1]
	species = varsplit[2]
	truedata = matrix(NA,1,3)
#read in true data if it exists		
	true_exist = file.exists(paste(well_name,'_Oct2009TT.txt',sep=''))
	if(true_exist)
		truedata = read.table(paste(well_name,'_Oct2009TT.txt',sep=''),skip=1)
	true_t = truedata[,1]/60.0 #time units converted to hours
	if(length(grep('U',species)) > 0) 
	{
		trueBTC = truedata[,2]
		y_label = 'U(VI) [ug/L]'
		legend.loc = 'bottomright'
		y_convert = 238.0*1000000
	} 
	if(length(grep('T',species)) > 0) 
	{
		trueBTC = truedata[,3]/180.0
		y_label = 'Tracer C/C0'
		legend.loc = 'topright'
		y_convert = 1000.0/2.25
	}
	jpeg(paste('TrueData_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mar=c(5, 4, 4, 6) + 0.1)
	plot(true_t,trueBTC,main=varnames[ivar],xlab="",ylab="",xlim=c(-50,400),col='black',type = 'b',lty='solid',lwd=linwd1,pch=1,axes=FALSE)
	axis(2,col="black",las=1)  ## las=1 makes horizontal labels
	mtext(y_label,side=2,line=2.5)
	## Allow a second plot on the same graph
	par(new=TRUE)
	## Plot the second plot and put axis scale on right
	plot(stage.t, stage, xlab="", ylab="",xlim=c(-50,400), ylim=c(104,107),axes=FALSE, type="l", col="blue")	
 
	## a little farther out (line=4) to make room for labels
	mtext("River Stage [m]",side=4,col="blue",line=4) 
	axis(4, ylim=c(104,107), col="blue",col.axis="blue",las=1)
 
	## Draw the time axis
	axis(1,at=seq(-50,400,50))
	mtext("Time [Hours]",side=1,col="black",line=2.5)  
	dev.off() 	
	
}

