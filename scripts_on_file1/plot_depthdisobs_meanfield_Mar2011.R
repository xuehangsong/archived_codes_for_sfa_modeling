
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/Mar2011/MeanField/'
paths = c('IFRC2')
grid_res = '120x120x30'
npath = length(paths)
fields = c(1)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_output'
ext_file = '.dat'
DataSet = 'Mar2011TT'
#plotting specifications
linwd1 = 1.5
linwd2 = 1.0
pwidth = 5
pheight = 5
plotfile = '.jpg'
#pwidth = 4.5
#pheight = 4
#plotfile = '.eps'
y_label = 'Tracer C/C0'
#y_convert = 1000.0/1.19 #for Mar2009 test
y_convert = 1000.0/5.9234 #Mar2011 test
NormTime_True = 1.0
NormConc_True = 210.0
time_start = 191.25 #Mar2011 test

wells = c('2-07','2-08','2-09','2-10','2-11','2-15','2-18')
nwell = length(wells)
#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{

	for(ifield in fields)
	{
    		#read from files
		path_prefix = paste(main_path,paths[ipath],'/',grid_res,'/',sep='')
		file_name = paste(path_prefix, prefix_file,'R',ifield,ext_file,sep='')
		a = readLines(file_name,n=1)
		b = unlist(strsplit(a,','))
		varnames = b
		Tracer_cols = grep('Tracer',varnames)
		n_tracer = length(Tracer_cols)
		data0 = read.table(file_name,skip=1) # the first line is skipped
		t0 = data0[,1] - time_start
		nt = length(t0)
		#plots 
		#jpeg(paste(main_path,'DepthDis_MeanField',ifield,'_',grid_res, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		#par(mfrow = c(6,7))

		for (iw in 1:nwell)
		{
			jpeg(paste(main_path,'DepthDis_',wells[iw],plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
			well_cols = grep(wells[iw],varnames) #find columns for the given well
			if(length(well_cols)<1)
				next
			col_vars = array(NA,0,0) #variable names for each column
			pt_dep = array(NA,0,0) #obs pt for each column			
			for (icol in well_cols)
			{
				varsplit = unlist(strsplit(varnames[icol],paste(' Well_',wells[iw],'_',sep='')))
				col_vars = c(col_vars, varsplit[1])
				varsplit2 = unlist(strsplit(varsplit[2], ' '))
				varsplit3 = unlist(strsplit(varsplit2[length(varsplit2)],')'))
				pt_dep = c(pt_dep, varsplit3[1])
			}
			pt_dep = as.numeric(pt_dep)
			pts = unique(pt_dep)
			#horizontal flux at each point
			flux = matrix(0,nt,length(pts)) 
			conc = matrix(0,nt,length(pts)) 
			k = 1 
			for (ipt in pts)
			{
				ivx = which((pt_dep == ipt) & (substr(col_vars,1,3) == 'vlx'))
                                ivy = which((pt_dep == ipt) & (substr(col_vars,1,3) == 'vly'))
				ic = which((pt_dep == ipt) & (substr(col_vars,1,3) == 'Tra'))
                                flux[,k] = sqrt(data0[,well_cols[ivx]]^2 + data0[,well_cols[ivy]]^2)
				conc[,k] = data0[,well_cols[ic]]
				k = k + 1
			}
			conc = conc * y_convert
    			ymin = min(conc,na.rm=T)
        		ymax = max(conc,na.rm=T)
			
			flux_wt = t(scale(t(flux),center=F,scale = rowSums(flux))) 
			# for the first point equal weights because they are all zero
			flux_wt[1,] = 1.0/length(pts)
                        true_t = matrix(NA,1,1)
                        true_BTC = matrix(NA,1,1)
                        #read in true data if it exists
                        true_file = paste('TrueData_',DataSet,'/Well_',wells[iw],'_',DataSet,'.txt',sep='')
                        true_exist = file.exists(true_file)

    			if(true_exist)
                        {
                                truedata = read.table(true_file,skip=1)
                                true_t = truedata[,1]/NormTime_True #time units converted to hours
                                true_BTC = (truedata[,3]- mean(truedata[which(truedata[,1]<0),3]))/NormConc_True
                     		ymax = max(ymax,max(true_BTC,na.rm=T))
                        	ymin = min(ymin,min(true_BTC,na.rm=T))
                        }
			yrange = ymax -ymin
			ymin = ymin - 0.05 * yrange
			ymax = ymax + 0.05 * yrange
			#reorganize the data so that qplot can be used
			plot_t = rep(t0,times = length(pts))
			flux_wt = matrix(flux_wt,,1)
			conc = matrix(conc,,1)
			depths = rep(pts, each = nt)
			#plot
			library(ggplot2) 
			qplot(plot_t,conc, main=paste(paths[ipath],': ',wells[iw],sep=''), xlab = b[1], ylab = 'Tracer C/C0',xlim=c(0,1000), ylim = c(ymin, ymax), colour = factor(depths),size = flux_wt) + geom_line(aes(true_t,true_BTC),col='black')
		#legend("topleft",c("Mean","95% CI",'True'), lty=c('solid','dashed','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), bty='n')
			dev.off()
		}
	}
}

