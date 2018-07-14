set(0,'defaultaxesfontsize',18)
set(0,'defaulttextfontsize',18)
set(0,'defaultlinelinewidth',4)
set(0,'defaultlinemarkersize',20)

A=load("output_linac_placet.dat");

filename = "DeltaE_z_linac_crest"

scatter(A(:,4)-mean(A(:,4)),(A(:,1)/mean(A(:,1))-1)*1e2);

xlabel('z (\mum)')
ylabel('\DeltaE/E (10^{-2})');

grid on;

print(['./' filename '.eps'],'-color');

system(['epstopdf ' filename '.eps']);


filename = "x_xp_linac_crest"

scatter(A(:,2),A(:,5));

xlabel('x (\mum)')
ylabel(["x'" '(\murad)']);

grid on;

print(['./' filename '.eps'],'-color');

system(['epstopdf ' filename '.eps']);

filename = "x_y_linac_crest"

scatter(A(:,2),A(:,3));

xlabel('x (\mum)')
ylabel('y (\mum)')

grid on;

print(['./' filename '.eps'],'-color');

system(['epstopdf ' filename '.eps']);
