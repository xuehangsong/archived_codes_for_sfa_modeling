rm(list=ls(all=TRUE))

folder = c('./')

file=c('WaterChemistryHanford.csv')
data_name = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, nrows =1, quote="",sep=',',header=F,row.names=NULL)  #; head(data)
data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, skip =1, quote="",sep=',',header=F)  #; head(data)
colnames(data) = data_name


chemical_name = unique(data[,"STD_CON_LONG_NAME"])
chemical_elinimate = rep(TRUE,length(chemical_name))
for (iname in 1:length(chemical_name))
    {
        ## if (grepl("^[[:lower:]]", chemical_name[iname])) ##start with lower
        ##     {
        ##         chemical_elinimate[iname] = FALSE
        ##     }

        ## if (length(grep("\\(", chemical_name[iname]))>0) ##start with (
        ##     {
        ##         chemical_elinimate[iname] = FALSE
        ##     }


        ## if (nchar(chemical_name[iname])>=15)
        ##     {
                
        ##         chemical_elinimate[iname] = FALSE
        ##     }

        ## if (substr(chemical_name[iname],1,1)==" ")
        ##     {
                
        ##         chemical_elinimate[iname] = FALSE
        ##     }



        if (length(which(data[,"STD_CON_LONG_NAME"] == chemical_name[iname]))<=1000)
            {
                
                chemical_elinimate[iname] = FALSE
            }


        if (!is.na(as.numeric(substr(chemical_name[iname],1,1))))
            {
                
                chemical_elinimate[iname] = FALSE
            }


        if (chemical_name[iname]=="")
            {
                
                chemical_elinimate[iname] = FALSE
            }

        
        if (length(grep("Not",chemical_name[iname]))>0)
            {
                
                chemical_elinimate[iname] = FALSE
            }

        if (length(grep("SAMPLING",chemical_name[iname]))>0)
            {
                
                chemical_elinimate[iname] = FALSE
            }
        
        
    }

print(chemical_name[chemical_elinimate])

chemical_name = chemical_name[chemical_elinimate]
save(list=c("chemical_name","data"),file="chemical.r")
