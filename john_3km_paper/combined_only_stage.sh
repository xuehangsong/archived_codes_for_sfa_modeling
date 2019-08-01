#!/bash/bin -l

for itime in $(seq 219 365)
do
    echo $itime
    convert -density 150 /Users/song884/john_paper/figures/Xingyuan_wl/"$itime".pdf -quality 100 /Users/song884/john_paper/xingyuan_ua/wl/"$itime".jpg
done    

convert -delay 10 -quality 100 /Users/song884/john_paper/xingyuan_ua/wl/*jpg /Users/song884/john_paper/xingyuan_ua/wl.gif
