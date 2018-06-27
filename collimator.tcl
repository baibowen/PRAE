TclCall -script {
  Octave {
    B0 = placet_get_beam();   
    mask_colli = abs(B0(:,2)) < 1000; ### micron meter 
    save -text 'B_colli.dat' B0 mask_colli;
    }
}
