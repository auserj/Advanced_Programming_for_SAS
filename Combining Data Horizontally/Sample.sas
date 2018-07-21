/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 15 • Combining Data Horizontally                                     */
/* Author: David Li                                                             */

/* Combining Data with the IF-THEN/ELSE Statement   */
data mylib.employees_new;
   set mylib.employees;
   if IDnum=1001 then Birthdate='01JAN1963'd;
   else if IDnum=1002 then Birthdate='08AUG1946'd;
   else if IDnum=1003 then Birthdate='23MAR1950'd;
   else if IDnum=1004 then Birthdate='17JUN1973'd;
run;

/* Combining Data with the ARRAY Statement   */
data mylib.employees_new;
   array birthdates{1001:1004} _temporary_ ('01JAN1963'd
         '08AUG1946'd '23MAR1950'd '17JUN1973'd);
   set mylib.employees;
   Birthdate=birthdates(IDnum);
run;


/* Combining Data with the FORMAT Procedure   */
proc format;
   value birthdate 1001 = '01JAN1963'
                   1002 = '08AUG1946'
                   1003 = '23MAR1950'
                   1004 = '17JUN1973';
run;

data mylib.employees_new;
   set mylib.employees;
   Birthdate=input(put(IDnum,birthdate.),date9.);
run;


/* Performing a DATA Step Match-Merge   */
proc sort data=sasuser.expenses out=expenses;
   by flightid date;
run;

proc sort data=sasuser.revenue out=revenue;
   by flightid date;
run;

data revexpns (drop=rev1st revbusiness revecon
     expenses);
    merge expenses(in=e) revenue(in=r);
    by flightid date;
    if e and r;
    Profit=sum(rev1st, revbusiness, revecon,
           -expenses);
run;

proc sort data=revexpns;
   by dest;
run;

proc sort data=sasuser.acities out=acities;
   by code;
run;

data sasuser.alldata;
   merge revexpns(in=r) acities
         (in=a rename=(code=dest)
         keep=city name code);
   by dest;
   if r and a;
run;


/* Performing a PROC SQL Join   */
proc sql;
   create table sqljoin as
   select revenue.flightid,
          revenue.date format=date9.,
          revenue.origin, revenue.dest,
          sum(revenue.rev1st,
              revenue.revbusiness,
              revenue.revecon)
          -expenses.expenses as Profit,
          acities.city, acities.name
from sasuser.expenses, sasuser.revenue,
     sasuser.acities
where expenses.flightid=revenue.flightid
      and expenses.date=revenue.date
      and acities.code=revenue.dest
order by revenue.dest, revenue.flightid,
         revenue.date;
quit;


/* Combining Summary Data and Detail Data  */
proc means data=sasuser.monthsum noprint;
   var revcargo;
   output out=sasuser.summary sum=Cargosum;
run;

data sasuser.percent1;
   if _n_=1 then set sasuser.summary
                     (keep=cargosum);
   set sasuser.monthsum
    (keep=salemon revcargo);
   PctRev=revcargo/cargosum;
run;

data sasuser.percent2(drop=totalrev);
   if _n_=1 then do until(lastobs);
      set sasuser.monthsum(keep=revcargo)
          end=lastobs;
      totalrev+revcargo;
   end;
   set sasuser.monthsum (keep=salemon revcargo);
   PctRev=revcargo/totalrev;
run;


/*  Using an Index to Combine Data  */
data work.profit work.errors;
   set sasuser.dnunder;
   set sasuser.sale2000(keep=routeid
       flightid date rev1st revbusiness
       revecon revcargo)key=flightdate;
   if _iorc_=0 then do;
      Profit=sum(rev1st, revbusiness, revecon,
             revcargo, -expenses);
      output work.profit;
   end;
   else do;
      _error_=0;
      output work.errors;
   end;
run;


/*  Using a Transaction Data Set  */
proc sort data=mylib.empmaster;
   by empid;
run;

proc sort data=mylib.empchanges;
   by empid;
run;

data mylib.empmaster;
   update mylib.empmaster mylib.empchanges;
   by empid;
run;

















