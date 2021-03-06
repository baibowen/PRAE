% some functions to calculate corrector settings
% i.e. dipole corrector strengths, quad positions,...
%

%----------------------------------------
function [emitfinal,beamfinal]=trajectory_correction(beamlinename,beamname,correctiontype,correctortype,numberofsets,...
          bpmfilename,correctorsfilename,statfilename,...
          error_cavity_pos,error_cavity_gradient_rel,...
          error_bend_pos,error_bend_strength_rel,...
          error_quadrupole_pos,error_quadrupole_strength_rel,...
          error_multipole_pos,error_multipole_strength_rel,...
          error_bpm_pos,bpm_resolution,keepolderrors,coupledplanes,rm_bpm_resolution,rm_stepsize)

format long;

% some variables which are needed later

delta_quad_str=0.05;

disp_traj_bpm_res=0.0;
df_wgt=1;
df_wgt_p=100;
df_wgt_m=100;

df_svd_cut=0.0000001;
svd_svd_cut=0.001;
pre_svd_cut=0.01;


% some initialisations
if strcmpi(correctortype,"dipole")
  corrxattr="strength_x";
  corryattr="strength_y";
elseif strcmpi(correctortype,"quadrupole")
  corrxattr="x";
  corryattr="y";
else
  correctortype="quadrupole";
  corrxattr="x";
  corryattr="y";
end;

fid=fopen(bpmfilename,"wt");
fprintf(fid,"#BPM readings (in micrometer)\n");
fprintf(fid,"#%21s %22s %22s %22s %22s %22s %22s %22s\n",
            "std BPM X initial","std BPM X final","mean BPM X initial","mean BPM X final",
            "std BPM Y initial","std BPM Y final","mean BPM Y initial","mean BPM Y final");
fclose(fid);

fid=fopen(correctorsfilename,"wt");
if strcmpi(correctortype,"dipole")
  fprintf(fid,"#Corrector settings (in GeV/micrometer)\n");
  fprintf(fid,"#%21s %22s %22s %22s %22s %22s %22s %22s\n",
              "std strength X ini","std strength X fin","mean strength X ini","mean strength X fin",
              "std strenght Y ini","std strength Y fin","mean strength Y ini","mean strength Y fin");
end;
if strcmpi(correctortype,"quadrupole")
  fprintf(fid,"#Corrector settings (in micrometer)\n");
  fprintf(fid,"#%21s %22s %22s %22s %22s %22s %22s %22s\n",
              "std offset X ini","std offset X fin","mean offset X ini","mean offset X fin",
              "std offset Y ini","std offset Y fin","mean offset Y ini","mean offset Y fin");
end;
fclose(fid);

btest=placet_get_beam(beamname);
if (columns(btest)==17)
  fid=fopen(statfilename,"wt");
  fprintf(fid,"# bunch train data\n");
  fprintf(fid,"# %18s %20s %20s %20s %20s %20s %20s %20s ",
              "semit nx [nm rad]","semit nx [nm rad]","temit nx [nm rad]","temit nx [nm rad]",
              "semit ny [nm rad]","semit ny [nm rad]","temit ny [nm rad]","temit ny [nm rad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean x [um]","mean x [um]","std x [um]","std x [um]","mean sx [um]","mean sx [um]",
              "mean xp [urad]","mean xp [urad]","std xp [urad]","std xp [urad]","mean sxp [um]","mean sxp [um]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean y [um]","mean y [um]","std y [um]","std y [um]","mean sy [um]","mean sy [um]",
              "mean yp [urad]","mean yp [urad]","std yp [urad]","std yp [urad]","mean syp [um]","mean syp [um]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "mean s [um]","mean s [um]","std s [um]","std s [um]",
              "mean e [GeV]","mean e [GeV]","std e [GeV]","std e [GeV]","dee [1]","dee [1]");

  fprintf(fid,"# %18s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fclose(fid);
 elseif (columns(btest)==6)
  fid=fopen(statfilename,"wt");
  fprintf(fid,"# bunch train data\n");
  fprintf(fid,"# %18s %20s %20s %20s ",
              "temit nx [nm rad]","temit nx [nm rad]",
              "temit ny [nm rad]","temit ny [nm rad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean x [um]","mean x [um]","std x [um]","std x [um]",
              "mean xp [urad]","mean xp [urad]","std xp [urad]","std xp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean y [um]","mean y [um]","std y [um]","std y [um]",
              "mean yp [urad]","mean yp [urad]","std yp [urad]","std yp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "mean s [um]","mean s [um]","std s [um]","std s [um]",
              "mean e [GeV]","mean e [GeV]","std e [GeV]","std e [GeV]","dee [1]","dee [1]");

  fprintf(fid,"# %18s %20s %20s %20s ",
              "ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fclose(fid);

  fid=fopen("beam_stat_dc.txt","wt");
  fprintf(fid,"# bunch train data\n");
  fprintf(fid,"# %18s %20s %20s %20s ",
              "temit nx [nm rad]","temit nx [nm rad]",
              "temit ny [nm rad]","temit ny [nm rad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean x [um]","mean x [um]","std x [um]","std x [um]",
              "mean xp [urad]","mean xp [urad]","std xp [urad]","std xp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean y [um]","mean y [um]","std y [um]","std y [um]",
              "mean yp [urad]","mean yp [urad]","std yp [urad]","std yp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "mean s [um]","mean s [um]","std s [um]","std s [um]",
              "mean e [GeV]","mean e [GeV]","std e [GeV]","std e [GeV]","dee [1]","dee [1]");

  fprintf(fid,"# %18s %20s %20s %20s ",
              "ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fclose(fid);

  fid=fopen("beam_stat_dc+cc.txt","wt");
  fprintf(fid,"# bunch train data\n");
  fprintf(fid,"# %18s %20s %20s %20s ",
              "temit nx [nm rad]","temit nx [nm rad]",
              "temit ny [nm rad]","temit ny [nm rad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean x [um]","mean x [um]","std x [um]","std x [um]",
              "mean xp [urad]","mean xp [urad]","std xp [urad]","std xp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean y [um]","mean y [um]","std y [um]","std y [um]",
              "mean yp [urad]","mean yp [urad]","std yp [urad]","std yp [urad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "mean s [um]","mean s [um]","std s [um]","std s [um]",
              "mean e [GeV]","mean e [GeV]","std e [GeV]","std e [GeV]","dee [1]","dee [1]");

  fprintf(fid,"# %18s %20s %20s %20s ",
              "ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fclose(fid);
 else
  printf("trajectory_correction: called with wrong bunch.\n");
  emitfinal=0;
  beamfinal=0;
  return;
end;


% get lists of bpms and correctors
%
list_bpm=placet_get_number_list(beamlinename,"bpm");
list_corr=placet_get_number_list(beamlinename,correctortype);

numbpm=length(list_bpm);
numcorr=length(list_corr);

if (numbpm==0)||(numcorr==0)
  printf("No correctors or BPMs. Tracking will be performed without corrections.\n");
  [emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
  return;
end;

printf("Initializing %s correction...\n",correctiontype);

% Getting response matrices and calculating SVD matrices can take a rediculous amount of time.
% Hence, it is a good idea to make these calculations once, save the result and reuse that.
% If a file with the correct name already exists, this is used and no calculation is done.
RM=0;

reloaded=0;
datafile=sprintf("response_matrix_%s.dat",beamlinename);
fid=fopen(datafile,"r");
if (fid!=-1)
    fclose(fid);
    printf("Reusing existing file for response matrices and SVD coefficients.\n");
    load(datafile);
    reloaded=1;
end;

if (rows(RM)!=2*numbpm)||(columns(RM)!=2*numcorr)
    if (reloaded!=0)
        printf("Number of BPMs or correctors does not match with re-loaded matrices. Re-calculating...\n");
        datafile=sprintf("response_matrix_%s_new.dat",beamlinename);
    end;
    % get response matrix
    syscall=sprintf("rm -f %s",datafile);
    system(syscall);
    RM=calc_response_matrix(beamlinename,beamname,list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                            rm_bpm_resolution,rm_stepsize);
    save("-text",datafile,"RM");
end;

if (coupledplanes==0)
  RMn=zeros(2*numbpm,2*numcorr);
  RMn(1:numbpm,1:numcorr)=RM(1:numbpm,1:numcorr);
  RMn(numbpm+1:2*numbpm,numcorr+1:2*numcorr)=RM(numbpm+1:2*numbpm,numcorr+1:2*numcorr);
  RM=RMn;
end;

%
% setup for dispersion free steering and evaluation of the corresponding response matrices
%
list_quads=placet_get_number_list(beamlinename,"quadrupole");
if strcmpi(correctiontype,"dispfree_quad")
    % setup for dispersion free correction using different quadrupole settings
    beamname_p=beamname;
    beamname_m=beamname;
    
    str_orig=placet_element_get_attribute(beamlinename,list_quads,"strength");
    str_p=(1.0+delta_quad_str)*str_orig;
    str_m=(1.0-delta_quad_str)*str_orig;
end;

if strcmpi(correctiontype,"dispfree_de")
    % setup for dispersion free correction using beams with energy offsets
    beamname_p=sprintf("%s_dep",beamname);
    beamname_m=sprintf("%s_dem",beamname);
    
    str_orig=placet_element_get_attribute(beamlinename,list_quads,"strength");
    str_p=str_orig;
    str_m=str_orig;
end;

if strcmpi(correctiontype,"dispfree_de") || strcmpi(correctiontype,"dispfree_quad")
    % evaluate dispersion trajectories
    Res=placet_element_get_attribute(beamlinename,list_bpm,"resolution");
    placet_element_set_attribute(beamlinename,list_bpm,"resolution",disp_traj_bpm_res);

    placet_test_no_correction(beamlinename,beamname,"None");
    bpm_x_orig=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
    bpm_y_orig=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_p);
    placet_test_no_correction(beamlinename,beamname_p,"None");
    bpm_x_p=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
    bpm_y_p=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_m);
    placet_test_no_correction(beamlinename,beamname_m,"None");
    bpm_x_m=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
    bpm_y_m=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_orig);
    placet_element_set_attribute(beamlinename,list_bpm,"resolution",Res);

    disp_x_p=bpm_x_p-bpm_x_orig;
    disp_y_p=bpm_y_p-bpm_y_orig;
    disp_x_m=bpm_x_m-bpm_x_orig;
    disp_y_m=bpm_y_m-bpm_y_orig;

    RM_p=0;
    RM_m=0;

    reloaded=0;
    datafile=sprintf("response_matrix_dispfree_%s.dat",beamlinename);
    fid=fopen(datafile,"r");
    if (fid!=-1)
        fclose(fid);
        printf("Reusing existing file for response matrices of energy offset beams.\n");
        load(datafile);
        reloaded=1;
    end;

    if (rows(RM_p)!=2*numbpm)||(columns(RM_p)!=2*numcorr)||...
       (rows(RM_m)!=2*numbpm)||(columns(RM_m)!=2*numcorr)
        if (reloaded!=0)
            printf("Number of BPMs or correctors does not match with re-loaded matrices. Re-calculating...\n");
            datafile=sprintf("response_matrix_dispfree_%s_new.dat",beamlinename);
        end;
        % get response matrix
        syscall=sprintf("rm -f %s",datafile);
        system(syscall);

        placet_element_set_attribute(beamlinename,list_quads,"strength",str_p);
        RM_p=calc_response_matrix(beamlinename,beamname_p,list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                                  rm_bpm_resolution,rm_stepsize);

        placet_element_set_attribute(beamlinename,list_quads,"strength",str_m);
        RM_m=calc_response_matrix(beamlinename,beamname_m,list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                                  rm_bpm_resolution,rm_stepsize);

        placet_element_set_attribute(beamlinename,list_quads,"strength",str_orig);

        save("-text",datafile,"RM_p","RM_m");
    end;
    RM_p=RM_p-RM;
    RM_m=RM_m-RM;

    if (coupledplanes==0)
        RMn_p=zeros(2*numbpm,2*numcorr);
        RMn_m=zeros(2*numbpm,2*numcorr);
        RMn_p(1:numbpm,1:numcorr)=RM_p(1:numbpm,1:numcorr);
        RMn_m(1:numbpm,1:numcorr)=RM_m(1:numbpm,1:numcorr);
        RMn_p(numbpm+1:2*numbpm,numcorr+1:2*numcorr)=RM_p(numbpm+1:2*numbpm,numcorr+1:2*numcorr);
        RMn_m(numbpm+1:2*numbpm,numcorr+1:2*numcorr)=RM_m(numbpm+1:2*numbpm,numcorr+1:2*numcorr);
        RM_p=RMn_p;
        RM_m=RMn_m;
    end;

    RM_tot=[df_wgt*RM;df_wgt_p*RM_p;df_wgt_m*RM_m];
    pinvRM_tot=pinv(RM_tot);
    %for correction using SVD
    [UT,Sinv,V]=mysvd(RM_tot,df_svd_cut);
    MI=V*Sinv*UT;
end;

beamini=placet_get_beam(beamname);
[emitperfect,beamperfect]=placet_test_no_correction(beamlinename,beamname,"None");
train_stat(beamini,beamperfect,statfilename);
fid=fopen(statfilename,"at");
fprintf(fid,"#\n");
fclose(fid);
train_stat(beamini,beamperfect,"beam_stat_dc.txt");
fid=fopen("beam_stat_dc.txt","at");
fprintf(fid,"#\n");
fclose(fid);
train_stat(beamini,beamperfect,"beam_stat_dc+cc.txt");
fid=fopen("beam_stat_dc+cc.txt","at");
fprintf(fid,"#\n");
fclose(fid);

%
% start the tracking
%
printf("Starting correction of %d misalignment sets.\n",numberofsets);
for nset=1:numberofsets
  printf("Initializing beam line (Set %d of %d).\n",nset,numberofsets);
  % set everything to zero, i.e. start from perfect machine
  placet_element_set_attribute(beamlinename,list_corr,corrxattr,zeros(numcorr,1));
  placet_element_set_attribute(beamlinename,list_corr,corryattr,zeros(numcorr,1));

  corr_sx_initial=zeros(numcorr,1);
  corr_sy_initial=zeros(numcorr,1);

  % induce errors, i.e. misalignment and strength errors, and set bpm resolution
  induce_beamline_errors(beamlinename,...
    error_cavity_pos,error_cavity_gradient_rel,...
    error_bend_pos,error_bend_strength_rel,...
    error_quadrupole_pos,error_quadrupole_strength_rel,...
    error_multipole_pos,error_multipole_strength_rel,...
    error_bpm_pos,bpm_resolution,keepolderrors);

  % track through misaligned beamline
  [emituncorrected,beamuncorrected]=placet_test_no_correction(beamlinename,beamname,"None");
  bpm_x_uncorrected=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
  bpm_y_uncorrected=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");

  % apply correction
  if strcmpi(correctiontype,"svd")
    [emitfinal,beamfinal]=trajectory_correction_svd(beamlinename,beamname,...
                                                    list_bpm,correctortype,list_corr,corrxattr,corryattr,RM,svd_svd_cut);
  elseif strcmpi(correctiontype,"1to1")
    [emitfinal,beamfinal]=trajectory_correction_1to1(beamlinename,beamname,...
                                                     list_bpm,correctortype,list_corr,corrxattr,corryattr,RM);
  elseif strcmpi(correctiontype,"dispfree_de") || strcmpi(correctiontype,"dispfree_quad")
    [emitfinal,beamfinal]=trajectory_correction_pre(beamlinename,beamname,...
                                                    list_bpm,correctortype,list_corr,corrxattr,corryattr,RM,pre_svd_cut);
%    [emitfinal,beamfinal]=trajectory_correction_svd(beamlinename,beamname,...
%                              list_bpm,correctortype,list_corr,corrxattr,corryattr,RM,0.003);

% instead of the SVD matrix one could also pass the pseudo inverse
    [emitfinal,beamfinal]=trajectory_correction_disp_free(beamlinename,beamname,beamname_p,beamname_m,...
                                    list_quads,str_orig,str_p,str_m,...
                                    list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                                    MI,df_wgt,df_wgt_p,df_wgt_m,...
                                    disp_x_p,disp_y_p,disp_x_m,disp_y_m);
   else
    printf("Unknown correction type.\n");
  end;

  % check the corrected beamline
  %[emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
  bpm_x_final=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
  bpm_y_final=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");
  corr_sx_final=placet_element_get_attribute(beamlinename,list_corr,corrxattr);
  corr_sy_final=placet_element_get_attribute(beamlinename,list_corr,corryattr);

  % dump data to files
  fid=fopen(bpmfilename,"at");
  fprintf(fid,"# Set %d\n",nset);
  fprintf(fid,"%22.14e %22.14e %22.14e %22.14e %22.14e %22.14e %22.14e %22.14e\n",
              std(bpm_x_uncorrected,1),std(bpm_x_final,1),
              mean(bpm_x_uncorrected,1),mean(bpm_x_final,1),
              std(bpm_y_uncorrected,1),std(bpm_y_final,1),
              mean(bpm_y_uncorrected,1),mean(bpm_y_final,1));
  fclose(fid);

  fid=fopen(correctorsfilename,"at");
  fprintf(fid,"# Set %d\n",nset);
  fprintf(fid,"%22.14e %22.14e %22.14e %22.14e %22.14e %22.14e %22.14e %22.14e\n",
              std(corr_sx_initial,1),std(corr_sx_final,1),
              mean(corr_sx_initial,1),mean(corr_sx_final,1),
              std(corr_sy_initial,1),std(corr_sy_final,1),
              mean(corr_sy_initial,1),mean(corr_sy_final,1));
  fclose(fid);

  % statistics of full bunch train
  train_stat(beamuncorrected,beamfinal,statfilename);
  beamfinal=dispersion_correction(beamfinal);
%  train_stat(beamuncorrected,beamfinal,statfilename);
  train_stat(beamuncorrected,beamfinal,"beam_stat_dc.txt");
  beamfinal=coupling_correction(beamfinal);
%  train_stat(beamuncorrected,beamfinal,statfilename);
  train_stat(beamuncorrected,beamfinal,"beam_stat_dc+cc.txt");

end;

endfunction;
%----------------------------------------


%----------------------------------------
% do some "pre"-alignment to get the beam correctly through the lattice
function [emitfinal,beamfinal]=trajectory_correction_pre(beamlinename,beamname,list_bpm,...
                                                         correctortype,list_corr,corrxattr,corryattr,...
                                                         RM,svdcutfactor)

%if quadrupoles are moved for correction, the attached BPMs have to be moved too
idbpm(1,1)=-1;
nq=0;
if strcmpi(correctortype,"quadrupole")
    for n=1:length(list_bpm)
        tt=(list_corr-(list_bpm(n)+1)).^2;
        [tts,ids]=sort(tt);
        if tts(1)==0
            nq=nq+1;
            idbpm(nq,1)=list_bpm(n);
            idbpm(nq,2)=ids(1);
        end;
    end;
end;

% one could iterate...
firsttimebeamthrough=1;
nibreakmax=20;
nibreak=1;
nimax=15;
ni=1;
while (ni<=nimax)&&(nibreak<=nibreakmax)
%    placet_test_no_correction(beamlinename,beamname,"None");
    bpm_x_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))';
    bpm_y_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))';
    
    if (sum(isnan(bpm_x_ini)+isinf(bpm_x_ini))>0) || (sum(isnan(bpm_y_ini)+isinf(bpm_y_ini))>0) || ...
       (max(abs(bpm_x_ini))>2e4) || (max(abs(bpm_y_ini))>2e4)
        ix=1;
        while (ix<=length(bpm_x_ini)) && (abs(bpm_x_ini(ix))<7e3) && ~isinf(bpm_x_ini(ix)) && ~isnan(bpm_x_ini(ix))
            ix=ix+1;
        end;
        ix=ix-1
        iy=1;
        while (iy<=length(bpm_y_ini)) && (abs(bpm_y_ini(iy))<7e3) && ~isinf(bpm_y_ini(iy)) && ~isnan(bpm_y_ini(iy))
            iy=iy+1;
        end;
        iy=iy-1
        if firsttimebeamthrough==0
            firsttimebeamthrough=1;
            ni=nimax-5;
        end;
      else
        ix=length(bpm_x_ini)
        iy=length(bpm_y_ini)
        if firsttimebeamthrough==1
            firsttimebeamthrough=0;
            ni=nimax-2;
        end;
    end;
    
    bpm_x_ini=bpm_x_ini(1:ix);
    bpm_y_ini=bpm_y_ini(1:iy);
    
    RMc=[RM(1:ix,:);RM(length(list_bpm)+1:length(list_bpm)+iy,:)];
    [UT,Sinv,V]=mysvd(RMc,svdcutfactor);
    RSVD=V*Sinv*UT;

    new_strength=-RSVD*[bpm_x_ini;bpm_y_ini]*0.7;
    new_strength_x=new_strength(1:length(list_corr));
    new_strength_y=new_strength(length(list_corr)+1:2*length(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr,corrxattr,new_strength_x);
    placet_element_vary_attribute(beamlinename,list_corr,corryattr,new_strength_y);
    
    if idbpm(1,1)~=-1
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corrxattr,new_strength_x(idbpm(:,2)));
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corryattr,new_strength_y(idbpm(:,2)));
    end;

    [emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
    ni=ni+1;
    nibreak=nibreak+1;
end;

endfunction;
%----------------------------------------


%----------------------------------------
% calculates the required corrector settings using SVD steering, i.e. global correction
function [emitfinal,beamfinal]=trajectory_correction_svd(beamlinename,beamname,list_bpm,...
                                                         correctortype,list_corr,corrxattr,corryattr,...
                                                         RM,svdcutfactor)

[UT,Sinv,V]=mysvd(RM,svdcutfactor);
svdRM=V*Sinv*UT;

%if quadrupoles are moved for correction, the attached BPMs have to be moved too
idbpm(1,1)=-1;
nq=0;
if strcmpi(correctortype,"quadrupole")
    for n=1:length(list_bpm)
        tt=(list_corr-(list_bpm(n)+1)).^2;
        [tts,ids]=sort(tt);
        if tts(1)==0
            nq=nq+1;
            idbpm(nq,1)=list_bpm(n);
            idbpm(nq,2)=ids(1);
        end;
    end;
end;


% one could iterate...
nimax=3;
for ni=1:nimax
%    placet_test_no_correction(beamlinename,beamname,"None");
    bpm_x_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))';
    bpm_y_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))';

    new_strength=-svdRM*[bpm_x_ini;bpm_y_ini];
    new_strength_x=new_strength(1:length(list_corr));
    new_strength_y=new_strength(length(list_corr)+1:2*length(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr,corrxattr,new_strength_x);
    placet_element_vary_attribute(beamlinename,list_corr,corryattr,new_strength_y);
    
    if idbpm(1,1)~=-1
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corrxattr,new_strength_x(idbpm(:,2)));
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corryattr,new_strength_y(idbpm(:,2)));
    end;

    [emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
end;

endfunction;
%----------------------------------------


%----------------------------------------
% calculates the required corrector settings using 1-to-1 steering, i.e. local correction
function [emitfinal,beamfinal]=trajectory_correction_1to1(beamlinename,beamname,list_bpm,...
                                                          correctortype,list_corr,corrxattr,corryattr,...
                                                          RM)

pinvRM=pinv(RM);

%if quadrupoles are moved for correction, the attached BPMs have to be moved too
idbpm(1,1)=-1;
nq=0;
if strcmpi(correctortype,"quadrupole")
    for n=1:length(list_bpm)
        tt=(list_corr-(list_bpm(n)+1)).^2;
        [tts,ids]=sort(tt);
        if tts(1)==0
            nq=nq+1;
            idbpm(nq,1)=list_bpm(n);
            idbpm(nq,2)=ids(1);
        end;
    end;
end;


% one could iterate...
nimax=1;
for ni=1:nimax
%    placet_test_no_correction(beamlinename,beamname,"None");
    bpm_x_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))';
    bpm_y_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))';

%    new_strength_x=-Ax\bpm_x_ini;
%    new_strength_y=-Ay\bpm_y_ini;
    new_strength=-pinvRM*[bpm_x_ini;bpm_y_ini];
    new_strength_x=new_strength(1:length(list_corr));
    new_strength_y=new_strength(length(list_corr)+1:2*length(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr,corrxattr,new_strength_x);
    placet_element_vary_attribute(beamlinename,list_corr,corryattr,new_strength_y);
    
    if idbpm(1,1)~=-1
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corrxattr,new_strength_x(idbpm(:,2)));
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corryattr,new_strength_y(idbpm(:,2)));
    end;

    [emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
end;

endfunction;
%----------------------------------------


%----------------------------------------
% calculates the required corrector settings using dispersion-free steering
% using either beams with different energy or different quadrupole settings
%
% MIx and MIy are either the pseudo inverse matrices or the inverse matrices obtained by SVD
% it just depends which one are passed as arguments
function [emitfinal,beamfinal]=trajectory_correction_disp_free(beamlinename,beamname,beamname_p,beamname_m,...
                                         list_quads,str_orig,str_p,str_m,...
                                         list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                                         MI,wgt,wgt_p,wgt_m,...
                                         disp_x_p,disp_y_p,disp_x_m,disp_y_m)

%if quadrupoles are moved for correction, the attached BPMs have to be moved too
idbpm(1,1)=-1;
nq=0;
if strcmpi(correctortype,"quadrupole")
    for n=1:length(list_bpm)
        tt=(list_corr-(list_bpm(n)+1)).^2;
        [tts,ids]=sort(tt);
        if tts(1)==0
            nq=nq+1;
            idbpm(nq,1)=list_bpm(n);
            idbpm(nq,2)=ids(1);
        end;
    end;
end;

% one could iterate...
nimax=3;
for ni=1:nimax
%    placet_test_no_correction(beamlinename,beamname,"None");
    bpm_x_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))';
    bpm_y_ini=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))';

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_p);
    placet_test_no_correction(beamlinename,beamname_p,"None");
    bpm_x_ini_p=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))'-bpm_x_ini-disp_x_p';
    bpm_y_ini_p=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))'-bpm_y_ini-disp_y_p';

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_m);
    placet_test_no_correction(beamlinename,beamname_m,"None");
    bpm_x_ini_m=(placet_element_get_attribute(beamlinename,list_bpm,"reading_x"))'-bpm_x_ini-disp_x_m';
    bpm_y_ini_m=(placet_element_get_attribute(beamlinename,list_bpm,"reading_y"))'-bpm_y_ini-disp_y_m';

    placet_element_set_attribute(beamlinename,list_quads,"strength",str_orig);

    bpm_tot=[wgt*bpm_x_ini;wgt*bpm_y_ini;wgt_p*bpm_x_ini_p;wgt_p*bpm_y_ini_p;wgt_m*bpm_x_ini_m;wgt_m*bpm_y_ini_m];

    new_strength=-MI*bpm_tot;
    new_strength_x=new_strength(1:length(list_corr));
    new_strength_y=new_strength(length(list_corr)+1:2*length(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr,corrxattr,new_strength_x);
    placet_element_vary_attribute(beamlinename,list_corr,corryattr,new_strength_y);
    
    if idbpm(1,1)~=-1
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corrxattr,new_strength_x(idbpm(:,2)));
        placet_element_vary_attribute(beamlinename,idbpm(:,1),corryattr,new_strength_y(idbpm(:,2)));
    end;

    [emitfinal,beamfinal]=placet_test_no_correction(beamlinename,beamname,"None");
end;

endfunction;
%----------------------------------------


%----------------------------------------
function [UT,Sinv,V]=mysvd(A,cutfactor)

[U,S,V]=svd(A);

% octave svd returns simplified matrices missing rows and columns which only contain zeros
sizeU=size(U);
sizeA=size(A);
if (sizeU(1)<sizeA(1))
  U=[U;zeros(sizeA(1)-sizeU(1),sizeU(2))];
end;
if (sizeU(2)<sizeA(2))
  U=[U,zeros(sizeU(1),sizeA(2)-sizeU(2))];
end;
sizeS=size(S);
if (sizeS(1)<sizeA(2))
  S=[S;zeros(sizeA(2)-sizeS(1),sizeS(2))];
end;
if (sizeS(2)<sizeA(2))
  S=[S,zeros(sizeS(1),sizeA(2)-sizeS(2))];
end;

if rows(S)<columns(S)
  maxi=rows(S);
 else
  maxi=columns(S);
end;

%cuts=0;
maxS=S(1,1);
%minS=S(maxi,maxi)
%minS_by_maxS=minS/maxS

for i=1:maxi
  if S(i,i)<cutfactor*maxS
    S(i,i)=0.0;
%    cuts=cuts+1;
  end;
end;
%size(S)
%totals=maxi
%cuts

Sinv=pinv(S);
UT=U';

endfunction;
%----------------------------------------


%----------------------------------------
function RM=calc_response_matrix(beamlinename,beamname,list_bpm,correctortype,list_corr,corrxattr,corryattr,...
                                 rm_bpm_resolution,rm_stepsize)

%if quadrupoles are moved for correction, the attached BPMs have to be moved too
idb=zeros(1,columns(list_corr))-1;
if strcmpi(correctortype,"quadrupole")
    for n=1:columns(list_corr)
        tt=(list_corr(n)-1-list_bpm).^2;
        [tts,ids]=sort(tt);
        if tts(1)==0
            idb(n)=list_bpm(ids(1));
        end;
    end;
end;

Res=placet_element_get_attribute(beamlinename,list_bpm,"resolution");
placet_element_set_attribute(beamlinename,list_bpm,"resolution",rm_bpm_resolution);

placet_test_no_correction(beamlinename,beamname,"Zero");
bx0=placet_element_get_attribute(beamlinename,list_bpm,"reading_x");
by0=placet_element_get_attribute(beamlinename,list_bpm,"reading_y");
RM=zeros(length(bx0)+length(by0),2*columns(list_corr));

for i=1:columns(list_corr)
    printf("Calculating response matrix, Column %d of %d...\n",i,2*columns(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr(i),corrxattr,rm_stepsize);
    if (idb(i)~=-1)
        placet_element_vary_attribute(beamlinename,idb(i),"x",rm_stepsize);
    end;

    placet_test_no_correction(beamlinename,beamname,"None");
    bx=1/rm_stepsize*(placet_element_get_attribute(beamlinename,list_bpm,"reading_x") - bx0);
    by=1/rm_stepsize*(placet_element_get_attribute(beamlinename,list_bpm,"reading_y") - by0);
    RM(:,i)=[bx';by'];

    if (idb(i)~=-1)
        placet_element_vary_attribute(beamlinename,idb(i),"x",-rm_stepsize);
    end;
    placet_element_vary_attribute(beamlinename,list_corr(i),corrxattr,-rm_stepsize);
end;
dc=columns(list_corr);
for i=1:columns(list_corr)
    printf("Calculating response matrix, Column %d of %d...\n",i+dc,2*columns(list_corr));

    placet_element_vary_attribute(beamlinename,list_corr(i),corryattr,rm_stepsize);
    if (idb(i)~=-1)
        placet_element_vary_attribute(beamlinename,idb(i),"y",rm_stepsize);
    end;

    placet_test_no_correction(beamlinename,beamname,"None");
    bx=1/rm_stepsize*(placet_element_get_attribute(beamlinename,list_bpm,"reading_x") - bx0);
    by=1/rm_stepsize*(placet_element_get_attribute(beamlinename,list_bpm,"reading_y") - by0);
    RM(:,i+dc)=[bx';by'];

    if (idb(i)~=-1)
        placet_element_vary_attribute(beamlinename,idb(i),"y",-rm_stepsize);
    end;
    placet_element_vary_attribute(beamlinename,list_corr(i),corryattr,-rm_stepsize);
end;

placet_element_set_attribute(beamlinename,list_bpm,"resolution",Res);

endfunction;
%----------------------------------------


%----------------------------------------
function beamfinal=coupling_correction(beamini)
% artificially correct plane coupling

if (columns(beamini)==6)&&(sum(sum(isnan(beamini)+isinf(beamini)))==0)
  x=beamini(:,2);
  mx=mean(x,1);
  x=x-mx;

  y=beamini(:,3);
  my=mean(y,1);
  y=y-my;

  xp=beamini(:,5);
  mxp=mean(xp,1);
  xp=xp-mxp;

  yp=beamini(:,6);
  myp=mean(yp,1);
  yp=yp-myp;

  [b,s,r]=ols(y,x);
  b;
  xn=x;
  yn=r;
%  dphi=atan(b)
%  xn=x*cos(dphi)+y*sin(dphi);
%  yn=-x*sin(dphi)+y*cos(dphi);

  [b,s,r]=ols(yp,xp);
  b;
  xpn=xp;
  ypn=r;
%  dphi=atan(b)
%  xpn=xp*cos(dphi)+yp*sin(dphi);
%  ypn=-xp*sin(dphi)+yp*cos(dphi);

  beamfinal=[beamini(:,1),xn,yn,beamini(:,4),xpn,ypn];
 else
  beamfinal=beamini;
end;

endfunction;


%----------------------------------------
function beamfinal=dispersion_correction(beamini)
% artificially correct residual dispersion

if (columns(beamini)==6)&&(sum(sum(isnan(beamini)+isinf(beamini)))==0)
  x=beamini(:,2);
  mx=mean(x,1);
  x=x-mx;

  y=beamini(:,3);
  my=mean(y,1);
  y=y-my;

  xp=beamini(:,5);
  mxp=mean(xp,1);
  xp=xp-mxp;

  yp=beamini(:,6);
  myp=mean(yp,1);
  yp=yp-myp;

  de=beamini(:,1);
  mde=mean(de,1);
  de=de-mde;

  [b,s,r]=ols(x,de);
  xn=r;

  [b,s,r]=ols(y,de);
  yn=r;

  [b,s,r]=ols(xp,de);
  xpn=r;

  [b,s,r]=ols(yp,de);
  ypn=r;

  beamfinal=[beamini(:,1),xn,yn,beamini(:,4),xpn,ypn];
 else
  beamfinal=beamini;
end;

endfunction;
