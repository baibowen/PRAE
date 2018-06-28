TclCall -script {
  Octave {
    B0 = placet_get_beam();   
    mask_colli = abs(B0(:,2)) < XXXX; ### micron meter 
    save -text 'B_colli.dat' B0 mask_colli;
    }
}
