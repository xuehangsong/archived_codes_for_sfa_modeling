rm(list=ls())
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
source("~/repos/sbr-river-corridor-sfa/250m_3d_model.R")

data = read.table('data/proj_coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])

proj_coord = proj_to_model(model_origin,angle,data)

save(proj_to_model,file="results/proj_to_model.r")
