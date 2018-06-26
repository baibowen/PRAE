#
# define RF parameters
#
# rfparams=[gradient,gradientww,phase,wavelength,a,g,l,delta,delta_g]
# units=[eV/m,eV/m,Degree,m,m,m,m,?,?]
#
# Attention: before usage the parameters must be converted to Placet units
#

# no wakes
set rfparamsbc1(gradient) [expr 13.14e6]
# with wakes
set rfparamsbc1(gradientww) [expr 13.238e6]
set rfparamsbc1(phase) 90.0
set rfparamsbc1(lambda) [expr 299792458/(2.0e9)]
set rfparamsbc1(a) 17.0e-3
set rfparamsbc1(g) 42.0e-3
set rfparamsbc1(l) 50.0e-3
set rfparamsbc1(delta) 0.0
set rfparamsbc1(delta_g) 0.0
