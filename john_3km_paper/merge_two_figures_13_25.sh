#!/bash/bin -l

##for itime in $(seq 219 365)
for itime in $(seq 317 317)
do
echo $(printf "%04d" $itime)
convert "/home/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf" \
"/files1/song884/bpt/new_simulation_13_25/figures/gw_tracer/gw."$(printf "%04d" $itime)".jpg" \
-append "/files1/song884/bpt/new_simulation_13_25/figures/gw_tracer_combinded/"$itime".pdf"  
done
