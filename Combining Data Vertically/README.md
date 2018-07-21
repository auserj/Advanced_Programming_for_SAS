# Summary

## Using a FILENAME Statement
You can use a FILENAME statement to concatenate raw data files by assigning a single fileref to the raw data files that you want to combine. When the fileref is specified in an INFILE statement, each raw data file that has been referenced can be sequentially read into a data set using an INPUT statement.

## Using an INFILE Statement
You can make the process of concatenating raw data files more flexible by using an INFILE statement with the FILEVAR= option. The FILEVAR= option enables you to dynamically change the currently opened input file to a new input file. When the INFILE statement executes, it reads from the file that the FILEVAR= variable specifies.
In some cases, you might need to use the COMPRESS function to eliminate spaces in the filenames that you generate.
When you read the last record in a raw data file, the DATA step normally stops processing. When you are concatenating raw data files, you do not want to read past the last record until you reach the end of the last input file. You can determine whether you are reading the last record in the last raw data file by using the END= option with the INFILE statement. You can then test the value of the END= variable to determine whether the DATA step should continue processing.
If you are working with date-related data, you might be able to make your program more flexible by eliminating the need to include explicit month numbers in your SAS statements. To create a program that always reads the current month and the previous two months, you can use the MONTH and TODAY functions to obtain the month number of today's date to begin the rolling quarter. In some cases, you might need to use the INTNX function with the TODAY and MONTH functions to correctly determine the month numbers.
## Appending SAS Data Sets
You can use PROC APPEND to concatenate two SAS data sets. PROC APPEND reads only the data in the DATA= SAS data set, not in the BASE= SAS data set. PROC APPEND concatenates data sets even though there might be variables in the BASE= data set that do not exist in the DATA= data set.
The FORCE option must be used if the DATA= data set contains variables that have the following characteristics:
- They are not in the BASE= data set.
- They are longer than the variables in the BASE= data set.
- They do not have the same type as the variables in the BASE= data set.
The FORCE option can cause loss of data because of truncation or dropping of variables. The following table summarizes the consequences of using the FORCE option.
