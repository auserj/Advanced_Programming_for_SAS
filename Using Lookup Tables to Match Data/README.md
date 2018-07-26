# Summary

## Using Multidimensional Arrays
When a lookup operation depends on more than one ordinal numeric key, you can use a multidimensional array. Use an ARRAY statement to create an array. The ARRAY statement defines a set of elements that you plan to process as a group.

## Using Stored Array Values
In many cases, you might prefer to load an array with values that are stored in a SAS data set rather than loading them in an ARRAY statement. Lookup tables should be stored in a SAS data set when the following conditions are true:

- there are too many values to initialize easily in the array
- the values change frequently
- the same values are used in many programs

The first step in loading an array from a data set is to create an array to hold the values from the source data set. The next step is to load the array elements. One method for accomplishing this task is to load the array within a DO loop. The last step is to read the base data set.

## Using PROC TRANSPOSE
The TRANSPOSE procedure can be used to prepare data when the orientation of the data sets differs. PROC TRANSPOSE creates an output data set by restructuring the values in a SAS data set, thereby transposing selected variables into observations. The transposed (output) data set can then be merged with another data set in order to match the data.
The output data set contains several default variables.
- _NAME_ is the default name of the variable that PROC TRANSPOSE creates to identify the source of the values in each observation in the output data set. This variable is a character variable whose values are the names of the variables that are transposed from the input data set. To override the default name, use the NAME= option.
- The remaining transposed variables are named COL1...COLn by default. To override the default names, use the PREFIX= option.

## Merging the Transposed Data Set
You might need to use a BY statement with PROC TRANSPOSE in order to correctly structure the data for a merge. For each BY group, PROC TRANSPOSE creates one observation for each variable that it transposes. The BY variable itself is not transposed. In order to structure the data for a merge, you might also need to sort the output data set. Any other source data sets might need to be reorganized and sorted as well. When the data is structured correctly, the data sets can be merged.











