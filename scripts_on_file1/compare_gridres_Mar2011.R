
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/Mar2011/MeanField'
grid_res = c('120x120x30','240x240x60')
#grid_res = c('480x480x60','240x240x60')
paths = c('IFRC2')
#paths = c('A','B')
npath = length(paths)
nfields = 1     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
DataSet = 'Mar2011TT'
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 25
pheight = 25
plotfile = '_finer.jpg'

y_label = 'Tracer C/C0'
#y_convert = 1000.0/1.19 #for Mar2009 test
y_convert = 1000.0/5.9234 #Mar2011 test
NormTime_True = 1.0
NormConc_True = 187.0
time_start = 191.25 #Mar2011 test

#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix1 = paste(main_path,'/',paths[ipath],'/',grid_res[1],'/',sep='')
	a = readLines(paste(path_prefix1, prefix_file,'R1',ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))

	path_prefix2 = paste(main_path,'/',paths[ipath],'/',grid_res[2],'/',sep='')
	a2 = readLines(paste(path_prefix2, prefix_file,'R1',ext_file,sep=''),n=1)
	b2 = unlist(strsplit(a2,','))
	
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]


	for(ifield in seq(1,nfields))
	{
    		#read from files
		data1 = read.table(paste(path_prefix1, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t1 = data1[,1]- time_start
		data1[,2:(nvar+1)]=data1[,2:(nvar+1)]*y_convert
		data2 = read.table(paste(path_prefix2, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t2 = data2[,1]- time_start
		data2[,2:(nvar+1)]=data2[,2:(nvar+1)]*y_convert
		jpeg(paste(main_path,'/Comp_GridRes_',paths[ipath],'_',ifield, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		par(mfrow=c(6,7))
    		for (ivar in 1:nvar)
    		{
			varsplit = unlist(strsplit(varnames[ivar],' '))
			varsplit = unlist(strsplit(varsplit[1],'_'))
			well_name = varsplit[2]
			true_t = matrix(NA,1,1)
			true_BTC = matrix(NA,1,1)
	                #read in true data if it exists
	                true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
        	        true_exist = file.exists(true_file)
                	if(true_exist)
                	{
                        	truedata = read.table(true_file,skip=1)
                        	true_t = truedata[,1]/NormTime_True #time units converted to hours
                	        true_BTC = (truedata[,3]-mean(truedata[which(truedata[,1]<0),3]))/NormConc_True
        	        }
			#find the column in second file
			icol2 = grep(varnames[ivar],b2)
			ymax = max(max(data1[,(ivar+1)],na.rm=T),max(true_BTC,na.rm=T))
			ymax = max(max(data2[,icol2],na.rm=T),ymax)
			ymin = min(min(data1[,(ivar+1)],na.rm=T),min(true_BTC,na.rm=T))
			ymin = min(min(data2[,icol2],na.rm=T),ymin)

			plot(t1,data1[,(ivar+1)], main=paste(paths[ipath],': ',well_name,sep=''), xlab = b[1], ylab = y_label,xlim=c(0,1000), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
			points(t2,data2[,icol2],col='blue',type = 'b',lty='solid',lwd=linwd1)
			points(true_t,true_BTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
			if(ivar == 1)
				legend('topright',grid_res,lty=c('solid','solid'),col=c('red','blue'),lwd=c(linwd1,linwd1),bty='n')
	
		}
		dev.off()
	}
}
