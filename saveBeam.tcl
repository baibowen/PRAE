Octave {
  [E,B] = placet_test_no_correction("prae", "beam1", "None");

    load("B_colli.dat");
  
  componets = {"D_KICKER_TO_CHICANE","D_CHICANE_1","D_CHICANE_2","D_CHICANE_3","D_TRIPLET_4TH_TO_TARGET"};
  for i = 1:length(componets)
      AA = placet_get_name_number_list("prae", componets{1,i});
      disp(componets{1,i})
      [E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,AA);
      save(["beam_prorad_" componets{1,i} ".dat"],"B");
      disp(["The x beam size is " num2str(std(B(:,2))) " um"]);
      disp(["The x beam divergence is " num2str(std(B(:,5))) " urad"]);
      disp(["The y beam size is " num2str(std(B(:,3))) " um"]);
      disp(["The y beam divergence is " num2str(std(B(:,6))) " urad"]);
      disp(["After Collimator The x beam size is " num2str(std(B(mask_colli,2))) " um"]);
      disp(["After Collimator The x beam divergence is " num2str(std(B(mask_colli,5))) " urad"]);
      disp(["After Collimator The y beam size is " num2str(std(B(mask_colli,3))) " um"]);
      disp(["After Collimator The y beam divergence is " num2str(std(B(mask_colli,6))) " urad"]);
  
  endfor


  #componets = {"D_DOUBLET_TO_DOGLEG","D_TRIPLET_2ND_TO_KICKER","D_TRIPLET_3RD_TO_TARGET"};
  #for i = 1:length(componets)
  #    AA = placet_get_name_number_list("prae", componets{1,i});
  #    disp(componets{1,i})
  #    [E,B] = placet_test_no_correction("prae", "beam1", "None",1,0,AA);
  #    save(["beam_radio_" componets{1,i} ".dat"],"B");
  #    disp(["The x beam size is " num2str(std(B(:,2))) " um"]);
  #    disp(["The x beam divergence is " num2str(std(B(:,5))) " urad"]);
  #    disp(["The y beam size is " num2str(std(B(:,3))) " um"]);
  #    disp(["The y beam divergence is " num2str(std(B(:,6))) " urad"]);
  #    disp("------------------");

  #endfor
  
}
