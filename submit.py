#!/usr/bin/env python

import os

for index in range(8):
    phi = 10 * (index+1)
    os.system('cp template_opt_prae.madx opt_prae.madx')
    os.system('gsed -i "s/XXXX/%d/g" opt_prae.madx' % phi)
    os.system("./run.sh")
    for job in range(5):
        os.system('cp template_collimator.tcl collimator.tcl ')
        coll_size = 1000*(job+1)
        os.system('gsed -i "s/XXXX/%d/g" collimator.tcl' % coll_size)
        os.system('placet -s main_prorad.tcl')
        os.system('./optimise_rf.m')
    os.system("echo %d  R56 %e >>result.txt" % (phi,coll_size/1.0e3));
