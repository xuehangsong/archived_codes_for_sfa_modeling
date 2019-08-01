rm(list=ls())
args=(commandArgs(TRUE))

load("statistics/parameters.r")
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
    ivari=20
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


ringold = c()
hanford = c()
alluvium = c()

years = 2:6
for (iyear in years)
{
    print(iyear)
    load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
    dim(value) =  c(dim(value)[1]*dim(value)[2],dim(value)[3])
    alluvium = c(alluvium,colSums(value[which(material_ids==5),]))        
    hanford = c(hanford,colSums(value[which(material_ids==1),]))    
    ringold = c(ringold,colSums(value[which(material_ids==4),]))
}


list=c("hanford",
       "ringold",
       "alluvium")

save(list=list,file = paste("highlight.data/",ireaz,"_",ivari,"_sum.r",sep=""))
