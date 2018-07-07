/* Correlation and Linear Regression                            */
/* Author: David Li                                             */

/****************************************************************/
/*   Correlation and Linear Regression	 		        */
/****************************************************************/
proc IMPORT
	DATAFILE = "C:\...\Online Purchase9.xls"
	OUT=OP DBMS=XLS
	Replace; 
	GETNAMES=YES ; 
	RANGE="Sheet1$A1:M1003"; 
	Sheet="sheet1!";
run;
PROC IMPORT
	DATAFILE = "C:\Users\abc\Online Purchase9.xls"	
	OUT=OP	DBMS=XLS	Replace;	
	; GETNAMES=YES	
	; RANGE="Sheet1$A1:M1003"	
	; Sheet="sheet1!"; 
Run;

/****************************************************************/
/*  Correlation                        			        */
/****************************************************************/
title "Pearson's correlation coefficient";
proc Corr data=op;
run;

/****************************************************************/
/*  check the .98 rho between Real_value and Price          	*/
/****************************************************************/
title "Show Relationship between Real Value and Price";
proc gplot data=OP;
	plot price * Real_value;
run;

/****************************************************************/
/*  Other lesser rhos                          	            	*/
/****************************************************************/
title "Lesser Rhos at -.05";
proc gplot data=OP(obs=100);
	plot Perceived_risk * buyer_age;
run;

/****************************************************************/
/*  A look ahead at Rho and R Square                  	        */
/****************************************************************/
proc Corr data=op; 
	var Trust_in_the_community Buyer_age;
run;
proc reg data=op; 
	model Trust_in_the_community = Buyer_age;
run;

/****************************************************************/
/*  More Proc Corr parameters. Keep the output         	        */
/****************************************************************/
proc Corr data=op outp=P ;
	var Trust_in_the_community Buyer_age;
run;

/****************************************************************/
/*  Run other kinds of correlations                    	        */
/****************************************************************/
proc Corr data=op KENDALL SPEARMAN;
	var Trust_in_the_community Buyer_age;
run;
	
/****************************************************************/
/*  Produce a Reliability coefficient           	        */
/****************************************************************/
title "Reliability coefficient Alpha";
data op1; set op;
	price1 = (price + log2(real_value))/2;
run;
proc corr data=op1 nomiss alpha;
	var Price Price1 Real_value ;
run;

/****************************************************************/
/*  Adding graphics                             	        */
/****************************************************************/
title "Corr and Graphics";
ods graphics on;
proc corr data=op1 (obs=100) nomiss
	plots=matrix(histogram);
	var Price Price1 Real_value;
run;
ods graphics off;

/* 1. Create Query in Access  */
/* 2. Proc Import the table */

PROC IMPORT OUT= WORK.minitenders 
            DATATABLE= "Unit_9_MiniTenders" 
            DBMS=ACCESSCS REPLACE;
     DATABASE="C:\Users\abc\Online Markets.accdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

/* 3. Run correlation */
proc corr data=minitenders ;
	var AmountInChosenBid MaxBid;
run;

/****************************************************************/
/*  Linear Regression   					*/
/****************************************************************/
proc IMPORT
	DATAFILE = "C:\...\Online Purchase.xls"
	OUT=OP9 DBMS=XLS Replace; GETNAMES=YES ; RANGE="Sheet1$A1:M1003"
	; Sheet="sheet1!";
run;
data op9; set op; run;
title "Run Regression on Database";
proc reg data=op9;
	model Percieved_Value = Perceived_Risk ;
run;
	
proc corr data=op9;
	var Percieved_Value Perceived_Risk;
run;

/****************************************************************/
/*   Plot the data to search for problems         	        */
/****************************************************************/
title "Plot the data to search for problems";
proc reg data=op9;
	model Percieved_Value =  Perceived_Risk ;
	plot Percieved_Value * Perceived_Risk ;
run;

/****************************************************************/
/*  Add A 95% Prediction Interval                 	        */
/****************************************************************/
title "Add A 95% Prediction Interval";
proc reg data=op9;
	model Percieved_Value =  Perceived_Risk ;
	plot Percieved_Value * Perceived_Risk / pred;
run;

/****************************************************************/
/*   Plot the residuals                                     	*/
/****************************************************************/
title "Plot the residuals";
proc reg data=op9;
	model Percieved_Value =  Perceived_Risk ;
	plot residual. * predicted.;
run;

/****************************************************************/
/*   multiple regression                               	        */
/****************************************************************/
title "multiple regression";
proc reg data=op9;
	model Percieved_Value =  Perceived_Risk
	AVG_Ratings_of_seller 
        Buyer_Gender;
run;

/****************************************************************/
/*   standardized betas                                     	*/
/****************************************************************/
title "Standardized Betas";
proc reg data=op9;
	model Percieved_Value =  Perceived_Risk
	AVG_Ratings_of_seller Buyer_Gender/ stb;
run;

/****************************************************************/
/*  Adding Diagnostics                                      	*/
/****************************************************************/
title "Adding Diagnostics";
proc reg data=op9;
	model Percieved_Value = Perceived_Risk AVG_Ratings_of_seller
		                Buyer_Gender;
	plot residual. * predicted.;
run;
	
/****************************************************************/
/* Stepwise   						        */
/****************************************************************/
ods graphics on;
title "show Stepwise Linear Regression ";
proc reg data=op9;
	model Percieved_Value =  
		Perceived_Risk Percieved_Utility
		AVG_Ratings_of_seller 
		Buyer_Gender / selection = stepwise
		SLENTRY=.05 SLSTAY=.10;
run;
ods graphics off;
	
/****************************************************************/
/*  Identifying influential residuals                       	*/
/****************************************************************/
title "Identifying influential residuals";
proc means data=op9; var Percieved_Value;
run;
ods graphics on;
data op91; set op9;
	if _N_ = 90 then Percieved_Value = 99;
run;
proc means data=op91; var Percieved_Value;
run;
proc reg data=op91;
	model Percieved_Value =  Perceived_Risk Percieved_Utility;
	plot residual. * predicted.;
run;

/****************************************************************/
/*  Identifying the outlier                                  	*/
/****************************************************************/
title "Identifying the outlier";
proc reg data=op91;
	model Percieved_Value =  Perceived_Risk Percieved_Utility;
	output out=op91R          /* Saving the results as a dataset            */
		p=yhat            /* p is the same as PREDICTED - var in dataset*/
		r=yresid ;        /*r is the same as RESIDUAL                   */ 
run;
proc print data=op91r (firstobs=85 obs=95);
	var Percieved_Value Perceived_Risk Percieved_Utility yhat yresid;
run;

/****************************************************************/
/* Alternatively, identify standardized residuals 	        */
/****************************************************************/
proc reg data=op91;
	model Percieved_Value =  Perceived_Risk Percieved_Utility;
		output out=op91Z
		p=zhat      /* p is the same as PREDICTED */
		r=zresid ;  /*r is the same as RESIDUAL   */
proc sort data=op91z; 
	by descending zresid;
run;
proc print data=op91Z (obs=5) ;
	where zresid > 3 or zresid < -3;
	var Percieved_Value Perceived_Risk Percieved_Utility zhat zresid;
run;
