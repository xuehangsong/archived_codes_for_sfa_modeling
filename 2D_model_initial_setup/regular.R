rm(list = ls())

nreaz =  100
state.vector = array(2*nreaz,c(nreaz,2))

state.vector[,1] = rep(c(1,12,seq(25,200,25)),10)
state.vector[,1] = state.vector[,1]/16/1000/3600/24

state.vector[,2] = rep(c(1,2,4,8,12,16,20,32,64,100),each=10)
state.vector[,2] = state.vector[,2]/12/1000

case.name = "rate.doc"


for (ireaz in 1:100)
{
    input.file = "2duniform.in"
    pflotran.input = readLines(paste(case.name,"/",ireaz,"/",input.file,sep=''),-1)


    ## reaction rate
    material.line = grep("MICROBIAL_REACTION",pflotran.input)[1]
    pflotran.input[material.line+2] = paste("    RATE_CONSTANT",format(state.vector[ireaz,1],digits=3))

    ##carbon boundary
    material.line = grep("TRANSPORT_CONDITION river",pflotran.input)[1]
    pflotran.input[material.line+6] = paste("      CH2O(aq)",format(state.vector[ireaz,2],digits=3),"T")

    
    ##write plotran input
    writeLines(pflotran.input,paste(case.name,"/",ireaz,"/",input.file,sep=''))
    
    ##find the pflotran input file
    input.file = "run.regular.sh"
    run.pflotran = readLines(paste(case.name,"/",ireaz,"/",input.file,sep=''),-1)
    name.line = grep("*SBATCH -J",run.pflotran)
    run.pflotran[name.line] = paste("#SBATCH -J",ireaz)
    writeLines(run.pflotran,paste(case.name,"/",ireaz,"/",input.file,sep=''))

    input.file = "run.premium.sh"
    run.pflotran = readLines(paste(case.name,"/",ireaz,"/",input.file,sep=''),-1)
    name.line = grep("*SBATCH -J",run.pflotran)
    run.pflotran[name.line] = paste("#SBATCH -J",ireaz)
    writeLines(run.pflotran,paste(case.name,"/",ireaz,"/",input.file,sep=''))
}   
save(state.vector,file=paste(case.name,"/statistics/","state.vector.r",sep=''))
