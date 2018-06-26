% some functions to calculate statistics
% and some helper functions
%

%----------------------------------------
function x=cutrandnv(rows,cols,sigma)
% return vector of normal distributed random numbers up to +- sigma
%
x=randn(rows,cols);
for j=1:rows
  for i=1:cols
    while (x(j,i) > sigma)||(x(j,i)<-sigma)
        x(j,i)=randn(1);
    end;
  end;
end;

endfunction;
%----------------------------------------


%----------------------------------------
% calculates the mean of weighted values
% the weight could be, e.g., the charge of a particle
function m=meanw(x,w)
sx=size(x);
sw=size(w);

if ((sw(1)~=1)&&(sw(2)~=1))||((sx(1)~=1)&&(sx(2)~=1))
  m=0.0;
  return;
end;
if ((sx(1)==1)&&(sx(2)==1))
  m=x;
  return;
end;


if (sx(1)<sx(2))
  x=x.';
end;

if ((sw(1)==1)&&(sw(2)==1))
  w=ones(sx(1),sx(2));
  sw=size(w);
end;

if (sw(1)>sw(2))
  w=w.';
end;

m=w*x/sum(w);
endfunction;
%----------------------------------------


%----------------------------------------
% calculates the median of weighted values
% the weight could be, e.g., the charge of a particle
% has to be called with correctly sized and sorted arrays!
function m=medianw(x,w)
sx=size(x);
sw=size(w);

if ((sw(1)~=1)&&(sw(2)~=1))||((sx(1)~=1)&&(sx(2)~=1))
  m=0.0;
  return;
end;
if ((sx(1)==1)&&(sx(2)==1))
  m=x;
  return;
end;


w05=sum(w)/2;
imax=length(w);
i=ceil(imax/2);
%i=round(imax/2);
wt=sum(w(1:i));
while wt > w05
  wt=wt-w(i);
  i--;
end;
while wt < w05
  i++;
  wt=wt+w(i);
end;

if wt==w05
  m=(x(i)+x(i+1))/2;
 else
  wt=wt-w(i);
  dx=(x(i)-x(i-1))/w(i)*(w05-wt);
  m=(x(i)+x(i-1))/2+dx;
end;

%if wt==w05
%  if round(i/2)==i/2
%    m=(x(i)+x(i+1))/2;
%   else
%    m=x(i);
%  end;
% else
%  wt=wt-w(i);
%  dx=(x(i)-x(i-1))/w(i)*(w05-wt);
%  m=x(i-1)+dx;
%end;

endfunction;
%----------------------------------------


%----------------------------------------
%calculates the standard deviation of weighted values
%the weight could be, e.g., the charge of a particle
function r=stdw(x,w)
sx=size(x);
sw=size(w);

if ((sw(1)~=1)&&(sw(2)~=1))||((sx(1)~=1)&&(sx(2)~=1))||((sx(1)==1)&&(sx(2)==1))
  r=0.0;
  return;
end;

if (sx(1)<sx(2))
  x=x.';
end;

if ((sw(1)==1)&&(sw(2)==1))
  w=ones(sx(1),sx(2));
  sw=size(w);
end;

if (sw(1)>sw(2))
  w=w.';
end;

xm=meanw(x,w);
r=sqrt(w*((x-xm).^2)/sum(w));
endfunction;
%----------------------------------------


%----------------------------------------
%calculates the rms of weighted values
%the weight could be, e.g., the charge of a particle
function r=rms(x,w)
sx=size(x);
sw=size(w);

if ((sw(1)~=1)&&(sw(2)~=1))||((sx(1)~=1)&&(sx(2)~=1))||((sx(1)==1)&&(sx(2)==1))
  r=0.0;
  return;
end;

if (sx(1)<sx(2))
  x=x.';
end;

if ((sw(1)==1)&&(sw(2)==1))
  w=ones(sx(1),sx(2));
  sw=size(w);
end;

if (sw(1)>sw(2))
  w=w.';
end;

xm=meanw(x,w);
xs=stdw(x,w);
r=sqrt(xm^2+xs^2);
endfunction;
%----------------------------------------


%----------------------------------------
% calculates the non-normalized projected emittance
function e=emitproj(x,xp,w)
sw=size(w);
sx=size(x);
sxp=size(xp);
if ((sx(1)!=sxp(1))||(sx(2)!=sxp(2)))
  e=0;
  return;
end;
if (sx(1)>sx(2))
  x=x.';
  xp=xp.';
end;
if ((sw(1)==1)&&(sw(2)==1))
  w=w*ones(sx(2),sx(1));
end;
sw=size(w);
sx=size(x);
if (sw==sx)
  w=w.';
end;

vxc=x-meanw(x,w);
vyc=xp-meanw(xp,w);

e=sqrt(((vxc.*vxc)*w/sum(w))*...
        ((vyc.*vyc)*w/sum(w))-...
        ((vxc.*vyc)*w/sum(w))^2);
endfunction;
%----------------------------------------


%----------------------------------------
% calculates beta function and alpha
function [b,a]=twiss(x,xp,w)
x=x-meanw(x,w);
xp=xp-meanw(xp,w);
ex=emitproj(x,xp,w);
b=stdw(x,w)^2/ex;
a=-meanw(x.*xp,w)/ex;
endfunction;
%----------------------------------------


%----------------------------------------
function [xn,xpn,wn]=clear_outliers(x,xp,w)
% delete particle, whose coordinates are far from the center of the distribution.
no=length(x);
sizexo=size(x);
sizexpo=size(xp);
sizewo=size(w);

% we track the original position to be able to put the particles back in the original order
pos=1:no;

% first, delete Inf, NaN, NA and ridiculously far particles
% to speed up we do some tricks to avoid cycling through the complete array
ts=finite(x)+finite(xp)+(abs(x)<1e15)+(abs(xp)<1e15);
[tstmp,idtmp]=sort(ts);
xtmp=x(idtmp);
xptmp=xp(idtmp);
wtmp=w(idtmp);
postmp=pos(idtmp);

i=1;
while (tstmp(i)~=4)&&(i<no)
  i++;
end;
n1=no-i+1;

% for further calculations it is practical to have
% row vectors for x and xp and a column vector for w
if sizexo(1)==1
  xn1=xtmp(i:no).';
 else
  xn1=xtmp(i:no);
end;
if sizexpo(1)==1
  xpn1=xptmp(i:no).';
 else
  xpn1=xptmp(i:no);
end;
if sizewo(1)==1
  wn1=wtmp(i:no);
 else
  wn1=wtmp(i:no).';
end;
posn1=postmp(i:no);

% now gradually cut away particles until std does not change significantly
% we calculate around median instead of mean
% median is more stable in case there are far outlying particles

% we cut a maximum of 1% of the particles
nmax=round(0.01*no);
% this is a criterium for the stability of the std at which we stop cutting
cut=10/no+1;

%first we cut in one plane
mx=medianw(xn1,wn1);
[dtmp1,idtmp1]=sort(-abs(xn1-mx));
xtmp1=xn1(idtmp1);
xptmp1=xpn1(idtmp1);
wtmp1=wn1(idtmp1);
postmp1=posn1(idtmp1);

% these steps are required for a trick to speed up calculations in medianw!
[xtmp1s,idx1s]=sort(xtmp1);
wtmp1s=wtmp1(idx1s);

tmx=medianw(xtmp1s,wtmp1s);
stdxold=sqrt(wtmp1*((xtmp1-tmx).^2)/sum(wtmp1));
wtmp1t=wtmp1;
wtmp1t(1)=0;
wtmp1s(idx1s(1))=0;
tmx=medianw(xtmp1s,wtmp1s);
stdx=sqrt(wtmp1t*((xtmp1-tmx).^2)/sum(wtmp1t));

i=2;
while (stdxold/stdx>cut)&&(i<nmax)
  stdxold=stdx;
  wtmp1(i-1)=0;
  wtmp1t=wtmp1;
  wtmp1t(i)=0;
  wtmp1s(idx1s(i))=0;
  tmx=medianw(xtmp1s,wtmp1s);
  stdx=sqrt(wtmp1t*((xtmp1-tmx).^2)/sum(wtmp1t));
  i++;
end;
xn2=xtmp1(i-1:n1);
xpn2=xptmp1(i-1:n1);
wn2=wtmp1(i-1:n1);
posn2=postmp1(i-1:n1);
n2=n1-i+2;

%then we cut in the other plane
mxp=medianw(xpn2,wn2);
[dtmp2,idtmp2]=sort(-abs(xpn2-mxp));
xtmp2=xn2(idtmp2);
xptmp2=xpn2(idtmp2);
wtmp2=wn2(idtmp2);
postmp2=posn2(idtmp2);

% these steps are required for a trick to speed up calculations in medianw!
[xptmp2s,idxp2s]=sort(xptmp2);
wtmp2s=wtmp2(idxp2s);

tmxp=medianw(xptmp2s,wtmp2s);
stdxpold=sqrt(wtmp2*((xptmp2-tmxp).^2)/sum(wtmp2));
wtmp2t=wtmp2;
wtmp2t(1)=0;
wtmp2s(idxp2s(1))=0;
tmxp=medianw(xptmp2s,wtmp2s);
stdxp=sqrt(wtmp2t*((xptmp2-tmxp).^2)/sum(wtmp2t));

i=2;
while (stdxpold/stdxp>cut)&&(i<nmax)
  stdxpold=stdxp;
  wtmp2(i-1)=0;
  wtmp2t=wtmp2;
  wtmp2t(i)=0;
  wtmp2s(idxp2s(i))=0;
  tmxp=medianw(xptmp2s,wtmp2s);
  stdxp=sqrt(wtmp2t*((xptmp2-tmxp).^2)/sum(wtmp2t));
  i++;
end;
xn3=xtmp2(i-1:n2);
xpn3=xptmp2(i-1:n2);
wn3=wtmp2(i-1:n2);
posn3=postmp2(i-1:n2);
n3=n2-i+2;


% we bring the remaining particles back in the original order
% and we want to preserve the original orientation of the arrays
[possort,idsort]=sort(posn3);

if sizexo(1)==1
  xn=xn3(idsort).';
 else
  xn=xn3(idsort);
end;

if sizexpo(1)==1
  xpn=xpn3(idsort).';
 else
  xpn=xpn3(idsort);
end;

if sizewo(1)==1
  wn=wn3(idsort);
 else
  wn=wn3(idsort).';
end;

if (no-n1~=0)||(n1-n2~=0)||(n2-n3~=0)
  printf("%d + %d + %d particles excluded.\n",no-n1,n1-n2,n2-n3);
end;
endfunction;
%----------------------------------------


%----------------------------------------
function [xn,xpn,yn,ypn,sn,den,wn]=clear_outliers_6d(ps,w)
% delete particle, whose coordinates are far from the center of the distribution.
if (columns(ps)!=6)
  printf("clear_outliers_6d works only on particle beams.\n");
  xn=0;
  xpn=0;
  yn=0;
  ypn=0;
  sn=0;
  den=0;
  wn=0;
  return;
end;

no=length(ps(:,1));

sizew=size(w);
if sizew(1)~=1
  w=w';
end;
if length(w)~=no
  w=ones(1,no);
end;

% we track the original position to be able to put the particles back in the original order
pos=1:no;

% first, delete Inf, NaN, NA and ridiculously far particles
% to speed up we do some tricks to avoid cycling through the complete array
ts=sum(finite(ps)+(abs(ps)<1e15),2);
[tstmp,pstmp,wtmp,postmp,idtmp]=sortmatrix(ts,ps,w,pos);
i=1;
while (tstmp(i)~=12)&&(i<no)
  i++;
end;
n1=no-i+1;
posn1=postmp(i:no);
wn1=wtmp(i:no);
psn1=pstmp(i:no,:);

% now gradually cut away particles until std does not change significantly
% we perform the cut in each plane separately
% we calculate around median instead of mean
% median is more stable in case there are far outlying particles

% we cut a maximum of 1% of the particles
nmax=round(0.01*no);
% this is a criterium for the stability of the std at which we stop cutting
cut=10/no+1;

c1=psn1(:,1);
c2=psn1(:,2);
c3=psn1(:,3);
c4=psn1(:,4);
c5=psn1(:,5);
c6=psn1(:,6);

wt=wn1;
post=posn1;
nt=n1;

for p=1:12
  switch(p)
    case 1
      v=c1;
    case 2
      v=c2;
    case 3
      v=c3;
    case 4
      v=c4;
    case 5
      v=c5;
    case 6
      v=c6;
    case 7
      v=c1;
    case 8
      v=c2;
    case 9
      v=c3;
    case 10
      v=c4;
    case 11
      v=c5;
    case 12
      v=c6;
  endswitch;
  
  mx=medianw(v,wt);
  [dtmp,idtmp]=sort(-abs(v-mx));
  vtmp=v(idtmp);
  wtmp=wt(idtmp);

  % the first steps are required for a trick to speed up calculations in medianw!
  [vtmps,ids]=sort(vtmp);
  wtmps=wtmp(ids);

  tmv=medianw(vtmps,wtmps);
  stdvold=sqrt(wtmp*((vtmp-tmv).^2)/sum(wtmp));
  wtmpt=wtmp;
  wtmpt(1)=0;
  wtmps=wtmpt(ids);
  tmv=medianw(vtmps,wtmps);
  stdv=sqrt(wtmpt*((vtmp-tmv).^2)/sum(wtmpt));
  i=2;
  while (stdvold/stdv>cut)&&(i<nmax)
    stdvold=stdv;
    wtmp(i-1)=0;
    wtmpt=wtmp;
    wtmpt(i)=0;
    wtmps=wtmpt(ids);
    tmv=medianw(vtmps,wtmps);
    stdv=sqrt(wtmpt*((vtmp-tmv).^2)/sum(wtmpt));
    i++;
%    p=p
  end;

  c1t=c1(idtmp);
  c2t=c2(idtmp);
  c3t=c3(idtmp);
  c4t=c4(idtmp);
  c5t=c5(idtmp);
  c6t=c6(idtmp);
  postt=post(idtmp);

  c1=c1t(i-1:nt);
  c2=c2t(i-1:nt);
  c3=c3t(i-1:nt);
  c4=c4t(i-1:nt);
  c5=c5t(i-1:nt);
  c6=c6t(i-1:nt);
  wt=wtmp(i-1:nt);
  post=postt(i-1:nt);

  [possort,idsort]=sort(post);
  c1=c1(idsort);
  c2=c2(idsort);
  c3=c3(idsort);
  c4=c4(idsort);
  c5=c5(idsort);
  c6=c6(idsort);
  wt=wt(idsort);
  post=possort;
  
  nt=nt-i+2;
end;


% we bring the remaining particles back in the original order
[possort,idsort]=sort(post);

xn =c2(idsort);
xpn=c5(idsort);
yn =c3(idsort);
ypn=c6(idsort);
sn =c4(idsort);
den=c1(idsort);
wn =wt(idsort);

if (no-n1~=0)||(n1-nt~=0)
  printf("%d + %d particles excluded.\n",no-n1,n1-nt);
end;

endfunction;
%----------------------------------------


%----------------------------------------
function [tsn,psn,wn,posn,idn]=sortmatrix(ts,ps,w,pos)
c1=ps(:,1);
c2=ps(:,2);
c3=ps(:,3);
c4=ps(:,4);
c5=ps(:,5);
c6=ps(:,6);

[tstmp,idtmp]=sort(ts);

c1n=c1(idtmp);
c2n=c2(idtmp);
c3n=c3(idtmp);
c4n=c4(idtmp);
c5n=c5(idtmp);
c6n=c6(idtmp);

tsn=tstmp;
psn=[c1n,c2n,c3n,c4n,c5n,c6n];
wn=w(idtmp);
posn=pos(idtmp);
idn=idtmp;

endfunction;
%----------------------------------------


%----------------------------------------
function bn=units_std_to_placet(bo)
bn=bo;
if (columns(bo)==17)
  bn=units_std_to_placet_slice_beam(bo);
end;
if (columns(bo)==6)
  bn(:,1)=bo(:,1)/1e9;
  bn(:,2)=bo(:,2)/1e-6;
  bn(:,3)=bo(:,3)/1e-6;
  bn(:,4)=bo(:,4)/1e-6;
  bn(:,5)=bo(:,5)/1e-6;
  bn(:,6)=bo(:,6)/1e-6;
end;
endfunction;
%----------------------------------------


%----------------------------------------
function bn=units_placet_to_std(bo)
bn=bo;
if (columns(bo)==17)
  bn=units_placet_to_std_slice_beam(bo);
end;
if (columns(bo)==6)
  bn(:,1)=bo(:,1)*1e9;
  bn(:,2)=bo(:,2)*1e-6;
  bn(:,3)=bo(:,3)*1e-6;
  bn(:,4)=bo(:,4)*1e-6;
  bn(:,5)=bo(:,5)*1e-6;
  bn(:,6)=bo(:,6)*1e-6;
end;
endfunction;
%----------------------------------------


%----------------------------------------
function bn=units_placet_to_std_slice_beam(bo)
bn=bo;
if (columns(bo)==6)
  bn=units_placet_to_std(bo);
end;
if (columns(bo)==17)
  bn(:,1)=bo(:,1)*1e-6;
  bn(:,2)=bo(:,2);
  bn(:,3)=bo(:,3)*1e9;
  bn(:,4)=bo(:,4)*1e-6;
  bn(:,5)=bo(:,5)*1e-6;
  bn(:,6)=bo(:,6)*1e-6;
  bn(:,7)=bo(:,7)*1e-6;
  bn(:,8)=bo(:,8)*1e-12;
  bn(:,9)=bo(:,9)*1e-12;
  bn(:,10)=bo(:,10)*1e-12;
  bn(:,11)=bo(:,11)*1e-12;
  bn(:,12)=bo(:,12)*1e-12;
  bn(:,13)=bo(:,13)*1e-12;
  bn(:,14)=bo(:,14)*1e-12;
  bn(:,15)=bo(:,15)*1e-12;
  bn(:,16)=bo(:,16)*1e-12;
  bn(:,17)=bo(:,17)*1e-12;
end;
endfunction;
%----------------------------------------


%----------------------------------------
function bn=units_std_to_placet_slice_beam(bo)
bn=bo;
if (columns(bo)==6)
  bn=units_std_to_placet(bo);
end;
if (columns(bo)==17)
  bn(:,1)=bo(:,1)/1e-6;
  bn(:,2)=bo(:,2);
  bn(:,3)=bo(:,3)/1e9;
  bn(:,4)=bo(:,4)/1e-6;
  bn(:,5)=bo(:,5)/1e-6;
  bn(:,6)=bo(:,6)/1e-6;
  bn(:,7)=bo(:,7)/1e-6;
  bn(:,8)=bo(:,8)/1e-12;
  bn(:,9)=bo(:,9)/1e-12;
  bn(:,10)=bo(:,10)/1e-12;
  bn(:,11)=bo(:,11)/1e-12;
  bn(:,12)=bo(:,12)/1e-12;
  bn(:,13)=bo(:,13)/1e-12;
  bn(:,14)=bo(:,14)/1e-12;
  bn(:,15)=bo(:,15)/1e-12;
  bn(:,16)=bo(:,16)/1e-12;
  bn(:,17)=bo(:,17)/1e-12;
end;
endfunction;
%----------------------------------------


%----------------------------------------
function beamnormal=transform_to_normal_coords(beam)
if (columns(beam)!=6)
  printf("transform_to_normal_coords has to be called with a particle beam.\n");
  beamnormal=beam;
  return;
end;

[bx,ax]=twiss(beam(:,2),beam(:,5),1);
[by,ay]=twiss(beam(:,3),beam(:,6),1);

beamnormal(:,1)=beam(:,1);
beamnormal(:,2)=beam(:,2)/sqrt(bx);
beamnormal(:,3)=beam(:,3)/sqrt(by);
beamnormal(:,4)=beam(:,4);
beamnormal(:,5)=ax/sqrt(bx)*beam(:,2)+sqrt(bx)*beam(:,5);
beamnormal(:,6)=ay/sqrt(by)*beam(:,3)+sqrt(by)*beam(:,6);

endfunction;
