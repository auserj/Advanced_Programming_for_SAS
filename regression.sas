Title "Regression on CDC Data";

/****************************************************************/
/* - Importing the Data                           				*/
/* - Connect to Access through DDE                            	*/
/****************************************************************/
options noxsync noxwait;
X '"E:\CDC.accdb"';
	Filename BMI2
	dde 'Msaccess|E:\CDC.accdb;Query BMI_Query!all';

data BMI2_DS;
	Infile BMI2 missover firstobs=2;
	Input SEQN Gender Age Weight2 BMI day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken;
run;

filename cmds dde 'Msaccess|system';
data _null_;
	file cmds; put '[Close]'; put '[CloseDatabase]'; put '[Quit]';
run;


PROC IMPORT OUT= WORK.BMI2_DS
DATATABLE= "BMI_Query"
	DBMS=ACCESSCS REPLACE;
	DATABASE="C:\Users\abc\CDC.accdb";
	SCANMEMO=YES;
	USEDATE=NO;
	SCANTIME=YES;
run;

proc corr data=BMI2_DS ;
	var SEQN Gender Age Weight2 BMI day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken;
run;

ods graphics on;
proc corr data=BMI2_DS (obs=200) nomiss
	plots=matrix(histogram);
	 var BMI Age Weight2 Saturated_fatty_acids Calcium_mg;
run;
proc corr data=BMI2_DS (obs=200) nomiss
	plots=matrix(histogram);
	var BMI SEQN Gender day_of_week
	Dietary_Supplements_Taken Antacids_Taken ;
run;
ods graphics off;

data bmi2_ds1;
	set bmi2_ds; 
	Age_group = int(age/10);
run;
proc sort data=bmi2_ds1; 
	by age_group;
run;
Title "Distribution of BMI by Age Group";
proc boxplot data=bmi2_DS1 ;
	plot BMI*age_group;
	inset min mean max stddev /
		header = 'Overall Statistics'
		pos    = tm /* place this box below the Inset one*/;
	insetgroup  max min/header = 'Extreme values by Code';
run;

/****************************************************************/
/* Run a Regression_Bearing in mind the Correlations      */
/****************************************************************/
proc reg data=BMI2_DS ;
	Model BMI = SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken;
	plot residual. * predicted. BMI * predicted.;
run;

proc reg data=BMI2_DS (obs=400);
	Model BMI = SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken;
	plot residual. * predicted. BMI * predicted.;
run;

/****************************************************************/
/* Correcting for large samples Stepwise              */
/****************************************************************/
ods graphics off;
proc reg data=BMI2_DS ;
	Model BMI = SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken 
		/ selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
		plot BMI*p.;
run;

ods graphics on; 
proc reg data=BMI2_DS (obs=400);
	Model Dietary_Supplements_Taken = /* DELETE ME */
		SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		Antacids_Taken /selection=stepwise
			SLENTRY=.05 SLSTAY=.10 stb;
run;

/****************************************************************/
/* Test Skewness and Kurtosis                        */
/****************************************************************/
Title "Test Skewness and Kurtosis";
proc means Data=BMI2_DS n min max mean var skewness kurtosis;
	var   BMI SEQN Gender Age Weight2 day_of_week
	Saturated_fatty_acids Calcium_mg
	Dietary_Supplements_Taken Antacids_Taken;
run;

/****************************************************************/
/* Correct for Skewness                              */
/****************************************************************/
Data BMI2a_DS; set BMI2_DS;
	Ln_Dietary_Supplements_Taken = Dietary_Supplements_Taken;
	if Dietary_Supplements_Taken > 0 then
		Ln_Dietary_Supplements_Taken = log(Dietary_Supplements_Taken);
	LN_Antacids_Taken = Antacids_Taken;
	if Antacids_Taken > 0 then
		LN_Antacids_Taken = log(Antacids_Taken);
run;
Title "Correcting for Skewness";
proc means Data=BMI2a_DS n min max mean var skewness kurtosis;
	var   BMI SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		Dietary_Supplements_Taken Antacids_Taken
		Ln_Dietary_Supplements_Taken
		LN_Antacids_Taken;
run;

/****************************************************************/
/* Run Regression                                */
/****************************************************************/
ods graphics off;
proc reg data=BMI2a_DS ;
	Model BMI = SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		ln_Dietary_Supplements_Taken ln_Antacids_Taken
			/ selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
run;


proc corr data=BMI2a_DS ;
	var BMI Dietary_Supplements_Taken
		ln_Dietary_Supplements_Taken
		Antacids_Taken
		ln_Antacids_Taken;
run;
ods graphics on;
proc reg data=BMI2a_DS ;
	Model BMI = SEQN Gender Age Weight2 day_of_week
		Saturated_fatty_acids Calcium_mg
		ln_Dietary_Supplements_Taken ln_Antacids_Taken
			/ selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
run;

/****************************************************************/
/* taking the SQRT reduces skewness */
/****************************************************************/
Data BMI2b_DS; set BMI2_DS;
	SQRT_Dietary_Supplements_Taken = Dietary_Supplements_Taken;
	if Dietary_Supplements_Taken > 0 then
		SQRT_Dietary_Supplements_Taken = SQRT(Dietary_Supplements_Taken);
	SQRT_Antacids_Taken = Antacids_Taken;
	if Antacids_Taken > 0 then
		SQRT_Antacids_Taken = SQRT(Antacids_Taken);
run;
proc means Data=BMI2b_DS n min max mean var skewness kurtosis;
	var   Dietary_Supplements_Taken Antacids_Taken
		SQRT_Dietary_Supplements_Taken
		SQRT_Antacids_Taken ;
run;

/****************************************************************/
/* Running Regressions.                                            */
/****************************************************************/
Title "More Regressions";
ods graphics on;
proc reg data=BMI2a_DS (obs=200);
	Model Weight2 = SEQN Gender Age day_of_week
		Saturated_fatty_acids Calcium_mg
		ln_Dietary_Supplements_Taken ln_Antacids_Taken
		/ stb selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
run;

/****************************************************************/
/*    More Regressions.                                 */
/****************************************************************/
proc reg data=BMI2a_DS (obs=200);
	Model Calcium_mg = Weight2 SEQN Gender Age day_of_week
		Saturated_fatty_acids
		ln_Dietary_Supplements_Taken ln_Antacids_Taken
		/ stb selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
run;

/****************************************************************/
/*  More Regressions.   */
/****************************************************************/
proc reg data=BMI2a_DS ;
	Model ln_Antacids_Taken = Calcium_mg Weight2 SEQN Gender
		Age day_of_week Saturated_fatty_acids
		ln_Dietary_Supplements_Taken
		/ stb selection=stepwise SLENTRY=.05 SLSTAY=.10 ;
run;

/****************************************************************/
/* Mediation Check                     */
/****************************************************************/
Data Tasty; /* Reminder on reading csv files*/
	infile "E:\Tasty.csv" delimiter=',' firstobs=2;
	input Tasty Sugar Salt Spice Amount_Eaten Social Hunger Age Adult;
run;
Title "Mediation Checks";
ods graphics off;
proc reg data=Tasty (obs=400);
	Model Amount_eaten = Tasty Sugar Salt Spice / stb;
run;

proc corr data=Tasty(obs=400);
	var Amount_eaten Tasty Sugar Salt Spice;
run;

proc reg data=Tasty (obs=400);
	Model Amount_eaten = Tasty Sugar Salt Spice
	/ selection=stepwise SLENTRY=.05 SLSTAY=.10 stb;
run;
proc reg data=Tasty (obs=400);
	Model Amount_eaten = Sugar Salt Spice
	/ selection=stepwise SLENTRY=.05 SLSTAY=.10 stb;
run;
proc reg data=Tasty (obs=400);
	Model Tasty = Sugar Salt Spice
	/ selection=stepwise SLENTRY=.05 SLSTAY=.10 stb;
run;

/****************************************************************/
/*    Check if this applies to children too                     */
/****************************************************************/
ods graphics on;
proc reg data=Tasty (obs=400);
	Where Age <=13;
	Model Amount_eaten = Tasty Sugar Salt Spice Social Hunger
	/ selection=stepwise
	SLENTRY=.05 SLSTAY=.10 stb;
run;
proc reg data=Tasty (obs=400);
	Where Age >13;
	Model Amount_eaten = Tasty Sugar Salt Spice Social Hunger
	/ selection=stepwise
	SLENTRY=.05 SLSTAY=.10 stb;
run;
proc reg data=Tasty (obs=400);
	Model Amount_eaten = Tasty Sugar Salt Spice Social Hunger
	/ selection=stepwise
	SLENTRY=.05 SLSTAY=.10 stb;
run;

/****************************************************************/
/*  Moderation   */
/****************************************************************/
ods graphics on;
Title "Testing Moderation";
Proc Sort data=tasty; by adult;
run;
proc reg data=Tasty (obs=400); by adult;
	Model Tasty = Sugar Salt Spice Social Hunger
/ stb;
run;

/****************************************************************/
/*Testing by Adding Interaction Terms              */
/****************************************************************/
data Tasty2; set Tasty;
	Hunger_by_Adult = Hunger * Adult;
run;
Title "Add a second block with interaction terms";
proc reg data=Tasty2 (obs=400);
	Model Tasty = {Sugar Salt Spice Social Hunger}
	{Hunger_by_Adult }
	/ selection=stepwise
	groupnames = 'Main Effects' 'Interaction Effects';
run;
