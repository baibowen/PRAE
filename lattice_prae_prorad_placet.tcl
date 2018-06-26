set e0 0.07
set e_initial $e0

set START "START"
set END "END"

set sbend_synrad 0
set quad_synrad 0
set mult_synrad 0

set match(beta_x) 35
set match(beta_y) 35
set match(alpha_x) -4.24
set match(alpha_y) -4.34

SetReferenceEnergy $e0
Girder
Drift -name "PRAE_PRORAD$START" -length 0 
Girder
Drift -name "D_LINAC_TO_TRIPLET" -length 2 
Girder
Quadrupole -name "Q_TRIPLET_1ST_1" -synrad $quad_synrad -length 0.15 -strength [expr -0.8679792866*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_1ST_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_1ST_2" -synrad $quad_synrad -length 0.15 -strength [expr 1.269276172*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_1ST_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_1ST_3" -synrad $quad_synrad -length 0.15 -strength [expr -0.3796461272*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_TO_DOGLEG" -length 6.2 
Girder
Sbend -name "S_KIKER" -synrad $sbend_synrad -length 0.2 -angle -0.52359877 -E1 0 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.52359877*-0.52359877/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_KIKER_TO_TRIPLET_2ND" -length 1.7 
Girder
Quadrupole -name "Q_TRIPLET_2ND_1" -synrad $quad_synrad -length 0.15 -strength [expr 2.384133355*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_2ND_1" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_2ND_2" -synrad $quad_synrad -length 0.15 -strength [expr -1.294587441*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_2ND_2" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_2ND_3" -synrad $quad_synrad -length 0.15 -strength [expr 1.975159661*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_2ND_TO_CHICANE" -length 1.7 
Girder
Sbend -name "S_CHICANE_1" -synrad $sbend_synrad -length 0.2 -angle 0.52359877 -E1 0 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.52359877*0.52359877/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "M_COLLIMATOR" -length 0 
source collimator.tcl
Girder
Drift -name "D_CHICANE_1" -length 1.6 
Girder
Sbend -name "S_CHICANE_2" -synrad $sbend_synrad -length 0.2 -angle -0.52359877 -E1 0 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.52359877*-0.52359877/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_2" -length 0.5 
Girder
Sbend -name "S_CHICANE_3" -synrad $sbend_synrad -length 0.2 -angle -0.75 -E1 0 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.75*-0.75/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_3" -length 1.6 
Girder
Sbend -name "S_CHICANE_4" -synrad $sbend_synrad -length 0.2 -angle 0.75 -E1 0 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.75*0.75/0.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_TO_TRIPLET_3RD" -length 2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_1" -synrad $quad_synrad -length 0.15 -strength [expr 1.871226132*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_2" -synrad $quad_synrad -length 0.15 -strength [expr -1.861374305*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_3" -synrad $quad_synrad -length 0.15 -strength [expr 0.2655731166*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_TO_TARGET" -length 2 
Girder
Drift -name "PRAE_PRORAD$END" -length 0 
