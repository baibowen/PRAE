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
source lattice_prae_radiobiology_placet.tcl 
BeamlineSet -name prae

FirstOrder 1

make_particle_beam beam1 beamparams particles.in zero_wake.dat

TwissPlot -beam "beam1" -file twiss_prae_radiobiology_placet.dat

Octave {

  B00 = placet_get_beam("beam1");
  B0 = load('./output_linac_placet.dat');
  #mask = abs(B0(:,1) - mean(B0(:,1))) < 0.5*std(B0(:,1));
  #B0(~mask,1) = mean(B0(:,1));
  #disp(["The sum of mask is " num2str(sum(mask))]);
  placet_set_beam("beam1", B0);

  [E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,0);
  save -text beam_prae_radiobiology_0.dat B;
  save -text emit_prae_radiobiology_0.dat E;

  disp(["The x beam size is " num2str(std(B)(:,2)) " um"]);
  disp(["The y beam size is " num2str(std(B)(:,3)) " um"]);
  disp(["The energy spread is " num2str(std(B)(:,1)/mean(B(:,1)))]);


  #END = placet_get_name_number_list("prae","D_TRIPLET_2ND_TO_CHICANE");

  #[E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,END);
  #save -text beam_prae_radiobiology_1.dat B;

  [E,B] = placet_test_no_correction("prae", "beam1", "None");
  save -text emit_prae_radiobiology.dat E;
  save -text beam_prae_radiobiology.dat B;

  disp(["The x beam size is " num2str(std(B)(:,2)) " um"]);
  disp(["The y beam size is " num2str(std(B)(:,3)) " um"]);
  disp(["The energy spread is " num2str(std(B)(:,1)/mean(B(:,1)))]);

  beta_f_x = 6.7; ## meter
  beta_f_y = 6.1; ## meter
  emit_x = 0.1*E(end,2); ## um
  emit_y = 0.1*E(end,6); ## um
  gamma_rel = mean(B(:,1))/0.511e-3;

  disp(["The expected x beam size is " num2str(sqrt(emit_x*beta_f_x*1e6/gamma_rel)) " um"]);
  disp(["The expected y beam size is " num2str(sqrt(emit_y*beta_f_y*1e6/gamma_rel)) " um"]);
}


Octave {
  
  source misalign.m
  
  }
