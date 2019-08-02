rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list
library(zoo)
library(hydroGOF)
# setwd("/Users/shua784/Dropbox/PNNL/Projects/300A/") 

##----------INPUT----------------##
# source("post_process/assemble.simulation.R")
fname_WellScreen = "/Users/shua784/Dropbox/PNNL/Projects/300A/data/Monitoring_Well_Screen_bigdomain.csv"
fname_well = "/Users/shua784/Dropbox/PNNL/Projects/300A/data/wells/"
separate = T
plot.wl = F
# plot.scatter = T
# all_in_one = F
##----------OUTPUT---------------##
# fname.simu_well.r = "Outputs/simu_wells.r"
fig.wl = "figures/well_sim_vs_obs/"
fig.wl_all = "/Users/shua784/Dropbox/PNNL/Projects/300A/figures/WL_all_15.jpg"
fig.wl_scatter_all = "/Users/shua784/Dropbox/PNNL/Projects/300A/figures/WL_scatter_optim_5.jpg"
fname_RMSE = "/Users/shua784/Dropbox/PNNL/Projects/300A/results/WL_RMSE_summary.csv"
fname_RMSE_overall = "/Users/shua784/Dropbox/PNNL/Projects/300A/results/WL_RMSE_overall.csv"

z0 = 88
dz = 0.5
nz = 44
# nz = 40 # John_rand_case 1,2,4 has wrong nz
pho = 996.877
g = 9.81
P_atm = 101325  #atmospheric pressure

RMSE = list()
RMSE_overall = list()

# dirs = list.files("/Users/shua784/Dropbox/PNNL/Projects/300A", pattern = "*rand*")
# # dirs = c("John_case_rand_1")


dirs = c("John_case_rand_1", "John_case_rand_2", "John_case_rand_3", "John_case_rand_4", 
         "John_case_rand_5", "John_case_rand_6", "John_case_rand_7", "John_case_rand_8", 
         "John_case_rand_9", "John_case_rand_10", "John_case_material_2", "John_case_optim_1",
         "John_case_optim_2", "John_case_optim_3","John_case_optim_4")


# dirs = c("John_case_optim_1")
# dirs = c("John_case_optim_2")

# dirs = c("John_case_rand_2", "John_case_rand_4", "John_case_optim_2", "John_case_optim_3", "John_case_optim_4")

dirs = c("John_case_optim_5")

n.row = length(dirs)

Well = read.csv(fname_WellScreen, header = TRUE, stringsAsFactors=FALSE)

wells = paste("Well_",Well[,1],sep="")
rownames(Well) = wells
nwell = length(wells)

Well = as.matrix(Well[,2:6])

x=Well[,1]
y=Well[,2]
elev=Well[,3]
screen_top=Well[,4]
screen_bot=Well[,5]

##-------------------------------Plot separate figures for wl-------------------------##
if(separate){
  
  for (idir in dirs){
  
  print(idir)
  # RMSE[[idir]]=list()
  # RSS= list()
  # N = list()
  # MSE = list()
  
wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
setwd(wdir)

path = "Outputs/"

load(paste(path,"simu.all.r",sep=''))

## truncate time series
start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")

cells_z = seq((z0+0.5*dz), (z0+nz*dz), dz)

# wells = c("1-10A", "1-21A", "2-1", "2-2","2-3", "2-32", "4-9")
# wells = paste("Well_399-",wells,sep="")
# nwell = length(wells)

##--------------------store all simu data--------------------##
obs.types = c("Liquid Pressure")

well.data = list()
for (iwell in wells)
{
    well.data[[iwell]] = list()
    ## !!BE CAREFUL when you do grep "Well_399-2-1", it will grep "Well_399-2-10" too...
    ## Instead, try grep "Well_399-2-1_"
    ## Similarly, do the same for "Well_399-2-2", "Well_399-2-3"
    well.name = paste(iwell,"_",sep="")
    for (iobs in obs.types)
    {
        simu.col=intersect(grep(well.name, names(simu.all)),grep(iobs,names(simu.all))) # find header contain both well.name and iobs
        well.data[[iwell]][[iobs]] = simu.all[,simu.col]
    }
}

simu.time = simu.all[,1] # simulation timestep 0, 6, 12... 


for (iwell in wells)
{
    for (iobs in obs.types)
    {
        well.data[[iwell]][[iobs]] = well.data[[iwell]][[iobs]][order(simu.time),]  #order well.data
        # print(dim(well.data[[iwell]][[iobs]]))
    }
}

simu.time = simu.time[order(simu.time)]

simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600


# wells = c("Well_399-2-1")

wells = c("Well_399-1-10A", "Well_399-1-21A", "Well_399-2-1", "Well_399-2-2","Well_399-2-3", "Well_399-2-32", "Well_399-4-9")
# wells = c("Well_399-1-10A",  "Well_399-2-1", "Well_399-2-2","Well_399-2-3",  "Well_399-4-9")
##--------------------Plot simu.WL vs obs.WL--------------------##
for (iwell in wells) {
   if (Well[iwell, 4] >= z0 & Well[iwell, 5] <= z0+ nz*dz) {
     # print(iwell)
    z = cells_z[which((cells_z >= Well[iwell, 5]) & (cells_z <= Well[iwell, 4]))]
    inz = length(z)
    # wellname = rownames(Well)[i]
    
    P = list()
    h = list()
    H = list()
    
    for (j in 1:inz) {
      ielevation = z[j]
      well.col = grep(ielevation, names(well.data[[iwell]][[iobs]])) #find rownames ("Liquid Pressure [Pa] Well_399-4-7_1 (118201) (1602. 994. 90.25)") contain "ielevation"
      P[[j]] = well.data[[iwell]][[obs.types]][, well.col] #store pressure value 
      h[[j]] = (P[[j]] - P_atm)/(pho*g) #convert P to pressure head
      H[[j]] = h[[j]] + ielevation #convert h to hydraulic head
    }
    
    ## plot simulated head
    fname = paste(fig.wl, iwell, "_WL_ma.jpg",sep="")
    jpeg(fname,width=10,height=10,units='in',res=300,quality=100)
    par(mar=c(4,4,2,1))

    
    par(mfrow=c(2,1)) #create two 2x1 panels
    
    ## plot c(1,1)
    plot(simu.real.time, H[[1]], type = "l", lty = "dotted",col="blue", lwd = 1,
         xlim = c(start.time, end.time),ylim=c(104,108.5),
         main = iwell,xlab=NA,ylab="Hydaulic head (m)", axes = F)
    box()
    # axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0),cex.axis=1)
    # mtext("Hydaulic head (m)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2013-01-01",tz="GMT"),
                          to=as.Date("2015-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    ## plot observation head
    fname = paste(fname_well, substr(iwell,6,nchar(iwell)), "_3var.csv",sep="")
    
    if (file.exists(fname)) {
      # print(iwell)
    obs = read.csv(fname)
    obs[,1] = as.POSIXct(obs[,1],format="%d-%b-%Y %H:%M:%S")
    obs = obs[order(obs[,1]), ]
    names(obs)= c("Date.Time", "Temp", "Spc", "WL")
    ##-------------- moving average----------------
    nwindows = 6 # 6-hour window size
    # obs.ma <- rollmean(obs$WL, nwindows, fill=NA, align = "center") # rollmean does not handel NA
    
    obs.ma = rollapply(obs$WL, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
    ##-------------------end------------------------
    
    selected.time = which(obs[,1]>start.time &
                            obs[,1]<end.time) 
    
    ## plot obs. water level
    lines(obs[selected.time, 1], obs.ma[selected.time],  lty = "solid", col="black", lwd=1)
    legend("topleft",c("Observed head", "Simulated head"), lty = c("solid", "dotted"), lwd = 2, col = c("black", "blue"), bty="n")
    
    
    obs.head = list()  # store obs WL every 6-h

    obs = obs[!duplicated(obs$Date.Time), ] #filter duplicated dates
    
    # rownames(obs) = paste(obs[,1],"GMT")
    

    ## fill data gap with NAs
    for (i in 1:length(simu.real.time)) {
        t = simu.real.time[i]
        
        if (length(obs[which(obs$Date.Time==t),4]) ==0) {
          obs.head[[i]] = NA
        } else {
          obs.head[[i]] = obs[which(obs$Date.Time==t),4]
        }
        
    }
    
    ##-------------- moving average----------------
    nwindows = 6 # 6-hour window size
    
    obs.head <- matrix(unlist(obs.head), nrow = length(obs.head), byrow = TRUE) # convert lists to matrix
    obs.head.ma = rollapply(obs.head, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
    ##-------------------end------------------------
    
    
    ind.start = which(simu.real.time == start.time)
    ind.end = length(simu.real.time)
    simu.head = H[[1]]
    
    df_1 <- data.frame(matrix(unlist(obs.head.ma), nrow=length(simu.real.time), byrow=T))
    names(df_1)="obs.head"
    df_2 = data.frame(matrix(unlist(simu.head), nrow=length(simu.real.time), byrow=T))
    names(df_2) = "simu.head"
    
    df = cbind(df_1, df_2) #combine two data frames "column combined", different from "rbind"
    
    df.sub = df[ind.start:ind.end, 1:2]
    gof.table = gof(df.sub$simu.head, df.sub$obs.head)
    
    legend("top", bty="n", legend=bquote(paste(bold(RMSE == .(gof.table["RMSE", ])), " m")))
    ## plot c(2,1)--scatter plot
    plot(obs.head.ma[ind.start:ind.end], 
         simu.head[ind.start:ind.end], 
         main=iwell, xlab="Observed head (m)", ylab="Simulated head (m)", pch=1)
    abline(0,1, col= "red") ## add 1 to 1 plot
    
    ## test GOF package
    
    
    ## add R-squared to the plot
    # fit = lm(df$simu.head ~ df$obs.head, data = df)

    # fit = lm(df.sub$simu.head ~ df.sub$obs.head, data = df.sub)
    # r.squared = format(summary(fit)$adj.r.squared, digits=4)
    legend("topleft", bty="n", legend=bquote(bold(R^2 == .(gof.table["R2", ]))))
    
    # ## calculate RMSE
    # df.sub$diff = df.sub$simu.head - df.sub$obs.head
    # RSS[[iwell]] = sum(df.sub$diff^2, na.rm=TRUE) # residual squared sum, ignore the NAs
    # N[[iwell]] = sum(!is.na(df.sub$diff)) # count number of data except NAs
    # MSE[[iwell]] = RSS[[iwell]]/N[[iwell]] # mean squared error
    # 
    # RMSE[[idir]][[iwell]] = sqrt(MSE[[iwell]]) # root mean squared error

    
    # print(RMSE[iwell])
    # legend("top", bty="n", legend=bquote(bold(RMSE == .(RMSE[[idir]][[iwell]]))))
    # legend("top", bty="n", legend=bquote(bold(RMSE == .(gof.table["RMSE", ]))))
    }
    
    dev.off()
   
    }
    
  
}
# sum_RSS = Reduce("+", RSS) # sum of elements in a list
# sum_N = Reduce("+", N)
# 
# RMSE_overall[[idir]]= sqrt(sum_RSS/sum_N)

}

  # write.csv(RMSE, file = fname_RMSE)
  # write.csv(RMSE_overall, file = fname_RMSE_overall)
}

##-----------------------------plot all in one figure for wl--------------------------##
if(!separate & plot.wl){
  
  # dirs = c("John_case_rand_1")
  
  jpeg(fig.wl_all, width = 35, height = n.row*3, units="in",res=300, quality=100)
  par(mfrow=c(n.row,7), mar=c(1,2,2,1)+0.5, oma= c(1,1,5,1))
  
  for (idir in dirs){
    print(idir)
    RMSE[[idir]]=list()
    RSS= list()
    N = list()
    MSE = list()

    wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
    setwd(wdir)
    
    path = "Outputs/"

    load(paste(path,"simu.all.r",sep=''))

    ## truncate time series
    start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
    end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")
    
    cells_z = seq((z0+0.5*dz), (z0+nz*dz), dz)
    

    ##--------------------store all simu data--------------------##
    obs.types = c("Liquid Pressure")
    
    well.data = list()
    for (iwell in wells)
    {
      well.data[[iwell]] = list()
      ## !!BE CAREFUL when you do grep "Well_399-2-1", it will grep "Well_399-2-10" too...
      ## Instead, try grep "Well_399-2-1_"
      ## Similarly, do the same for "Well_399-2-2", "Well_399-2-3"
      well.name = paste(iwell,"_",sep="")
      for (iobs in obs.types)
      {
        simu.col=intersect(grep(well.name, names(simu.all)),grep(iobs,names(simu.all))) # find header contain both well.name and iobs
        well.data[[iwell]][[iobs]] = simu.all[,simu.col]
      }
    }
    
    simu.time = simu.all[,1] # simulation timestep 0, 6, 12... 
    
    
    for (iwell in wells)
    {
      for (iobs in obs.types)
      {
        well.data[[iwell]][[iobs]] = well.data[[iwell]][[iobs]][order(simu.time),]  #order well.data
        # print(dim(well.data[[iwell]][[iobs]]))
      }
    }
    
    simu.time = simu.time[order(simu.time)]
    
    simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600
    
    
    # wells = c("Well_399-2-1")
    
    wells = c("Well_399-1-10A", "Well_399-1-21A", "Well_399-2-1", "Well_399-2-2","Well_399-2-3", "Well_399-2-32", "Well_399-4-9")
    
    ##--------------------Plot simu.WL vs obs.WL--------------------##
    for (iwell in wells) {
      if (Well[iwell, 4] >= z0 & Well[iwell, 5] <= z0+ nz*dz) {
        # print(iwell)
        z = cells_z[which((cells_z >= Well[iwell, 5]) & (cells_z <= Well[iwell, 4]))]
        inz = length(z)
        # wellname = rownames(Well)[i]
        
        P = list()
        h = list()
        H = list()
        
        for (j in 1:inz) {
          ielevation = z[j]
          well.col = grep(ielevation, names(well.data[[iwell]][[iobs]])) #find rownames ("Liquid Pressure [Pa] Well_399-4-7_1 (118201) (1602. 994. 90.25)") contain "ielevation"
          P[[j]] = well.data[[iwell]][[obs.types]][, well.col] #store pressure value 
          h[[j]] = (P[[j]] - P_atm)/(pho*g) #convert P to pressure head
          H[[j]] = h[[j]] + ielevation #convert h to hydraulic head
        }
        
        ## plot simulated head
        # fname = paste(fig.wl, iwell, "_WL_ma.jpg",sep="")
        # jpeg(fname,width=10,height=10,units='in',res=300,quality=100)
        # # par(mar=c(2,3,2,1))
        # 
        # 
        # par(mfrow=c(2,1)) #create two 2x1 panels
        
        ## plot c(1,1)
        plot(simu.real.time, H[[1]],type="l",col="red", lwd = 1,
             xlim = c(start.time, end.time),ylim=c(104,108.5),
             axes=FALSE,xlab=NA,ylab=NA)
        box()
        title(main = paste(idir, "_", iwell, sep = ""), cex.main = 2)
        # axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
        axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0),cex.axis=1)
        mtext("Water level (m)",2,line=1.7)
        axis.POSIXct(1,at=seq(as.Date("2013-01-01",tz="GMT"),
                              to=as.Date("2015-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
        
        ## plot observation head
        fname = paste(fname_well, substr(iwell,6,nchar(iwell)), "_3var.csv",sep="")
        
        if (file.exists(fname)) {
          # print(iwell)
          obs = read.csv(fname)
          obs[,1] = as.POSIXct(obs[,1],format="%d-%b-%Y %H:%M:%S")
          obs = obs[order(obs[,1]), ]
          names(obs)= c("Date.Time", "Temp", "Spc", "WL")
          ##-------------- moving average----------------
          nwindows = 6 # 6-hour window size
          # obs.ma <- rollmean(obs$WL, nwindows, fill=NA, align = "center") # rollmean does not handel NA
          
          obs.ma = rollapply(obs$WL, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
          ##-------------------end------------------------
          
          selected.time = which(obs[,1]>start.time &
                                  obs[,1]<end.time) 
          
          ## plot obs. water level
          lines(obs[selected.time, 1], obs.ma[selected.time],  type="l", col="blue", lwd=1)
          # legend("topleft",c("simulated","observed (6h-ma)"), lwd = 2, col = c("red","blue"))
          
          
          obs.head = list()  # store obs WL every 6-h
          
          obs = obs[!duplicated(obs$Date.Time), ] #filter duplicated dates
          
          # rownames(obs) = paste(obs[,1],"GMT")
          
          
          ## fill data gap with NAs
          for (i in 1:length(simu.real.time)) {
            t = simu.real.time[i]
            
            if (length(obs[which(obs$Date.Time==t),4]) ==0) {
              obs.head[[i]] = NA
            } else {
              obs.head[[i]] = obs[which(obs$Date.Time==t),4]
            }
            
          }
          
          ##-------------- moving average----------------
          nwindows = 6 # 6-hour window size
          
          obs.head <- matrix(unlist(obs.head), nrow = length(obs.head), byrow = TRUE) # convert lists to matrix
          obs.head.ma = rollapply(obs.head, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
          ##-------------------end------------------------
          
          
          ind.start = which(simu.real.time == start.time)
          ind.end = length(simu.real.time)
          simu.head = H[[1]]
          
          df_1 <- data.frame(matrix(unlist(obs.head.ma), nrow=length(simu.real.time), byrow=T))
          names(df_1)="obs.head"
          df_2 = data.frame(matrix(unlist(simu.head), nrow=length(simu.real.time), byrow=T))
          names(df_2) = "simu.head"
          
          df = cbind(df_1, df_2) #combine two data frames "column combined", different from "rbind"
          
          
          # ## plot c(2,1)--scatter plot
          # plot(obs.head.ma[ind.start:ind.end], 
          #      simu.head[ind.start:ind.end], 
          #      main=iwell, xlab="Obs. WL (6h-ma) ", ylab="Simulated WL", pch=1)
          # abline(0,1, col= "red") ## add 1 to 1 plot
          
          ## add R-squared to the plot
          # fit = lm(df$simu.head ~ df$obs.head, data = df)
          df.sub = df[ind.start:ind.end, 1:2]
          # fit = lm(df.sub$simu.head ~ df.sub$obs.head, data = df.sub)
          # r.squared = format(summary(fit)$adj.r.squared, digits=4)
          # legend("topleft", bty="n", legend=bquote(bold(R^2 == .(r.squared))))
          
          ## calculate RMSE
          df.sub$diff = df.sub$simu.head - df.sub$obs.head
          RSS[[iwell]] = sum(df.sub$diff^2, na.rm=TRUE) # residual squared sum, ignore the NAs
          N[[iwell]] = sum(!is.na(df.sub$diff)) # count number of data except NAs
          MSE[[iwell]] = RSS[[iwell]]/N[[iwell]] # mean squared error
          
          RMSE[[idir]][[iwell]] = sqrt(MSE[[iwell]]) # root mean squared error
          # print(RMSE[iwell])
          legend("top", bty="n", legend=bquote(bold(RMSE == .(RMSE[[idir]][[iwell]]))), cex=3)
          
        }
        # dev.off()
      }
      
      
    }
    # sum_RSS = Reduce("+", RSS) # sum of elements in a list
    # sum_N = Reduce("+", N)
    # 
    # RMSE_overall[[idir]]= sqrt(sum_RSS/sum_N)
    
  }
  
  ## place legend outside of plot
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
  legend("top", c("Simulated wl", "Observed wl (6h ma)"),
         xpd = TRUE, horiz = TRUE, col=c("red", "blue"),
         inset = c(0, 0), bty = "n", pch = c(NA, NA), lty = 1, lwd = 2, cex = 4)
  dev.off()
  
}

##-----------------------------plot all in one figure for one to one scatter plot--------------------------##
if(!separate & !plot.wl){
  
  # dirs = c("John_case_rand_1")
  
  jpeg(fig.wl_scatter_all, width = 35, height = n.row*5, units="in",res=300, quality=100)
  par(mfrow=c(n.row,7), mar=c(4,4,2,1)+0.5, oma= c(5,5,1,1))
  
  for (idir in dirs){
    print(idir)
    # RMSE[[idir]]=list()
    # RSS= list()
    # N = list()
    # MSE = list()
    
    wdir = paste("/Users/shua784/Dropbox/PNNL/Projects/300A/", idir, sep = "")
    setwd(wdir)
    
    path = "Outputs/"
    
    load(paste(path,"simu.all.r",sep=''))
    
    ## truncate time series
    start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
    end.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT")
    
    cells_z = seq((z0+0.5*dz), (z0+nz*dz), dz)
    
    
    ##--------------------store all simu data--------------------##
    obs.types = c("Liquid Pressure")
    
    well.data = list()
    for (iwell in wells)
    {
      well.data[[iwell]] = list()
      ## !!BE CAREFUL when you do grep "Well_399-2-1", it will grep "Well_399-2-10" too...
      ## Instead, try grep "Well_399-2-1_"
      ## Similarly, do the same for "Well_399-2-2", "Well_399-2-3"
      well.name = paste(iwell,"_",sep="")
      for (iobs in obs.types)
      {
        simu.col=intersect(grep(well.name, names(simu.all)),grep(iobs,names(simu.all))) # find header contain both well.name and iobs
        well.data[[iwell]][[iobs]] = simu.all[,simu.col]
      }
    }
    
    simu.time = simu.all[,1] # simulation timestep 0, 6, 12... 
    
    
    for (iwell in wells)
    {
      for (iobs in obs.types)
      {
        well.data[[iwell]][[iobs]] = well.data[[iwell]][[iobs]][order(simu.time),]  #order well.data
        # print(dim(well.data[[iwell]][[iobs]]))
      }
    }
    
    simu.time = simu.time[order(simu.time)]
    
    simu.real.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT") + simu.time*3600
    
    
    # wells = c("Well_399-1-10A")
    
    wells = c("Well_399-1-10A", "Well_399-1-21A", "Well_399-2-1", "Well_399-2-2","Well_399-2-3", "Well_399-2-32", "Well_399-4-9")
    
    ##--------------------Plot simu.WL vs obs.WL--------------------##
    for (iwell in wells) {
      if (Well[iwell, 4] >= z0 & Well[iwell, 5] <= z0+ nz*dz) {
        # print(iwell)
        z = cells_z[which((cells_z >= Well[iwell, 5]) & (cells_z <= Well[iwell, 4]))]
        inz = length(z)
        # wellname = rownames(Well)[i]
        
        P = list()
        h = list()
        H = list()
        
        for (j in 1:inz) {
          ielevation = z[j]
          well.col = grep(ielevation, names(well.data[[iwell]][[iobs]])) #find rownames ("Liquid Pressure [Pa] Well_399-4-7_1 (118201) (1602. 994. 90.25)") contain "ielevation"
          P[[j]] = well.data[[iwell]][[obs.types]][, well.col] #store pressure value 
          h[[j]] = (P[[j]] - P_atm)/(pho*g) #convert P to pressure head
          H[[j]] = h[[j]] + ielevation #convert h to hydraulic head
        }
        
        # ## plot c(1,1)
        # plot(simu.real.time, H[[1]],type="l",col="red", lwd = 1,
        #      xlim = c(start.time, end.time),ylim=c(104,108.5),
        #      axes=FALSE,xlab=NA,ylab=NA)
        # box()
        # title(main = paste(idir, "_", iwell, sep = ""), cex.main = 2)
        # # axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
        # axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0),cex.axis=1)
        # mtext("Water level (m)",2,line=1.7)
        # axis.POSIXct(1,at=seq(as.Date("2013-01-01",tz="GMT"),
        #                       to=as.Date("2015-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
        # 
        ## plot observation head
        fname = paste(fname_well, substr(iwell,6,nchar(iwell)), "_3var.csv",sep="")
        
        if (file.exists(fname)) {
          # print(iwell)
          obs = read.csv(fname)
          obs[,1] = as.POSIXct(obs[,1],format="%d-%b-%Y %H:%M:%S")
          obs = obs[order(obs[,1]), ]
          names(obs)= c("Date.Time", "Temp", "Spc", "WL")
          ##-------------- moving average----------------
          nwindows = 6 # 6-hour window size
          # obs.ma <- rollmean(obs$WL, nwindows, fill=NA, align = "center") # rollmean does not handel NA
          
          obs.ma = rollapply(obs$WL, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
          ##-------------------end------------------------
          
          selected.time = which(obs[,1]>start.time &
                                  obs[,1]<end.time) 
          
          # ## plot obs. water level
          # lines(obs[selected.time, 1], obs.ma[selected.time],  type="l", col="blue", lwd=1)
          # # legend("topleft",c("simulated","observed (6h-ma)"), lwd = 2, col = c("red","blue"))
          
          
          obs.head = list()  # store obs WL every 6-h
          
          obs = obs[!duplicated(obs$Date.Time), ] #filter duplicated dates
          
          # rownames(obs) = paste(obs[,1],"GMT")
          
          
          ## fill data gap with NAs
          for (i in 1:length(simu.real.time)) {
            t = simu.real.time[i]
            
            if (length(obs[which(obs$Date.Time==t),4]) ==0) {
              obs.head[[i]] = NA
            } else {
              obs.head[[i]] = obs[which(obs$Date.Time==t),4]
            }
            
          }
          
          ##-------------- moving average----------------
          nwindows = 6 # 6-hour window size
          
          obs.head <- matrix(unlist(obs.head), nrow = length(obs.head), byrow = TRUE) # convert lists to matrix
          obs.head.ma = rollapply(obs.head, width=nwindows, FUN=mean, by=1, by.column=TRUE, fill=NA, align="center")
          ##-------------------end------------------------
          
          
          ind.start = which(simu.real.time == start.time)
          ind.end = length(simu.real.time)
          simu.head = H[[1]]
          
          df_1 <- data.frame(matrix(unlist(obs.head.ma), nrow=length(simu.real.time), byrow=T))
          names(df_1)="obs.head"
          df_2 = data.frame(matrix(unlist(simu.head), nrow=length(simu.real.time), byrow=T))
          names(df_2) = "simu.head"
          
          df = cbind(df_1, df_2) #combine two data frames "column combined", different from "rbind"
          
          
          ## plot c(2,1)--scatter plot
          plot(obs.head.ma[ind.start:ind.end], simu.head[ind.start:ind.end], pch=1, xlab = "", ylab = "")
          title(main = paste(idir, "_", iwell, sep = ""), cex.main = 2, xlab = "Observed WL", ylab = "Simulated WL", cex.lab = 1.5)
          abline(0,1, col= "red", lwd = 2) ## add 1 to 1 plot

          ## add R-squared to the plot
          # fit = lm(df$simu.head ~ df$obs.head, data = df)
          df.sub = df[ind.start:ind.end, 1:2]
          # fit = lm(df.sub$simu.head ~ df.sub$obs.head, data = df.sub)
          # r.squared = format(summary(fit)$adj.r.squared, digits=4)
          
          
          gof.table = gof(df.sub$simu.head, df.sub$obs.head)         
          
          legend(x=104.8, y=106.3, bty="n", legend=bquote(bold(R^2 == .(gof.table["R2", ]))), cex =2)
          
          ## calculate RMSE
          # df.sub$diff = df.sub$simu.head - df.sub$obs.head
          # RSS[[iwell]] = sum(df.sub$diff^2, na.rm=TRUE) # residual squared sum, ignore the NAs
          # N[[iwell]] = sum(!is.na(df.sub$diff)) # count number of data except NAs
          # MSE[[iwell]] = RSS[[iwell]]/N[[iwell]] # mean squared error
          # 
          # RMSE[[idir]][[iwell]] = sqrt(MSE[[iwell]]) # root mean squared error
          

          # print(RMSE[iwell])
          # legend("top", bty="n", legend=bquote(bold(RMSE == .(gof.table["RMSE", ]))), cex=2)
          legend(x=104.8, y=106.8, bty="n", legend=bquote(bold(RMSE == .(gof.table["RMSE", ]))), cex=2)
          
        }
        # dev.off()
      }
      
      
    }
    # sum_RSS = Reduce("+", RSS) # sum of elements in a list
    # sum_N = Reduce("+", N)
    # 
    # RMSE_overall[[idir]]= sqrt(sum_RSS/sum_N)
    
  }
  
  # place legend outside of plot
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n", xlab = "Observed WL", ylab = "Simulated WL")
  # legend("top", c("Simulated wl", "Observed wl (6h ma)"),
  #        xpd = TRUE, horiz = TRUE, col=c("red", "blue"),
  #        inset = c(0, 0), bty = "n", pch = c(NA, NA), lty = 1, lwd = 2, cex = 4)
  dev.off()
  
}
