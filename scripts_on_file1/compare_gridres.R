
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/Mar2011/MeanField'
grid_res = c('120x120x30','240x240x60')
paths = c('IFRC2')
#paths = c('A','B')
npath = length(paths)
nfields = 4     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 20
pheight = 20
plotfile = '.jpg'

y_label = 'Tracer C/C0'
y_convert = 1000.0/1.19

truedata_all = read.table('Mar2009/TracerData_Mar2009.txt',header=T)
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
		t1 = data1[,1]-100.0
		data1[,2:(nvar+1)]=data1[,2:(nvar+1)]*y_convert
		data2 = read.table(paste(path_prefix2, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t2 = data2[,1]-100.0
		data2[,2:(nvar+1)]=data2[,2:(nvar+1)]*y_convert
		jpeg(paste(main_path,'Comp_GridRes2_',paths[ipath],'_',ifield, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		par(mfrow=c(6,6))
    		for (ivar in 1:nvar)
    		{
			varsplit = unlist(strsplit(varnames[ivar],' '))
			varsplit = unlist(strsplit(varsplit[1],'_'))
			well_name = varsplit[2]
			true_t = matrix(NA,1,1)
			true_BTC = matrix(NA,1,1)
			true_loc = which(truedata_all[,1] == well_name) 
			if(length(true_loc)>0)
			{
				true_t = truedata_all[true_loc,2]/60.0 #time units converted to hours
				true_BTC = truedata_all[true_loc,3]/95.0
				idx = which(true_t>0)
				true_t = true_t[idx]
				true_BTC = true_BTC[idx]
			}
			ymax = max(max(data1[,(ivar+1)],na.rm=T),max(true_BTC,na.rm=T))
			ymax = max(max(data2[,(ivar+1)],na.rm=T),ymax)
			ymin = min(min(data1[,(ivar+1)],na.rm=T),min(true_BTC,na.rm=T))
			ymin = min(min(data2[,(ivar+1)],na.rm=T),ymin)

			plot(t1,data1[,(ivar+1)], main=paste(paths[ipath],': ',well_name,sep=''), xlab = b[1], ylab = y_label,xlim=c(0,300), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
			points(t2,data2[,(ivar+1)],col='blue',type = 'b',lty='solid',lwd=linwd1)
			points(true_t,true_BTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
			if(ivar == 1)
				legend('topright',grid_res,lty=c('solid','solid'),col=c('red','blue'),lwd=c(linwd1,linwd1),bty='n')
	
		}
		dev.off()
	}
}
