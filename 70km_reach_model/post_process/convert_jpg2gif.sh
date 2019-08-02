#!/bin/bash -l

##convert -delay 50 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age_level/tracer_age_level.*.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_age_level/tracer_age_level.gif

convert -delay 50 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age_{276..641}.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age.gif

convert -delay 50 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age_{276..641}.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/GW_age/sorted/age.gif
 
convert -delay 10 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/head/resize*.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/head/head_2011_2015.gif

convert -delay 10 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_level/tracer_level*.jpg -resize 30% /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/test_2007_age/combined_tracer_level/tracer_level_2011_2015.gif

convert -delay 1 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/river_stage/resize*.png -resize 30% /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/river_stage/river_stage_2011_2015.gif

convert -delay 1 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/age/age*.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/age/age_2011_2015.gif

convert -delay 1 -loop 0 -quality 75 /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/tracer/tracer*.jpg /Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_200x200x5/tracer/tracer_2011_2015.gif
