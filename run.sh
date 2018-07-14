#!/bin/bash

flag=3

madx < prae.madx > madx_run.log 

if [ $flag -eq 1 ]; then
  line="prorad"
elif [ $flag -eq 2 ]; then
  line="instrument"
else
  line="radiobiology"
fi

ps2pdf twiss_prae_${line}.ps

./scripts/madx2placet.pl twiss_prae_${line}_madx.dat 1 0 1 > lattice_prae_${line}_placet.tcl 

if [ $flag -eq 1 ]; then
  gsed -i "/M_COLLIMATOR/a\source collimator.tcl" lattice_prae_${line}_placet.tcl
fi

placet -s main_${line}.tcl
#
#if [ $flag -eq 1 ]; then
#  ./optimise_rf.m 
#fi
