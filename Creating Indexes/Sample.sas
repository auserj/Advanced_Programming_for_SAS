/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 13 • Creating Indexes                                                */
/* Author: David Li                                                             */


/*  Creating an Index in the DATA Step  */
options msglevel=i;
data sasuser.sale2000(index=(origin FlightDate=
                            (flightid date)/unique));
   infile 'sale2000.dat';
input FlightID $7. RouteID $7. Origin $3.
      Dest $3. Cap1st 8. CapBusiness 8.
      CapEcon 8. CapTotal 8. CapCargo 8.
      Date date9. Psgr1st 8./
      PsgrBusiness 8. PsgrEcon 8.
      Rev1st dollar15.2
      RevBusiness dollar15.2
      RevEcon dollar15.2 SaleMon $7.
      CargoWgt 8./ RevCargo dollar15.2;
run;


/*  Managing Indexes with PROC DATASETS  */
proc datasets library=sasuser nolist;
   modify sale2000;
   index delete origin;
   index create flightid;
   index create Tofrom=(origin dest);
quit;


/*  Managing Indexes with PROC SQL  */
proc sql;
   create index Tofrom on
          sasuser.sale2000(origin, dest);
   drop index origin from sasuser.sale2000;
quit;

/*  You can also generate reports using the Dictionary.Indexes table  */
proc sql;
   select *
        from dictionary.indexes
          where libname='SASUSER' and
memname='SALE2000';
   quit;





















