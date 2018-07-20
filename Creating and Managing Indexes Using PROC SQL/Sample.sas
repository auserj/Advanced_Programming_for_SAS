/* Advanced_Programming_for_SAS                                                 */ 
/* 221Chapter 6 • Creating and Managing Indexes Using PROC SQL                  */
/* Author: David Li                                                             */


/*   Creating a Simple, Unique Index, and a Composite Index     */
proc sql;
   create unique index EmpID
     on work.payrollmaster(empid);
create index daily
     on work.marchflights(flightnumber,date);
quit;


/*   Displaying Index Specifications     */
proc sql;
   describe table marchflights;
quit;


/*   Determining Whether SAS Is Using an Index     */
options msglevel=i;
proc sql;
    select *
       from marchflights
       where flightnumber='182';
quit;


/*   Directing SAS to Ignore All Indexes     */
proc sql;
   select *
      from marchflights (idxwhere=no)
      where flightnumber='182';
quit;


/*   Directing SAS to Use a Specified Index     */
proc sql;
   select *
      from marchflights (idxname=daily)
      where flightnumber='182';
quit;


/*   Dropping an Index     */
proc sql;
   drop index daily
      from work.marchflights;
quit;















