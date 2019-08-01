#!/bash/bin -l

for itime in $(seq 219 365)
do
echo $(printf "%04d" $itime)
convert "/home/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf" \
"/files1/song884/bpt/new_simulation_13_5/figures/tracer2/tracer2."$(printf "%04d" $itime)".jpg" \
-append "/files1/song884/bpt/new_simulation_13_5/figures/tracer_2_combined_2/"$itime".pdf"  
done
# echo $(printf "%04d" $itime)
# convert  "../bpt/visual/Xingyuan/1_tracer/river."
# "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation/figures/flux_average/flux"$itime".pdf"  \
# +append temp111.pdf
# convert "/home/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf" temp111.pdf \
# -append "/home/song884/john_paper/figures/Xingyuan_tracer1_combined_3/"$itime".pdf"  
