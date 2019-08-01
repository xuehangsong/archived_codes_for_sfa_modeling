cenkf.window.mc.input <- function(jtime)
{

    if (jtime==2)
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
    pflotranin[lindex+1] = paste("    TIMES sec ",obs.time[jtime-1])
    
    lindex = grep("pflotran-restart.chk",pflotranin)                    
    if(window.start==1)
    {
        pflotranin[lindex] = "# RESTART pflotran-restart.chk"
    }else{
        pflotranin[lindex] = paste(" RESTART 1dthermal-",sprintf("%.4f",obs.time[window.start]),"sec.chk",sep="")        
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



