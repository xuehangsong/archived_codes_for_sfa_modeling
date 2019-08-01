rm(list=ls())
library(rhdf5)

load(file="results/perm.data.2.r")

truncated_hanford_threshold = rep(exp(8.742916)*0.001/1000/9.81/24/3600,2)
truncated_alluvium_threshold = rep(exp(3.489701)*0.001/1000/9.81/24/3600,2)
truncated_hanford_threshold = 10^(log10(truncated_hanford_threshold)+c(-1.8,1.8))
truncated_alluvium_threshold = 10^(log10(truncated_alluvium_threshold)+c(-0.4,0.4))

truncated_hanford = hanford.perm[,4]
truncated_alluvium = alluvium.perm[,4]


truncated_hanford[truncated_hanford>truncated_hanford_threshold[2]] = truncated_hanford_threshold[2]
truncated_hanford[truncated_hanford<truncated_hanford_threshold[1]] = truncated_hanford_threshold[1]



truncated_alluvium[truncated_alluvium>truncated_alluvium_threshold[2]] = truncated_alluvium_threshold[2]
truncated_alluvium[truncated_alluvium<truncated_alluvium_threshold[1]] = truncated_alluvium_threshold[1]

hanford.perm[,4] = truncated_hanford
alluvium.perm[,4] = truncated_alluvium

#hist(log10(truncated_hanford))
#hist(log10(truncated_alluvium))
save(list=c("hanford.perm","alluvium.perm"),file="results/perm.data.5.r")



H5close()        
h5file = "ert_model/ERT_alluvium_5.h5"

nreaz = 1
if(file.exists(h5file)) {file.remove(h5file)}

cell.ids = 1:dim(alluvium.perm)[1]

h5createFile(h5file)
h5write(cell.ids,h5file,"Cell Ids",level=0)
for (ireaz in 1:nreaz)
{
    print(ireaz)
    h5write(alluvium.perm[,(ireaz+3)],h5file,paste("Alluvium_perm",ireaz,sep=""),level=0)
    H5close()        

}

H5close()        
h5file = "ert_model/ERT_hanford_5.h5"


if(file.exists(h5file)) {file.remove(h5file)}

cell.ids = 1:dim(hanford.perm)[1]

h5createFile(h5file)
h5write(cell.ids,h5file,"Cell Ids",level=0)
for (ireaz in 1:nreaz)
{
    print(ireaz)
    h5write(hanford.perm[,(ireaz+3)],h5file,paste("Hanford_perm",ireaz,sep=""),level=0)
    H5close()        
}


