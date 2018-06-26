# PRAE
The PRAE Accelerator Optics
The script run.sh will run the start-to-end simulation
convert_Octave_To_ROOT.C will convert the placet output beam to ROOT format
The optics line is put at prae.madx
The option file for the prae.mad is opt_prae.madx
The script ./scripts/madx2placet.pl can convert the madx optics to placet format
The main_*.tcl is the input file for the PLACET simulation
optimise_rf.m is used to caculate the RF voltage to compensate the R56 from magnetic chicane
