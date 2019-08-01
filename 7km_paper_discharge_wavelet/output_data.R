rm(list=ls())
load("discharge.wavelet.r")


data = cbind(real.w$Power.avg,log2(real.w$Period/24))
colnames(data) = c("average wavelet power",
                   "period (log2 day)"
                   )

write.table(data,file="real_discharge.txt",row.names=FALSE)


data = cbind(natural.w$Power.avg,log2(natural.w$Period/24))
colnames(data) = c("average wavelet power",
                   "period (log2 day)"
                   )
write.table(data,file="smoothed_discharge.txt",row.names=FALSE)
