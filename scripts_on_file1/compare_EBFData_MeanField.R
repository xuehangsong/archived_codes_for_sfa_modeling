
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/120x120x30/Oct2009/'
testvariables = c('UO2_Oct2009','Tracer_Oct2009')
ntest = length(testvariables)
paths = c('UK_MR_0/MeanField','UK_MR_0_newEBF/MeanField')
npath = length(paths)

fields = c(1)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth =25 
pheight = 25
plotfile = '.jpg'
plotfile_pre = 'Comp_EBF_MeanField_'
legend_name = c('Old_EBF','New_EBF')
for (itest in 1:ntest)
{
	testvariable = testvariables[itest]

	if(length(grep('UO2',testvariable)) > 0)
	{
		norm_true = 1.0
		y_label = 'U(VI) [ug/L]'
		y_convert = 238.0*1000000
		true_col = 2
	}
	if(length(grep('Tracer',testvariable)) > 0)
	{
		norm_true = 180.0
		y_label = 'Tracer C/C0'
		y_convert = 1000.0/2.25
		true_col = 3
	}

	#read the headers in the first file and determine what variables are available
	path_prefix1 = paste(main_path,paths[1],'/',sep='')
	a = readLines(paste(path_prefix1, prefix_file,'R',fields[1],ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]

	path_prefix2 = paste(main_path,paths[2],'/',sep='')
	a2 = readLines(paste(path_prefix2, prefix_file,'R',fields[1],ext_file,sep=''),n=1)
	b2 = unlist(strsplit(a2,','))

	col_id = numeric(nvar)
	for (ivar in 1:nvar)
		col_id[ivar] = match(varnames[ivar],b2)

	#read in all the data
	for(ifield in fields)
	{
		#read from files
		data1 = read.table(paste(path_prefix1, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t1 = data1[,1]-255.0
		data2 = read.table(paste(path_prefix2, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t2 = data2[,1]-255.0

		jpeg(paste(main_path,plotfile_pre,testvariable, 'R',ifield, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		par(mfrow=c(6,6))
		for (ivar in 1:nvar)
        {
        	varsplit = unlist(strsplit(varnames[ivar],' '))
        	well_name = varsplit[1]
        	species = varsplit[2]
			# only deals with tracer data
			if(length(grep('Tracer',testvariable)) > 0)
				if(length(grep('U',species)) > 0) next
			if(length(grep('UO2',testvariable)) > 0)
				if(length(grep('T',species)) > 0) next

        	truedata = matrix(NA,1,3)
		#read in true data if it exists         
        	true_exist = file.exists(paste('TrueData_Oct2009TT/',well_name,'_Oct2009TT.txt',sep=''))
        	if(true_exist)
                	truedata = read.table(paste('TrueData_Oct2009TT/',well_name,'_Oct2009TT.txt',sep=''),skip=1)
        	true_t = truedata[,1]/60.0 #time units converted to hours
			trueBTC = truedata[,true_col]/norm_true

			BTC1 = data1[,(ivar+1)] * y_convert
			BTC2 = data2[,col_id[ivar]] * y_convert
			ymax = max(max(BTC1,na.rm=T),max(trueBTC,na.rm=T))
			ymin = min(min(BTC1,na.rm=T),min(trueBTC,na.rm=T))
			ymax = max(ymax,max(BTC2,na.rm=T))
			ymin = min(ymin,min(BTC2,na.rm=T))
			yrange = ymax - ymin
			ymax = ymax + 0.05*yrange
			ymin = ymin - 0.05*yrange
			plot(t1,BTC1, main=paste('MeanField: ',well_name,sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid',bty="n") 
			lines(t2,BTC2,lwd=linwd1,col='blue',lty='solid')
			points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		}
		plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)	
		legend("topleft",legend_name, lty=c('solid','solid','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), cex=2.5, bty='n')
		dev.off()
	}
}
	
