/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 16 • Using Lookup Tables to Match Data                               */
/* Author: David Li                                                             */


/*  Using a Multidimensional Array  */
data work.wndchill (drop = column row);
  array WC{4,2} _temporary_
    (-22,-16,-28,-22,-32,-26,-35,-29);
  set sasuser.flights;
  row = round(wspeed,5)/5;
  column = (round(temp,5)/5)+3;
  WindChill= wc{row,column};
run;


/*  Using Stored Array Values  */
data work.lookup1;
   array Targets{1997:1999,12} _temporary_;
   if _n_=1 then do i= 1 to 3;
      set sasuser.ctargets;
      array Mnth{*} Jan--Dec;
      do j=1 to dim(mnth);
         targets{year,j}=mnth{j};
      end;
end;
      set sasuser.monthsum(keep=salemon revcargo monthno);
      year=input(substr(salemon,4),4.);
      Ctarget=targets{year,monthno};
      format ctarget dollar15.2;
run;


/*  Using PROC TRANSPOSE and a Merge  */
proc transpose data=sasuser.ctargets
     out=work.ctarget2
     name=Month
     prefix=Ctarget;
    by year;
run;

proc sort data=work.ctarget2;
   by year month;
run;

data work.mnthsum2;
   set sasuser.monthsum(keep=SaleMon RevCargo);
   length Month $ 8;
   Year=input(substr(SaleMon,4),4.);
   Month=substr(SaleMon,1,1)
         ||lowcase(substr(SaleMon,2,2));
run;

proc sort data=work.mnthsum2;
   by year month;
run;

data work.merged;
   merge work.mnthsum2 work.ctarget2;
   by year month;
run;


/*  Loading a Hash Object from Hardcoded Values  */
data work.difference (drop= goalamount);
   if _N_ = 1 then do;
       declare hash goal( );
       goal.definekey("QtrNum");
       goal.definedata("GoalAmount");
       goal.definedone( );
       call missing(goalamount);
       goal.add(key:'qtr1', data:10 );
       goal.add(key:'qtr2', data:15 );
       goal.add(key:'qtr3', data: 5 );
       goal.add(key:'qtr4', data:15 );
   end;
   set sasuser.contrib;
   rc=goal.find();
   Diff = amount - goalamount;
run;


/*  Loading a Hash Object from a SAS Data Set  */
data work.report;
   if _N_=1 then do;
           if 0 then set sasuser.acities(keep=Code City Name);
      declare hash airports (dataset: "sasuser.acities");
      airports.definekey ("Code");
      airports.definedata ("City", "Name");
      airports.definedone();
end;
set sasuser.revenue;
rc=airports.find(key:origin);
if rc=0 then do;
   OriginCity=city;
   OriginAirport=name;
end;
else do;
   OriginCity='';
   OriginAirport='';
end;
rc=airports.find(key:dest);
if rc=0 then do;
   DestCity=city;
   DestAirport=name;
end;
else do;
   DestCity='';
   DestAirport='';
end;
run;









