/*data breast_cancer_dataset;
set wdata.breast_cancer;
run;
*/
FILENAME REFFILE '/home/ldajani0/Stats2_proj2/BreastCancer.csv';

PROC IMPORT DATAFILE=REFFILE
    DBMS=CSV 
    OUT=work.breast_cancer_dataset
    REPLACE;
    GETNAMES=YES;
RUN;

proc means data=breast_cancer_dataset;
run;

data breast_cancer_dataset_2;
set breast_cancer_dataset;
if cmiss(of _all_) then delete;
if bare_nuclei='?' then delete;
if outcome=2 then new_outcome=0;
if outcome=4 then new_outcome=1;
run;

/* Correlation */
PROC CORR DATA = breast_cancer_dataset_2;
RUN;

/* EDA Starts */
proc means data=breast_cancer_dataset_2;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis / Diagonal=(Histogram);
run;

/* new_outcome vs clump_thick */
proc means data=breast_cancer_dataset_2;
class clump_thick;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome clump_thick / Diagonal=(Histogram);
run;

/* new_outcome vs bare_nuclei */
proc means data=breast_cancer_dataset_2;
class bare_nuclei;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome bare_nuclei / Diagonal=(Histogram);
run;

/* new_outcome vs bland_chro */
proc means data=breast_cancer_dataset_2;
class bland_chro;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome bland_chro / Diagonal=(Histogram);
run;

/* new_outcome vs normal_nucleoli */
proc means data=breast_cancer_dataset_2;
class normal_nucleoli;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome normal_nucleoli / Diagonal=(Histogram);
run;

/* new_outcome vs mitosis */
proc means data=breast_cancer_dataset_2;
class mitosis;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome mitosis / Diagonal=(Histogram);
run;

/* new_outcome vs epi_cell_size */
proc means data=breast_cancer_dataset_2;
class epi_cell_size;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome epi_cell_size / Diagonal=(Histogram);
run;

/* new_outcome vs unif_cellshape */
proc means data=breast_cancer_dataset_2;
class unif_cellshape;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome unif_cellshape / Diagonal=(Histogram);
run;

/* new_outcome vs unif_cellsize */
proc means data=breast_cancer_dataset_2;
class unif_cellsize;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome unif_cellsize / Diagonal=(Histogram);
run;

/* new_outcome vs marg_adhes */
proc means data=breast_cancer_dataset_2;
class marg_adhes;
var new_outcome;
run;

proc sgscatter data = breast_cancer_dataset_2 ;
title "Scatterplot Matrix of Breast Cancer Variables";
matrix new_outcome marg_adhes / Diagonal=(Histogram);
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

