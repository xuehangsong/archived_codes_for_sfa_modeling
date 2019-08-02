#!/bin/bash

for itime in {276..641} ## timesteps from 2010-1-1 to 2015-12-31
##for itime in {203..641} ## timesteps from 2010-1-1 to 2015-12-31
##for itime in {203..203} ## timesteps from 2010-1-1 to 2015-12-31

do
	echo $(printf "%04d" $itime)

	convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/tracer_plume/sorted/tracer_"$itime".jpg" "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age_"$itime".jpg" +append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age/tracer_age."$itime".jpg" 

	convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/sorted/stage_"$itime".jpg" -resize 30% -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age/tracer_age."$itime".jpg" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age_level/tracer_age_level."$itime".jpg" 

 
done
