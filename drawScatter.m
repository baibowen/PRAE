#!/usr/bin/env octave-cli --persist

set(0,'defaultaxesfontsize',18)
set(0,'defaulttextfontsize',18)
set(0,'defaultlinelinewidth',4)
set(0,'defaultlinemarkersize',10)

%load("beam_prae.dat");
%load("B_colli.dat");
%scatter(B(:,4),1e2*(B(:,1)/mean(B(:,1))-1))
%hold on;
%scatter(B(mask_colli,4),1e2*(B(mask_colli,1)/mean(B(:,1))-1),"r");
%
%xlabel('z (\mu m)');
%ylabel('\delta_E (%)');
%legend("All","Survived");
%
%filename = "delta_z_prorad";
%
%print([filename '.eps'],'-color');
%
%system(['epstopdf ' filename '.eps']);
%
%
%hold off;

load("beam_prae_radiobiology.dat");
scatter(B(:,2),B(:,5));
xlabel('x (\mu m)');
ylabel(["x'" '(\murad)']);
grid on;
filename = "x_xp_radiobiology";
print([filename '.eps'],'-color');
system(['epstopdf ' filename '.eps']);

scatter(B(:,3),B(:,6));
xlabel('y (\mu m)');
ylabel(["y'" '(\murad)']);
grid on;
filename = "y_yp_radiobiology";
print([filename '.eps'],'-color');
system(['epstopdf ' filename '.eps']);


filename = "DeltaE_z_radiobiology_crest"
scatter(B(:,4)-mean(B(:,4)),(B(:,1)/mean(B(:,1))-1)*1e2);
xlabel('z (\mum)')
ylabel('\DeltaE/E (10^{-2})');
grid on;
print(['./' filename '.eps'],'-color');
system(['epstopdf ' filename '.eps']);
