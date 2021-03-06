
data breast_cancer_dataset;
set wdata.breast_cancer;
run;


/* FILENAME REFFILE '/home/ldajani0/Stats2_proj2/BreastCancer.csv'; */
/* PROC IMPORT DATAFILE=REFFILE */
/*     DBMS=CSV */
/*     OUT=work.breast_cancer_dataset */
/*  REPLACE */
/*     ; */
/*     GETNAMES=YES; */
/* RUN; */

proc means data=breast_cancer_dataset;

data breast_cancer_dataset_2;
set breast_cancer_dataset;
if cmiss(of _all_) then delete;
if bare_nuclei='?' then delete;
if outcome=2 then new_outcome=0;
if outcome=4 then new_outcome=1;
run;

data temp;
set breast_cancer_dataset_2;
n=ranuni(8);
proc sort data=temp;
  by n;
  data breast_cancer_training breast_cancer_testing;
   set temp nobs=nobs;
   if _n_<=.7*nobs then output breast_cancer_training;
    else output breast_cancer_testing;
   run;
   
proc export data=breast_cancer_training 
dbms=csv 
outfile='/home/afaltesek0/my_courses/scratchSpace/STATS_6372/Project_2/breast_cancer_training.csv';
run;

proc export data=breast_cancer_testing 
dbms=csv 
outfile='/home/afaltesek0/my_courses/scratchSpace/STATS_6372/Project_2/breast_cancer_testing.csv';
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
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size bare_nuclei bland_chro normal_nucleoli mitosis /clb VIF;
title 'Regression of (Outcome)';
run;

proc freq data=breast_cancer_dataset_2;
tables clump_thick*new_outcome unif_cellsize*new_outcome  unif_cellshape*new_outcome marg_adhes*new_outcome 
epi_cell_size*new_outcome  bare_nuclei*new_outcome bland_chro*new_outcome normal_nucleoli*new_outcome  mitosis*new_outcome / chisq relrisk;
run;quit;


/* EDA Ends */

/* 12.8 */

/* Model 1: Full Simple Model (all variables and no interactions) */
proc logistic data=breast_cancer_training DESCENDING;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit rsquare;
score data=breast_cancer_testing fitstat ;
run;

/* Model 2: Manual Reduced model (obvious non-significant variables extracted from model 1) */
proc logistic data=breast_cancer_training DESCENDING;
model new_outcome= clump_thick unif_cellsize marg_adhes  
bare_nuclei bland_chro / ctable lackfit rsquare;
ROC 'MainEffects' clump_thick unif_cellsize marg_adhes 
bare_nuclei bland_chro ;
score data=breast_cancer_testing fitstat;
run;

/* Model 3a: Stepwise Reduced model */
proc logistic data=breast_cancer_training DESCENDING plots=all;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit rsquare selection=stepwise;
score data=breast_cancer_testing fitstat  out=pred_one ;
run;


proc tabulate data=pred_one;
class new_outcome i_new_outcome;
table new_outcome,i_new_outcome;
run;

/* Model 3b: Stepwise FORWARD model */
proc logistic data=breast_cancer_training DESCENDING;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit rsquare selection=FORWARD;
ROC 'MainEffects' clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis;
score data=breast_cancer_testing fitstat;
run;


/* Model 3c: Stepwise backward model */
proc logistic data=breast_cancer_training DESCENDING;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis / ctable lackfit rsquare selection=backward;
ROC 'MainEffects' clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis;
score data=breast_cancer_testing fitstat ;
run;


/* Objective 2: Complex Logistic Regression */
/* Interactions with stepwise selection */
proc logistic data=breast_cancer_training DESCENDING plots=all;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis unif_cellsize*unif_cellshape unif_cellsize*epi_cell_size bland_chro*normal_nucleoli / ctable lackfit rsquare selection=stepwise;
ROC 'MainEffects' clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis;
score data=breast_cancer_testing fitstat ;
run;

/* Objective 2: Complex Logistic Regression */
/* Interactions without selection (force inclusion of all variables) */
proc logistic data=breast_cancer_training DESCENDING plots=all;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis 
unif_cellsize*unif_cellshape unif_cellsize*epi_cell_size bland_chro*normal_nucleoli / ctable lackfit rsquare;
run;





/* Objective 2: Complex Logistic Regression */
/* log(mitosis) added */

data breast_cancer_dataset_complex;
set breast_cancer_training;
log_mitosis=log(mitosis);
run;

data breast_cancer_complex_test;
set breast_cancer_testing;
log_mitosis=log(mitosis);
run;

proc logistic data=breast_cancer_dataset_complex DESCENDING plots=all;
model new_outcome= clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli log_mitosis 
unif_cellsize*unif_cellshape unif_cellsize*epi_cell_size bland_chro*normal_nucleoli / ctable lackfit rsquare;
score data=breast_cancer_complex_test fitstat out=pred_two ;
run;

proc tabulate data=pred_two;
class f_new_outcome i_new_outcome;
table f_new_outcome,i_new_outcome;
run;

/* LDA/QDA Tests*/

/* Run Discrim proc */
title 'Run Discrim proc regular dataset';
proc discrim data=breast_cancer_dataset_2 pool=test crossvalidate list;
class new_outcome;
var clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis;
priors "0"=.65 "1"=.35;
run;

/* Run Discrim proc Train/Test */
title 'Run Discrim proc Train/Test';
proc discrim data=breast_cancer_training pool=test testdata=breast_cancer_testing list testlist;
class new_outcome;
var clump_thick unif_cellsize unif_cellshape marg_adhes epi_cell_size 
bare_nuclei bland_chro normal_nucleoli mitosis;
priors "0"=.65 "1"=.35;
run;
