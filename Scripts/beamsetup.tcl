# create a file containing a particle distibution
proc create_particles_file {outfile bparray} {
    global placetunits
    upvar $bparray beamparams

    set bx $beamparams(betax)
    set ax $beamparams(alphax)
    set enx $beamparams(emitnx)
    set by $beamparams(betay)
    set ay $beamparams(alphay)
    set eny $beamparams(emitny)
    set sigmaz $beamparams(sigmaz)
    set meanz $beamparams(meanz)
    set espread $beamparams(uncespread)
    set echirp $beamparams(echirp)
    set energy $beamparams(startenergy)
    set nslice $beamparams(nslice)
    set nmacro $beamparams(nmacro)
    set nsigma $beamparams(nsigmabunch)

    set meanx $beamparams(meanx)
    set meanxp $beamparams(meanxp)
    set meany $beamparams(meany)
    set meanyp $beamparams(meanyp)

    set npart [expr $nmacro*$nslice]

    set pu_xyz $placetunits(xyz)
    set pu_xpyp $placetunits(xpyp)
    set pu_e $placetunits(energy)
    set pu_emit $placetunits(emittance)

    # the creation of the particle distribution is done in Octave
    Octave {
    create_particle_distribution("$outfile",$bx,$ax,$enx,$by,$ay,$eny,$sigmaz,$meanz,$espread,$echirp,$energy,$meanx,$meanxp,$meany,$meanyp,$nsigma,$npart,$pu_xyz,$pu_xpyp,$pu_e,$pu_emit);
    }
}


# set up the internal structure which stores the beam and
# use BeamRead to overwrite the particle distribution which is automatically
# created by InjectorBeam by the one stored in the file particlesfile
#
# the beam will be a single bunch only
proc make_particle_beam {beamname bparray particlesfile wakefile} {
    upvar $bparray beamparams

    InjectorBeam $beamname -bunches 1 \
	    -macroparticles $beamparams(nmacro) \
	    -particles [expr $beamparams(nslice)*$beamparams(nmacro)] \
	    -energyspread $beamparams(uncespread) \
	    -ecut $beamparams(nsigmawake) \
	    -e0 $beamparams(startenergy) \
	    -file $wakefile \
	    -chargelist {1.0} \
	    -charge $beamparams(charge) \
	    -phase 0.0 \
	    -overlapp 0.0 \
	    -distance 0.0 \
	    -beta_x $beamparams(betax) \
	    -alpha_x $beamparams(alphax) \
	    -emitt_x $beamparams(emitnx) \
	    -beta_y $beamparams(betay) \
	    -alpha_y $beamparams(alphay) \
	    -emitt_y $beamparams(emitny)

    # now load the real particles
    BeamRead -file $particlesfile -beam $beamname
}
