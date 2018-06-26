SplineCreate "rtml_Wt_bc1" -file "Wt_bc1.dat"
SplineCreate "rtml_Wl_bc1" -file "Wl_bc1.dat"
ShortRangeWake "rtml_SR_bc1" -type 2 \
-wx "rtml_Wt_bc1" \
-wy "rtml_Wt_bc1" \
-wz "rtml_Wl_bc1"
WakeSet rtml_Wlong_bc1 {}

TclCall -script {
       set rfparamsbc1(lambda) [expr 299792458/(2.0e9)]
       Octave {
               CAV = placet_get_name_number_list('rtml','060C');
               placet_element_set_attribute("rtml", CAV, "short_range_wake", "rtml_SR_bc1");
               placet_element_set_attribute("rtml", CAV, "six_dim", true);
              
               lambda_bc1 = placet_element_get_attribute("rtml", CAV(1),"lambda");
               Tcl_SetVar("lambda_bc1",lambda_bc1);
       }
       InjectorCavityDefine -lambda $lambda_bc1 -wakelong rtml_Wlong_bc1
}
