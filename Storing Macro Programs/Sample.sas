/* Advanced_Programming_for_SAS                                                 */ 
/* Chapter 12 • Storing Macro Programs                                          */
/* Author: David Li                                                             */


/* Compiling an Externally Stored Macro Definition with the %INCLUDE Statement  */
%include 'c:\sasfiles\prtlast.sas' / source2;
proc sort data=sasuser.courses out=bydays;
   by days;
run;

%prtlast


/*  Listing the Contents of a Catalog  */
proc catalog cat=work.sasmacr;
   contents;
   title "Default Storage of SAS Macros";
quit;


/*  Using the Catalog Access Method  */
filename prtlast catalog 'sasuser.mymacs.prtlast.source';
%include prtlast;
proc sort data=sasuser.courses out=bydays;
   by days;
run;
%prtlast


/*  Accessing an Autocall Macro  */
options mautosource sasautos=('c:\mysasfiles',sasautos);
%prtlast


/*  Creating a Stored Compiled Macro  */
libname macrolib 'c:\storedlib';
options mstored sasmstore=macrolib;

%macro words(text,root=w,delim=%str( ))/store;
   %local i word;
   %let i=1;
   %let word=%scan(&text,&i,&delim);
   %do %while (&word ne );
      %global &root&i;
      %let &root&i=&word;
      %let i=%eval(&i+1);
      %let word=%scan(&text,&i,&delim);
   %end;
   %global &root.num;
   %let &root.num=%eval(&i-1);
%mend words;







