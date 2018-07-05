/* SAS-SQL-Access                                                 */
/* Author: David Li                                               */

/* Read Excel through DDE and run SQL on it                       */
/******************************************************************/
Title "data read directly from Excel";
/* http://support.sas.com/documentation/cdl/en/hostwin/63285/HTML/default/viewer.htm#ddeexamples.htm */

options noxsync noxwait;
X '"C:\Users\Desktop\Lightsabers Sold.xlsx"';
filename ls2
DDE 'Excel|C:\Users\Desktop\[Lightsabers Sold.xlsx]sheet1!R2C1:R300C4';
data xls2;
	Infile ls2 notab dlm='09'x dsd missover;
	Input Year Price Sold Color;
run;

proc print data=xls2; run;
	Proc SQL;
	Create Table p3 as select year, price from xls2 where year between 120 and 150;
quit;

proc print data=p3; 
run;

/* These PUT statements are  executing Excel macro commands */

filename cmds dde 'excel|system';
data _null_;
	file cmds;
		put '[SAVE()]';
		put '[QUIT()]';
run;
	
/******************************************************************/
/* Read the [Lightsabers Sold].xlsx into SAS limiting the
rows with SQL to only those with Price between 3000 and 3600.
Show the Mean and Std. of Sold and draw a Gplot Sold by Price.
Limit the rows with SQL to only those with Price between 3000
and 3100*/
/******************************************************************/
options noxsync noxwait;
X '"C:\Users\Desktop\Lightsabers Sold.xlsx"';
filename ls2
DDE 'Excel|C:\Users\Desktop\[Lightsabers Sold.xlsx]sheet1!R2C1:R300C4';

data Analyze;
	Infile ls2 notab dlm='09'x dsd missover;
	Input Year Price Sold Color;   
run;

Proc SQL;
	Create Table Pricy as
		select year, price, sold from Analyze where Price between 3000 and 3600; 
quit;

/* Show the Mean and Std. of Sold */
proc means data=Pricy Mean std maxdec=2; 
run;
	
/* Draw a Gplot Year by Sold */
proc gplot data=Pricy; 
	plot sold*Price; 
run;
filename cmds dde 'excel|system';

data _null_;
	file cmds;
		put '[SAVE()]';
		put '[QUIT()]';
run;
	 
/******************************************************************/
/*        Read Access Table                                       */
/******************************************************************/
Title "data read directly from Access";
options noxsync noxwait;
X '"C:\Users\abc\Online Markets.accdb"';
Filename Person9 dde 'Msaccess|C:\Users\abc\Online Markets.accdb;Table Person!all';

data test91;
	infile Person9 missover firstobs=2;
	Input PersonID SellerSignIn mmddyy10. BuyerSignIn mmddyy10. CountryName & $20. 
		City & $20. Gender $6. CountRating AverageRating;
Run;

Proc SQL;
	Create Table persons as select * from test91 where PersonID <= 1000;
quit;

proc print data=persons;
run;

filename cmds dde 'Msaccess|system';
data _null_;
	file cmds;
		put '[Close]';
		put '[CloseDatabase]';
		put '[Quit]';
run;
	
/******************************************************************/
/*  Read Access Query                                             */
/******************************************************************/
Title "data read directly from Access Query";
options noxsync noxwait;
X '"C:\Users\abc\Online Markets.accdb"';
Filename Naaf dde 'Msaccess|C:\Users\abc\Online Markets.accdb;Query Unit6Slide63!all';

data NationAve;
	infile Naaf missover firstobs=2;
	Input AvgOfScore  Country $;
Run;
proc print data=NationAve;
run;

Proc SQL;
	create table above70 as 
		select NationAve.AvgOfScore, NationAve.Country
		from NationAve
		where NationAve.AvgOfScore > 70;
quit;
proc print data=Above70;
run;
filename cmds dde 'Msaccess|system';
data _null_;
	file cmds;
		put '[Close]';
		put '[CloseDatabase]';
		put '[Quit]';
run;
	
/******************************************************************/
/*        Join Access tables in SAS                               */
/******************************************************************/
Title "data read directly from Access and join in SAS";
options noxsync noxwait;
X '"C:\Users\abc\Online Markets.accdb"';
Filename Persons dde 'Msaccess|C:\Users\abc\Online Markets.accdb;Table Person!all';
Filename Exams dde 'Msaccess|C:\Users\abc\Online Markets.accdb;Table ExamsTaken!all';

data Persons_taking_Exams;
	infile Persons missover firstobs=2;
	length sellerDate $20.;
	Input PersonID SellerDate $ BuyerDate $ Country $ ;
Run;
proc print data= Persons_taking_Exams (obs=10);
run;
data Exams_taken;
	infile Exams missover firstobs=2;
	Input ExamID PersonID ExamName $ Score ;
Run;
proc print data= Exams (obs=10);
run;

Proc SQL;
	Create Table persons_and_exams as
		select * from Persons_taking_Exams, Exams_taken
		where Persons_taking_Exams.PersonID = Exams_taken.PersonID;
quit;
Proc Print data=persons_and_exams; 
Run;

filename cmds dde 'Msaccess|system';
data _null_;
	file cmds;
		put '[Close]';
		put '[CloseDatabase]';
		put '[Quit]';
run;
