/* SAS Functions                                                  */
/* Author: David Li                                               */

/************************************************************/
/*                SAS Functions                             */
/************************************************************/

Title "Date formats ";
Data palmulae; /* date in latin */
	Input @1 date1 mmddyy10. @11 date2 mmddyy10.
		@22 date3 mmddyy8.
		@32 date4 mmddyy8.
		@41 date5 date9. ;
/* 123456789a123456789b123456789c123456789d123456789e123456789 */
	datalines;
12311991  11/30/1990 092989   08/28/88  28Jul87
06271986  05/26/1985 042584   03/24/83  23Feb82
; 
run; 
proc print data=palmulae; 
run;

/************************************************************/
/* Setting the Output Format   */
/************************************************************/
Data palmulae; set palmulae; /* date in latin */
	format date1 mmddyy10.
		date2 mmddyy10.
		date3 mmddyy8.
		date4 mmddyy8.
		date5 date9.  ;
run; 
proc print data=palmulae; run;

/************************************************************/
/*  Checking it out with code & Verifying is it 2014 or 1914*/
/************************************************************/
Options yearcutoff=1900;
Data palmulae;
	Input @1 date1 date9. ;
	format date1 mmddyy10.;
datalines;
28Jul14
11Nov19
; 
run; 
proc print data=palmulae; run;

/************************************************************/
/* Checking it out with code & Verifying is it 2014 or 1914*/
/************************************************************/
/* The Great War */
Options yearcutoff=2900;
proc print data=palmulae; 
run;

/************************************************************/
/*              How long was the Great War                 */
/************************************************************/
Options yearcutoff=1900;
Data WW1;
	Input @1 date1 date9.
	@11 date2 date9. ;
	WWI_Length = yrdif (date1, date2, 'actual') ;
	/* actual means calculate the actual number of days in each
	month, including leap years */
	WWI_in_days=datdif(date1,date2,'actual');
	WWI_in_years = intck('years',date1,date2);
	WWI_in_months = intck('months',date1,date2);
	WWI_in_weeks = intck('weeks',date1,date2);
	WWI_in_days2 = intck('days',date1,date2);
	Days_ago = abs(intck('days',date2,date()));
	/* 1234567890123456790 */
	datalines;
28Jul14   11Nov19
; 
run; 
proc print data=ww1; 
run;

/************************************************************/
/*  Date literals                                           */
/************************************************************/
Data palmulae2;
	myDate = '01Jan1910'd ;
	myDate2 = "02Feb1912"d ;
	MyDate3 = Today();
	format MyDate ddmmyy10. MyDate2 ddmmyy10. MyDate3 ddmmyy10.;
run;
proc print data=palmulae2; 
run;

/************************************************************/
/*            Breaking up a Date                            */
/************************************************************/
Data palmulae2;
	myDate = '01Jan1910'd ;
	myDay = weekday(MyDate);
	myMonth = month (MyDate);
	myYear = year(MyDate);
	format MyDate ddmmyy10. ;
run;
proc print noobs data=palmulae2; 
	var MyDay--MyYear; 
run;

/************************************************************/
/*          Adding days to a date                           */
/************************************************************/
Title "Adding days to a date";
Data a;
	mybasedate = '01Jan1910'd;
	format mybasedate mmddyy10.
		myDatePlus10Days mmddyy10.
		myDatePlus10Weeks mmddyy10.
		myDatePlus10Years mmddyy10. ;
	myDatePlus10Days =intnx('day', mybasedate, 10);
	myDatePlus10Weeks =intnx('week', '01Jan1910'd, 10); 
	myDatePlus10Years =intnx('year', '01Jan1910'd, 10);
run; 
proc print data=a; 
run;

/************************************************************/
/*          Numeric Functions                               */
/************************************************************/
Data numeros;
input Product_Code Product_Name $ Price;
	Price_int = int(price);
	Price_round = round (price);
	price_round2 = round (price, .1) ; /* .1 is the round off unit, here to xxx.x*/
	price_round3 = round (price, 10) ; /* 10 is the round off unit, here to xx0. */
	datalines;
001 Apples 1.95
002 Oranges 1.45
003 Milk 2.98
004 Coffee 7.98
005 Bread  2.56
006 BMW    65432.87
; 
run;
proc print noobs data=numeros; 
run;

/************************************************************/
/*          Missing Numeric and Character values            */
/************************************************************/
Data numeros;
	input Product_Code Product_Name $ Price Discount;
	if missing(Price) then price = 2.50;
	if _n_ = 3 then call missing (of _all_);
	if _n_ = 4 then call missing (Product_Code, Product_Name);
	datalines;
001 Apples 1.95  .20
002 Oranges .   .25
003 Milk   2.98  .
004 . 7.98 .66
; 
proc print noobs data=numeros; 
run;

/*****************************************************************/
/* Performing a math function on the columns of the current row  */
/*****************************************************************/
Data numeros;
	input Product_Code Product_Name $ Price1-price10;
	number_of_obs = n(of price1-price10);
	Max_of_obs = max(of price1-price10);
	Min_of_obs = min(of price1-price10);
	Mean_of_obs = mean(of price1-price10);
	Sum_of_obs = sum(of price1-price10);
	Largest_of_obs = largest(1, of price1-price10);
	Second_Largest_of_obs = largest(2, of price1-price10);
	Smallest_of_obs = smallest(1, of price1-price10);
	Second_Smallest_of_obs = smallest(2, of price1-price10);
	Sum_return_minus_1_if_all_missng = sum(-1, of price1-price10);
datalines;
001 Apples 1.95 1.86 2.04 3.01 1.55  .98 2.02 1.98 2.20 1.98
002 Oranges .   2.86 3.04 2.91 2.55 1.98 2.42 1.98 2.26 1.95
003 Cherries . . . . . . . . . .
; 
run;
proc print noobs data=numeros; 
run;

/***********************************************************************/
/*Other math functions. This time on an unknown number of observations */
/***********************************************************************/
Data numeros;
	input Price @@;
	number_of_obs = n(of price);
	abs_of_obs = abs(price);
	sqrt_of_obs = sqrt(price);
	exp_of_obs = exp(price);
	log_of_obs = log(price);
	datalines;
1.95 1.86 2.04 -3.01 1.55  .98
; 
run;
proc print noobs data=numeros; 
run;

/************************************************************/
/*   Constants                                              */
/************************************************************/
Data perpetua; /* Latin for constant as in perpetual*/
	myPI = constant ("pi");
	myPi_3_digits = int(myPI *1000)/1000;
	*myE = constant("e"); /* Hey, remember exp()? */
run;
proc print noobs data=perpetua; 
run;

/************************************************************/
/*          More on Random Numbers                          */
/************************************************************/
Data fortuitae;
	array random99 (10); 
	do I = 1 to 10 by 1;
		Random99 (I) = ranuni (99);
	end;
run; 
proc print noobs data=fortuitae; 
run;

/************************************************************/
/*             Reading Previous Observations                */
/*             the LAG function                             */
/************************************************************/
Data erat;
input price @@;
	previous_price = lag(price);
	if price NE 60 then previous_price_skip = lag2(price);
datalines;
10 20 30 40 50 60 70 80 90
;
run;
proc print noobs data=erat; 
run;
	
/************************************************************/
/*              Character functions                         */
/************************************************************/
Title "Character Functions";
Data persona;
input Person1 $ Person2 $;
	Name_length1 = lengthn (Person1);
	Upper_case1 = upcase (Person1);
	Person1_and_leading_spaces = cat ("A    ", person1);
	person1_turn_2_spaces_into_1 = compbl(Person1_and_leading_spaces );
	person1_no_spaces = compress (Person1_and_leading_spaces);
	Person1_and_Person2_strip_blanks = cats (person1, person2);
	Person1_and_person2_concatinated = person1 || person2;
	Person1_with_blanks_added = "      " || person1 || "     ";
	Person1_trim_left = "/" || left(Person1_with_blanks_added) || "/";
	Person1_trim_right = "/" || trim(Person1_with_blanks_added) || "/";
	Person1_trim_strip_all = "/" || strip(Person1_with_blanks_added) || "/";
	datalines;
Jacob Emily
Michael Hannah
Matthew Madison
Joshua Ashley
Christopher Sarah
Nicholas Alexis
Andrew Samantha
Joseph Jessica
Daniel Taylor
Tyler Elizabeth
William Lauren
;
run;
proc print data=persona; 
run;

/************************************************************/
/*                  more on trim                            */
/************************************************************/
Data persona;
	input Person1 $ Person2 $;
	Person1_trim = "/ " || Person1 || " " || Person2 || " /";
	Person1_trim = Trim(Person1_trim);
	datalines;
Jacob Emily
; 
run; 
proc print data=persona; 
run;

/************************************************************/
/*            Compress                                      */ 
/************************************************************/
Data persona;
	input Person1 $ Person2 $;
	Person1_compress = "/ " || Person1 || " " || Person2 || " /";
	Person1_compress = compress(Person1_compress, " ");
	Person2_compress = compress(Person1_compress, "a");
	datalines;
Jacob Emily
; 
run; 
proc print data=persona; 
run;
/************************************************************/
/*              More on Compress                            */
/************************************************************/
Data persona;
input Person1 $ Person2 $;
	Person1_compress = "/ " || Person1 || " " || Person2 || " /";
	Person2_compress = compress(Person1_compress, "air");
	datalines;
Jacob Emily
; 
run; 
proc print data=persona; 
run;
/************************************************************/
/*             More on Compress                            */
/************************************************************/
Data persona;
	String1 = Compress ("1a2b3c4d",,"d");
	Put string1;  
run;

Data persona;
	/* prints acd */
	String1 = Compress ("1a2b3c4d","b","d");
	Put string1;  
run;

Data persona;
	String1 = Compress ("1a2b3,;c4d",,"DP");
	Put string1;
run;
	
/************************************************************/
/*          K = keeps rather than deletes specified codes   */
/************************************************************/
Data persona;
	String1 = Compress ("1a2b3,;c4d","A","DPIK");
	Put string1;
	String1 =Compress ("1a2b3,;c4d","A","DP");
	Put string1;
run;


/************************************************************/
/*           Dealing with wrongly entered data              */
/************************************************************/
Data iniuriam;
	input Person1 $ Compensation1 $;
	if notalpha (trim(person1)) > 0 then
		/* NotAlpha returns the first character that is not an alpha
	 	as in 1II which should have been 111
		and Er1c which should have been Eric*/
	Person1 = .;
	if notdigit(trim(compensation1)) >0 then Compensation1 = .;
	datalines;
Jacob 100
Emily 1II
Er1C 700
John 999
; 
run; 
proc print data=iniuriam; 
run;

/************************************************************/
/*        Substrings                                        */
/************************************************************/
Data subcadena; 
	B= substr ("1234567890", 2, 3); 
	put B; 
run;
data subcadena; 
	B= substr ("1234567890", 9); 
	put B; 
run;
/************************************************************************/
/* Parsing a sentence into its individual words using substr and a loop.*/
/************************************************************************/
Data parse;
	sentence = "The 99 quick brown fox jumped over the lazy Moon";
	drop sentence X I;
	format word2 $30.;
	Word2 = "";
	sentence = left(sentence);
	Do I = 1 to lengthn(sentence) by 1;
		X = substr(sentence,I,1);
		if X NE " "
		then
			Word2 = cats(Word2,X);
		else do;
			output parse;
			Word2 = "";
		end;
	end;
	if word2 NE "" then output parse;
run; 
proc print data=parse; 
run;

/************************************************************/
/*          comparison with modifiers use Compare           */
/************************************************************/
data comparo;
	if compare ("abc", "aBc") then put "1 abc and aBc are equal";
	if compare ("abc", "abcd") then put "2 abc and aBcd are equal";
	if compare ("abc", "aBc", "i") then put "3 abc and aBc are equal";
	if compare ("abcde", "abcd", ":") then put "4 abcde and aBcd are equal";
run;
