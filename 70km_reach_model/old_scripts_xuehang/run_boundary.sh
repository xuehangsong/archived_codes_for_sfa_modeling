#!/bin/bash -l

Rscript mass.data.R
Rscript mass.multi.boundary.R
Rscript mass.multi.smooth.boundary.R

wait
