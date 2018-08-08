data breast_cancer_dataset;
set wdata.breast_cancer;
run;

proc means data=breast_cancer_dataset;
run;

data breast_cancer_dataset_2;
set breast_cancer_dataset;
if cmiss(of _all_) then delete;
if F='?' then delete;
run;

proc means data=breast_cancer_dataset_2;
run;

proc means data=breast_cancer_dataset_2;
class clump_thick;
var Outcome;
run;

proc reg data=breast_cancer_dataset_2 PLOTS=ALL PLOTS;
model Outcome= clump_thick unif_cellsize unit_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis /clb VIF;
title 'Regression of (Outcome)';
run;

/* 12.8 */
proc logistic data=breast_cancer_dataset_2 DESCENDING;
model Outcome= clump_thick unif_cellsize unit_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit;
run;


