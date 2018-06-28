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
Drift -name "D_LINAC_TO_DOUBLET" -length 1 
Girder
Quadrupole -name "Q_DOUBLET_1ST_1" -synrad $quad_synrad -length 0.2 -strength [expr 1.70181969*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_1ST_1" -length 0.5 
Girder
Quadrupole -name "Q_DOUBLET_1ST_2" -synrad $quad_synrad -length 0.2 -strength [expr -1.143692359*$e0] -e0 $e0 
Girder
Drift -name "D_DOUBLET_TO_DOGLEG" -length 2 
Girder
Drift -name "D_KICKER" -length 0.2 
Girder
Drift -name "D_KICKER_TO_CHICANE" -length 0.2 
Girder
Sbend -name "S_CHICANE_1" -synrad $sbend_synrad -length 1.2 -angle 1.396263402 -E1 0 -E2 1.396263402 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*1.396263402*1.396263402/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_1" -length 2 
Girder
Sbend -name "S_CHICANE_2" -synrad $sbend_synrad -length 1.2 -angle -1.396263402 -E1 -1.396263402 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-1.396263402*-1.396263402/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "M_COLLIMATOR" -length 0 
source collimator.tcl
Girder
Drift -name "D_CHICANE_2" -length 1.5 
Girder
Sbend -name "S_CHICANE_3" -synrad $sbend_synrad -length 1.2 -angle -1.396263402 -E1 0 -E2 -1.396263402 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*-1.396263402*-1.396263402/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_3" -length 2 
Girder
Sbend -name "S_CHICANE_4" -synrad $sbend_synrad -length 1.2 -angle 1.396263402 -E1 1.396263402 -E2 0 -six_dim 1 -e0 $e0 -fintx -1 
set e0 [expr $e0-14.1e-6*1.396263402*1.396263402/1.2*$e0*$e0*$e0*$e0*$sbend_synrad]
SetReferenceEnergy $e0
Girder
Drift -name "D_CHICANE_TO_TRIPLET_4TH" -length 1 
Girder
Quadrupole -name "Q_TRIPLET_4TH_1" -synrad $quad_synrad -length 0.2 -strength [expr -1.152939441*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_1" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_4TH_2" -synrad $quad_synrad -length 0.2 -strength [expr -0.547785762*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_2" -length 0.2 
Girder
Quadrupole -name "Q_TRIPLET_4TH_3" -synrad $quad_synrad -length 0.2 -strength [expr 2.066513816*$e0] -e0 $e0 
Girder
Drift -name "D_TRIPLET_4TH_TO_TARGET" -length 2 
Girder
Drift -name "PRAE_PRORAD$END" -length 0 
