/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 7 • Creating and Managing Views Using PROC SQL                       */
/* Author: David Li                                                             */

/*  Creating a PROC SQL View   */
proc sql;
   create view sasuser.raisev as
      select empid, jobcode,
             salary format=dollar12.2,
             salary/12 as MonthlySalary
             format=dollar12.
         from payrollmaster
         using libname airline 'c:\data\ia';
quit;


/*  Displaying the Definition for a PROC SQL View   */
proc sql;
   describe view sasuser.raisev;
quit;


/*  Using a PROC SQL View in a Query   */
proc sql;
   select *
      from sasuser.raisev
      where jobcode in ('PT2','PT3');
quit;


/*  Updating a PROC SQL View   */
proc sql;
   update sasuser.raisev
      set salary=salary * 1.20
      where jobcode='PT3';
quit;


/*  Dropping a PROC SQL View   */
proc sql;
   drop view sasuser.raisev;
quit;




















