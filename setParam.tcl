array set args {
    machine 1
    sigma 30
}
array set args $argv
set machine $args(machine)
set sigma $args(sigma)

set beamparams(nbunches) 1
set beamparams(nslice) 100
set beamparams(nmacro) 100
set beamparams(nsigmabunch) 4
set beamparams(nsigmawake) 5
set beamparams(useisr) 1
set beamparams(usewakefields) 1
set flag 1
set bpmres 1

set charge 1.0e-9

#Octave {
#        randn("seed", 876 * 1e4);
#}


# this is needed to concatenate data at the correct z position since each step
# restarts at z=0.0
set zoffset 0.0
set fid [open zoffset.dat w]
close $fid
#
# beamparams=[betax,alphax,emitnx,betay,alphay,emitny,sigmaz,charge,
#             uncespread,echirp,energy,nslice,nmacro,nsigma]
# units=[m,rad,m*rad,m,rad,m*rad,m,C,1,1/m,eV,1,1,1]
# hence, in the array the values are stored in Placet units
set beamparams(betax) $beam0010(betax)
set beamparams(alphax) $beam0010(alphax)
set beamparams(emitnx) [expr $beam0010(emitnx)*$placetunits(emittance)]
set beamparams(betay) $beam0010(betay)
set beamparams(alphay) $beam0010(alphay)
set beamparams(emitny) [expr $beam0010(emitny)*$placetunits(emittance)]
set beamparams(sigmaz) [expr $beam0010(sigmaz)*$placetunits(xyz)]
set beamparams(meanz) [expr $beam0010(meanz)*$placetunits(xyz)]
set beamparams(charge) [expr $beam0010(charge)*$placetunits(charge)]
set beamparams(uncespread) $beam0010(uncespr)
set beamparams(echirp) [expr $beam0010(echirp)/$placetunits(xyz)]
set beamparams(energy) [expr $beam0010(energy)*$placetunits(energy)]

set beamparams(startenergy) [expr $beam0010(energy)*$placetunits(energy)]
set beamparams(meanenergy) [expr $beam0010(energy)*$placetunits(energy)]

# random misalignment of beam
set gamma [expr $beamparams(startenergy)/0.0005109989]
set emitx [expr $beamparams(emitnx)/($placetunits(emittance)*$gamma)]
set emity [expr $beamparams(emitny)/($placetunits(emittance)*$gamma)]
set betax $beamparams(betax)
set alphax $beamparams(alphax)
set betay $beamparams(betay)
set alphay $beamparams(alphay)
Octave {
    format long;
    ex=$emitx;
    bx=$betax;
    ax=$alphax;
    ey=$emity;
    by=$betay;
    ay=$alphay;

    xn =0.0*sqrt(ex)*randn(1,1);
    xpn=0.0*sqrt(ex)*randn(1,1);
    yn =0.0*sqrt(ey)*randn(1,1);
    ypn=0.0*sqrt(ey)*randn(1,1);

    x  =(sqrt(bx)*xn)*1e6;
    xp =(-ax/sqrt(bx)*xn+xpn/sqrt(bx))*1e6;
    y  =(sqrt(by)*yn)*1e6;
    yp =(-ay/sqrt(by)*yn+ypn/sqrt(by))*1e6;
    Tcl_SetVar("bm_x",x);
    Tcl_SetVar("bm_xp",xp);
    Tcl_SetVar("bm_y",y);
    Tcl_SetVar("bm_yp",yp);
}
set beamparams(meanx) $bm_x
set beamparams(meanxp) $bm_xp
set beamparams(meany) $bm_y
set beamparams(meanyp) $bm_yp
