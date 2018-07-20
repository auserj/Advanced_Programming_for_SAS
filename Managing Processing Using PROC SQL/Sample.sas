/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 8 • Managing Processing Using PROC SQL                               */
/* Author: David Li                                                             */


/* Querying a Table Using PROC SQL Options  */
proc sql outobs=5;
   select flightnumber, destination
      from sasuser.internationalflights;
reset number;
   select flightnumber, destination
      from sasuser.internationalflights
      where boarded gt 200;
quit;


/*  Describing and Querying a Dictionary Table  */
proc sql;
   describe table dictionary.columns;
   select memname
      from dictionary.columns
      where libname='SASUSER'
            and name='EmpID';
quit;
