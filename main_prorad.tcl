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
source lattice_prae_prorad_placet.tcl 
BeamlineSet -name prae

FirstOrder 1

make_particle_beam beam1 beamparams particles.in zero_wake.dat

TwissPlot -beam "beam1" -file twiss_placet.dat

Octave {
  B00 = placet_get_beam("beam1");
  #B0 = load('./output_linac_placet.dat');
  B0 = load('./output_linac_placet.dat.left');
  B0(:,4) -= mean(B0(:,4));
  #mask = abs(B0(:,1) - mean(B0(:,1))) < 0.5*std(B0(:,1));
  #mean(B0(mask,1))
  #B0(~mask,1) = mean(B0(:,1));
  #disp(["The sum of mask is " num2str(sum(mask))]);
  placet_set_beam("beam1", B0);
  [E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,0);
  save -text beam_prae_0.dat B;


  [E,B] = placet_test_no_correction("prae", "beam1", "None");
  save -text emit_prae.dat E;
  save -text beam_prae.dat B;

  #B_1 = B(mask,:);
  #
  #x = B_1(:,2);  ### micron meter
  #y = B_1(:,3);
  #xp = B_1(:,5);  ### micron radian
  #yp = B_1(:,6);

  #B_cov = cov([ x xp y yp]);

  #emit_x = sqrt(det(B_cov(1:2,1:2))) * 1e-6; ### micron meter
  #emit_y = sqrt(det(B_cov(3:4,3:4))) * 1e-6;

  #gamma = mean(B_1(:,1))/0.511e-3;
  #emit_nx = emit_x * gamma
  #emit_ny = emit_y * gamma
}
