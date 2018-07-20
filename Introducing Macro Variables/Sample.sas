/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 9 • Introducing Macro Variables                                      */
/* Author: David Li                                                             */


/*  Creating Macro Variables with a %LET Statement  */
options symbolgen;
%let year=2002;
proc print data=sasuser.schedule;
   where year(begin_date)=&year;
   title "Scheduled Classes for &year";
run;
proc means data=sasuser.all sum;
   where year(begin_date)=&year;
   class location;
   var fee;
   title1 "Total Fees for &year Classes";
   title2 "by Training Center";
run;


/*  Using Automatic Macro Variables  */
footnote1 "Created &systime &sysday, &sysdate9";
footnote2 "on the &sysscp system using Release &sysver";
title "REVENUES FOR DALLAS TRAINING CENTER";
proc tabulate data=sasuser.all(keep=location course_title fee);
   where upcase(location)="DALLAS";
        class course_title;
        var fee;
        table course_title=" " all="TOTALS",
              fee=" "*(n*f=3. sum*f=dollar10.)
              / rts=30 box="COURSE";
run;


/*  Inserting Macro Variables Immediately after Text  */
%let year=02;
%let month=jan;
proc chart data=sasuser.y&year&month;
   hbar week / sumvar=sale;
run;
proc plot data=sasuser.y&year&month;
  plot sale*day;
run;


/*  Inserting Macro Variables Immediately before Text  */
%let graphics=g;
%let year=02;
%let month=jan;
%let var=sale;
proc &graphics.chart data=sasuser.y&year&month;
  hbar week / sumvar=&var;
run;
proc &graphics.plot data=sasuser.y&year&month;
  plot &var*day;
run;




