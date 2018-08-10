data breast_cancer_dataset;
set wdata.breast_cancer;
run;

proc means data=breast_cancer_dataset;
run;

data breast_cancer_dataset_2;
set breast_cancer_dataset;
if cmiss(of _all_) then delete;
if bare_nuclei='?' then delete;
if outcome=2 then new_outcome=0;
if outcome=4 then new_outcome=1;
run;

/* EDA Starts */
proc means data=breast_cancer_dataset_2;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome clump_thick unif_cellsize unit_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis / Diagonal=(Histogram);
run;

proc means data=breast_cancer_dataset_2;
class clump_thick;
var new_outcome;
run;

proc means data=breast_cancer_dataset_2;
class bare_nuclei;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome bare_nuclei ;
run;

proc means data=breast_cancer_dataset_2;
class clump_thick;
var new_outcome;
run;

proc means data=breast_cancer_dataset_2;
class bland_chro;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome bland_chro ;
run;

proc means data=breast_cancer_dataset_2;
class normal_nucleoli;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome normal_nucleoli ;
run;

proc means data=breast_cancer_dataset_2;
class mitosis;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome mitosis ;
run;

proc reg data=breast_cancer_dataset_2 PLOTS=ALL PLOTS;
model new_outcome= clump_thick unif_cellsize unit_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis /clb VIF;
title 'Regression of (Outcome)';
run;


/* EDA Ends */

/* 12.8 */
proc logistic data=breast_cancer_dataset_2 DESCENDING;
model new_outcome= clump_thick unif_cellsize unit_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit;
run;

