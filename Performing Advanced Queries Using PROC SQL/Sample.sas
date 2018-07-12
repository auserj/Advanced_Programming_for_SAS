

/* Displaying All Columns in Output and an Expanded Column List in the SAS Log */
proc sql feedback;
   select *
     from sasuser.staffchanges;
quit;


/* Eliminating Duplicate Rows from Output */
proc sql;
   select distinct flightnumber, destination
      from sasuser.internationalflights 
      order by 1;    
quit;


/* Subsetting Rows By Using Calculated Values */
proc sql outobs=10;
   validate
   select flightnumber,
          date label="Flight Date", destination,
          boarded + transferred + nonrevenue
          as Total
     from sasuser.marchflights
     where calculated total between 100 and 150;
quit;


/* Subsetting Data By Using a Noncorrelated Subquery */
proc sql noexec;
   select jobcode,
          avg(salary) as AvgSalary
          format=dollar11.2
      from sasuser.payrollmaster
      group by jobcode
      having avg(salary) >
         (select avg(salary)
            from sasuser.payrollmaster);
quit;



/* Subsetting Data By Using a Correlated Subquery */
proc sql;
  title 'Frequent Flyers Who Are Not Employees';
     select count(*) as Count
        from sasuser.frequentflyers
        where not exists
           (select *
              from sasuser.staffmaster
              where name=
                    trim(lastname)||', '||firstname);
quit;




