%
% this file contains all procedures required to calculate
% longitudinal and transverse short range wake fields
%


%-----------------------------------------------------
%function wt=w_trans_new(s,a,g,l,delta,delta_g)
%    s=s*1e-6;
%    
%    ax=a;
%    gx=g;
%    s0=0.169*ax^1.79*gx^0.38*l^-1.17;
%    ss0=sqrt(s/s0);
%    tmp=s0/(pi*ax^4)*(1.0-(1.0+ss0)*exp(-ss0));
%    
%    ax=a*(1.0-0.5*delta);
%    gx=g-0.5*delta_g;
%    s0=0.169*ax^1.79*gx^0.38*l^-1.17;
%    ss0=sqrt(s/s0);
%    tmp=tmp+s0/(pi*ax^4)*(1.0-(1.0+ss0)*exp(-ss0));
%
%    ax=a*(1.0+0.5*delta);
%    gx=g+0.5*delta_g;
%    s0=0.169*ax^1.79*gx^0.38*l^-1.17;
%    ss0=sqrt(s/s0);
%    tmp=tmp+s0/(pi*ax^4)*(1.0-(1.0+ss0)*exp(-ss0));
%    
%    ax=a*(1.0-delta);
%    gx=g-delta_g;
%    s0=0.169*ax^1.79*gx^0.38*l^-1.17;
%    ss0=sqrt(s/s0);
%    tmp=tmp+0.5*s0/(pi*ax^4)*(1.0-(1.0+ss0)*exp(-ss0));
%    
%    ax=a*(1.0+delta);
%    gx=g+delta_g;
%    s0=0.169*ax^1.79*gx^0.38*l^-1.17;
%    ss0=sqrt(s/s0);
%    tmp=tmp+0.5*s0/(pi*ax^4)*(1.0-(1.0+ss0)*exp(-ss0));
%
%    wt=0.25*4.0*377.0*3e8*1e-12*tmp;
%endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
%function wtlist=cavity_wake_trans_new(charge,z_matrix,a,g,l,delta,delta_g)
%tic
%    ll=length(z_matrix);
%
%    tmp=zeros((ll+1)*ll/2,1);
%    tc=0;
%    for i=1:ll
%        z0=z_matrix(i,1);
%	for j=1:i
%            tc=tc+1;
%            z=z_matrix(j,1);
%            tmp(tc)=w_trans_new(z0-z,a,g,l,delta,delta_g);
%	end;
%    end;
%    wtlist=1.602177e-7*charge*1.0e-6*tmp;
%toc
%endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function wtlist=cavity_wake_trans_new2(charge,z_matrix,a,g,l,delta,delta_g)
    ax1=a;
    gx1=g;
    s01=0.169*ax1^1.79*gx1^0.38*l^-1.17;
    s01b=s01/(pi*ax1^4);

    ax2=a*(1.0-0.5*delta);
    gx2=g-0.5*delta_g;
    s02=0.169*ax2^1.79*gx2^0.38*l^-1.17;
    s02b=s02/(pi*ax2^4);

    ax3=a*(1.0+0.5*delta);
    gx3=g+0.5*delta_g;
    s03=0.169*ax3^1.79*gx3^0.38*l^-1.17;
    s03b=s03/(pi*ax3^4);
    
    ax4=a*(1.0-delta);
    gx4=g-delta_g;
    s04=0.169*ax4^1.79*gx4^0.38*l^-1.17;
    s04b=0.5*s04/(pi*ax4^4);
    
    ax5=a*(1.0+delta);
    gx5=g+delta_g;
    s05=0.169*ax5^1.79*gx5^0.38*l^-1.17;
    s05b=0.5*s05/(pi*ax5^4);

    z_matrix(:,1)=z_matrix(:,1)*1e-6;
    
    ll=length(z_matrix);

    tmp=zeros((ll+1)*ll/2,1);
    tc=1;
    for i=1:ll
        z0=z_matrix(i,1);

        s=z0-z_matrix(1:i,1);
        ss01=sqrt(s/s01);
        ss02=sqrt(s/s02);
        ss03=sqrt(s/s03);
        ss04=sqrt(s/s04);
        ss05=sqrt(s/s05);
        tmp(tc:tc+(i-1))=(s01b*(1.0-(1.0+ss01).*exp(-ss01))+...
                          s02b*(1.0-(1.0+ss02).*exp(-ss02))+...
                          s03b*(1.0-(1.0+ss03).*exp(-ss03))+...
                          s04b*(1.0-(1.0+ss04).*exp(-ss04))+...
                          s05b*(1.0-(1.0+ss05).*exp(-ss05)));
        tc=tc+i;
    end;
    wtlist=1.602177e-7*charge*1.0e-6*0.25*4.0*377.0*3e8*1e-12*tmp;
endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
%function wl=w_long_new(s,a,g,l,delta,delta_g)
%    s=s*1e-6;
%    
%    ax=a;
%    gx=g;
%    s0=0.41*ax^1.8*gx^1.6*l^-2.4;
%    tmp=1/(pi*ax*ax)*exp(-sqrt(s/s0));
%
%    ax=a*(1.0-0.5*delta);
%    gx=g-0.5*delta_g;
%    s0=0.41*ax^1.8*gx^1.6*l^-2.4;
%    tmp=tmp+1/(pi*ax*ax)*exp(-sqrt(s/s0));
%
%    ax=a*(1.0+0.5*delta);
%    gx=g+0.5*delta_g;
%    s0=0.41*ax^1.8*gx^1.6*l^-2.4;
%    tmp=tmp+1/(pi*ax*ax)*exp(-sqrt(s/s0));
%
%    ax=a*(1.0-delta);
%    gx=g-delta_g;
%    s0=0.41*ax^1.8*gx^1.6*l^-2.4;
%    tmp=tmp+0.5/(pi*ax*ax)*exp(-sqrt(s/s0));
%
%    ax=a*(1.0+delta);
%    gx=g+delta_g;
%    s0=0.41*ax^1.8*gx^1.6*l^-2.4;
%    tmp=tmp+0.5/(pi*ax*ax)*exp(-sqrt(s/s0));
%
%    wl=377.0*3e8*1e-12*tmp/4.0;
%endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
%function wllist=cavity_wake_long_new(charge,z_matrix,a,g,l,delta,delta_g)
%tic
%    n=length(z_matrix);
%
%    tmp=zeros(n,2);
%    tc=0;
%    for i=1:n
%        z0=z_matrix(i,1);
%        wgt0=charge*z_matrix(i,2);
%	tsum=0.0;
%	for j=1:(i-1)
%            z=z_matrix(j,1);
%            wgt=charge*z_matrix(j,2);
%	    tsum=tsum+wgt*w_long_new(z0-z,a,g,l,delta,delta_g);
%	end;
%        tc=tc+1;
%	tmp(tc,1)=z_matrix(i,1);
%        tmp(tc,2)=tsum+0.5*wgt0*w_long_new(0,a,g,l,delta,delta_g);
%    end;
%    tmp(:,2)=-tmp(:,2)*1.602177e-7*1e-6;
%    wllist=tmp;
%toc
%endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function wllist=cavity_wake_long_new2(charge,z_matrix,a,g,l,delta,delta_g)
    ax1=a;
    ax1b=1/(pi*ax1*ax1);
    gx1=g;
    s01=0.41*ax1^1.8*gx1^1.6*l^-2.4;

    ax2=a*(1.0-0.5*delta);
    ax2b=1/(pi*ax2*ax2);
    gx2=g-0.5*delta_g;
    s02=0.41*ax2^1.8*gx2^1.6*l^-2.4;

    ax3=a*(1.0+0.5*delta);
    ax3b=1/(pi*ax3*ax3);
    gx3=g+0.5*delta_g;
    s03=0.41*ax3^1.8*gx3^1.6*l^-2.4;

    ax4=a*(1.0-delta);
    ax4b=0.5/(pi*ax4*ax4);
    gx4=g-delta_g;
    s04=0.41*ax4^1.8*gx4^1.6*l^-2.4;

    ax5=a*(1.0+delta);
    ax5b=0.5/(pi*ax5*ax5);
    gx5=g+delta_g;
    s05=0.41*ax5^1.8*gx5^1.6*l^-2.4;

    wl0=0.5*(ax1b+ax2b+ax3b+ax4b+ax5b);
    
    z_matrix(:,1)=z_matrix(:,1)*1e-6;
    
    n=length(z_matrix);
    tmp=zeros(n,2);
    tc=0;
    for i=1:n
        s=z_matrix(i,1)-z_matrix(1:i-1,1);
        tsum=z_matrix(1:i-1,2)'*...
	     (ax1b*exp(-sqrt(s/s01))+...
	      ax2b*exp(-sqrt(s/s02))+...
	      ax3b*exp(-sqrt(s/s03))+...
	      ax4b*exp(-sqrt(s/s04))+...
	      ax5b*exp(-sqrt(s/s05)));
        tc=tc+1;
        tmp(tc,2)=tsum+z_matrix(i,2)*wl0;
    end;
    tmp(:,1)=z_matrix(:,1)*1e6;
    tmp(:,2)=-tmp(:,2)*charge*1.602177e-7*1e-6*377.0*3e8*1e-12/4.0;
    wllist=tmp;
endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function dewake=cavity_wake(filename,charge,sigmamin,sigmamax,sigmaz,meanz,nslice,a,g,l,delta,delta_g,particlesfile)
% create a list of longitudinal and transverse wake kicks
% required by the InjectorBeam command
    fid=fopen(filename,"rt");
    if (fid~=-1)
        [nsliceold,dewake,ccc]=fscanf(fid,"%f %f","C");
%        cc
%        dewake
%        ccc
        fclose(fid);
    end;
    if (fid==-1)||(nsliceold~=nslice)
        fid=fopen(filename,"wt");
        fprintf(fid,"%d\n",nslice);
        
%        profilelong=gausslist(sigmamin,sigmamax,sigmaz,meanz,1.0,1*nslice);
        profilelong=profilelist(sigmamin,sigmamax,sigmaz,meanz,1.0,1*nslice,particlesfile);
        wakelong=cavity_wake_long_new2(charge,profilelong,a,g,l,delta,delta_g);
        
%        wl=wakelong(floor(nslice/2)*5+3,2);
        wl=wakelong(:,2)'*profilelong(:,2)/sum(profilelong(:,2));
        dewake=wl;
        fprintf(fid,"%22.18e\n",wl);
        for i=1:nslice
%            zv=wakelong(5*(i-1)+1:5*(i-1)+5,1);
%            wlv=wakelong(5*(i-1)+1:5*(i-1)+5,2);
%            wgtv=profilelong(5*(i-1)+1:5*(i-1)+5,2);
%            z=mean(zv,1);
%            if (sum(wgtv)>0)
%              wl=wlv'*wgtv/sum(wgtv);
%             else
%              wl=mean(wlv,1);
%            end;
%            wgt=sum(wgtv);
%            z=wakelong(3+5*(i-1),1);
%            wl=wakelong(3+5*(i-1),2);
%            wgt=profilelong(3+5*(i-1),2)*5;
            z=wakelong(i,1);
            wl=wakelong(i,2);
            wgt=profilelong(i,2);
	    fprintf(fid,"%20.16e %20.16e %20.16e\n",z,wl,wgt);
        end;
        
%        profiletrans=gausslist(sigmamin,sigmamax,sigmaz,0.0,1.0,nslice);
%        profiletrans=profilelist(sigmamin,sigmamax,sigmaz,meanz,1.0,nslice,particlesfile);
        profiletrans=profilelong;
        waketrans=cavity_wake_trans_new2(charge,profiletrans,a,g,l,delta,delta_g);
        nt=length(waketrans);
        for i=1:nt
    	    fprintf(fid,"%20.16e\n",waketrans(i));
        end;
    fclose(fid);
    end;
endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function dewake=cavity_wake_zero(filename,sigmamin,sigmamax,sigmaz,meanz,nslice)
% create a list of longitudinal and transverse wake kicks
% required by the InjectorBeam command
% all kicks are set to 0
    fid=fopen(filename,"rt");
    if (fid~=-1)
        [nsliceold,dewake,ccc]=fscanf(fid,"%f %f","C");
%        cc
%        dewake
%        ccc
        fclose(fid);
    end;
    if (fid==-1)||(nsliceold~=nslice)
        fid=fopen(filename,"wt");
        fprintf(fid,"%d\n",nslice);
        fprintf(fid,"0.0\n");

        gl=gausslist(sigmamin,sigmamax,sigmaz,0.0,1.0,nslice);
        n=length(gl);
        for i=1:n
            fprintf(fid,"%20.16e %20.16e %20.16e\n",gl(i,1)+meanz,0.0,gl(i,2));
        end;
        maxi=(nslice+1)*nslice/2;
        for i=1:maxi
            fprintf(fid,"%20.16e\n",0.0);
        end;
    fclose(fid);
    end;
    dewake=0.0;
endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function gl=gausslist(sigmamin,sigmamax,sigmaz,meanz,charge,nslices)
    minz=sigmamin*sigmaz;
    maxz=sigmamax*sigmaz;
    zstep=(maxz-minz)/nslices;
    minz=minz+zstep/2.0;
    maxz=maxz-zstep/2.0;
    
    for i=1:nslices
        z=minz+(i-1)*zstep;
        gl(i,1)=z+meanz;
        gl(i,2)=charge*0.5*(erf((z+zstep/2)/(sigmaz*sqrt(2)))-erf((z-zstep/2)/(sigmaz*sqrt(2))));
    end;
endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
function pl=profilelist(sigmamin,sigmamax,sigmaz,meanz,charge,nslices,particlesfile)
    particlesdata=load(particlesfile);
    pd=particlesdata(:,4);
    lpd=length(pd);
    [pds,id]=sort(pd);

    minpd=min(pd);
    maxpd=max(pd);
    minz=sigmamin*sigmaz+meanz;
    maxz=sigmamax*sigmaz+meanz;
    
    if (minpd<minz)||(maxpd>maxz)
        printf("Particles out of range. Continuing any way.\n");
    end;

    zstep=(maxz-minz)/nslices;
    z=minz:zstep:maxz+zstep/100;
    nz=length(z);
    
    ipd=1;
    for i=1:nz-1
        nb=0;
        while (pds(ipd)<z(i+1))&&(ipd<lpd)
            ipd=ipd+1;
            nb=nb+1;
        end;
        c(i)=nb;
    end;
    
    pl(:,1)=z(1:nz-1)+zstep/2.0;

    fs=floor(nslices/100)+1;
%    b=ones(1,fs)/fs;
%    cn=filter(b,1,c);
    [sn,cn]=makesmooth(pl(:,1),c,fs);
    pl(:,2)=charge*cn/sum(cn);

endfunction;
%-----------------------------------------------------


%-----------------------------------------------------
% a very simple smoothing algorithm
function [sn,xn]=makesmooth(s,x,w)
lx=length(x);
sl=w;

for i=1:sl
  sn(i)=s(i);
  xn(i)=meanw(x(1:i+i-1),1);
end;

for i=1+sl:lx-sl
  sn(i)=s(i);
  xn(i)=meanw(x(i-sl:i+sl),1);
end;

for i=lx-sl+1:lx
  sn(i)=s(i);
  xn(i)=meanw(x(i-(lx-i):lx),1);
end;

endfunction;
