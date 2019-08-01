rm(list=ls())
source("codes/xuehang_R_functions.R")
source("codes/ert_parameters.R")

data = read.table('data/proj_coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])

proj_coord = proj_to_model(model_origin,angle,data)

save(proj_to_model,file="results/proj_to_model.r")
