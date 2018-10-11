#!/usr/bin/env gnuplot
set terminal postscript eps enhanced color font 'Helvetica,10'
set output "SURVEY.eps"
set multiplot
set key right top
set grid

##### Draw the geometry box
height = 7 ### meter
L_H1 = 15.73
L_H2 = 13.35

L_tilt = 13.0
angle = 28*pi/180 #### 28 degree

origin_x = 0
origin_y = 0

set style arrow 1 nohead lw 2
set arrow  from origin_x,origin_y to origin_x,height as 1
set style arrow 2 nohead lw 2
set arrow  from origin_x,origin_y to L_H1+L_H2,origin_y as 2
set style arrow 3 nohead lw 2
set arrow  from L_H1,height to (L_H1+L_tilt*cos(angle)),(height+L_tilt*sin(angle)) as 3
set style arrow 4 nohead lw 2
set arrow  from origin_x,height to L_H1,height as 4 
set style arrow 5 nohead lw 2 
set arrow  from (15.730+13*cos(0.48869)),(7+13*sin(0.48869)) to 15.730+13.350,0 as 5

####
set style arrow 6 nohead lw 2 
set arrow  from 28.5,13.1 to 29.6,13.1 as 5   ##### The legend
set label 'Box' at 28.3,13.05 right font "Droid, 15"


###################################################
#### Draw the beamline
shift_linac = -5;
shift_vertical = 1.5;

set xlabel "x, m"
set ylabel "y, m"
set xrange [-1:30] 
set yrange [-1:14] 
set title "Plotting location beam "
set key font "Droid, 15"
#plot 'survey_radiobiology_gnuplot.dat' u (shift_linac+$4):(-1*$2 + 2.0) w l title "survey" lw 4
plot 'survey_prorad_gnuplot.dat' u (shift_linac+$4):(1*$2 + shift_vertical) w l title "survey" lw 4, 'survey_radiobiology_gnuplot.dat' u (shift_linac+$4):(-1*$2 + shift_vertical) w l title "survey" lw 4

replot


system("epstopdf SURVEY.eps")
system("open SURVEY.pdf")
