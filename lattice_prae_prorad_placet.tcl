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
Drift -name "D_LINAC_TO_TRIPLET" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_1ST_1" -synrad $quad_synrad -length 0.15 -strength [expr -0.7419503038*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_1ST_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_1ST_2" -synrad $quad_synrad -length 0.15 -strength [expr 1.186087308*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_1ST_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_1ST_3" -synrad $quad_synrad -length 0.15 -strength [expr -0.4186500257*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_2ND_TO_CHICANE" -length 1 
Girder
# WARNING: putting a Sbend instead of a Rbend. Arc's length is : angle * L / sin(angle/2) / 2
# WARNING: original length was 1.213818192
Sbend -name "S_CHICANE_1" -synrad $sbend_synrad -six_dim  1 -length 1.213818192 -angle 0.52359877 -E1 0.52359877 -E2 0.52359877 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.52359877*0.52359877/1.213818192*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_1" -length 3 
Girder
# WARNING: putting a Sbend instead of a Rbend. Arc's length is : angle * L / sin(angle/2) / 2
# WARNING: original length was 1.213818192
Sbend -name "S_CHICANE_2" -synrad $sbend_synrad -six_dim  1 -length 1.213818192 -angle -0.52359877 -E1 0 -E2 0 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.52359877*-0.52359877/1.213818192*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "M_COLLIMATOR" -length 0 
source collimator.tcl
Girder
Drift -name "D_CHICANE_2" -length 1.5 
Girder
# WARNING: putting a Sbend instead of a Rbend. Arc's length is : angle * L / sin(angle/2) / 2
# WARNING: original length was 1.213818192
Sbend -name "S_CHICANE_3" -synrad $sbend_synrad -six_dim  1 -length 1.213818192 -angle -0.52359877 -E1 0 -E2 0 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-0.52359877*-0.52359877/1.213818192*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_3" -length 3 
Girder
# WARNING: putting a Sbend instead of a Rbend. Arc's length is : angle * L / sin(angle/2) / 2
# WARNING: original length was 1.213818192
Sbend -name "S_CHICANE_4" -synrad $sbend_synrad -six_dim  1 -length 1.213818192 -angle 0.52359877 -E1 0.52359877 -E2 0.52359877 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*0.52359877*0.52359877/1.213818192*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_TO_TRIPLET_3RD" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_3RD_1" -synrad $quad_synrad -length 0.15 -strength [expr 1.032565124*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_2" -synrad $quad_synrad -length 0.15 -strength [expr -0.732567419*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_3RD_3" -synrad $quad_synrad -length 0.15 -strength [expr -0.3362140653*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_3RD_TO_TARGET" -length 2.5 
Girder
Drift -name "PRAE_PRORAD$END" -length 0 
