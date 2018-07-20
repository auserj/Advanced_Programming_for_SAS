/* Advanced_Programming_for_SAS                                                 */ 
/* 118Chapter 4 • Combining Tables Vertically Using PROC SQL                    */
/* Author: David Li                                                             */


proc sql;
   select firstname, lastname
      from sasuser.staffchanges
   intersect all
   select firstname, lastname
      from sasuser.staffmaster;
quit;
