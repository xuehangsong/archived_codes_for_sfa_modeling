rm(list=ls())
library(rhdf5)

load("material.ids.r")
new.material = material.ids

load("../cross.section/results/general.r")
old.material = material_ids.new

