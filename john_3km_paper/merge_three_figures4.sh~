#!/bash/bin -l

for itime in $(seq 219 438)
do
echo $(printf "%04d" $itime)

convert  "../bpt/visual/Xingyuan/2_tracer/river."$(printf "%04d" $itime)".jpg" \
"/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation/figures/flux_average/flux"$itime".pdf"  \
+append temp222.pdf
convert "/home/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf" temp222.pdf \
-append "/home/song884/john_paper/figures/Xingyuan_tracer2_combined_3/"$itime".pdf"  
done
