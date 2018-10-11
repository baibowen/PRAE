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
Drift -name "PRAE_PRORAD$START" -length 0 
Girder
Drift -name "D_LINAC_TO_DOUBLET" -length 1 
Girder
Quadrupole -name "Q_DOUBLET_1ST_1" -synrad $quad_synrad -length 0.2 -strength [expr 1.090662784*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_1ST_1" -length 0.5 
Girder
Quadrupole -name "Q_DOUBLET_1ST_2" -synrad $quad_synrad -length 0.2 -strength [expr -0.8868183801*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_TO_DOUBLET" -length 5 
Girder
Quadrupole -name "Q_DOUBLET_2ND_1" -synrad $quad_synrad -length 0.2 -strength [expr 0.4341576288*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_2ND_1" -length 0.5 
Girder
Quadrupole -name "Q_DOUBLET_2ND_2" -synrad $quad_synrad -length 0.2 -strength [expr -0.1514424723*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_TO_DOGLEG" -length 0.5 
Girder
Drift -name "D_KICKER" -length 0.2 
Girder
Drift -name "D_KICKER_TO_CHICANE" -length 4.7 
Girder
Sbend -name "S_CHICANE_1" -synrad $sbend_synrad -length 1.2 -angle -0.5235987756 -E1 0 -E2 -0.5235987756 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.5235987756*-0.5235987756/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_1" -length 1.732050808 
Girder
Sbend -name "S_CHICANE_2" -synrad $sbend_synrad -length 1.2 -angle 0.5235987756 -E1 0.5235987756 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.5235987756*0.5235987756/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "M_COLLIMATOR" -length 0 
source collimator.tcl
Girder
Drift -name "D_CHICANE_2" -length 1.5 
Girder
Sbend -name "S_CHICANE_3" -synrad $sbend_synrad -length 1.2 -angle 0.5235987756 -E1 0 -E2 0.5235987756 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.5235987756*0.5235987756/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_3" -length 1.732050808 
Girder
Sbend -name "S_CHICANE_4" -synrad $sbend_synrad -length 1.2 -angle -0.5235987756 -E1 -0.5235987756 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.5235987756*-0.5235987756/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_TO_TRIPLET_4TH" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_4TH_1" -synrad $quad_synrad -length 0.2 -strength [expr 1.065507478*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_4TH_2" -synrad $quad_synrad -length 0.2 -strength [expr -1.581845884*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_4TH_3" -synrad $quad_synrad -length 0.2 -strength [expr 0.6208382187*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_TO_TARGET" -length 2 
Girder
Drift -name "PRAE_PRORAD$END" -length 0 
