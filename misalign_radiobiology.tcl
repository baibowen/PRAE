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

set machine_start 1
set machine_end 100

Octave {

      quads = placet_get_number_list("prae", "quadrupole");
      sbends = placet_get_number_list("prae", "sbend");

      STRENGTH_perfect = placet_element_get_attribute("prae", quads, "strength");
      E0_perfect = placet_element_get_attribute("prae", sbends, "e0");

}

proc my_survey {} {
  global machine sigma bpmres
    Octave {
      sigma_xy = 100; %%% um
      roll = 100; %%% urad
      sigma_strength = 2e-3;

      randn("seed", $machine * 1e4);

      magnets = placet_get_number_list("prae", "quadrupole");
      magnets = [ magnets placet_get_number_list("prae", "sbend") ];
      quads = placet_get_number_list("prae", "quadrupole");
      sbends = placet_get_number_list("prae", "sbend");

      placet_element_set_attribute("prae", magnets, "xp", randn(size(magnets))*sigma_xy);
      placet_element_set_attribute("prae", magnets, "yp", randn(size(magnets))*sigma_xy);
      placet_element_set_attribute("prae", magnets, "roll", randn(size(magnets))*roll);
      placet_element_set_attribute("prae", magnets, "xp", randn(size(magnets))*roll);
      placet_element_set_attribute("prae", magnets, "yp", randn(size(magnets))*roll);

      placet_element_set_attribute("prae", quads, "strength", STRENGTH_perfect.*(1+sigma_strength*randn(size(quads))'));
      placet_element_set_attribute("prae", sbends, "e0", E0_perfect.*(1+sigma_strength*randn(size(sbends))'));
    }
}

Octave {

  B00 = placet_get_beam("beam1");
  B0 = load('./output_linac_placet.dat');
  placet_set_beam("beam1", B0);

  R = [];

}

for {set machine $machine_start} {$machine <= $machine_end} {incr machine} {

  puts "MACHINE: $machine"

  my_survey

  Octave {

  [E,B] = placet_test_no_correction("prae", "beam1", "None");
  save -text emit_mis_prae_radiobiology.dat E;
  save -text beam_mis_prae_radiobiology.dat B;

  R = [R;$machine, std(B(:,2)), std(B(:,3)), E(end,2)*0.1,E(end,6)*0.1];

  disp(["The x beam size is " num2str(std(B)(:,2)) " um"]);
  disp(["The y beam size is " num2str(std(B)(:,3)) " um"]);
  disp(["The energy spread is " num2str(std(B)(:,1)/mean(B(:,1)))]);
  }
}


Octave {
  

  save -text resutlt_sigma_radiobiology.dat R;

  std(R)
}
