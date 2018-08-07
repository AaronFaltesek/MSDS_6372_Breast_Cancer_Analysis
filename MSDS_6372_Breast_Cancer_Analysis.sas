data breast_cancer_dataset;
set wdata.breast_cancer;
run;

data breast_cancer_dataset_2;
set breast_cancer_dataset;
if cmiss(of _all_) then delete;
if F='?' then delete;
run;

proc means data=breast_cancer_dataset_2;
run;

proc means data=breast_cancer_dataset_2;
class F;
var Outcome;
run;

proc reg data=breast_cancer_dataset_2 PLOTS=ALL PLOTS;
model Outcome= A 'B'n C D E G H 'I'n /clb VIF;
title 'Regression of (Outcome)';
run;




