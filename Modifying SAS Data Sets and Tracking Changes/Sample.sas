/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 18 • Modifying SAS Data Sets and Tracking Changes                    */
/* Author: David Li                                                             */


/* Modifying a Data Set Using the MODIFY Statement with a BY Statement or the KEY= Option  */
data capacity;
   modify capacity sasuser.newrtnum;
   by flightid;
run;

data cargo99;
   set sasuser.newcgnum (rename =
       (capcargo = newCapCargo
       cargowgt = newCargoWgt
       cargorev = newCargoRev));
   modify cargo99 key=flghtdte;
   capcargo = newcapcargo;
   cargowgt = newcargowgt;
   cargorev = newcargorev;
run;


/* Placing Integrity Constraints on Data  */
proc datasets nolist;
   modify capinfo;
   ic create PKIDInfo=primary key(routeid)
      message='You must supply a Route ID Number';
   ic create Class1=check(where=(cap1st<capbusiness
                                 or capbusiness=.))
      message='Cap1st must be less than CapBusiness';
quit;


/* Initiating an Audit Trail  */
proc datasets nolist;
   audit capinfo;
   initiate;
quit;


/* Initiating Generation Data Sets  */
proc datasets nolist;
   modify cargorev (genmax=4);
quit;



























