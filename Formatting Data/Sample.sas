/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 17 • Formatting Data                                                 */
/* Author: David Li                                                             */


/* Creating a Multilabel Format  */
proc format;
   value dates (multilabel)
        '01jan2000'd - '31mar2000'd = '1st Quarter'
        '01apr2000'd - '30jun2000'd = '2nd Quarter'
        '01jul2000'd - '30sep2000'd = '3rd Quarter'
        '01oct2000'd - '31dec2000'd = '4th Quarter'
        '01jan2000'd - '30jun2000'd = 'First Half of Year'
        '01jul2000'd - '31dec2000'd = 'Second Half of Year';
run;


/* Creating a Picture Format  */
proc format;
   picture rainamt
           0-2='9.99 slight'
           2<-4='9.99 moderate'
           4<-<10='9.99 heavy'
           other='999 check value';
run;


/* Creating a Picture Format Using Directives  */
proc format;
   picture mydate
           low-high='%0d-%b%Y ' (datatype=date);
run;


/* Restructuring a SAS Data Set and Creating a Format from the Data  */
data sasuser.aports;
   keep Start Label FmtName;
   retain FmtName '$airport';
   set sasuser.acities (rename=(Code=Start
       City= Label));
run;

proc format library=sasuser cntlin=sasuser.aports;
run;


/*  Creating a SAS Data Set from a Format  */
proc format lib=sasuser cntlout=sasuser.fmtdata;
   select $airport;
run;













