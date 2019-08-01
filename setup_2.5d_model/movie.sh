#!/bin/bash -l
casename=combined.streamline
jpgfiles=$(ls -tr figures/"$casename"{1..400}.jpg)
echo $jpgfiles
convert -delay 10 -loop 0  $jpgfiles combined.streamline.gif
