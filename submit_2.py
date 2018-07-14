#!/usr/bin/env python

import os

for index in range(8):
    phi = 10 * (index+1)
    os.system('cp template_opt_prae.madx opt_prae.madx')
    os.system('sed -i ".bak" "s/XXXX/%d/g" opt_prae.madx' % phi)
    os.system("./run.sh")
    os.system('placet -s main_prorad.tcl')
    os.system('./optimise_rf.m')
