%
% particle beam setup
%
% values are expected in Placet units and the output is done in Placet units.
% and intermediate conversion to standard units is done via pu_xyz, pu_xpyp, pu_e and pu_emit

function create_particle_distribution(outfilename,bx,ax,enx,by,ay,eny,sigmaz,meanz,...
                                      espread,echirp,energy,meanx,meanxp,meany,meanyp,...
                                      nsigma,npart,pu_xyz,pu_xpyp,pu_e,pu_emit)
format long;

% first we convert to some useful units ;-)
bx=bx;
ax=ax;
enx=enx/pu_emit;
by=by;
ay=ay;
eny=eny/pu_emit;
sz=sigmaz/pu_xyz;
espread=espread;
echirp=echirp*pu_xyz;
energy=energy/pu_e;

%then we calculate a few beam properties
ex=enx/energy*510998.9;
ey=eny/energy*510998.9;

sx=sqrt(ex*bx);
sxp=sqrt(ex/bx);
sy=sqrt(ey*by);
syp=sqrt(ey/by);
seu=abs(espread)*energy;

xxpc=-ax/bx;
yypc=-ay/by;

% create the particle distribution
% and eliminate any offset and correlation
nc=6;
%randn("seed", 9876 * 1e4);
rv=cutrandnv(npart,nc,nsigma);
for i=1:nc
  rv(:,i)=rv(:,i)-mean(rv(:,i),1);
end;
for i=1:nc-1
  for j=i+1:nc
    a=rv(:,i);
    b=rv(:,j);
    c=ols(b,a);
    b=b-c*a;
    rv(:,j)=b;
  end;
end;
for i=1:nc
  rv(:,i)=rv(:,i)/std(rv(:,i),1);
end;

x =sx*rv(:,1);
xp=sxp*rv(:,2)+x*xxpc;
y =sy*rv(:,3);
yp=syp*rv(:,4)+y*yypc;
z =sz*rv(:,5);
e =seu*rv(:,6)+z*echirp*energy+energy;

% now we convert back to Placet units
% and we shift the distribution by the requested values
x=x*pu_xyz+meanx;
xp=xp*pu_xpyp+meanxp;
y=y*pu_xyz+meany;
yp=yp*pu_xpyp+meanyp;
z=z*pu_xyz+meanz;
e=e*pu_e;

%sort by z position to be consistent with Placet output
[zs,id]=sort(z);
outdata=[e(id),x(id),y(id),z(id),xp(id),yp(id)];
%outdata=[e,x,y,z,xp,yp];

fid=fopen(outfilename,"wt");
fprintf(fid,"%20.12e %20.12e %20.12e %20.12e %20.12e %20.12e\n",outdata');
fclose(fid);

endfunction;
