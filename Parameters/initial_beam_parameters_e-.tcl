#
# define beam parameters at entrances of all sections
# if tracking starts in front of a section, the corresponding
# beam parameters as defined here should be used
# these values are close to what you would get at a certain position by tracking from the start
# but the values are not corrected for wake field effects etc.
# i.e. they are not necessarily what a real simulation will give
#
# beamXXX=[betax,alphax,emitnx,betay,alphay,emitny,sigmaz,charge,
#          uncespr,echirp,energy]
# units=[m,rad,m*rad,m,rad,m*rad,m,C,1,1/m,eV]
#
# Attention: before usage the parameters must be converted to Placet units
#

# at entrance of section 0010 (Matching DR to RTML)
set beam0010(betax)    35.0
set beam0010(alphax)    -4.24
set beam0010(emitnx)    [expr 5.0e-8*137]
set beam0010(betay)     35.0
set beam0010(alphay)    -4.34
set beam0010(emitny)    [expr 5.0e-8*137]
set beam0010(sigmaz)    3.0e-3
set beam0010(meanz)     0.0e-6
set beam0010(charge)    2.0-9
set beam0010(uncespr)   2.0e-3
set beam0010(echirp)    0.0
set beam0010(energy)    0.07e9
