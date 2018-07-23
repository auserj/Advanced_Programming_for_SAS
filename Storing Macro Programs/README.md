# Summary


## Understanding Session-Compiled Macros
You can make a macro available to your SAS session by submitting the macro definition before calling the macro. This creates a session-compiled macro. Session-compiled macros are deleted from the temporary SAS catalog Work.Sasmacr at the end of the session.


## Storing Macro Definitions in External Files
One way to store your macro definitions permanently is to save them in external files. You can make a macro definition that is stored in an external file accessible to your SAS programs by using the %INCLUDE statement.


## Storing Macro Definitions in Catalog SOURCE Entries
You can also store your macro definitions permanently as SOURCE entries in SAS catalogs. You can use the catalog access method to make these macros accessible to your SAS programs. The PROC CATALOG statement enables you to view a list of the contents of a SAS catalog.


## Using the Autocall Facility
You can permanently store macro definitions in source libraries called autocall libraries. SAS provides several macro definitions for you in a default autocall library. You can concatenate multiple autocall libraries. To access macros that are stored in an autocall library, you specify the SASAUTOS= and MAUTOSOURCE system options.


## Using Stored Compiled Macros
Another efficient way to make macros available to a program is to store them in compiled form in a SAS library. To store a compiled macro permanently, you must set two system options, MSTORED and SASMSTORE=. Then you submit one or more macro definitions, using the STORE option in the %MACRO statement. The compiled macro is stored as a catalog entry in Libref.Sasmacr. The source program is not stored as part of the compiled macro. You should always maintain the original source program for each macro definition in case you need to redefine the macro. You can use the SOURCE option in the %MACRO statement to store the macro source code with the compiled macro. If you use the SOURCE option in the %MACRO statement, you can use the %COPY statement to access the macro source code later.
