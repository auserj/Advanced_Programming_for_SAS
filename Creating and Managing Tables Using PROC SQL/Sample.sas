/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 5 • Creating and Managing Tables Using PROC SQL                      */
/* Author: David Li                                                             */


/*  Creating an Empty Table By Defining Columns  */
proc sql;
   create table work.discount
          (Destination char(3),
          BeginDate num Format=date9.,
          EndDate num format=date9.,
          Discount num);
quit;


/*  Creating an Empty Table That Is like Another Table  */
proc sql;
   create table work.flightdelays2
          (drop=delaycategory destinationtype)
      like sasuser.flightdelays;
quit;


/*  Creating a Table from a Query Result  */
proc sql;
   create table work.ticketagents as
      select lastname, firstname,
             jobcode, salary
         from sasuser.payrollmaster,
              sasuser.staffmaster
         where payrollmaster.empid
               = staffmaster.empid
               and jobcode contains 'TA';
quit;


/*  Displaying the Structure of a Table  */
proc sql;
   describe table work.discount;
quit;


/*  Inserting Rows into a Table By Specifying Column Names and Values  */
proc sql;
   insert into work.discount
        set destination='LHR',
            begindate='01MAR2000'd,
            enddate='05MAR2000'd,
            discount=.33
        set destination='CPH',
            begindate='03MAR2000'd,
            enddate='10MAR2000'd,
            discount=.15;
quit;


/*  Inserting Rows into a Table By Specifying Lists of Values  */
proc sql;
   insert into work.discount (destination,
          begindate,enddate, discount)
       values ('LHR','01MAR2000'd,
               '05MAR2000'd,.33)
       values ('CPH','03MAR2000'd,
               '10MAR2000'd,.15);
quit;


/*  Inserting Rows into a Table from a Query Result  */
proc sql;
   insert into work.payrollchanges2
      select empid, salary, dateofhire
         from sasuser.payrollmaster
         where empid in ('1919','1350','1401');
quit;


/*  Creating a Table That Has Integrity Constraints  */
proc sql;
   create table work.employees
          (Name char(10),
          Gender char(1),
          HDate date label='Hire Date' not null,
          constraint prim_key primary key(name),
          constraint gender check(gender in ('M' 'F')));
quit;


/*  Displaying Integrity Constraints for a Table  */
proc sql;
   describe table constraints work.discount4;
quit;


/*  Updating Rows in a Table Based on an Expression  */
proc sql;
   update work.payrollmaster_new
      set salary=salary*1.05
      where jobcode like '__1';
quit;


/*  Updating Rows in a Table By Using a CASE Expression  */
proc sql;
   update work.payrollmaster_new
      set salary=salary*
        case
           when substr(jobcode,3,1)='1'
                then 1.05
           when substr(jobcode,3,1)='2'
                then 1.10
           when substr(jobcode,3,1)='3'
                then 1.15
           else 1.08
        end;
quit;


/*  Updating Rows in a Table By Using a CASE Expression (Alternate Syntax)  */
proc sql outobs=10;
   select lastname, firstname, jobcode,
          case substr(jobcode,3,1)
          when '1'
                then 'junior'
          when '2'
                then 'intermediate'
          when '3'
                then 'senior'
          else 'none'
      end as JobLevel
   from sasuser.payrollmaster,
        sasuser.staffmaster
   where staffmaster.empid=
         payrollmaster.empid;
quit;


/*  Deleting Rows in a Table  */
proc sql;
   delete from work.frequentflyers2
      where pointsearned-pointsused<=0;
quit;


/*  Adding, Modifying, and Dropping Columns in a Table  */
proc sql;
   alter table work.payrollmaster4
      add Age num
      modify dateofhire date format=mmddyy10.
      drop dateofbirth, gender;
quit;


/*  Dropping a Table  */
proc sql;
   drop table work.payrollmaster4;
quit;









