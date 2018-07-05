/* SAS  Subsetting                                                */
/* Author: David Li                                               */

filename W4BMI "C:\abc\BMI.xls";

/* Subsetting    */
/* Reading Excel */
PROC IMPORT
	DATAFILE = W4BMI
	OUT=BMI DBMS=XLS Replace ;
	GETNAMES=YES ; RANGE="Sheet1$A1:G1001"; Sheet="sheet1!";
Run;
proc print data=bmi (obs=20); 
run;

/************************************************************************/
/* Show Freq of Gender and Means of Weight, Height, Exercise and BMI   */
/***********************************************************************/
proc freq data=bmi; 
	tables gender age; 
run;

proc means data=bmi;
	var Height_Inches Weight_pounds Age BMI Exercise_Level; 
run;

/*************************************************************/
/* Subset only the female data                               */
/*************************************************************/
data females_only;
	set bmi;
	where gender="F";
run;

/* Subsetting only some of the columns */
data females_only_no_age_asked;
	set bmi (drop=age);
	where gender="F";
run;

proc contents data=females_only_no_age_asked;
run;

/*************************************************************/
/* Subsetting more than one dataset at a time                */
/*************************************************************/
proc datasets library=work;
	delete  females_only males_only;
run;
data females_only males_only;
	set bmi;
	if gender="F" then output females_only;
	if gender="M" then output males_only;
run;

/*************************************************************/
/* Unifying the Females Only and Males Only Datasets         */
/*************************************************************/
data Reunified;
	Set females_only males_only;
run;

/*************************************************************/
/* Interleaving
	Determine the order in the unified dataset by the value in
	a chosen column. */
/*************************************************************/
Proc SORT data=males_only; 
	by Height_Inches Weight_pounds;
run;
Proc SORT data=females_only; 
	by Height_Inches Weight_pounds;
run;
data unified_by_height;
	Set females_only males_only;
	by Height_Inches Weight_pounds;
run;

/*************************************************************/
/*Interleaving with Summary Data
	Add a column with the z statistic of weight              */
/* stage 1. Create the mean                                  */
/*************************************************************/
proc means data=unified_by_height
	NOPRINT;             
	var Weight_pounds; 
	output out = Mean_of_Weight  
		mean=avg111Weight_pounds  
		stddev = std111Weight_pounds ; 
run;

/* stage 2. Now reading this new dataset */
Data Z_scores; /* create a new dataset named Z-scores*/
	set unified_by_height;  
	if _N_ = 1 then set Mean_of_Weight; 
	z_score = (Weight_pounds - avg111Weight_pounds) /	 
				std111Weight_pounds;
	format z_score 8.4;
run;

/* stage 3. Identify outliers */
Data outliers; set Z_scores;
	if Z_score >= 2.5 or Z_score <= -2.5 then
		output outliers;
run;
Proc print data=outliers; 
run;

/*************************************************************/
/* Merge the z scores into the Males Dataset                 */
/*************************************************************/
Proc SORT data=males_only; 
	by name; 
run;
Proc SORT data=z_scores; 
	by name; 
run;
data Males_with_a_z;
	Merge males_only z_scores;
	by name; 
run;
title "Males with a Z score";
Proc print data=Males_with_a_z; 
run;

/*************************************************************/
/* Create a new dataset with people whose BMI is above 30.
Save in it only their name and BMI.
In another step create another new dataset with people whose
BMI is below 18. Save in it only their name and BMI.
Merge the two datasets interleaving it by name.
Show the mean, std, and 90% confidence intervals.            */
/*************************************************************/
Data BMI_Above_30; set BMI;
	Keep name BMI;
	if BMI > 30 then output BMI_Above_30 ;
run;

Data BMI_Below_18; set BMI;
	Keep name BMI;
	if BMI < 18 then output BMI_Below_18;
run;

Proc SORT data=BMI_Above_30; 
	by name; 
run;

Proc SORT data=BMI_Below_18; 
	by name; 
run;

data BMI_Extreme;
	Merge BMI_Above_30 BMI_Below_18;
	by name;
run;

proc means data=BMI_Extreme n mean stddev clm; 
Run;

/*************************************************************/
/* Updating
If the two merged datasets overlap in the BY variable,
then the results of the second dataset will override
those of the first if the keyword UPDATE is added.           */
/*************************************************************/
Data One;
	Input  ID Name $ age;
	datalines;
1 David 20
2 Mason 22
3 Ethan 24
4 Noah 26
5 William 28
6 Liam 30
7 Jayden 32
8 Michael 34
9 Alexander 36
10 Aiden 38
;

Run;

Proc Print data=One; 
run;

Data ChangeSet;
	Input  ID  Name $ age ;
	datalines;
1 Jacob 120
18 Andrew 77;
run;

Proc Print data=ChangeSet; 
run;

proc sort data=one; 
	by ID; 
run;

proc sort data=ChangeSet; 
	by ID; 
run;

Data Updated_one;
	UPDATE one ChangeSet;
	BY ID;
run;

Title "Updated One";
Proc Print data=Updated_One; 
run;
