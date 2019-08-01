simu.segment <- function(data,start,end)
{
    times = data[,1]
    temp.start = which(times-start<0)
    temp.start = max(temp.start,1)
    temp.end = which(times-end>0)
    temp.end = min(temp.end,length(times))
    data = data[temp.start:temp.end,]
    data[,1] = data[,1]-start
    data[1,1] = 0
    return(data)
}

mc.input <- function()
{

    ##create boundary
    ireaz = 1
    system("rm -rf pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
    system("mkdir pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)    
    system("mkdir pflotran_mc/1",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)
    write.table(segment.head.top,file="pflotran_mc/1/head_top.dat",
                col.names=FALSE,row.names=FALSE)
    write.table(segment.temp.top,file="pflotran_mc/1/temp_top.dat",
                col.names=FALSE,row.names=FALSE)
    write.table(segment.temp.bottom,file="pflotran_mc/1/temp_bottom.dat",
                col.names=FALSE,row.names=FALSE)
    for (ireaz in 2:nreaz)
    {
        system(paste("cp -r pflotran_mc/1 pflotran_mc/",ireaz,sep=""),
               wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)            
    }

    pflotranin = readLines("dainput/1dthermal.in")

    for (ireaz in 1:nreaz)
    {
        lindex = grep("PERMEABILITY",pflotranin)        
        pflotranin[lindex+1] = paste("    PERM_X",perm[ireaz])
        pflotranin[lindex+2] = paste("    PERM_Y",perm[ireaz])
        pflotranin[lindex+3] = paste("    PERM_Z",perm[ireaz])

        lindex = grep("FINAL_TIME",pflotranin)        
        pflotranin[lindex] = paste("  FINAL_TIME",segment.length,"sec")

        lindex = grep("SNAPSHOT_FILE",pflotranin)        
        pflotranin[lindex+1] = paste("   TIMES sec",segment.length)
        
        writeLines(pflotranin,paste("pflotran_mc/",ireaz,"/1dthermal.in",sep=""))
        
        h5file = paste("pflotran_mc/",ireaz,"/initial_temperature.h5",sep="")
        h5createFile(h5file)
        h5write(1:nz,h5file,"Cell Ids",level=0)
        h5write(temperature.profile[ireaz,],h5file,"init_temperature",level=0)

        
        h5file = paste("pflotran_mc/",ireaz,"/initial_pressure.h5",sep="")
        h5createFile(h5file)
        h5write(1:nz,h5file,"Cell Ids",level=0)
        h5write(pressure.profile[ireaz,],h5file,"init_pressure",level=0)


    }
    H5close()
}

mc.output <- function()
{
    obs.cell = rep(NA,nobs)
    for (iobs in 1:nobs)
    {
        obs.cell[iobs] = which.min(abs(z-obs.coord[iobs]))
    }
    mc_dir="pflotran_mc/"
    
    pressure.ensemble = array(NA,c(nreaz,nz))
    temperature.ensemble = array(NA,c(nreaz,nz))    
    for (ireaz in 1:nreaz)
    {
        h5data = h5dump(paste(mc_dir,ireaz,"/1dthermal.h5",sep=''))
        pressure.ensemble[ireaz,] = as.numeric(unlist(h5data[[3]]["Liquid_Pressure [Pa]"]))
        temperature.ensemble[ireaz,] = as.numeric(unlist(h5data[[3]]["Temperature [C]"]))        
    }
    
    simu.ensemble = temperature.ensemble[,obs.cell]
    return(list(pressure.ensemble=pressure.ensemble,
                temperature.ensemble=temperature.ensemble,
                simu.ensemble=simu.ensemble))
}


cenkf.mc.input <- function(jtime)
{

    pflotranin = readLines("dainput/1dthermal.in")
    ##check checkpoint
    lindex = grep("CHECKPOINT",pflotranin)
    pflotranin[lindex+1] = paste("    TIMES sec ",obs.time[jtime])
    ##determine when to restart simulation
    lindex = grep("pflotran-restart.chk",pflotranin)                    
    if(jtime==1)
    {
        pflotranin[lindex] = "# RESTART pflotran-restart.chk"
    }else{
        pflotranin[lindex] = paste(" RESTART 1dthermal-",
                                   sprintf("%.4f",obs.time[jtime-1]),"sec.chk",sep="")        
    }

    lindex = grep("FINAL_TIME",pflotranin)        
    pflotranin[lindex] = paste("  FINAL_TIME",obs.time[jtime],"sec")

    lindex = grep("SNAPSHOT_FILE",pflotranin)        
    pflotranin[lindex+1] = paste("   TIMES sec",obs.time[jtime])
    
    for (ireaz in 1:nreaz)
    {
        lindex = grep("PERM_ISO",pflotranin)        
        pflotranin[lindex] = paste("    PERM_ISO",perm[ireaz])
        writeLines(pflotranin,paste("pflotran_mc/",ireaz,"/1dthermal.in",sep=""))
    }
    
}


cenkf.mc.input <- function(jtime)
{

    pflotranin = readLines("dainput/1dthermal.in")
    ##check checkpoint
    lindex = grep("CHECKPOINT",pflotranin)
    pflotranin[lindex+1] = paste("    TIMES sec ",obs.time[jtime])
    ##determine when to restart simulation
    lindex = grep("pflotran-restart.chk",pflotranin)                    
    if(jtime==1)
    {
        pflotranin[lindex] = "# RESTART pflotran-restart.chk"
    }else{
        pflotranin[lindex] = paste(" RESTART 1dthermal-",
                                   sprintf("%.4f",obs.time[jtime-1]),"sec.chk",sep="")        
    }

    lindex = grep("FINAL_TIME",pflotranin)        
    pflotranin[lindex] = paste("  FINAL_TIME",obs.time[jtime],"sec")

    lindex = grep("SNAPSHOT_FILE",pflotranin)        
    pflotranin[lindex+1] = paste("   TIMES sec",obs.time[jtime])
    
    for (ireaz in 1:nreaz)
    {
        lindex = grep("PERM_ISO",pflotranin)        
        pflotranin[lindex] = paste("    PERM_ISO",perm[ireaz])
        writeLines(pflotranin,paste("pflotran_mc/",ireaz,"/1dthermal.in",sep=""))
    }
    
}



cenkf.mc.input.strata <- function(forecast.start,forecast.end)
{

    pflotranin = readLines("dainput/1dthermal.in")
    ##check checkpoint
    lindex = grep("CHECKPOINT",pflotranin)
    pflotranin[lindex+1] = paste("    TIMES sec ",obs.time[forecast.end])
    ##determine when to restart simulation
    lindex = grep("pflotran-restart.chk",pflotranin)                    
    if(forecast.start==1)
    {
        pflotranin[lindex] = "# RESTART pflotran-restart.chk"
    }else{
        pflotranin[lindex] = paste(" RESTART 1dthermal-",
                                   sprintf("%.4f",obs.time[forecast.start-1]),"sec.chk",sep="")        
    }

    lindex = grep("FINAL_TIME",pflotranin)        
    pflotranin[lindex] = paste("  FINAL_TIME",obs.time[forecast.end],"sec")

    lindex = grep("SNAPSHOT_FILE",pflotranin)        
    pflotranin[lindex+1] = paste("   TIMES sec",obs.time[forecast.end])


    perm.card.length=14
    perm.card.lindex = grep("MATERIAL_PROPERTY Alluvium",pflotranin)-1        
    perm.card = pflotranin[1:perm.card.length+perm.card.lindex]
    perm.value.cardindex = grep("PERM_ISO",perm.card)

    strata.card.lindex = grep("STRATA",pflotranin)-1        
    strata.card = c("STRATA","REGION all")
    strata.card = c(strata.card,paste("  MATERIAL Perm",1,sep=""))
    strata.card = c(strata.card,paste("  START_TIME",0,"sec"))
    strata.card = c(strata.card,paste("  FINAL_TIME",obs.time[1],"sec"))    
    strata.card = c(strata.card,"END")
    strata.card = c(strata.card,"")        
    strata.card.length=length(strata.card)    

    for (ireaz in 1:nreaz)
    {
        strata.card.new = c()
        perm.card.new = c()    
        
        temp.pflotranin = pflotranin
        for (jtime in 1:forecast.end)
            {
                if (jtime==1)
                {
                    strata.card[4] = paste("  START_TIME",0,"sec")
                }else
                {
                    strata.card[4] = paste("  START_TIME",obs.time[jtime-1],"sec")
                }
                strata.card[5] = paste("  FINAL_TIME",obs.time[jtime],"sec")                
                strata.card[3] = paste("  MATERIAL Perm",jtime,sep="")                
                strata.card.new = c(strata.card.new,strata.card)

                perm.card[1] = paste("MATERIAL_PROPERTY Perm",jtime,sep="")
                perm.card[2] = paste("  ID",jtime)                
                perm.card[perm.value.cardindex] = paste("    PERM_ISO",perm.ls[[jtime]][ireaz])
                perm.card.new = c(perm.card.new,perm.card)
            }
        temp.pflotranin = c(temp.pflotranin[1:strata.card.lindex],
                            strata.card.new,
                            temp.pflotranin[-c(1:(strata.card.lindex+strata.card.length))])
                

        temp.pflotranin = c(temp.pflotranin[1:perm.card.lindex],
                      perm.card.new,
                      temp.pflotranin[-c(1:(perm.card.lindex+perm.card.length))])                
        writeLines(temp.pflotranin,paste("pflotran_mc/",ireaz,"/1dthermal.in",sep=""))
    }
    
}


cenkf.mc.output <- function(itime)
{
    obs.cell = rep(NA,nobs)
    for (iobs in 1:nobs)
    {
        obs.cell[iobs] = which.min(abs(z-obs.coord[iobs]))
    }
    mc_dir="pflotran_mc/"

    simu.ensemble = array(NA,c(nreaz,nobs))    
    for (ireaz in 1:nreaz)
    {
        simu.ensemble[ireaz,] = h5read(paste(mc_dir,ireaz,"/1dthermal.h5",sep=''),
                               paste("Time:",sprintf("%12.5E",obs.time[itime]),
                                     "s/Temperature [C]"))[obs.cell]
    }
    return(simu.ensemble)
}
