set e0 0.070298
set e_initial $e0

set START "START"
set END "END"

set sbend_synrad 1
set quad_synrad 0
set mult_synrad 0

set match(beta_x) 8.7976
set match(beta_y) 8.3025
set match(alpha_x) -0.99591
set match(alpha_y) -0.84441

SetReferenceEnergy $e0
Girder
Drift -name "PRAE_RADIOBIOLOGY$START" -length 0 
Girder
Drift -name "D_LINAC_TO_DOUBLET" -length 1 
Girder
Quadrupole -name "Q_DOUBLET_1ST_1" -synrad $quad_synrad -length 0.2 -strength [expr 0.6526005099*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_1ST_1" -length 0.5 
Girder
Quadrupole -name "Q_DOUBLET_1ST_2" -synrad $quad_synrad -length 0.2 -strength [expr -0.8172614863*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_TO_DOUBLET" -length 5 
Girder
Quadrupole -name "Q_DOUBLET_2ND_1" -synrad $quad_synrad -length 0.2 -strength [expr 1.210505313*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_2ND_1" -length 0.5 
Girder
Quadrupole -name "Q_DOUBLET_2ND_2" -synrad $quad_synrad -length 0.2 -strength [expr -0.9531858099*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_TO_DOGLEG" -length 0.5 
Girder
Sbend -name "S_KICKER" -synrad $sbend_synrad -length 0.2 -angle 0.2443460953 -E1 0 -E2 0.2443460953 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.2443460953*0.2443460953/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_KICKER_TO_TRIPLET_2ND" -length 1.7 
Girder
Quadrupole -name "Q_TRIPLET_2ND_1" -synrad $quad_synrad -length 0.2 -strength [expr 1.092316846*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_2ND_TO_KICKER" -length 1.7 
Girder
Sbend -name "S_KICKER_2" -synrad $sbend_synrad -length 0.2 -angle 0.2443460953 -E1 0.2443460953 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.2443460953*0.2443460953/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_KICKER_TO_TRIPLET_3RD" -length 0.4 
Girder
Quadrupole -name "Q_TRIPLET_3RD_1" -synrad $quad_synrad -length 0.2 -strength [expr 2.19307518*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_2" -synrad $quad_synrad -length 0.2 -strength [expr -2.408370782*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_3" -synrad $quad_synrad -length 0.2 -strength [expr 1.127096269*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_TO_TARGET" -length 3 
Girder
Drift -name "PRAE_RADIOBIOLOGY$END" -length 0 
