
#This file is used for plotting flux averaged Tracer and UO2 concentrations with single realization
# Tracer and UO2 are plotted together to show retardation effect

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
# paths = c(paste(main_path,'A_MR_Oct2009_0/',sep=''),paste(main_path,'A_MR_Oct2009_1/',sep=''),paste(main_path,'A_EQ_Oct2009_0/',sep=''),paste(main_path,'A_EQ_Oct2009_1/',sep=''))
testvariables = c('Tracer_','UO2')
true_col = c(3,2)
NormConc_True = c(210.0, 1.0) #for Mar2011 test
y_label = c('Tracer C/C0','U(VI) [ug/L]')
y_convert = c(1000.0/5.9234,238.0*1000000) #for Mar2011 test


#time_start = 191.25 #Mar2011 test
time_start = 24 #
MeanData_exist = 0 #whether results from mean field exist

BC = 'IFRC2'
DataSet = 'Mar2011TT'
plot_true = F
#paths = c(paste(BC,'_Tracer',sep=''))
paths = c('Premodel_Oct2011_10gpm')
npath = length(paths)
fields =  c(1)
nfields = length(fields)     # number of random fields
#prefix and extension of data files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
time_upper = 600
time_low = 0
linwd1 = 1.5
linwd2 = 1.5
pwidth =25 
pheight = 17
plotfile = '_MeanField.jpg'

#y_convert = 1000.0/2.25 # For tracer in Oct2009 test
#NormTime_True = 60.0
#NormConc_True = 180.0
#time_start = 255.5 #Oct2009 test

wells_plot = c('2-05','2-07','2-08','2-09','2-10','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-25','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-26','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
nwell = length(wells_plot)

#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	#loop through fields
	for(ifield in fields)
	{
		#read in data
		input_file = paste(path_prefix, prefix_file,'R',ifield,ext_file,sep='')
		a = readLines(input_file,n=1)
		b = unlist(strsplit(a,','))
		nvar = length(b)-1 #the first column is time
		varnames = b[-1]
		#find the columns needed
		varcols_1 = array(NA,nwell,1)
		varcols_2 = array(NA,nwell,1)
		varcols_tracer1 = array(NA,nwell,1)
		for (iw in 1:nwell)
		{
			varcols_1[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariables[1],varnames)) + 1 #the first column is time		
			varcols_tracer1[iw] = intersect(grep(wells_plot[iw],varnames),grep('Tracer1',varnames)) + 1 #the first column is time		
			varcols_2[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariables[2],varnames)) + 1 #the first column is time		
		}
    	#read from files
		data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t0 = data0[,1]-time_start
		data_1 = (data0[,varcols_1]-data0[,varcols_tracer1]) * y_convert[1]
		data_2 = data0[,varcols_2] * y_convert[2]	
		rm(data0)	

		#plot
		jpeg(paste(main_path,paths[ipath],'_',prefix_file, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		par(mfrow=c(5,8))
		for (ivar in 1:nwell)
		{
			well_name = wells_plot[ivar]
			if(plot_true)
			{
				truedata = matrix(NA,1,3)
				true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
				true_exist = file.exists(true_file)
				true_t = NA
				trueBTC_1 = NA
				trueBTC_2 = NA
				if(true_exist)
				{
						truedata = read.table(true_file,skip=1)
						true_t = truedata[,1]/NormTime_True #time units converted to hours
						trueBTC_1 = truedata[,true_col[1]]/NormConc_True[1]
						trueBTC_2 = truedata[,true_col[2]]/NormConc_True[2]
						if(length(grep('Tracer',testvariables[1])))
							trueBTC_1 = (truedata[,true_col[1]]-mean(truedata[which(truedata[,1]<0),true_col[1]]))/NormConc_True[1]
						if(length(grep('Tracer',testvariables[2])))
							trueBTC_2 = (truedata[,true_col[2]]-mean(truedata[which(truedata[,1]<0),true_col[2]]))/NormConc_True[2]						
				}
			}

			plot(t0,data_1[,ivar],main=well_name,xlab="",ylab="",xlim=c(time_low,time_upper),ylim=c(0,1),type='l',col='red',lty='solid',lwd=linwd1,axes=FALSE)
			if(plot_true)
				lines(true_t,trueBTC_1, col='black',type = 'b', lty='solid', pch=1, lwd=linwd1)
			axis(2,col="black",las=1)  ## las=1 makes horizontal labels
			mtext(y_label[1],side=2,line=2.5)
			## Allow a second plot on the same graph
			par(new=TRUE)
			## Plot the second plot and put axis scale on right
			plot(t0,data_2[,ivar], xlab="", ylab="",xlim=c(time_low,time_upper),ylim=c(0,max(data_2[,ivar],na.rm=T)+1),axes=FALSE, type='l',col='gold4',lty='solid')	
			if(plot_true)
				lines(true_t, trueBTC_2, lwd=linwd1,type="b",lty='solid', pch=2,col="chocolate")		
## a little farther out (line=4) to make room for labels
			mtext(y_label[2],side=4,col="chocolate",line=2.5) 
			axis(4, col="chocolate",col.axis="chocolate",las=1)
			
## Draw the time axis
			axis(1,at=seq(time_low,time_upper,50))
			mtext("Time [Hours]",side=1,col="black",line=2.5) 
		}
		plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)
		if(plot_true)	
			legend("topleft",c("Tracer_true","Tracer_sim",'UO2_true','UO2_sim'), lty=c('solid','solid','solid','solid'),col=c('black','red','chocolate','gold4'),lwd=c(linwd1,linwd1,linwd1,linwd1),pch=c(1,-1,2,-1), cex=2.5, bty='n')
		if(!plot_true)	
			legend("topleft",c("Tracer_sim",'UO2_sim'), lty=c('solid','solid'),col=c('red','gold4'),lwd=c(linwd1,linwd1), cex=2.5, bty='n')
		
		dev.off() 	
	}
}
