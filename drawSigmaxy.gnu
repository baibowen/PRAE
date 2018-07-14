#!/usr/bin/env gnuplot

set terminal postscript eps enhanced color font 'Helvetica,10'

set output 'sigma_xy_misalign.eps'

set xlabel 'number'
set ylabel '\sigma (\mu m)'

#set yrange [0:1]
#set xrange [0:1]
#set grid
#set title 'title'

#set grid

plot "resutlt_sigma_radiobiology.dat" u 1:2 w lp axis x1y1 t 'sigma_x', "resutlt_sigma_radiobiology.dat" u 1:3 t '\sigma_y' w lp
