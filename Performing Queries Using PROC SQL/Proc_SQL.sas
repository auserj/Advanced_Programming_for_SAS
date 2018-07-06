
/* Advanced_Programming_for_SAS                                                 */ 
/*Chapter 1 • Performing Queries Using PROC SQL                                 */
/* Author: David Li                                                             */

/* PROC SQL */
proc sql;
   select empid,jobcode,salary,
          salary*.06 as bonus
      from sasuser.payrollmaster
      where salary<32000
      order by jobcode;
      
/* Submitting another PROC step, a DATA step, or a QUIT statement to end the procedure */ 
proc sql;
   select empid,jobcode,salary,
          salary*.06 as bonus
       from sasuser.payrollmaster
       where salary<32000
       order by jobcode desc;
quit;

/* Combining Tables  */
proc sql;
   select salcomps.empid,lastname,              /* Specifying Columns That Appear in Multiple Tables */ 
          newsals.salary,newsalary              /* Specifying Columns That Appear in Multiple Tables */ 
      from sasuser.salcomps,sasuser.newsals     /* Specifying Multiple Table Names                   */ 
      where salcomps.empid=newsals.empid        /* Specifying a Join Condition                       */ 
      order by lastname;  

 /* Summarizing Groups of Data  */   
 proc sql;
    select membertype,
           sum(milestraveled) as TotalMiles
      from sasuser.frequentflyers
      group by membertype;
      

      
