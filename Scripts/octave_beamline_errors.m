% since multipoles cannot be misaligned by SurveyErrorSet
% and since the random seed is always the same when
% restarting Placet, we do misalignment the hard way
%
% this also allows us to better control of some details

%----------------------------------------
function induce_beamline_errors(beamlinename,...
          error_cavity_pos,error_cavity_gradient_rel,orig_cav_gradient,...
          error_bend_pos,error_bend_strength_rel,orig_bend_angle,...
          error_quadrupole_pos,error_quadrupole_strength_rel,orig_quad_strength,...
          error_multipole_pos,error_multipole_strength_rel,orig_multi_strength,...
          error_dipole_pos,error_dipole_strength_rel,orig_dipole_str_x,orig_dipole_str_y,...
          error_bpm_pos,bpm_resolution,keepolderrors)

id_cav=placet_get_number_list(beamlinename,"cavity");
id_bend=placet_get_number_list(beamlinename,"sbend");
id_quad=placet_get_number_list(beamlinename,"quadrupole");
id_multi=placet_get_number_list(beamlinename,"multipole");
id_bpm=placet_get_number_list(beamlinename,"bpm");
id_dip=placet_get_number_list(beamlinename,"dipole");


if (keepolderrors!=0)
  keepolderrors=1;
end;

id=id_cav;
pos_err=error_cavity_pos;
str_err=error_cavity_gradient_rel;
if (length(id)>0)
	old_x=placet_element_get_attribute(beamlinename,id,"x");
	old_xp=placet_element_get_attribute(beamlinename,id,"xp");
	old_y=placet_element_get_attribute(beamlinename,id,"y");
	old_yp=placet_element_get_attribute(beamlinename,id,"yp");
	old_roll=placet_element_get_attribute(beamlinename,id,"roll");
	old_str=placet_element_get_attribute(beamlinename,id,"gradient")-orig_cav_gradient;
	
	err_x=pos_err*cutrandnv(1,length(id),3);
	err_xp=pos_err*cutrandnv(1,length(id),3);
	err_y=pos_err*cutrandnv(1,length(id),3);
	err_yp=pos_err*cutrandnv(1,length(id),3);
	err_roll=pos_err*cutrandnv(1,length(id),3);
	err_str=orig_cav_gradient.*(1+str_err*cutrandnv(1,length(id),3));
	
	if keepolderrors==1
		placet_element_set_attribute(beamlinename,id,"x",old_x+err_x);
		placet_element_set_attribute(beamlinename,id,"xp",old_xp+err_xp);
		placet_element_set_attribute(beamlinename,id,"y",old_y+err_y);
		placet_element_set_attribute(beamlinename,id,"yp",old_yp+err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",old_roll+err_roll);
		placet_element_set_attribute(beamlinename,id,"gradient",old_str+err_str);
	else
		placet_element_set_attribute(beamlinename,id,"x",err_x);
		placet_element_set_attribute(beamlinename,id,"xp",err_xp);
		placet_element_set_attribute(beamlinename,id,"y",err_y);
		placet_element_set_attribute(beamlinename,id,"yp",err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",err_roll);
		placet_element_set_attribute(beamlinename,id,"gradient",err_str);
	end;
end;


id=id_bend;
pos_err=error_bend_pos;
str_err=error_bend_strength_rel;
if (length(id)>0)
	old_x=placet_element_get_attribute(beamlinename,id,"x");
	old_xp=placet_element_get_attribute(beamlinename,id,"xp");
	old_y=placet_element_get_attribute(beamlinename,id,"y");
	old_yp=placet_element_get_attribute(beamlinename,id,"yp");
	old_roll=placet_element_get_attribute(beamlinename,id,"roll");
	old_angle=placet_element_get_attribute(beamlinename,id,"angle")-orig_bend_angle;
	
	err_x=pos_err*cutrandnv(1,length(id),3);
	err_xp=pos_err*cutrandnv(1,length(id),3);
	err_y=pos_err*cutrandnv(1,length(id),3);
	err_yp=pos_err*cutrandnv(1,length(id),3);
	err_roll=pos_err*cutrandnv(1,length(id),3);
	err_angle=orig_bend_angle.*(1+str_err*cutrandnv(1,length(id),3));
	
	if keepolderrors==1
		placet_element_set_attribute(beamlinename,id,"x",old_x+err_x);
		placet_element_set_attribute(beamlinename,id,"xp",old_xp+err_xp);
		placet_element_set_attribute(beamlinename,id,"y",old_y+err_y);
		placet_element_set_attribute(beamlinename,id,"yp",old_yp+err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",old_roll+err_roll);
		placet_element_set_attribute(beamlinename,id,"angle",old_angle+err_angle);
	else
		placet_element_set_attribute(beamlinename,id,"x",err_x);
		placet_element_set_attribute(beamlinename,id,"xp",err_xp);
		placet_element_set_attribute(beamlinename,id,"y",err_y);
		placet_element_set_attribute(beamlinename,id,"yp",err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",err_roll);
		placet_element_set_attribute(beamlinename,id,"angle",err_angle);
	end;
end;


if (length(id_bpm)>0)
	idq(1)=-1;
	idf(1)=-1;
	if length(id_quad>0)
		nq=0;
		nf=0;
		for n=1:length(id_bpm)
			tt=(id_quad-(id_bpm(n)+1)).^2;
			tts=sort(tt);
			if tts(1)==0
				nq=nq+1;
				idq(nq)=id_bpm(n);
			else
				nf=nf+1;
				idf(nf)=id_bpm(n);
			end;
		end;
	else
		idf=id_bpm;
	end;
end;
if idq(1)~=-1
    old_x_quadbpm=placet_element_get_attribute(beamlinename,idq+1,"x");
    old_xp_quadbpm=placet_element_get_attribute(beamlinename,idq+1,"xp");
    old_y_quadbpm=placet_element_get_attribute(beamlinename,idq+1,"y");
    old_yp_quadbpm=placet_element_get_attribute(beamlinename,idq+1,"yp");
    old_roll_quadbpm=placet_element_get_attribute(beamlinename,idq+1,"roll");
end;

id=id_quad;
pos_err=error_quadrupole_pos;
str_err=error_quadrupole_strength_rel;
if (length(id)>0)
	old_x=placet_element_get_attribute(beamlinename,id,"x");
	old_xp=placet_element_get_attribute(beamlinename,id,"xp");
	old_y=placet_element_get_attribute(beamlinename,id,"y");
	old_yp=placet_element_get_attribute(beamlinename,id,"yp");
	old_roll=placet_element_get_attribute(beamlinename,id,"roll");
	old_str=placet_element_get_attribute(beamlinename,id,"strength")-orig_quad_strength;
	
	err_x=pos_err*cutrandnv(1,length(id),3);
	err_xp=pos_err*cutrandnv(1,length(id),3);
	err_y=pos_err*cutrandnv(1,length(id),3);
	err_yp=pos_err*cutrandnv(1,length(id),3);
	err_roll=pos_err*cutrandnv(1,length(id),3);
	err_str=orig_quad_strength.*(1+str_err*cutrandnv(1,length(id),3));
	
	if keepolderrors==1
		placet_element_set_attribute(beamlinename,id,"x",old_x+err_x);
		placet_element_set_attribute(beamlinename,id,"xp",old_xp+err_xp);
		placet_element_set_attribute(beamlinename,id,"y",old_y+err_y);
		placet_element_set_attribute(beamlinename,id,"yp",old_yp+err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",old_roll+err_roll);
		placet_element_set_attribute(beamlinename,id,"strength",old_str+err_str);
	else
		placet_element_set_attribute(beamlinename,id,"x",err_x);
		placet_element_set_attribute(beamlinename,id,"xp",err_xp);
		placet_element_set_attribute(beamlinename,id,"y",err_y);
		placet_element_set_attribute(beamlinename,id,"yp",err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",err_roll);
		placet_element_set_attribute(beamlinename,id,"strength",err_str);
	end;
end;


id=id_multi;
pos_err=error_multipole_pos;
str_err=error_multipole_strength_rel;
if (length(id)>0)
	old_x=placet_element_get_attribute(beamlinename,id,"x");
	old_xp=placet_element_get_attribute(beamlinename,id,"xp");
	old_y=placet_element_get_attribute(beamlinename,id,"y");
	old_yp=placet_element_get_attribute(beamlinename,id,"yp");
	old_roll=placet_element_get_attribute(beamlinename,id,"roll");
	old_str=placet_element_get_attribute(beamlinename,id,"strength")-orig_multi_strength;
	
	err_x=pos_err*cutrandnv(1,length(id),3);
	err_xp=pos_err*cutrandnv(1,length(id),3);
	err_y=pos_err*cutrandnv(1,length(id),3);
	err_yp=pos_err*cutrandnv(1,length(id),3);
	err_roll=pos_err*cutrandnv(1,length(id),3);
	err_str=orig_multi_strength.*(1+str_err*cutrandnv(1,length(id),3));
	
	if keepolderrors==1
		placet_element_set_attribute(beamlinename,id,"x",old_x+err_x);
		placet_element_set_attribute(beamlinename,id,"xp",old_xp+err_xp);
		placet_element_set_attribute(beamlinename,id,"y",old_y+err_y);
		placet_element_set_attribute(beamlinename,id,"yp",old_yp+err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",old_roll+err_roll);
		placet_element_set_attribute(beamlinename,id,"strength",old_str+err_str);
	else
		placet_element_set_attribute(beamlinename,id,"x",err_x);
		placet_element_set_attribute(beamlinename,id,"xp",err_xp);
		placet_element_set_attribute(beamlinename,id,"y",err_y);
		placet_element_set_attribute(beamlinename,id,"yp",err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",err_roll);
		placet_element_set_attribute(beamlinename,id,"strength",err_str);
	end;
end;

id=id_bpm;
pos_err=error_bpm_pos;
if (length(id)>0)
	placet_element_set_attribute(beamlinename,id,"resolution",bpm_resolution);
	if idf(1)~=-1
		old_x=placet_element_get_attribute(beamlinename,idf,"x");
		old_xp=placet_element_get_attribute(beamlinename,idf,"xp");
		old_y=placet_element_get_attribute(beamlinename,idf,"y");
		old_yp=placet_element_get_attribute(beamlinename,idf,"yp");
		old_roll=placet_element_get_attribute(beamlinename,idf,"roll");
	
		errf=0.3;
		err_x=errf*pos_err*cutrandnv(1,length(idf),3);
		err_xp=errf*pos_err*cutrandnv(1,length(idf),3);
		err_y=errf*pos_err*cutrandnv(1,length(idf),3);
		err_yp=errf*pos_err*cutrandnv(1,length(idf),3);
		err_roll=errf*pos_err*cutrandnv(1,length(idf),3);
	
		if keepolderrors==1
			placet_element_set_attribute(beamlinename,idf,"x",old_x+err_x);
			placet_element_set_attribute(beamlinename,idf,"xp",old_xp+err_xp);
			placet_element_set_attribute(beamlinename,idf,"y",old_y+err_y);
			placet_element_set_attribute(beamlinename,idf,"yp",old_yp+err_yp);
			placet_element_set_attribute(beamlinename,idf,"roll",old_roll+err_roll);
		else
			placet_element_set_attribute(beamlinename,idf,"x",err_x);
			placet_element_set_attribute(beamlinename,idf,"xp",err_xp);
			placet_element_set_attribute(beamlinename,idf,"y",err_y);
			placet_element_set_attribute(beamlinename,idf,"yp",err_yp);
			placet_element_set_attribute(beamlinename,idf,"roll",err_roll);
		end;
	end;
	
	if idq(1)~=-1
		old_x=placet_element_get_attribute(beamlinename,idq,"x")-old_x_quadbpm;
		old_xp=placet_element_get_attribute(beamlinename,idq,"xp")-old_xp_quadbpm;
		old_y=placet_element_get_attribute(beamlinename,idq,"y")-old_y_quadbpm;
		old_yp=placet_element_get_attribute(beamlinename,idq,"yp")-old_yp_quadbpm;
		old_roll=placet_element_get_attribute(beamlinename,idq,"roll")-old_roll_quadbpm;
	
		err_x=pos_err*cutrandnv(1,length(idq),3);
		err_xp=pos_err*cutrandnv(1,length(idq),3);
		err_y=pos_err*cutrandnv(1,length(idq),3);
		err_yp=pos_err*cutrandnv(1,length(idq),3);
		err_roll=pos_err*cutrandnv(1,length(idq),3);
	
		quad_x=placet_element_get_attribute(beamlinename,idq+1,"x");
		quad_xp=placet_element_get_attribute(beamlinename,idq+1,"xp");
		quad_y=placet_element_get_attribute(beamlinename,idq+1,"y");
		quad_yp=placet_element_get_attribute(beamlinename,idq+1,"yp");
		quad_roll=placet_element_get_attribute(beamlinename,idq+1,"roll");

		if keepolderrors==1
			placet_element_set_attribute(beamlinename,idq,"x",old_x+quad_x+err_x);
			placet_element_set_attribute(beamlinename,idq,"xp",old_xp+quad_xp+err_xp);
			placet_element_set_attribute(beamlinename,idq,"y",old_y+quad_y+err_y);
			placet_element_set_attribute(beamlinename,idq,"yp",old_yp+quad_yp+err_yp);
			placet_element_set_attribute(beamlinename,idq,"roll",old_roll+quad_roll+err_roll);
		else
			placet_element_set_attribute(beamlinename,idq,"x",err_x+quad_x);
			placet_element_set_attribute(beamlinename,idq,"xp",err_xp+quad_xp);
			placet_element_set_attribute(beamlinename,idq,"y",err_y+quad_y);
			placet_element_set_attribute(beamlinename,idq,"yp",err_yp+quad_yp);
			placet_element_set_attribute(beamlinename,idq,"roll",err_roll+quad_roll);
		end;
	end;
end;


id=id_dip;
pos_err=error_dipole_pos;
str_err=error_dipole_strength_rel;
if (length(id)>0)
	old_x=placet_element_get_attribute(beamlinename,id,"x");
	old_xp=placet_element_get_attribute(beamlinename,id,"xp");
	old_y=placet_element_get_attribute(beamlinename,id,"y");
	old_yp=placet_element_get_attribute(beamlinename,id,"yp");
	old_roll=placet_element_get_attribute(beamlinename,id,"roll");
	old_str_x=placet_element_get_attribute(beamlinename,id,"strength_x")-orig_dipole_str_x;
	old_str_y=placet_element_get_attribute(beamlinename,id,"strength_y")-orig_dipole_str_y;

	err_x=pos_err*cutrandnv(1,length(id),3);
	err_xp=pos_err*cutrandnv(1,length(id),3);
	err_y=pos_err*cutrandnv(1,length(id),3);
	err_yp=pos_err*cutrandnv(1,length(id),3);
	err_roll=pos_err*cutrandnv(1,length(id),3);
	err_str_x=orig_dipole_str_x.*(1+str_err*cutrandnv(1,length(id),3));
	err_str_y=orig_dipole_str_y.*(1+str_err*cutrandnv(1,length(id),3));
	
	if keepolderrors==1
		placet_element_set_attribute(beamlinename,id,"x",old_x+err_x);
		placet_element_set_attribute(beamlinename,id,"xp",old_xp+err_xp);
		placet_element_set_attribute(beamlinename,id,"y",old_y+err_y);
		placet_element_set_attribute(beamlinename,id,"yp",old_yp+err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",old_roll+err_roll);
		placet_element_set_attribute(beamlinename,id,"strength_x",old_str_x+err_str_x);
		placet_element_set_attribute(beamlinename,id,"strength_y",old_str_y+err_str_y);
	else
		placet_element_set_attribute(beamlinename,id,"x",err_x);
		placet_element_set_attribute(beamlinename,id,"xp",err_xp);
		placet_element_set_attribute(beamlinename,id,"y",err_y);
		placet_element_set_attribute(beamlinename,id,"yp",err_yp);
		placet_element_set_attribute(beamlinename,id,"roll",err_roll);
		placet_element_set_attribute(beamlinename,id,"strength_x",err_str_x);
		placet_element_set_attribute(beamlinename,id,"strength_y",err_str_y);
	end;
end;


endfunction;
%----------------------------------------
