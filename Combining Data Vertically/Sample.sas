/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 14 • Combining Data Vertically                                       */
/* Author: David Li                                                             */


/* Combining Raw Data Files Using a FILENAME Statement  */
filename qtr1 ('c:\data\month1.dat''c:\data\month2.dat'
               'c:\data\month3.dat');
data work.firstqtr;
   infile qtr1;'
   input Flight $ Origin $ Dest $
         Date : date9. RevCargo : comma15.;
run;


/* Combining Raw Data Files Using an INFILE Statement  */
data quarter (drop=monthnum midmon lastmon);
   monthnum=month(today());
   midmon=month(intnx('month',today(),-1));
   lastmon=month(intnx('month',today(),-2));
   do month = monthnum, midmon, lastmon;
      nextfile="c:\sasuser\month"
               !!compress(put(month,2.)!!".dat",' ');
do until (lastobs);
   infile temp filevar=nextfile end=lastobs;
   input Flight $ Origin $ Dest $ Date : date9.
         RevCargo : comma15.;
   output;
      end;
   end;
   stop;
run;


/* Combining SAS Data Sets Using PROC APPEND  */
proc append base=work.acities
            data=work.airports force;
run;



























