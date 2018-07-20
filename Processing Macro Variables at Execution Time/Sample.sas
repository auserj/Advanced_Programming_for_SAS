/* Advanced_Programming_for_SAS                                                 */ 
/* 323Chapter 10 • Processing Macro Variables at Execution Time                 */
/* Author: David Li                                                             */


/*  Using CALL SYMPUT to Create Macro Variables   */
options symbolgen pagesize=30;
%let crsnum=3;
data revenue;
   set sasuser.all end=final;
   where course_number=&crsnum;
   total+1;
   if paid='Y' then paidup+1;
   if final then do;
       if paidup<total then do;
          call symput('foot','Some Fees Are Unpaid');
       end;
       else do;
          call symput('foot','All Students Have Paid');
       end;
   end;
run;
proc print data=revenue;
   var student_name student_company paid;
   title "Payment Status for Course &crsnum";
   footnote "&foot";
run;


/*  Referencing Macro Variables Indirectly   */
options symbolgen;
data _null_;
    set sasuser.courses;
    call symput(course_code, trim(course_title));
run;

%let crsid=C005;
proc print data=sasuser.schedule noobs label;
    where course_code="&crsid";
    var location begin_date teacher;
    title1 "Schedule for &&&crsid";
run;

%let crsid=C002;
proc print data=sasuser.schedule noobs label;
    where course_code="&crsid";
    var location begin_date teacher;
    title1 "Schedule for &&&crsid";
run;


/*  Using SYMGET to Obtain Macro Variable Values   */
data teachers;
   set sasuser.register;
   length Teacher $ 20;
   teacher=symget('teach'||left(course_number));
run;

proc print data=teachers;
   var student_name course_number teacher;
title1 "Teacher for Each Registered Student";
run;


/*  Creating Macro Variables with the INTO Clause   */
proc sql noprint;
   select course_code, location, begin_date format=mmddyy10.
      into :crsid1-:crsid3,
           :place1-:place3,
           :date1-:date3
      from sasuser.schedule
      where year(begin_date)=2002
      order by begin_date;
quit;






















