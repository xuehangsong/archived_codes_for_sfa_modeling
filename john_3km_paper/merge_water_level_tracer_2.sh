#!/bash/bin -l

for itime in $(seq 219 438)
do
echo $(printf "%04d" $itime)
convert  "/home/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf"  \
"../bpt/visual/Xingyuan/2_tracer/river."$(printf "%04d" $itime)".jpg" \
-append "/home/song884/john_paper/figures/Xingyuan_tracer2_combined/"$itime".pdf"  
done
##
