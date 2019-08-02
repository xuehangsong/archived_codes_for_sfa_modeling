rm(list=ls())

library(hydroGOF)
# setwd("/Users/shua784/Dropbox/PNNL/Projects/300A/")

##-----------------INPUT------------------##
# source("post_process/generate.well.data_add_piecewise_to_nms.R")
fname.simu_well.r = "Outputs/simu_wells.r"
fname_SpC_U.csv = "/Users/shua784/Dropbox/PNNL/Projects/300A/data/Sample_Data_2015_U.csv"
separate = T
# all_in_one = TRUE
hasSpC = T
hasU = F
##------------------OUTPUT----------------##
fig.Spc_U = "figures/well_sim_vs_obs/"
fname_RMSE = "/Users/shua784/Dropbox/PNNL/Projects/300A/results/tracer_RMSE_summary.csv"
fname_RMSE_overall = "/Users/shua784/Dropbox/PNNL/Projects/300A/results/tracer_RMSE_overall.csv"
# fig.SpC_all = "/Users/shua784/Dropbox/PNNL/Projects/300A/figures/Spc_all_15.jpg"
fig.SpC_all = "/Users/shua784/Dropbox/PNNL/Projects/300A/figures/Spc_optim_5.jpg"
fig.U_all = "/Users/shua784/Dropbox/PNNL/Projects/300A/figures/U_all_15.jpg"
fname_gstat = "/Users/shua784/Dropbox/PNNL/Projects/300A/results/"

# dirs = list.files("/Users/shua784/Dropbox/PNNL/Projects/300A", pattern = "*rand*")
# dirs = c(dirs, "John_case_material_2")

dirs = c("John_case_rand_1", "John_case_rand_2", "John_case_rand_3", "John_case_rand_4", 
         "John_case_rand_5", "John_case_rand_6", "John_case_rand_7", "John_case_rand_8", 
         "John_case_rand_9", "John_case_rand_10", "John_case_material_2", "John_case_optim_1",
         "John_case_optim_2", "John_case_optim_3", "John_case_optim_4")

# dirs = c("John_case_optim_4")
# dirs = c("John_case_rand_1", "John_case_rand_2")

# dirs = c("John_case_rand_2", "John_case_rand_4", "John_case_optim_2", "John_case_optim_3", "John_case_optim_4")

dirs = c("John_case_optim_5")

n.row = length(dirs)

obs = read.csv(fname_SpC_U.csv)
obs[,1] = paste("Well_",obs[,1],sep="")
obs[,2] = as.POSIXct(obs[,2],format="%d-%b-%Y %H:%M:%S", tz="GMT")
obs = obs[order(obs[,2]),]
obs.spc = 4  #SpC
obs.U = 6 # Uranium
# spc.min = min(obs[,obs.spc])
spc.min = 120 #from John's paper
spc.max = max(obs[,obs.spc]) # max.SpC= 507 us/cm
# spc.max = 507
U.min = min(obs[,obs.U])
U.max = max(obs[,obs.U]) 

colors = c("purple","dark green","darkgoldenrod")
# names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s","Tracer_north")
names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m")
color.U = "dark orange"


##========================Plot separate figures===========================##
if (separate) {
  
  
  RMSE = list()
  RMSE_overall = list()
  simu.obs.model = list()
  
  gstat = matrix(, nrow = 20, ncol = 0)
  overall.gstat = matrix(, nrow = 20, ncol = 0)
  
  # dirs = c("John_case_optim_2")
  for (idir in dirs)
    {
    
    print(idir)
    
    # RMSE[[idir]]=list()
    # RSS= list()
    # N = list()
    # MSE = list()
    
    simu.obs.model[[idir]]= list()
    
    wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
    setwd(wdir)
  
  load(fname.simu_well.r)
  
  start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
  end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")
  simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600
  
  wells = names(well.data)
  # tracer.types = names(tracer)[c(1,2,4)]
  # tracer.types = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s", "Tracer_north")
  tracer.types = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m")
  
  ###colors = c("purple","blue","green","red")
  # colors = c("purple","green","magenta", "cyan","red")
  # colors = c("purple","dark green","orange", "red")
  # # names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s","Tracer_north")
  # names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m")

  
  selected.time = which(simu.real.time<=range(obs[,2])[2] &
                        simu.real.time>=range(obs[,2])[1])
  
  # wells = c("Well_399-1-10A")
  # wells = c("Well_399-1-21A")
  # wells = c("Well_399-2-1")
  # wells = c("Well_399-2-2")
  # wells = c("Well_399-2-3")
  # wells = c("Well_399-2-32")
  # wells = c("Well_399-4-9")
  # wells = c("Well_399-1-10A",  "Well_399-2-1", "Well_399-2-2","Well_399-2-3",  "Well_399-4-9")
  wells = c("Well_399-1-10A", "Well_399-1-21A", "Well_399-2-1", "Well_399-2-2","Well_399-2-3", "Well_399-2-32", "Well_399-4-9")
  
  ## ----------------------plot tracer vs SpC-------------------------------
  for (iwell in wells)
  {
      print(iwell)
      
      fname = paste(fig.Spc_U, iwell, "_SpC_all",".jpg",sep="")
      jpeg(fname,width=6.25,height=5,units='in',res=300,quality=100)
      # pdf(file=fname,width=6.25,height=5)
      par(mar=c(2,3,2,1))
      plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
           xlim = range(simu.real.time[selected.time]),
           main = iwell,axes=FALSE,xlab=NA,ylab=NA         
           )
      
      box()
      axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
      mtext("Normalized Concentration (-)",2,line=1.7)
      axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                   to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
      
      for (itracer in tracer.types)
      {
          lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2, lty = "dashed")
      }
  
      lines(simu.real.time[selected.time],tracer[["Tracer_north"]][[iwell]][selected.time]/0.001,col="red",lwd=2, lty = "solid")
      lines(simu.real.time[selected.time],tracer[["Tracer_total"]][[iwell]][selected.time]/0.001,col="blue",lwd=2, lty = "solid")
      
      ## plot obs. data
      # obs.row = which(obs[,1] == iwell)   
      obs.row = which(obs[,1] == iwell & obs[, 2] <= end.time)
  ###    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
      data = (obs[obs.row,obs.spc]-spc.min)/(spc.max-spc.min)
      date = obs[obs.row, 2]
      lines(date, data, lwd=2)
      points(date, data, pch=1, cex=1)
      
  # ## sample the simulated time closest to the observation time in data
  #     simu.date = vector()
  # 
  #     for (i in 1:length(date))
  #     {
  #       diff = date[i] - simu.real.time
  #       simu.date[i] = which.min(abs(diff))
  #     }
  #     simu.data = tracer[["Tracer_north"]][[iwell]][simu.date]/0.001
  # 
  # 
  #     
  #     ## calculate RMSE
  #     df = data.frame(obs = data, simu = simu.data)
  #     fit = lm(df$obs ~ df$simu, data = df)
  # 
  #     RSS[[iwell]] = sum((data-simu.data)^2)
  #     N[[iwell]] = length(data)
  #     MSE[[iwell]] = RSS[[iwell]]/N[[iwell]] # mean squared error
  #     RMSE[[idir]][[iwell]] = sqrt(MSE[[iwell]])
  #     # print(RMSE)
  #     
  #     ## store simu. obs. data for each well
  #     simu.obs.model[[idir]][[iwell]] = df
      
      ## test hydroGOF package
      # gstat_new = gof(df$simu, df$obs)
      # gstat = cbind(gstat, gstat_new)
      # grmse = gstat["RMSE",]
      # gr2 = gstat["R2",]
      
      
      legend(x=as.POSIXct("2013-03-30",tz="GMT"),y=1.25,
             c("SpC observation","North groundwater tracer"),lty=c(1, 1),pch=c(1,NA),
             lwd=2,col=c("black","red"),horiz=TRUE,bty="n")
  
      legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.2,
             c("North river tracer","Middle river tracer"),lty=c(2, 2),
             lwd=2,col=c("dark green", "darkgoldenrod"),horiz=TRUE,bty="n")
      
      # legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.15,
      #        c("Upstream tracer", "South river tracer"),lty=1,
      #        lwd=2,col=c("purple", "cyan"),horiz=TRUE,bty="n")
      
      legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.15,
             c("Upstream river tracer", "Total river tracer"),lty=c(2, 1),
             lwd=2,col=c("purple", "blue"),horiz=TRUE,bty="n")  
      
      
      # legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.1,
      #        c("Total river tracer"),lty=1,
      #        lwd=2,col=c("grey"),horiz=TRUE,bty="n")
  
      # legend(x=as.POSIXct("2013-12-20",tz="GMT"),y=1.1,
      #        legend=bquote(bold(RMSE == .(RMSE[[idir]][[iwell]]))), horiz=TRUE,bty="n")
      
      dev.off()
  }    
  
  # sum_RSS = Reduce("+", RSS) # sum of elements in a list
  # sum_N = Reduce("+", N)
  # 
  # RMSE_overall[[idir]]= sqrt(sum_RSS/sum_N)
  
  #-------------------- plot tracer vs Uranium---------------------------
  for (iwell in wells)
  {
      print(iwell)
      fname = paste(fig.Spc_U,iwell,"_U_all",".jpg",sep="")

      jpeg(fname,width=6.25,height=5,units='in',res=300,quality=100)

      # pdf(file=fname,width=6.25,height=5)

      par(mar=c(2,3,2,3))
      plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
           xlim = range(simu.real.time[selected.time]),
           main = iwell,axes=FALSE,xlab=NA,ylab=NA
           )
      box()
      axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
      mtext("Normalized Concentration (-)",2,line=1.7)
      axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                   to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))

      for (itracer in tracer.types)
      {
          lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2, lty = "dashed")
      }
      
      lines(simu.real.time[selected.time],tracer[["Tracer_north"]][[iwell]][selected.time]/0.001,col="red",lwd=2, lty = "solid")
      
      lines(simu.real.time[selected.time],tracer[["Tracer_total"]][[iwell]][selected.time]/0.001,col="blue",lwd=2, lty = 1)


      legend(x=as.POSIXct("2013-03-30",tz="GMT"),y=1.25,
             c("Uranium observation","North groundwater tracer"),lty=c(1, 1),pch=c(1,NA),
             lwd=2,col=c(color.U,"red"),horiz=TRUE,bty="n")
      
      legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.2,
             c("North river tracer","Middle river tracer"),lty=c(2, 2),
             lwd=2,col=c("dark green", "darkgoldenrod"),horiz=TRUE,bty="n")
      
      # legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.15,
      #        c("Upstream tracer", "South river tracer"),lty=1,
      #        lwd=2,col=c("purple", "cyan"),horiz=TRUE,bty="n")
      
      legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.15,
             c("Upstream river tracer", "Total river tracer"),lty=c(2, 1),
             lwd=2,col=c("purple", "blue"),horiz=TRUE,bty="n")
      # 
      # legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.1,
      #        c("Total river tracer"),lty=1,
      #        lwd=2,col=c("grey"),horiz=TRUE,bty="n")


      par(new=T)
      # obs.row = which(obs[,1] == iwell)
      obs.row = which(obs[,1] == iwell & obs[, 2] <= tail(simu.real.time,1))
      # data = (obs[obs.row,obs.U] - U.min)/(U.max - U.min)
      # lines(obs[obs.row,2],data,lwd=2, col="orange")

      data = obs[obs.row,obs.U]
      date = obs[obs.row, 2]
      plot(date, data, type="l", col=color.U, lwd=2, pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
           xlim=range(simu.real.time[selected.time]),
           ylim = c(0, 180))
      axis(4, mgp=c(5,0.7,0), col = color.U, col.axis = color.U)
      mtext("Uranium concentration (ug/L)", 4, line=1.7, col = color.U)  
      points(obs[obs.row,2],data,pch=1,cex=1, col= color.U)
      



      dev.off()
      }
  
  # # stack all dataframes in a list
  #     big.df = do.call(rbind, args = simu.obs.model[[idir]])
  # 
  #     overall.gstat_new = gof(big.df$simu, big.df$obs)
  #     overall.gstat = cbind(overall.gstat, overall.gstat_new)
  
  }
  
  # write.csv(RMSE, file = fname_RMSE)
  # write.csv(RMSE_overall, file = fname_RMSE_overall)
  # colnames(overall.gstat) = dirs
  # colnames(gstat) = dirs 

  # t_gstat = t(gstat)
  
  # fname_gstat = paste(fname_gstat, wells, "_gstat.csv", sep = "")
  # write.csv(t_gstat, file = fname_gstat)
  
  # fname_overall.gstat = paste(fname_gstat, "_overall_gstat.csv", sep = "")
  # write.csv(t(overall.gstat), file = fname_overall.gstat)
  # 

}


##-----------------------------Plot SpC all in one----------------------------------##

if(!separate & hasSpC){
 
  # RMSE = list()
  # RMSE_overall = list()
  # 
  jpeg(fig.SpC_all, width = 43.75, height = 5*n.row, units="in", res=300, quality=100)
  par(mfrow=c(n.row, 7), mar=c(2,3,2,3)+0.5, oma= c(1,1,5,1))
  
  # dirs = c("John_case_rand_1", "John_case_rand_2")
  # dirs = c("John_case_rand_1")
  
  for (idir in dirs)
  {
    
    print(idir)
    
    # RMSE[[idir]]=list()
    # RSS= list()
    # N = list()
    # MSE = list()
    
    wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
    setwd(wdir)
    
    load(fname.simu_well.r)
    
    start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
    end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")
    simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600
    
    wells = names(well.data)
    # tracer.types = names(tracer)[c(1,2,4)]
    tracer.types = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s", "Tracer_north")
    
    ###colors = c("purple","blue","green","red")
    colors = c("purple","green","blue", "cyan","red")
    names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s","Tracer_north")
    
    selected.time = which(simu.real.time<=range(obs[,2])[2] &
                            simu.real.time>=range(obs[,2])[1])
    # selected.time = which(simu.real.time <= end.time &
    #                         simu.real.time >= start.time)
    
    ## plot tracer vs SpC
    for (iwell in wells)
    {
      # print(iwell)
      
      # fname = paste(fig.Spc_U, iwell, "_SpC_all",".jpg",sep="")
      # jpeg(fname,width=6.25,height=5,units='in',res=300,quality=100)
      # pdf(file=fname,width=6.25,height=5)
      # par(mar=c(2,3,2,1))
      plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
           xlim = range(simu.real.time[selected.time]),
           axes=FALSE,xlab=NA,ylab=NA         
      )
      title(main = paste(idir, "_", iwell, sep = ""), cex.main = 2)
      box()
      axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
      mtext("Normalized Concentration (-)",2,line=1.7)
      axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                            to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
      
      for (itracer in tracer.types)
      {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=1)
      }
      
      lines(simu.real.time[selected.time],tracer[["Tracer_total"]][[iwell]][selected.time]/0.001,col="grey",lwd=2, lty = 1)
      
      ## plot obs. data
      # obs.row = which(obs[,1] == iwell)   
      obs.row = which(obs[,1] == iwell & obs[, 2] <= tail(simu.real.time,1)) # make obs data ending the same date with simu data
 
      data = (obs[obs.row,obs.spc]-spc.min)/(spc.max-spc.min)
      date = obs[obs.row, 2]
      lines(date, data, lwd=1)
      points(date, data, pch=1, cex=1)
      
      ## sample the simulated time closest to the observation time in data
      simu.date = vector()

      for (i in 1:length(date))
      {
        diff = date[i] - simu.real.time
        simu.date[i] = which.min(abs(diff))
      }
      simu.data = tracer[["Tracer_north"]][[iwell]][simu.date]/0.001

      ## calculate RMSE
      df = data.frame(obs = data, simu = simu.data)
      fit = lm(df$obs ~ df$simu, data = df)
      
      gof.table = gof(df$simu, df$obs)
       
      # RMSE = gof.table["RMSE", ]
      # KGE = gof.table["KGE", ]
      # RSS[[iwell]] = sum((data-simu.data)^2)
      # N[[iwell]] = length(data)
      # MSE[[iwell]] = RSS[[iwell]]/N[[iwell]] # mean squared error
      # RMSE[[idir]][[iwell]] = sqrt(MSE[[iwell]])
      ## print(RMSE)
      
      # legend("top",legend=bquote(bold(RMSE == .(RMSE[[idir]][[iwell]]))), cex=2, bty="n")
      legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.2,legend=bquote(bold(RMSE == .(gof.table["RMSE", ]))), cex=2, bty="n")
      legend(x=as.POSIXct("2014-01-20",tz="GMT"),y=1.2,legend=bquote(bold(KGE == .(gof.table["KGE", ]))), cex=2, bty="n")
      # dev.off()
    }   
    
  }
  
  ## place legend outside of plot
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
  legend("top", c("SpC", "Groundwater", "Upstream_river", "North_river","Middle_river","South_river"), 
         xpd = TRUE, horiz = TRUE, col=c("black", "red", "purple", "green", "blue", "cyan"),
         inset = c(0, 0), bty = "n", pch = c(1, NA, NA, NA, NA, NA), lty = 1, lwd = 2, cex = 3)
  dev.off()
  
  
  
}

#-----------------------Plot U all in one------------------------------##
if(!separate & hasU){

  
  jpeg(fig.U_all, width = 43.75, height = n.row*6, units="in",res=300, quality=100)
  par(mfrow=c(n.row,7), mar=c(2,3,2,3)+0.5, oma= c(1,1,5,1))

  # dirs = c("John_case_rand_1")
  for (idir in dirs)
  {

    print(idir)

    wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
    setwd(wdir)

    load(fname.simu_well.r)

    start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
    end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")
    
    simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600


    #
    wells = names(well.data)
    tracer.types = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s", "Tracer_north")

    colors = c("purple","green","blue", "cyan","red")
    names(colors) = c("Tracer_river_upstr","Tracer_river_n","Tracer_river_m", "Tracer_river_s","Tracer_north")

    selected.time = which(simu.real.time<=range(obs[,2])[2] &
                            simu.real.time>=range(obs[,2])[1])

    # plot tracer vs Uranium
    for (iwell in wells)
    {

        plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
             xlim = range(simu.real.time[selected.time]),
             axes=FALSE,xlab=NA,ylab=NA
             )
        title(main = paste(idir, "_", iwell, sep = ""), cex.main = 2)
        box()
        axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
        mtext("Normalized Concentration (-)",2,line=1.7)
        axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                     to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))

        for (itracer in tracer.types)
        {
            lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=1)
        }

        lines(simu.real.time[selected.time],tracer[["Tracer_total"]][[iwell]][selected.time]/0.001,col="grey",lwd=2, lty = 1)

        par(new=T)
        # obs.row = which(obs[,1] == iwell)
        obs.row = which(obs[,1] == iwell & obs[, 2] <= tail(simu.real.time,1))
        # data = (obs[obs.row,obs.U] - U.min)/(U.max - U.min)
        # lines(obs[obs.row,2],data,lwd=2, col="orange")

        data = obs[obs.row,obs.U]
        plot(obs[obs.row,2],data, type="l", col="orange ", lwd=1, pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
             xlim=range(simu.real.time[selected.time]),
             ylim = c(0, 180))
        axis(4,mgp=c(5,0.7,0))
        mtext("Uranium concentration (ug/L)",4,line=1.7)

        points(obs[obs.row,2],data,pch=1,cex=1, col= "orange")

    }


  }

  ## place legend outside of plot
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
  legend("top", c("Uranium", "Groundwater", "Upstream_river", "North_river","Middle_river","South_river"),
         xpd = TRUE, horiz = TRUE, col=c("orange", "red", "purple", "green", "blue", "cyan"),
         inset = c(0, 0), bty = "n", pch = c(1, NA, NA, NA, NA, NA), lty = 1, lwd = 2, cex = 2)

  dev.off()



}
