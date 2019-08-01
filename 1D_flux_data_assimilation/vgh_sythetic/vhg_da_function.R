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


cenkf.mc.input <- function()
{

    if (itime==2)
        {
            system("rm -rf pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
            system("mkdir pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)    
            for (ireaz in 1:nreaz)
            {
                system(paste("mkdir pflotran_mc/",ireaz,sep=""),
                       wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)            
            }
        }

    pflotranin = readLines("dainput/1dthermal.in")

    lindex = grep("CHECKPOINT",pflotranin)
    pflotranin[lindex+1] = paste("    TIMES sec ",simu.time[itime-1])
    
    lindex = grep("pflotran-restart.chk",pflotranin)                    
    if(itime<=3)
    {
        pflotranin[lindex] = "# RESTART pflotran-restart.chk"
    }else{
        pflotranin[lindex] = paste(" RESTART 1dthermal-",sprintf("%.4f",simu.time[itime-2]),"sec.chk",sep="")        
    }

    lindex = grep("FINAL_TIME",pflotranin)        
    pflotranin[lindex] = paste("  FINAL_TIME",simu.time[itime],"sec")

    lindex = grep("SNAPSHOT_FILE",pflotranin)        
    pflotranin[lindex+1] = paste("   TIMES sec",simu.time[itime])
    
    for (ireaz in 1:nreaz)
    {
        lindex = grep("PERM_ISO",pflotranin)        
        pflotranin[lindex] = paste("    PERM_ISO",perm[ireaz])
        writeLines(pflotranin,paste("pflotran_mc/",ireaz,"/1dthermal.in",sep=""))
    }
    
}





cenkf.mc.output <- function()
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
                               paste("Time:",sprintf("%12.5E",simu.time[itime]),"s/Temperature [C]"))[obs.cell]
    }
    return(simu.ensemble)
}
