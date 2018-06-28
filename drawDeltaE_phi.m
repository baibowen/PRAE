set(0,'defaultaxesfontsize',18)
set(0,'defaulttextfontsize',18)
set(0,'defaultlinelinewidth',4)
set(0,'defaultlinemarkersize',10)

A=load("result.txt");

for i_coll = 5:-1:1
mask_coll_size = A(:,3) == i_coll;
plot(A(mask_coll_size,1),A(mask_coll_size,4));
hold on;
endfor

line([5 85],[5,5]);

legend("5 mm","4 mm","3 mm","2 mm", "1 mm");
xlabel("Chicane Angle (degree)")
ylabel('\DeltaE/E (10^{-4})');

grid on;
hold off;

print(['./DeltaE_phi_noRF.eps'],'-color');


for i_coll = 5:-1:1
mask_coll_size = A(:,3) == i_coll;
plot(A(mask_coll_size,1),A(mask_coll_size,5));
hold on;
endfor

line([5 85],[20,20]);

legend("5 mm","4 mm","3 mm","2 mm", "1 mm");
xlabel("Chicane Angle (degree)")
ylabel('Survived (%)');

grid on;
hold off;

print(['./Survive_phi_noRF.eps'],'-color');


system("epstopdf Survive_phi_noRF.eps");
system("epstopdf DeltaE_phi_noRF.eps");
