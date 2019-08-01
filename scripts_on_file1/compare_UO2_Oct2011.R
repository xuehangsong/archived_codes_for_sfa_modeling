
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
comp_paths = c('Geochem_Oct2011_Hetero_InitU_2_R270','Geochem_Oct2011_Hetero_InitU_2_R432_AlterChem','Geochem_Oct2011_Hetero_InitU_2_R432')
#comp_col = c('black','red','blue','darkgreen','mediumorchid')
comp_legends = c('MR_R270','AlterChem_R432','MR_R432')
comp_col = c('red','blue','darkgreen')
testvariable = ' UO2'
BC = ''
npath = length(comp_paths)
fields = c(270,432,432)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
true_data_exist = T
plot_true = T   #whether to plot true observed curves
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
plotfile_name = 'Compare_MR_AlterChem_BestFitPerm'
plotfile = '_Oct2011.jpg'
x_lim = c(0,1000)
NormTime_True = 1.0 #normalization factor for time of true data
time_start = rep(168,npath) # for Oct2011 test

MeanData_exist = 0 #whether results from mean field exist
#read in true data
data_true = read.csv(paste(main_path,'TracerData_Oct2011.csv',sep=''),header=T)
# the columns are Well Name[1],Sample Time PDT[2],Elapsed Hr T1[3],Elapsed Hr T2[4],Temp- C[5],SpC- mS/cm[6],pH[7],U (ug/L)[8],F (mg/L)[9],Cl (mg/L)[10],
# NO2 (mg/L)[11],Br (mg/L)[12],SO4 (mg/L)[13],NO3 (mg/L)[14],Ca (ug/L)[15]
#filter data between time_low and time_upper

#convert the character strings
data_true[,1] = paste(data_true[,1]) # well names
data_true[,2] = paste(data_true[,2]) # sample time
# to force the well IDs to have the same format, e.g., change 2-5 to 2-05 
idx = which(nchar(data_true[,1]) < 4)
if(length(idx)>0)
{
	for (i in idx)
	{
		ctemp = substring(data_true[i,1],nchar(data_true[i,1]),nchar(data_true[i,1]))
		data_true[i,1] = paste(data_true[i,1],'0',sep='')
		substring(data_true[i,1],3,3)='0'
		substring(data_true[i,1],4,4)=ctemp	
	}
}

NormTime_True = 1.0
if(length(grep('Tracer1',testvariable))>0)
{
	true_col = 10
	NormConc_True = 110.0
	y_convert = 1000.0
	y_label = 'Cl- C/C0'
}

if(length(grep('Cl-',testvariable))>0)
{
	true_col = 10
	NormConc_True = 110.0
	y_convert = 1000.0*35.5/110.0
	y_label = 'Cl- C/C0'
}

if(length(grep('Tracer2',testvariable))>0)
{
	true_col = 12
	NormConc_True = 110.0
	y_convert = 1000.0
	y_label = 'Br- C/C0'
}

if(length(grep('Br-',testvariable))>0)
{
	true_col = 12
	NormConc_True = 110.0
	y_convert = 1000.0*80.0/110.0
	y_label = 'Br- C/C0'
}

if(length(grep('Tracer3',testvariable))>0)
{
	true_col = 9
	NormConc_True = 73.0
	y_convert = 1000.0
	y_label = 'F- C/C0'
}

if(length(grep('F-',testvariable))>0)
{
	true_col = 9
	NormConc_True = 73.0
	y_convert = 1000.0 * 19.0/73.0
	y_label = 'F- C/C0'
}

if(length(grep('UO2',testvariable))>0)
{
	true_col = 8
	NormConc_True = 1.0
	y_convert = 238.0*1000000.0
	y_label = 'U(VI) [ug/L]'
}


wells_plot = c('2-34','2-07','2-08','2-09','2-11','2-26','2-27','2-28','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','3-23','2-21','3-25','3-24','3-30','3-31','3-32','2-37','2-29','2-30','2-31','2-22','3-27','3-28','3-29','2-23','2-24')
#wells_plot = c('2-11','2-14','2-18','2-26','2-28','3-29','3-31')
nwell = length(wells_plot)

plot_nrow = 5
plot_ncol = 7

	for (ipath in 1:npath)
	{
		path_prefix = paste(main_path,'/',comp_paths[ipath],'/',sep='')
		input_file = paste(path_prefix, prefix_file,'R',fields[ipath],ext_file,sep='')
		a = readLines(input_file,n=1)
		b = unlist(strsplit(a,','))
	
		nvar = length(b)-1 #the first column is time
		varnames = b[-1]
		#find the columns needed
		varcols = array(NA,nwell,1)
		for (iw in 1:nwell)
			varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time

		#read from files
		input_data = read.table(input_file,skip=1) # the first line is skipped

		data0 = matrix(0,nrow(input_data),(nwell+1))
		data0[,1] = input_data[,1]- time_start[ipath]
		for (ivar in 1:nwell)
			data0[,(ivar+1)] = input_data[,varcols[ivar]]
		data0[,2:(nwell+1)] = data0[,2:(nwell+1)] * y_convert
		#remove the first row (sometimes the first row of flux averaged concentrations are 0 because of 0 velocities)
		data0 = data0[-1,]
		
		#store data from different cases in different names
		text1 = paste('data',ipath,'=data0',sep='')
		eval(parse(text = text1))
	}
		

	jpeg(paste(main_path,'/',plotfile_name,sub("^\\s+|\\s+$", "", testvariable), plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfcol=c(plot_nrow,plot_ncol),mar=c(3,3,3,3))
	for (iw in 1:nwell)
	{
		well_name = wells_plot[iw]
		#find the maximum y among th cases
		ymin = 5000
		ymax = 0
		for (ipath in 1:npath)
		{
			text1 = paste('data0 = data',ipath,sep='')
			eval(parse(text = text1))
			ymax = max(max(data0[,(iw+1)],na.rm=T),ymax)
			ymin = min(min(data0[,(iw+1)],na.rm=T),ymin)
		}
		if(plot_true)
		{
			if(true_data_exist)
			{
				true_idx = grep(well_name,data_true[,1])		
				if(length(true_idx)>0)
				{
					true_exist = T
					true_t = data_true[true_idx,3]/NormTime_True #time units converted to hours
					trueBTC = data_true[true_idx,true_col]/NormConc_True
					if(length(grep('Tracer2',testvariable))>0)
					trueBTC[which(true_t <191.6)] = 0.0
					if(length(which(true_t<0))>0&&length(grep('Tracer',testvariable))>0)
						trueBTC = trueBTC - mean(trueBTC[which(true_t <0)],na.rm=T)
				}
				ymax = max(ymax,max(trueBTC,na.rm=T))
				ymin = min(ymin,min(trueBTC,na.rm=T))				
			}
		}

		yrange = ymax - ymin
		ymax = ymax + 0.05*yrange
		ymin = ymin - 0.05*yrange
		#ymax = 1.1
		plot(data1[,1],data1[,(iw+1)], main=paste(BC,' ',wells_plot[iw],sep=''), xlab = b[1], ylab = y_label,xlim=x_lim, ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = comp_col[1],lty = 'solid')
		for(ipath in 2:npath) 
		{
			text1 = paste('data0 = data',ipath,sep='')
			eval(parse(text = text1))
			points(data0[,1],data0[,iw+1],col=comp_col[ipath],type = 'l',lty='solid',lwd=linwd1)
		}
		if(plot_true)
			points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		#points(data0[,1],data1[,(iw+1)]+data2[,(iw+1)]+data3[,(iw+1)]+data4[,(iw+1)]+data5[,(iw+1)],type='l',lty='dashed')

	}
			
	plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)
	legend('topleft',comp_legends,lty=rep('solid',times = npath),col=comp_col,lwd=rep(linwd1,times=npath),bty='n',cex=1.7)
	dev.off()
