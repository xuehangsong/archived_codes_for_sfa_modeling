## rename files

# setwd("/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/sorted/")
setwd("/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/tracer/horn_sorted/")

library(gtools)
# list.stage = list.files(path = "river_stage/.", pattern = "*.stage.jpg")
# list.stage = mixedsort(list.stage)

# Sort Strings With Embedded Numbers So That The Numbers Are In The Correct Order
# file.rename(mixedsort(list.files(pattern = "river_stage*")), paste0("stage_", 1:641, ".jpg"))

#file.rename(mixedsort(list.files(pattern = "gw_age_*")), paste0("age_", 1:641, ".jpg"))

#file.rename(mixedsort(list.files(pattern = "resize*")), paste0("stage", 1:366, ".jpg"))

# file.rename(list.files(pattern = "resize*"), paste0("stage", sprintf("%03d", 1:366), ".jpg"))

file.rename(list.files(pattern = "*"), paste0("tracer_horn", 1:366, ".png"))

file.rename(list.files(path = "./", pattern = "*.jpg"), paste0("tracer_120h_", sprintf("%04d", 1:366), ".jpg"))