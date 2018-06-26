#!/opt/local/bin/octave-cli

load "beam_prae.dat"
load "B_colli.dat"

global C = B(mask_colli,:);
global C = B(:,:);
C(:,1) = C(:,1)/mean(C(:,1)) - 1;
C(:,4) = C(:,4) * 1e-6;


function ret = optimise_espread(X) 
    global C;
    factor = X(1);
    D = C(:,1) + factor *C(:,4);
    ret = std(D);
endfunction

z = B(:,4) * 1e-6; ### meter
delta = B(:,1)/mean(B(:,1)) - 1;

[p,s] = polyfit(delta,z,1);


R_56 = p(1)

R_65 = 1./R_56

X = randn(1,1);

[R, fval] = fminsearch("optimise_espread",X)

disp(["The optimsed energy spread is " num2str(fval)]);

disp(["The beamsize before the collimator is " num2str(std(B0(:,2)))]);

disp(["The number of paritcles after collimater is " num2str(sum(mask_colli))]);
