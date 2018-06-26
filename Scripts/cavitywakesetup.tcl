#
# procedure required to setup longitudinal and transverse wake fields
# as well as cavities
#
# the calculation of the short range wakes is done in octave


# initialize cavities and set longrange wake fields
proc initialize_cavities {rfparray wakelongrange wlrdarray} {
upvar $rfparray rfparams
upvar $wlrdarray wakelongrangedata

set nmodes $wakelongrangedata(nmodes)
set modes $wakelongrangedata(modes)

set wlrdata {}
for {set i 0} {$i<$nmodes} {incr i} {
    puts [lindex $modes $i]
    lappend wlrdata [lindex [lindex $modes $i] 0]
    lappend wlrdata [lindex [lindex $modes $i] 1]
    lappend wlrdata [lindex [lindex $modes $i] 2]
}

WakeSet $wakelongrange $wlrdata
InjectorCavityDefine -lambda $rfparams(lambda) -wakelong $wakelongrange
}


# create the file containing the short range wakes
proc create_wakes_file {outfile bparray rfparray particlesfile} {
    global placetunits
    upvar $bparray beamparams
    upvar $rfparray rfparams

    set sgbunch $beamparams(nsigmabunch)
    set sgwake $beamparams(nsigmawake)
    set sigmaz $beamparams(sigmaz)
    set meanz $beamparams(meanz)
    set charge $beamparams(charge)
    set nslice $beamparams(nslice)
    set usewakes $beamparams(usewakefields)
    set a $rfparams(a)
    set g $rfparams(g)
    set l $rfparams(l)
    set delta $rfparams(delta)
    set delta_g $rfparams(delta_g)

    # the calculation of the wakes is done in Octave
    Octave {
        dewake=0.0;
        if $usewakes==0
            dewake=cavity_wake_zero("$outfile",-1*$sgwake,$sgwake,$sigmaz,$meanz,$nslice);
          else
            dewake=cavity_wake("$outfile",$charge,-1*$sgwake,$sgwake,$sigmaz,$meanz,$nslice,$a,$g,$l,$delta,$delta_g,"$particlesfile");
        end;
        Tcl_SetVar("dewake",dewake);
    }
    return $dewake
}


proc create_zero_wakes_file {outfile bparray rfparray particlesfile} {
    global placetunits
    upvar $bparray beamparams
    upvar $rfparray rfparams

    set sgbunch $beamparams(nsigmabunch)
    set sgwake $beamparams(nsigmawake)
    set sigmaz $beamparams(sigmaz)
    set meanz $beamparams(meanz)
    set charge $beamparams(charge)
    set nslice $beamparams(nslice)
    set usewakes $beamparams(usewakefields)
    set a $rfparams(a)
    set g $rfparams(g)
    set l $rfparams(l)
    set delta $rfparams(delta)
    set delta_g $rfparams(delta_g)

    # the calculation of the wakes is done in Octave
    Octave {
        dewake=0.0;
	dewake=cavity_wake_zero("$outfile",-1*$sgwake,$sgwake,$sigmaz,$meanz,$nslice);
        Tcl_SetVar("dewake",dewake);
    }
    return $dewake
}

