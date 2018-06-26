#!/usr/bin/perl

# this script is able to processes a file saved in madx using the commands:

use constant PI => 4*atan2(1,1);

if (@ARGV < 1) { die "usage:\tmadx2placet.pl FILE 1 (:beam parameters printed into the file) 1 (:take apertures from madX (0 apertures 1 m)) 1 (:add girders)"; }

open(FILE, $ARGV[0]) or die "Could not open file $ARGV[0]\n";

@names = ();
@line = ();

my $first_element = $ARGV[1];
my $aper = $ARGV[2];
my $girder = $ARGV[3];

sub find_index  # $i = find_index("ENERGY"); $energy = $line[$i];
{
  my $name = $_[0];
  my $i;
  
  for ($i = 0; $i < @names; $i++) {
    if ($names[$i] eq $name) {
      last;
    }
  }
  return $i;
}

sub find_value  # $energy = find_value("ENERGY");
{
  return $line[find_index($_[0])];
}

$previous_s = 0.0;

while ($lines = <FILE>) {

  if ($lines =~ /^\*/) {

    @line = split(" ", $lines);

    for ($i=1;$i<@line;$i++) {
      push(@names, $line[$i]);
    }
    
  } elsif ($lines !~ /^[@\*\$]/) {

    @line = split(" ", $lines);

    if ($first_element == 1) {

      $first_element = 0;
   
      my $energy = find_value("ENERGY");

      print "set e0 $energy\n";
      print "set e_initial \$e0\n";
      print "\n";

      print "set START \"START\"\n";
      print "set END \"END\"\n";
      print "\n";

      print "set sbend_synrad 0\n";
      print "set quad_synrad 0\n";
      print "set mult_synrad 0\n";
      print "\n";

      my $beta_x = find_value("BETX");
      my $beta_y = find_value("BETY");
      my $alpha_x = find_value("ALFX");
      my $alpha_y = find_value("ALFY");
 
      print "set match(beta_x) $beta_x\n";
      print "set match(beta_y) $beta_y\n";
      print "set match(alpha_x) $alpha_x\n";
      print "set match(alpha_y) $alpha_y\n";
      print "\n";
      print "SetReferenceEnergy \$e0\n";
    }
  
    my $keyword = find_value("KEYWORD");
    my $length = find_value("L");
    my $name = find_value("NAME");
    # default aperture if aperture is not taken from MadX
    my $apx = 0.0; # beware, this is in meters.
    my $apy = 0.0; # beware, this is in meters
    if($aper == 1) {
      $apx = find_value("APER_1"); # beware, this is in meters
      $apy = find_value("APER_2"); # beware, this is in meters
    }

    my $expected_length = find_value("S") - $previous_s;
 
    if (abs($length - $expected_length)>1e-6) {
      print STDERR "Element $name (type ${keyword}) = length mismatch ($length != ${expected_length})\n";
      # $length = find_value("S") - $previous_s;
    }

    if($girder == 1) {
      print "Girder\n";
    }
    if ($keyword =~ /DRIFT/) {
      print "Drift -name $name -length $length";
    } elsif ($keyword =~ /QUADRUPOLE/) {
      my $tilt = find_value("TILT");
      my $k1l = find_value("K1L");
      print "Quadrupole -name $name -synrad \$quad_synrad -length $length -strength \[expr $k1l*\$e0\] -e0 \$e0";
      if ($tilt != 0) {
        print " -tilt $tilt";
      }
    } elsif ($keyword =~ /SEXTUPOLE/) {
      my $tilt = -1.0 * find_value("TILT");
      my $k2l = find_value("K2L");
      print "Multipole -name $name -synrad \$mult_synrad -type 3 -length $length -strength \[expr $k2l*\$e0\] -e0 \$e0";
      if ($tilt != 0) {
        print " -tilt $tilt";
      }
    } elsif ($keyword =~ /OCTUPOLE/) {
      my $tilt = -1.0 * find_value("TILT");
      my $k3l = find_value("K3L");
      # Octopolar field is flipped!
      print "Multipole -name $name -synrad \$mult_synrad -type 4 -length $length -strength \[expr $k3l*\$e0\] -e0 \$e0";
      if ($tilt != 0) {
        print " -tilt $tilt";
      }
    } elsif ($keyword =~ /MULTIPOLE/) {
      my $tilt = -1.0 * find_value("TILT");
      my $k0l = find_value("K0L");
      my $k1l = find_value("K1L");
      my $k2l = find_value("K2L");
      my $k3l = find_value("K3L");
      my $k4l = find_value("K4L");

      if ($k0l == 0 && $k1l == 0 && $k2l == 0 && $k2l == 0 && $k3l == 0 && $k4l == 0)  {
        print "# WARNING: Multipole options not defined\n";
	# Print Drift instead
	print "Drift -name $name -length $length";
      }
      if ($k0l != 0) {
        print "Dipole -name $name -synrad 0 -length $length -strength \[expr -1.0*$k0l*\$e0\] -e0 \$e0";
      } elsif ($k1l != 0) {
        print "Quadrupole -name $name -synrad \$quad_synrad -length $length -strength \[expr $k1l*\$e0\] -e0 \$e0";
      } elsif ($k2l != 0) {
        print "Multipole -name $name -synrad \$mult_synrad -type 3 -length $length -strength \[expr $k2l*\$e0\] -e0 \$e0";
      } elsif ($k3l != 0) {
        # Octopolar field is flipped!
        print "Multipole -name $name -synrad \$mult_synrad -type 4 -length $length -strength \[expr $k3l*\$e0\] -e0 \$e0";
      } elsif ($k4l != 0) {
	print "Multipole -name $name -synrad \$mult_synrad -type 5 -length $length -strength \[expr $k4l*\$e0\] -e0 \$e0";
      } 
      if ($tilt != 0) {
	print " -tilt $tilt";
      }
    } elsif ($keyword =~ /RBEND/) {
      my $k1l = find_value("K1L");
      my $k2l = find_value("K2L");
      my $tilt = find_value("TILT");
      my $angle = find_value("ANGLE");
      my $half_angle = $angle * 0.5;
      my $e1 = find_value("E1") + abs($half_angle);
      my $e2 = find_value("E2") + abs($half_angle);
      my $hgap = find_value("HGAP");
      my $fint = find_value("FINT");
      my $fintx = find_value("FINTX");
      print "# WARNING: putting a Sbend instead of a Rbend. Arc's length is : angle * L / sin(angle/2) / 2\n";
      print "# WARNING: original length was $length\n";
      print "Sbend -name $name -synrad \$sbend_synrad -six_dim $usesixdim 1 -length $length -angle $angle -E1 $e1 -E2 $e2 -e0 \$e0";
      if ($tilt != 0) {
	print " -tilt $tilt";
      }
      if ($k1l != 0.0) {
        print " -K \[expr $k1l*\$e0\]";
      }
      if ($k2l != 0.0) {
        print " -K2 \[expr $k2l*\$e0\]";
      }
      if ($hgap > 0.0) {
        print " -hgap $hgap";
      }
      if ($fint > 0.0) {
        print " -fint $fint";
      }
      if ($fintx != "") {
        print " -fintx $fintx";
      }
    } elsif ($keyword =~ /SBEND/) {
      my $k1l = find_value("K1L");
      my $k2l = find_value("K2L");
      my $tilt = find_value("TILT");
      my $angle = find_value("ANGLE");
      my $e1 = find_value("E1");
      my $e2 = find_value("E2");
      my $hgap = find_value("HGAP");
      my $fint = find_value("FINT");
      my $fintx = find_value("FINTX");
      print "Sbend -name $name -synrad \$sbend_synrad -length $length -angle $angle -E1 $e1 -E2 $e2 -six_dim 1 -e0 \$e0";
      if ($tilt != 0) {
	print " -tilt $tilt";
      }
      if ($k1l != 0.0) {
        print " -K \[expr $k1l*\$e0\]";
      }
      if ($k2l != 0.0) {
        print " -K2 \[expr $k2l*\$e0\]";
      }
      if ($hgap > 0.0) {
        print " -hgap $hgap";
      }
      if ($fint > 0.0) {
        print " -fint $fint";
      }
      if ($fintx != "") {
        print " -fintx $fintx";
      }
    } elsif ($keyword =~ /MATRIX/) {
    } elsif ($keyword =~ /RFCAVITY/ || $keyword =~ /LCAVITY/) {
      my $voltage = find_value("VOLT") * 1e-3;
      my $gradient = 0.0;
      if ($length != 0.0) {
	$gradient = $voltage / $length;
      }
      my $lag = find_value("LAG");
      my $freq = find_value("FREQ");
      my $phase = $lag * 360;
      my $phase_rad = $lag * 2 * PI;
      my $egain = $voltage * cos($phase_rad);
      print "AccCavity -name $name -length $length -gradient $gradient -phase $phase";
    } elsif ($keyword =~ /RCOLLIMATOR/) {
      print "# Collimator -name $name -length $length -e0 \$e0 -aperture_shape rectangular -aperture_x $apx -aperture_y $apy\n";
      # Print Drift instead
      print "Drift -name $name -length $length";
    } elsif ($keyword =~ /ECOLLIMATOR/) {
      print "# Collimator -name $name -length $length -e0 \$e0 -aperture_shape elliptic -aperture_x $apx -aperture_y $apy\n";
      # Print Drift instead
      print "Drift -name $name -length $length";
    } elsif ($keyword =~ /HKICKER/) {
      my $kick = find_value("KICK");
      print "# WARNING: HCORRECTOR needs to be defined, no PLACET element\n";
      print "HCORRECTOR -name $name -length $length";
      if ($kick != 0) {
	print " -strength_x [expr $kick*1e6*\$e0]";
      }
    } elsif ($keyword =~ /VKICKER/) {
      my $kick = find_value("KICK");
      print "# WARNING: VCORRECTOR needs to be defined, no PLACET element\n";
      print "VCORRECTOR -name $name -length $length";
      if ($kick != 0) {
	print " -strength_y [expr $kick*1e6*\$e0]";
      }
    } elsif ($keyword =~ /KICKER/) {
      my $hkick = find_value("HKICK");
      my $vkick = find_value("VKICK");
      print "# WARNING: CORRECTOR needs to be defined, no PLACET element\n";
      print "CORRECTOR -name $name -length $length";
      if ($hkick != 0) {
	print " -strength_x [expr $hkick*1e6*\$e0]";
      }
      if ($vkick != 0) {
	print " -strength_y [expr $vkick*1e6*\$e0]";
      }
    } elsif ($keyword =~ /MARKER/) {
      print "Drift -name $name -length $length";
    } elsif ($keyword =~ /MONITOR/ || $keyword =~ /INSTRUMENT/) {
      print "Bpm -name $name -length $length";
    } elsif ($keyword =~ /SOLENOID/) {
      my $ksi = find_value("KSI");
      my $ks = $ksi / $length;
      my $bz_e0 = $ks / 0.299792458;
      print "Solenoid -name $name -length $length -bz \[expr $bz_e0*\$e0\]";
    } elsif ($keyword =~ /LINE/) {
    } else {
        print "# UNKNOWN: @line\n";
        print "Drift -name $name -length $length"; 
    }

    # Common properties for all elements
    # Aperture
    if($apx !=0 && $apy !=0){
      print " -aperture_shape elliptic -aperture_x $apx -aperture_y $apy";
    }
    elsif($apx !=0 && $apy ==0){
      # use horizontal aperture for vertical
      print " -aperture_shape elliptic -aperture_x $apx -aperture_y $apx";
    }
    # close element
    print " \n";

    # Additional printout

    # Energy loss in bends
    if ($keyword =~ /RBEND/) {
      my $angle = find_value("ANGLE");
      print "set e0 \[expr \$e0-14.1e-6*$angle*$angle/$length*\$e0*\$e0*\$e0*\$e0*\$sbend_synrad\]\n";
      print "SetReferenceEnergy \$e0\n"
    } elsif ($keyword =~ /SBEND/) {
      my $angle = find_value("ANGLE");
      print "set e0 \[expr \$e0-14.1e-6*$angle*$angle/$length*\$e0*\$e0*\$e0*\$e0*\$sbend_synrad\]\n";
      print "SetReferenceEnergy \$e0\n"
    }

    $previous_s = find_value("S");
  } 
}

close(FILE);
