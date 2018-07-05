/* Graphing                                                    */
/* Author: David Li                                            */

/***************************************************************/
/* Graphing                                                    */
/***************************************************************/
PROC IMPORT
	DATAFILE = "C:\Users\abc\Online Purchase.xls"	
	OUT=OP	DBMS=XLS	Replace;	
	; GETNAMES=YES	
	; RANGE="Sheet1$A1:J1003"	
	; Sheet="sheet1!"; 
Run;

/****************************************************************/
/*                Introduction                                  */
/****************************************************************/
title "Pie Chart Buyer Gender";
Proc gchart data=OP(obs=900); 
	pie buyer_gender; 
run;
title "Trust Levels by Buyer Gender";
Proc gchart data=OP(obs=100);	
	vbar Trust_in_seller / subgroup=buyer_gender; 
run;
/****************************************************************/
/*                         Goptions                             */
/****************************************************************/
Goptions reset=all ftext="Times New Roman"	Colors=(Blue, Green, Red)	
	htext=2.0 htitle=2.5;
Proc gchart data=OP(obs=100);
	vbar Trust_in_seller / subgroup=buyer_gender; 
run;

Goptions reset=all;
Proc gchart data=OP(obs=100);
	vbar Trust_in_seller / subgroup=buyer_gender; 
run;

/****************************************************************/
/*                     Vertical Bars                            */
/****************************************************************/
Title "VBar and various patterns";
Goptions htext=1.2 hsize=7in vsize=5in;
pattern value=empty; 
Proc gchart data=OP;	
	vbar Trust_in_seller / subgroup=buyer_gender; 
run;
/****************************************************************/
/*               Other Kinds of Charts                          */
/****************************************************************/
Goptions reset=all;
pattern v=s; /* or value=solid;  */

Proc gchart data=OP;
	hbar Trust_in_seller / subgroup=buyer_gender; 
run;

Proc gchart data=OP;
	pie Trust_in_seller / subgroup=buyer_gender; 
run;
Proc gchart data=OP;
	vbar3d Trust_in_seller / subgroup=buyer_gender; 
run;
Proc gchart data=OP;
	hbar3d Trust_in_seller / subgroup=buyer_gender; 
run;
Proc gchart data=OP;
	pie3d Trust_in_seller / subgroup=buyer_gender; 
run;
Proc gchart data=OP;
	donut Trust_in_seller / subgroup=buyer_gender; 
run;
Proc gchart data=OP;
	star Trust_in_seller ; 
run;

/****************************************************************/
/*                    Adjusting Continuous Variables Bars       */
/****************************************************************/
Title "Setting the midpoint etc." ;
pattern v=l2;
pattern v=X3;
pattern v=R1;

Proc gchart data=OP;
	vbar Price / midpoints= 60 to 100 by 5 ; 
run;
Proc gchart data=OP;
	vbar3d Trust_in_seller / midpoints= 6 to 10 by 1
		subgroup=buyer_gender
		shape=hexagon
		coutline=brown
		descending; 
run;

/* Check with other random number functions*/
Title "Uniform Distribution" ;
Data Uni;
	Drop I;
	Do I = 1 to 1000 by 1;
		Rand_number = rand("Uniform") * 10;
		output Uni;
	end;
Run;

Proc gchart data=Uni;
	Vbar Rand_number / midpoints= 0 to 10 by .5; 
run;

/****************************************************************/
/*                 Sums in Bar Charts                           */
/****************************************************************/
Title "Show sum in a Bar Chart";
Data op4; set op;
	Format Gender $char6.;
	if Buyer_gender = 1 then Gender = "Male";
	else Gender ="Female";
Run;
	*Pattern = R1;

axis1 order=("Female" "Male");
Proc gchart data=OP4;
	Vbar gender / Sumvar=Trust_in_seller /* show function on this column*/
	Type=sum  /* what function to run can be also mean */
	maxis=axis1  ;
run;

/****************************************************************/
/*                  Multi Group Charts                          */
/****************************************************************/
Title "Trust in Seller by Age and Gender";
Proc gchart data=OP4;
	Vbar buyer_age / Sumvar=Trust_in_seller  /* show function on this
									column */
	Type=mean  /* what function to run can be also mean */
	group=gender ; 
run;

/****************************************************************/
/*                  And by Subgroup                             */
/****************************************************************/
Title "Trust in Seller by Age and subgroup Gender";
Proc gchart data=OP4;
	Vbar buyer_age /
		Sumvar=Trust_in_seller  /* show function on this column */
		Type=mean  /* what function to run can be also mean */
		subgroup=gender ; 
run;

/****************************************************************/
/*                       Scatter Plots                          */
/****************************************************************/
Title "Scatter Plot of Price by Real Value";
Proc gplot data=OP4;
	plot price * Real_value; 
run;

symbol value="W" Color=Brown; 
Proc gplot data=OP4 (OBS=10); 
	plot price * Real_value; 
run;
symbol value=dot Color=Red;
Proc gplot data=OP4 (OBS=10); 
	plot price * Real_value; 
run;

/* Connecting the dots */
Title h=2.0 "Connecting the dots";
Title2 h=1.5 "200 dots of price by Real_value";
symbol value=dot Color=orange interpol=join width=2;
proc sort data=op4; 
	by price; 
run;
Proc gplot data=OP4 (OBS=20);
	plot Real_value * price;
run;
/* Rounding the Corners */
symbol value=dot Color=cyan interpol=SMS width=2;
proc sort data=op4; 
	by price; 
run;
Proc gplot data=OP4 (OBS=100);
	plot Real_value * price; 
run;

/****************************************************************/
/*  Box Plot   */
/****************************************************************/
Goptions reset=all;
Title "Box Plot Demo ";
Data box_plot_Prep;
	Drop I;
	 	Do Code = 1 to 10 by 1; 
		Do I = 1 to 10 by 1;
			val2 = rand("Uniform") * 10;
			output box_plot_Prep;
		end;
	end;
Run;
Proc boxplot data=box_plot_Prep;
	plot val2*code;
run;

/****************************************************************/
/*  More Complex Box Plots                          */
/****************************************************************/
Proc boxplot data=box_plot_Prep;
	plot val2*code;
	inset min mean max stddev /
		header = 'Overall Statistics'
		pos    = tm /* place this box below the Inset one*/;
		insetgroup min max /
		header = 'Extreme values by Code';
run;

/****************************************************************
 * Many obs. per subject
	****************************************************************/
Title "Transpose";
data Grades;
	Input Name $ @;
	Array grade (9) Assignment_1 - Assignment_9;
	Do I=1 to 9 by 1;
		Input Grade(I) @;
	End;
	Drop i;
	Output grades;
	Datalines;
Gerry 9 10 8 7 10 9 8 10 9
Gladis 8 9 10 8 9 10 8 9 10
Saturnus 7 7 7 8 8 8 9 9 9
Dorotheos 6 7 10 8 9 10 8 8 9
Bonifatius 8 8 8 9 9 8 8 7 9
Caratacos 10 10 10 9 9 9 8 8 9
Ludolf 8 9 10 7 8 9 10 9 10
Hari 9 9 9 8 10 10 9 9 10
Otto 7 9 10 9 7 10 8 9 10
Wiebe 7 8 10 9 8 10 8 9 10
Takis 9 9 10 9 9 10 8 9 10
; run;

proc print data=grades; 
run;

/****************************************************************/
/*            create the mean of each assignment                */
/****************************************************************/

proc means data=grades; 
run;

/****************************************************************/
/*        Transpose the datset and check the results
	          Only the numeric data was transposed.             */
/****************************************************************/
Title "Transpose the datset";
proc transpose data=grades out=Grades_transposed; 
run;
proc print data=Grades;
run;
proc print data=Grades_transposed; 
run;

/****************************************************************/
/*            Run A Boxplot on transposed data                  */
/****************************************************************/
Title "Run A Boxplot on transposed data";
proc sort data=grades ; 
	by name ;
run;
proc transpose data=grades out=Grades_transposed; 
	by name; 
run;
Proc boxplot data=grades_transposed;
	Label Col1 = "Assignments Grades";
	plot Col1*Name; 
run;

/****************************************************************/
/*            Transpose also Character Columns                  */
/****************************************************************/

Title "Transpose also Character Columns";
proc sort data=grades ; 
	by name ;
run;

proc transpose data=grades out=Grades_transposed
	prefix=grade_;  /* set prefix of columns*/
	var name Assignment_1-Assignment_9;
run;
proc print data=Grades_transposed; 
run;

/****************************************************************/
/*            Referencing Values in the Previous Row            */
/****************************************************************/
Title "Reminder Lag";
proc sort data=grades; 
	by name;
run;
data GT_lag ; 
	set grades;
	if not first.name then
	do;
		Put Name;
		keep Assignment_1-Assignment_2 Col1-Col2;
		Col1 = (Assignment_1+Assignment_2)/2;
		Col2 = lag(col1);
	end;
run;
proc print data=GT_lag; 
run;

/****************************************************************/
/*               Missing Keeps                              */
/****************************************************************/
Title "Missing Keeps";
proc sort data=GT_lag; 
	by name;
run;
data GT_delta ; 
	set GT_Lag;
/* create missing values in even numbered rows*/
	if _N_ in (2,4,6,8) then Col2=.;
	if Not missing (col2) then Delta = Col2 - Col1;
	Keep Name Col1 Col2 Delta;
	output;

proc print data=GT_delta; 
run;

/******************************************************************/
/* Extra 3D graphs   */
/******************************************************************/
goptions reset=all border cback=white htitle=12pt;
/* Create the data set HAT */
data hat;
	do x=-5 to 5 by 0.25;
		do y=-5 to 5 by 0.25;
			z=sin(sqrt(x*x+y*y));
			output;
		end;
	end;
run;
/* Define a title for the graph */
Title 'G3D Graphs';
Title1 'Surface Plot of HAT Data Set';
/* Create the plot */
proc g3d data=hat;
	plot y*x=z / grid
		rotate=45
		yticknum=5 zticknum=5
		zmin=-3
		zmax=1; 
run;

/****************************************************************/
/*                 Buyer Behavior in Online Markets             */
/****************************************************************/
Title "Buyer Behavior in Online Markets";
data ISR;
	do Risk = 40 to 100 by 1;
		Do Institution = 3 to 10 by 1 ;
			Buy = 100 -.9*Risk/10 -.5*Institution - 
				1.2 * Institution**(-2)*Risk;
			output;
		end;

	end; 
run;
	
proc g3d data=ISR;
	plot Institution*Risk=Buy
		/ grid rotate=30; 
run ;
proc g3d data=ISR (Obs=100);
	scatter Institution*Risk=Buy; 
run;
