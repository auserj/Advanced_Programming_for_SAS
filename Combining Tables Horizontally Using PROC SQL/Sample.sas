/* Advanced_Programming_for_SAS                                                 */ 
/* 76Chapter 3 • Combining Tables Horizontally Using PROC SQL                   */
/* Author: David Li                                                             */


/*    Combining Tables By Using an Inner Join      */
proc sql outobs=15;
title 'New York Employees';
  select substr(firstname,1,1) || '. ' || lastname
         as Name,
         jobcode,
         int((today() - dateofbirth)/365.25)
         as Age
     from sasuser.payrollmaster as p,
          sasuser.staffmaster as s
     where p.empid =
           s.empid
           and state='NY'
     order by 2, 3;
quit;


/*  Combining Tables By Using a Left Outer Join  */
proc sql outobs=20;
title 'All March Flights';
   select m.date,
          m.flightnumber
             label='Flight Number',
          m.destination
          label='Left',
          f.destination
          label='Right',
          delay
          label='Delay in Minutes'
       from sasuser.marchflights as m
            left join
            sasuser.flightdelays as f
       on m.date=f.date
          and m.flightnumber=
              f.flightnumber
       order by delay;
quit;


/*  Overlaying Common Columns in a Full Outer Join  */
proc sql;
   select coalesce(p.empid, s.empid)
          as ID, firstname, lastname, gender
      from sasuser.payrollmaster as p
                  full join
           sasuser.staffmaster as s
      on p.empid = s.empid
      order by id;
quit;


/*  Joining Tables By Using a Subquery and an In-Line View  */
proc sql;
   select empid
      from sasuser.supervisors as m,
        (select substr(jobcode,1,2) as JobCategory,
                state
           from sasuser.staffmaster as s,
                sasuser.payrollmaster as p
           where s.empid=p.empid and s.empid in
              (select empid
                 from sasuser.flightschedule
                 where date='04mar2000'd
                       and destination='CPH')) as c
      where m.jobcategory=c.jobcategory
            and m.state=c.state;
quit;





