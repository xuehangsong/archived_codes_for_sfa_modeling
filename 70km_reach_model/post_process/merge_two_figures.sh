#!/bin/bash -l

for itime in {1..1} ## timesteps from 2011-1-1 to 2015-12-31
##for itime in {203..641} ## timesteps from 2010-1-1 to 2015-12-31
##for itime in {276..276} 

do
echo $(printf "%04d" $itime)

convert "/global/project/projectdirs/m1800/pin/Reach_scale_model/Outputs/river_stage_6h/stage_"$(printf "%04d" $itime )".jpg" -gravity Center "/global/project/projectdirs/m1800/pin/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/tracer_6h/sorted/tracer_6h_."$(printf "%04d" $itime )".jpg" -append "/global/project/projectdirs/m1800/pin/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/tracer_stage_6h/tracer_stage_6h_"$(printf "%04d" $itime )".jpg" 

##	convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/tracer_plume/sorted/tracer."$(printf "%04d" $(($itime-1)) )".jpg" "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age."$(printf "%04d" $(($itime-1)) )".jpg" +append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age/tracer_age."$itime".jpg" 

##	convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/sorted/stage_"$itime".jpg" -resize 50% -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age/tracer_age."$itime".jpg" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age_level/tracer_age_level."$itime".jpg" 

##  convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/sorted/stage_"$itime".jpg" -resize 50% -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age."$(printf "%04d" $(($itime-1)) )".jpg" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_age_level/age_level."$itime".jpg" 

##  convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/snapshots/sorted/stage"$itime".jpg" -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/wl/sorted/wl"$itime".png" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/combo_wl_stage/wl_stage"$(printf "%03d" $itime )".jpg" 


## convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/snapshots/sorted/stage"$itime".jpg" -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/tracer_3d/tracer_3d."$(printf "%03d" $(($itime-1)) )".png" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/combo_tracer3d_stage/tracer3d_stage"$(printf "%03d" $itime )".jpg" 



## convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/snapshots/sorted/stage"$itime".jpg" -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/face_flux/sorted/flux"$itime".jpg" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/combo_flux_stage/flux_stage"$(printf "%03d" $itime )".jpg" 

# convert "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage/snapshots/sorted/stage"$itime".jpg" -gravity Center "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/tracer/horn_sorted/tracer_horn"$itime".png" -append "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2_cyclic/combo_tracer_stage_horn/tracer_stage_horn"$(printf "%03d" $itime )".jpg" 
 
done
