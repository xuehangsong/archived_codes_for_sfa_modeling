#!/bin/bash -

convert -delay 1 -quality 100 paraview/default/default*png figures/default.gif
convert -delay 1 -quality 100 paraview/map/map*png figures/map.gif
