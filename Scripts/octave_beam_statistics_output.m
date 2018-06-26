#
# single bunch and train statistics
#


%----------------------------------------
%dump some statistics to stdout
function print_mean_std(beam1,beam2)
if (columns(beam1)!=6)||(columns(beam2)!=6)
  printf("print_mean_std has to be called with two particle beams.\n");
  return;
end;

gamma1=mean(beam1(:,1),1)/(0.5109989*1e6);
gamma2=mean(beam2(:,1),1)/(0.5109989*1e6);

printf("---------------------------------------------------------------------\n");
printf("mean e =%3.15e / %3.15e\n",mean(beam1(:,1),1),mean(beam2(:,1),1));
printf("mean x =%3.15e / %3.15e\n",mean(beam1(:,2),1),mean(beam2(:,2),1));
printf("mean y =%3.15e / %3.15e\n",mean(beam1(:,3),1),mean(beam2(:,3),1));
printf("mean z =%3.15e / %3.15e\n",mean(beam1(:,4),1),mean(beam2(:,4),1));
printf("mean xp=%3.15e / %3.15e\n",mean(beam1(:,5),1),mean(beam2(:,5),1));
printf("mean yp=%3.15e / %3.15e\n",mean(beam1(:,6),1),mean(beam2(:,6),1));
printf("std e  =%3.15e / %3.15e\n", std(beam1(:,1),1), std(beam2(:,1),1));
printf("std e/mean e=%3.15e / %3.15e\n",std(beam1(:,1),1)/mean(beam1(:,1),1),std(beam2(:,1),1)/mean(beam2(:,1),1));
printf("std x  =%3.15e / %3.15e\n",std(beam1(:,2),1),std(beam2(:,2),1));
printf("std y  =%3.15e / %3.15e\n",std(beam1(:,3),1),std(beam2(:,3),1));
printf("std z  =%3.15e / %3.15e\n",std(beam1(:,4),1),std(beam2(:,4),1));
printf("std xp =%3.15e / %3.15e\n",std(beam1(:,5),1),std(beam2(:,5),1));
printf("std yp =%3.15e / %3.15e\n",std(beam1(:,6),1),std(beam2(:,6),1));
printf("emit x =%3.15e / %3.15e\n",gamma1*emitproj(beam1(:,2),beam1(:,5),1),gamma2*emitproj(beam2(:,2),beam2(:,5),1));
printf("emit y =%3.15e / %3.15e\n",gamma1*emitproj(beam1(:,3),beam1(:,6),1),gamma2*emitproj(beam2(:,3),beam2(:,6),1));

[bx1,ax1]=twiss(beam1(:,2),beam1(:,5),1);
[bx2,ax2]=twiss(beam2(:,2),beam2(:,5),1);
printf("beta x =%3.15e / %3.15e\n",bx1,bx2);
printf("alpha x=%3.15e / %3.15e\n",ax1,ax2);

[by1,ay1]=twiss(beam1(:,3),beam1(:,6),1);
[by2,ay2]=twiss(beam2(:,3),beam2(:,6),1);
printf("beta y =%3.15e / %3.15e\n",by1,by2);
printf("alpha y=%3.15e / %3.15e\n",ay1,ay2);
printf("---------------------------------------------------------------------\n");

endfunction;
%----------------------------------------


%----------------------------------------
function create_statistics_file(beam,statfilename)
%create a file which later can be filled with data using save_statistics

if (columns(beam)==17)
  fid=fopen(statfilename,"wt");
  fprintf(fid,"#\n");
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
 elseif (columns(beam)==6)
  fid=fopen(statfilename,"wt");
  fprintf(fid,"#\n");
  fprintf(fid,"# %18s %20s %20s %20s ",
              "temit nx [nm rad]","temit nx [nm rad]",
              "temit ny [nm rad]","temit ny [nm rad]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean x [um]","mean x [um]","std x [um]","std x [um]",
              "mean xp [urad]","mean xp [urad]","std xp [urad]","std xp [urad]",
              "beta x [m]","beta x [m]","alpha x [1]","alpha x [1]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "mean y [um]","mean y [um]","std y [um]","std y [um]",
              "mean yp [urad]","mean yp [urad]","std yp [urad]","std yp [urad]",
              "beta y [m]","beta y [m]","alpha y [1]","alpha y [1]");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "mean s [um]","mean s [um]","std s [um]","std s [um]",
              "mean e [GeV]","mean e [GeV]","std e [GeV]","std e [GeV]","dee [1]","dee [1]");

  fprintf(fid,"# %18s %20s %20s %20s ",
              "ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s ",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fprintf(fid,"%20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "ini","fin","ini","fin","ini","fin","ini","fin","ini","fin");
  fclose(fid);
 else
  printf("create_train_statistics_file: called with wrong bunch.\n");
  return;
end;
endfunction;
%----------------------------------------


%----------------------------------------
function save_statistics(bi,bf,statfilename)

if (columns(bi)==17)&&(columns(bf)==17)
  save_statistics_slices(bi,bf,statfilename);
 elseif (columns(bi)==6)&&(columns(bf)==6)
  save_statistics_particles(bi,bf,statfilename);

 else
  printf("save_statistics: wrong size of beam matrices.\n");
end;

endfunction;
%----------------------------------------


%----------------------------------------
function save_statistics_slices(bi,bf,statfilename)
format long;

mean_x_ini=mean(bi(:,4),bi(:,2));
mean_x_fin=mean(bf(:,4),bf(:,2));
mean_xp_ini=mean(bi(:,5),bi(:,2));
mean_xp_fin=mean(bf(:,5),bf(:,2));

mean_y_ini=mean(bi(:,6),bi(:,2));
mean_y_fin=mean(bf(:,6),bf(:,2));
mean_yp_ini=mean(bi(:,7),bi(:,2));
mean_yp_fin=mean(bf(:,7),bf(:,2));

std_x_ini=std(bi(:,4),bi(:,2));
std_x_fin=std(bf(:,4),bf(:,2));
std_xp_ini=std(bi(:,5),bi(:,2));
std_xp_fin=std(bf(:,5),bf(:,2));

std_y_ini=std(bi(:,6),bi(:,2));
std_y_fin=std(bf(:,6),bf(:,2));
std_yp_ini=std(bi(:,7),bi(:,2));
std_yp_fin=std(bf(:,7),bf(:,2));

mean_sx_ini=mean(sqrt(bi(:,8)),bi(:,2));
mean_sx_fin=mean(sqrt(bf(:,8)),bf(:,2));
mean_sxp_ini=mean(sqrt(bi(:,10)),bi(:,2));
mean_sxp_fin=mean(sqrt(bf(:,10)),bf(:,2));

mean_sy_ini=mean(sqrt(bi(:,11)),bi(:,2));
mean_sy_fin=mean(sqrt(bf(:,11)),bf(:,2));
mean_syp_ini=mean(sqrt(bi(:,13)),bi(:,2));
mean_syp_fin=mean(sqrt(bf(:,13)),bf(:,2));

mean_s_ini=mean(bi(:,1),bi(:,2));
mean_s_fin=mean(bf(:,1),bf(:,2));
mean_e_ini=mean(bi(:,3),bi(:,2));
mean_e_fin=mean(bf(:,3),bf(:,2));

std_s_ini=std(bi(:,1),bi(:,2));
std_s_fin=std(bf(:,1),bf(:,2));
std_e_ini=std(bi(:,3),bi(:,2));
std_e_fin=std(bf(:,3),bf(:,2));

dee_ini=std_e_ini/mean_e_ini;
dee_fin=std_e_fin/mean_e_fin;

bi(:,4)=bi(:,4)-mean(bi(:,4),bi(:,2));
bi(:,5)=bi(:,5)-mean(bi(:,5),bi(:,2));
bi(:,6)=bi(:,6)-mean(bi(:,6),bi(:,2));
bi(:,7)=bi(:,7)-mean(bi(:,7),bi(:,2));
bf(:,4)=bf(:,4)-mean(bf(:,4),bf(:,2));
bf(:,5)=bf(:,5)-mean(bf(:,5),bf(:,2));
bf(:,6)=bf(:,6)-mean(bf(:,6),bf(:,2));
bf(:,7)=bf(:,7)-mean(bf(:,7),bf(:,2));

old_s=bi(1,1);
c=1;
r_start=1;
for i=1:rows(bi)
  s=bi(i,1);
  if (s!=old_s)||(i==rows(bi))
    r_end=i-1;
    if i==rows(bi)
      r_end=i;
    end;

    bip=bi(r_start:r_end,:);
    bfp=bf(r_start:r_end,:);

    se_x_ini(c)=sqrt(mean(bip(:,8)+bip(:,4).^2,bip(:,2))*mean(bip(:,10)+bip(:,5).^2,bip(:,2)) -...
                     mean(bip(:,9)+bip(:,4).*bip(:,5),bip(:,2))^2);
    se_x_fin(c)=sqrt(mean(bfp(:,8)+bfp(:,4).^2,bfp(:,2))*mean(bfp(:,10)+bfp(:,5).^2,bfp(:,2)) -...
                     mean(bfp(:,9)+bfp(:,4).*bfp(:,5),bfp(:,2))^2);
    se_y_ini(c)=sqrt(mean(bip(:,11)+bip(:,6).^2,bip(:,2))*mean(bip(:,13)+bip(:,7).^2,bip(:,2)) -...
                     mean(bip(:,12)+bip(:,6).*bip(:,7),bip(:,2))^2);
    se_y_fin(c)=sqrt(mean(bfp(:,11)+bfp(:,6).^2,bfp(:,2))*mean(bfp(:,13)+bfp(:,7).^2,bfp(:,2)) -...
                     mean(bfp(:,12)+bfp(:,6).*bfp(:,7),bfp(:,2))^2);

    s_weight_ini(c)=sum(bip(:,2));
    s_weight_fin(c)=sum(bfp(:,2));

    old_s=s;
    r_start=i;
    c=c+1;
  end;
end;

sliceemit_x_ini=mean(bip(:,3),bip(:,2))/510998.9*mean(se_x_ini,s_weight_ini);
sliceemit_x_fin=mean(bfp(:,3),bfp(:,2))/510998.9*mean(se_x_fin,s_weight_fin);
sliceemit_y_ini=mean(bip(:,3),bip(:,2))/510998.9*mean(se_y_ini,s_weight_ini);
sliceemit_y_fin=mean(bfp(:,3),bfp(:,2))/510998.9*mean(se_y_fin,s_weight_fin);

totalemit_x_ini=mean(bi(:,3),bi(:,2))/510998.9*...
                sqrt(mean(bi(:,8)+bi(:,4).^2,bi(:,2))*mean(bi(:,10)+bi(:,5).^2,bi(:,2)) -...
                     mean(bi(:,9)+bi(:,4).*bi(:,5),bi(:,2))^2);
totalemit_x_fin=mean(bf(:,3),bf(:,2))/510998.9*...
                sqrt(mean(bf(:,8)+bf(:,4).^2,bf(:,2))*mean(bf(:,10)+bf(:,5).^2,bf(:,2)) -...
                     mean(bf(:,9)+bf(:,4).*bf(:,5),bf(:,2))^2);
totalemit_y_ini=mean(bi(:,3),bi(:,2))/510998.9*...
                sqrt(mean(bi(:,11)+bi(:,6).^2,bi(:,2))*mean(bi(:,13)+bi(:,7).^2,bi(:,2)) -...
                     mean(bi(:,12)+bi(:,6).*bi(:,7),bi(:,2))^2);
totalemit_y_fin=mean(bf(:,3),bf(:,2))/510998.9*...
                sqrt(mean(bf(:,11)+bf(:,6).^2,bf(:,2))*mean(bf(:,13)+bf(:,7).^2,bf(:,2)) -...
                     mean(bf(:,12)+bf(:,6).*bf(:,7),bf(:,2))^2);

fid=fopen(statfilename,"at");
if (fid!=-1)
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e ",
          sliceemit_x_ini*1e9,sliceemit_x_fin*1e9,totalemit_x_ini*1e9,totalemit_x_fin*1e9,
          sliceemit_y_ini*1e9,sliceemit_y_fin*1e9,totalemit_y_ini*1e9,totalemit_y_fin*1e9);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e ",
          mean_x_ini*1e6,mean_x_fin*1e6,std_x_ini*1e6,std_x_fin*1e6,mean_sx_ini*1e6,mean_sx_fin*1e6,
          mean_xp_ini*1e6,mean_xp_fin*1e6,std_xp_ini*1e6,std_xp_fin*1e6,mean_sxp_ini*1e6,mean_sxp_fin*1e6);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e ",
          mean_y_ini*1e6,mean_y_fin*1e6,std_y_ini*1e6,std_y_fin*1e6,mean_sy_ini*1e6,mean_sy_fin*1e6,
          mean_yp_ini*1e6,mean_yp_fin*1e6,std_yp_ini*1e6,std_yp_fin*1e6,mean_syp_ini*1e6,mean_syp_fin*1e6);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e\n",
          mean_s_ini*1e6,mean_s_fin*1e6,std_s_ini*1e6,std_s_fin*1e6,mean_e_ini*1e-9,mean_e_fin*1e-9,std_e_ini*1e-9,std_e_fin*1e-9,dee_ini,dee_fin);
  fclose(fid);
end;

endfunction;
%----------------------------------------


%----------------------------------------
function save_statistics_particles(bi,bf,statfilename)
format long;

mean_x_ini=mean(bi(:,2),1);
mean_x_fin=mean(bf(:,2),1);
mean_xp_ini=mean(bi(:,5),1);
mean_xp_fin=mean(bf(:,5),1);

mean_y_ini=mean(bi(:,3),1);
mean_y_fin=mean(bf(:,3),1);
mean_yp_ini=mean(bi(:,6),1);
mean_yp_fin=mean(bf(:,6),1);

std_x_ini=std(bi(:,2),1);
std_x_fin=std(bf(:,2),1);
std_xp_ini=std(bi(:,5),1);
std_xp_fin=std(bf(:,5),1);

std_y_ini=std(bi(:,3),1);
std_y_fin=std(bf(:,3),1);
std_yp_ini=std(bi(:,6),1);
std_yp_fin=std(bf(:,6),1);

mean_s_ini=mean(bi(:,4),1);
mean_s_fin=mean(bf(:,4),1);
mean_e_ini=mean(bi(:,1),1);
mean_e_fin=mean(bf(:,1),1);

std_s_ini=std(bi(:,4),1);
std_s_fin=std(bf(:,4),1);
std_e_ini=std(bi(:,1),1);
std_e_fin=std(bf(:,1),1);

dee_ini=std_e_ini/mean_e_ini;
dee_fin=std_e_fin/mean_e_fin;

totalemit_x_ini=mean_e_ini/510998.9*emitproj(bi(:,2),bi(:,5),1);
totalemit_x_fin=mean_e_fin/510998.9*emitproj(bf(:,2),bf(:,5),1);
totalemit_y_ini=mean_e_ini/510998.9*emitproj(bi(:,3),bi(:,6),1);
totalemit_y_fin=mean_e_fin/510998.9*emitproj(bf(:,3),bf(:,6),1);

[bx_ini,ax_ini]=twiss(bi(:,2),bi(:,5),1);
[bx_fin,ax_fin]=twiss(bf(:,2),bf(:,5),1);

[by_ini,ay_ini]=twiss(bi(:,3),bi(:,6),1);
[by_fin,ay_fin]=twiss(bf(:,3),bf(:,6),1);

fid=fopen(statfilename,"at");
if (fid!=-1)
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e ",
          totalemit_x_ini*1e9,totalemit_x_fin*1e9,
          totalemit_y_ini*1e9,totalemit_y_fin*1e9);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e ",
          mean_x_ini*1e6,mean_x_fin*1e6,std_x_ini*1e6,std_x_fin*1e6,
          mean_xp_ini*1e6,mean_xp_fin*1e6,std_xp_ini*1e6,std_xp_fin*1e6,
          bx_ini,bx_fin,ax_ini,ax_fin);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e ",
          mean_y_ini*1e6,mean_y_fin*1e6,std_y_ini*1e6,std_y_fin*1e6,
          mean_yp_ini*1e6,mean_yp_fin*1e6,std_yp_ini*1e6,std_yp_fin*1e6,
          by_ini,by_fin,ay_ini,ay_fin);
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e\n",
          mean_s_ini*1e6,mean_s_fin*1e6,std_s_ini*1e6,std_s_fin*1e6,mean_e_ini*1e-9,mean_e_fin*1e-9,std_e_ini*1e-9,std_e_fin*1e-9,dee_ini,dee_fin);
  fclose(fid);
end;

endfunction;
%----------------------------------------


%----------------------------------------
function bunchtrain_statistics(beam,statfilename,nbunches,nmacro,nslice)

if (columns(beam)==17)
  bunchtrain_statistics_slices(beam,statfilename,nbunches,nmacro,nslice);
 elseif (columns(beam)==6)
%  bunchtrain_statistics_particles(beam,statfilename,nbunches,nmacro,nslice);
   printf("bunchtrain_statistics: Bunchtrain statistics for particle bunches is not yet implemented.\n");
 else
  printf("bunch_statistics: wrong size of beam matrix.\n");
end;

endfunction;
%----------------------------------------


%----------------------------------------
function bunchtrain_statistics_slices(beam,statfilename,nbunches,nmacro,nslice)
format long;

fid=fopen(statfilename,"wt");
if (fid!=-1)
  fprintf(fid,"# bunch train data\n");
  fprintf(fid,"# %18s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s %20s\n",
              "semit nx [nm rad]","cemit nx [nm rad]","semit ny [nm rad]","cemit ny [nm rad]",
              "mean x [um]","std x [um]","mean xp [urad]","std xp [urad]",
              "mean y [um]","std y [um]","mean yp [urad]","std yp [urad]",
              "mean s [um]","std s [um]","mean e [GeV]","std e [GeV]","dee [1]");
end;

% full bunch train
bf=beam;
sliceemit_x=mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,8),bf(:,2))*mean(bf(:,10),bf(:,2)) - mean(bf(:,9),bf(:,2))^2)/1000
sliceemit_y=mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,11),bf(:,2))*mean(bf(:,13),bf(:,2)) - mean(bf(:,12),bf(:,2))^2)/1000
coreemit_x =mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,4).^2,bf(:,2))*mean(bf(:,5).^2,bf(:,2)) - mean(bf(:,4).*bf(:,5),bf(:,2))^2)/1000
coreemit_y =mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,6).^2,bf(:,2))*mean(bf(:,7).^2,bf(:,2)) - mean(bf(:,6).*bf(:,7),bf(:,2))^2)/1000

mean_x =mean(bf(:,4),bf(:,2));
mean_xp=mean(bf(:,5),bf(:,2));
mean_y =mean(bf(:,6),bf(:,2));
mean_yp=mean(bf(:,7),bf(:,2));

std_x =std(bf(:,4),bf(:,2));
std_xp=std(bf(:,5),bf(:,2));
std_y =std(bf(:,6),bf(:,2));
std_yp=std(bf(:,7),bf(:,2));

mean_s=mean(bf(:,1),bf(:,2));
mean_e=mean(bf(:,3),bf(:,2));
std_s =std(bf(:,1),bf(:,2));
std_e =std(bf(:,3),bf(:,2));

dee=std_e/mean_e;

if (fid!=-1)
    fprintf(fid,"# full bunch train\n");
    fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e\n",
	        sliceemit_x,coreemit_x,sliceemit_y,coreemit_y,
	        mean_x,std_x,mean_xp,std_xp,
	        mean_y,std_y,mean_yp,std_yp,
	        mean_s,std_s,mean_e,std_e,dee);
    fprintf(fid,"# single bunches\n");
end;

% single bunches
for i=1:nbunches
  is=nmacro*nslice*(i-1)+1;
  ie=nmacro*nslice*i;

  bf=beam(is:ie,:);

  printf("--------------------------------------------------\n");
  printf("Bunch %d of %d:\n",i,nbunches);
  sliceemit_x=mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,8),bf(:,2))*mean(bf(:,10),bf(:,2)) - mean(bf(:,9),bf(:,2))^2)/1000
  sliceemit_y=mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,11),bf(:,2))*mean(bf(:,13),bf(:,2)) - mean(bf(:,12),bf(:,2))^2)/1000
  coreemit_x =mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,4).^2,bf(:,2))*mean(bf(:,5).^2,bf(:,2)) - mean(bf(:,4).*bf(:,5),bf(:,2))^2)/1000
  coreemit_y =mean(bf(:,3),bf(:,2))/0.0005109989*sqrt(mean(bf(:,6).^2,bf(:,2))*mean(bf(:,7).^2,bf(:,2)) - mean(bf(:,6).*bf(:,7),bf(:,2))^2)/1000

  mean_x =mean(bf(:,4),bf(:,2));
  mean_xp=mean(bf(:,5),bf(:,2));
  mean_y =mean(bf(:,6),bf(:,2));
  mean_yp=mean(bf(:,7),bf(:,2));

  std_x =std(bf(:,4),bf(:,2));
  std_xp=std(bf(:,5),bf(:,2));
  std_y =std(bf(:,6),bf(:,2));
  std_yp=std(bf(:,7),bf(:,2));

  mean_s=mean(bf(:,1),bf(:,2));
  mean_e=mean(bf(:,3),bf(:,2));
  std_s =std(bf(:,1),bf(:,2));
  std_e =std(bf(:,3),bf(:,2));

  dee=std_e/mean_e;

  if (fid!=-1)
  fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e %20.12e\n",
	      sliceemit_x,coreemit_x,sliceemit_y,coreemit_y,
	      mean_x,std_x,mean_xp,std_xp,
	      mean_y,std_y,mean_yp,std_yp,
	      mean_s,std_s,mean_e,std_e,dee);
  end;
end;

fclose(fid);

endfunction;
%----------------------------------------


