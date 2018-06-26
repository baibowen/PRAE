set tcl_precision 15

set scriptdir ./Scripts
set paramsdir ./Parameters

source $scriptdir/placet_units.tcl
source $scriptdir/beamsetup.tcl
source $paramsdir/initial_beam_parameters_e-.tcl
source $paramsdir/rf_parameters_e-.tcl
source $scriptdir/cavitywakesetup.tcl
source setParam.tcl
source octave_fun.tcl

create_particles_file particles.in beamparams
create_zero_wakes_file zero_wake.dat beamparams rfparamsbc1 particles.in

set wakelongrangedata(nmodes) 0
set wakelongrangedata(modes) {}
initialize_cavities rfparamsbc1 wakelong1 wakelongrangedata

BeamlineNew
source lattice_prae_therapy_placet.tcl 
BeamlineSet -name prae

FirstOrder 1

make_particle_beam beam1 beamparams particles.in zero_wake.dat

TwissPlot -beam "beam1" -file twiss_prae_therapy_placet.dat

Octave {
  [E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,0);
  save -text beam_prae_therapy_0.dat B;


  #END = placet_get_name_number_list("prae","D_TRIPLET_2ND_TO_CHICANE");

  #[E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,END);
  #save -text beam_prae_therapy_1.dat B;

  [E,B] = placet_test_no_correction("prae", "beam1", "None");
  save -text emit_prae_therapy.dat E;
  save -text beam_prae_therapy.dat B;
}
