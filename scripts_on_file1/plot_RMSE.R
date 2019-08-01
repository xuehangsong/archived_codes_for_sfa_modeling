
#This file is used for plotting RMSE in selected wells for all parameter sets and find the best-fit realization

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths = c('A','B','C','D','E','F','G','H','IFRC2')
paths = c('Tracer_Mar2011_UK_Inv')
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
npath = length(paths)
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
testvariable = 'Tracer'
DataSet = 'Mar2011TT'
fields = 1:40000
group_ids = rep(1:200,each = 200)
#fields = 10801:11000
#group_ids = rep(55,each = 200)
group_ids = as.factor(group_ids)
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
#pwidth = 10.5
#pheight = 7.5
plotfile = 'All_Wells.jpg'
y_label = 'Tracer C/C0'
true_col = 3
NormConc_True = 210.0  # Mar2011 test
NormTime_True = 1.0
y_convert = 1000.0/5.9234 #Mar2011 test, injected tracer
time_start = 0.25 #Mar2011 test

wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
nwell = length(wells)
select_wells = wells  #selected wells for calculating RMSE
nselect = length(select_wells)
#wells_plot = c('2-07','2-08','2-14','2-26','2-27','2-28','3-23','3-25','3-35')
wells_plot = select_wells
nplot = length(wells_plot)
nt_obs_orig = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
time_upper = 1000
for (ivar in 1:nwell)
{
       well_name = wells[ivar]
       true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
       truedata = read.table(true_file,skip=1)
       true_t = truedata[,1]/NormTime_True #time units converted to hours
       trueBTC = truedata[,true_col]/NormConc_True
       if(length(grep('Tracer',testvariable)))
             trueBTC = (truedata[,true_col]-mean(truedata[which(truedata[,1]<0),true_col]))/NormConc_True
       nt_obs_orig[ivar] = length(true_t)
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC) 
}
#the ids of each selected well
idx_wells = array(0,c(nselect,1))
for (iw in 1:nselect)
	idx_wells[iw] = grep(select_wells[iw],wells)
 
#the ids of each selected well for plotting
idx_plotwells = array(0,c(nplot,1))
for (iw in 1:nplot)
	idx_plotwells[iw] = grep(wells_plot[iw],wells)
for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
        #load(paste(path_prefix,'Square_error_par55.Rdata',sep=''))
        load(paste(path_prefix,'Square_error_1to40000.Rdata',sep=''))
        #SE_part1 = SE_all
        #load(paste(path_prefix,'Square_error_10001to20000.Rdata',sep=''))
	#SE_part2 = rbind(SE_part1,SE_all)
        #load(paste(path_prefix,'Square_error_20001to23800.Rdata',sep=''))
	#SE_all   = rbind(SE_part2,SE_all)
	#rm(SE_part1,SE_part2)
	SE_select = rowSums(SE_all[,idx_wells])
	total_obs = sum(nt_obs[idx_wells])
	SE_select = sqrt(SE_select/total_obs)
        # boxplot of RMSE for each parameter set
        jpeg(paste(path_prefix,'BoxPlot_RMSE_',plotfile,sep=""),width=pwidth,height=pheight,units="in",res=150,quality=100)         
	boxplot(SE_select ~ group_ids,ylab="RMSE")
	dev.off()
	#find the realization with smallest RMSE
	idx_best_fit = which.min(SE_select)
	#plot the best fit
	#read in data
        input_file = paste(path_prefix, prefix_file,'R',fields[idx_best_fit],ext_file,sep='')
        a = readLines(input_file,n=1)
        b = unlist(strsplit(a,','))
        nvar = length(b)-1 #the first column is time
        varnames = b[-1]
        #find the columns needed
        varcols = array(NA,nplot,1)
        for (iw in 1:nplot)
                varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
        #read from files
        data0 = read.table(input_file,skip=1) # the first line is skipped
        t0 = data0[,1]-time_start
 
        jpeg(paste(path_prefix,'Best_Fit_',plotfile,sep=""),width=pwidth,height=pheight,units="in",res=250,quality=100)         
	par(mfrow=c(5,7))
#	par(mfrow=c(3,3))
	k=1
        for (iw in idx_plotwells)
        {
		if(iw == 1)
			istart = 1
		else
			istart = sum(nt_obs_orig[1:(iw-1)])+1
                fixedt = t_obs[istart:sum(nt_obs_orig[1:iw])]
                trueBTC = BTC_obs[istart:sum(nt_obs_orig[1:iw])]
                simulated = data0[,varcols[k]] * y_convert
		ymax = max(c(max(trueBTC,na.rm=T),max(simulated,na.rm=T)),na.rm=T)
		#ymax = 1.05
                #plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',cex.axis=1.7,cex.lab=1.7,cex.main=1.7,bty = 'n')
                plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',bty = 'n')
                points(fixedt,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
        	k = k + 1
	}
	dev.off()
	#find the worst fit
	idx_worst_fit = which.max(SE_select)
	#read in data
        input_file = paste(path_prefix, prefix_file,'R',fields[idx_worst_fit],ext_file,sep='')
        a = readLines(input_file,n=1)
        b = unlist(strsplit(a,','))
        nvar = length(b)-1 #the first column is time
        varnames = b[-1]
        #find the columns needed
        varcols = array(NA,nplot,1)
        for (iw in 1:nplot)
                varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
        #read from files
        data0 = read.table(input_file,skip=1) # the first line is skipped
        t0 = data0[,1]-time_start
 
        jpeg(paste(path_prefix,'Worst_Fit_',plotfile,sep=""),width=pwidth,height=pheight,units="in",res=250,quality=100)         
	par(mfrow=c(5,7))
#	par(mfrow=c(3,3))
	k=1
        for (iw in idx_plotwells)
        {
		if(iw == 1)
			istart = 1
		else
			istart = sum(nt_obs_orig[1:(iw-1)])+1
                fixedt = t_obs[istart:sum(nt_obs_orig[1:iw])]
                trueBTC = BTC_obs[istart:sum(nt_obs_orig[1:iw])]
                simulated = data0[,varcols[k]] * y_convert
		ymax = max(c(max(trueBTC,na.rm=T),max(simulated,na.rm=T)),na.rm=T)
		#ymax = 1.05
                plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',bty='n')
                #plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',cex.axis=1.7,cex.lab=1.7,cex.main=1.7,bty='n')
                points(fixedt,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
        	k = k + 1
	}
	dev.off()
}
