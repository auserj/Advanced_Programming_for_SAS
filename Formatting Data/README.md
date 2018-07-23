# Summary

## Creating Custom Formats Using the VALUE Statement
Character and numeric formats are created by using VALUE statements in a FORMAT procedure. When you specify a libref in the LIBRARY= option, the format is stored in the specified library. If no catalog name is specified, the format is saved in the Formats catalog by default.

## Creating Formats with Overlapping Ranges
Use the MULTILABEL option to create a format that has overlapping ranges. When a format has overlapping ranges, the values in the format might have more than one label. This format can be used in procedures that support the MLF option.

## Creating Custom Formats Using the PICTURE Statement
The PICTURE statement is used to create a template for formatting values of numeric variables. Pictures are specified using digit selectors, message characters, and directives.

## Documenting Formats
Use the FMTLIB keyword in the PROC FORMAT statement to get documentation about the formats in the specified catalog. The output displays the format name, start and end values, and the label. You can also use the SELECT and EXCLUDE statements to process specific formats rather than an entire catalog.

## Managing Formats
Because formats are saved as catalog entries, you use PROC CATALOG to copy, rename, delete, or create a listing of the entries in a catalog.

## Using Custom Formats
Once you have created a format, you can reference it as you would reference a SAS format. If you have stored the format in a location other than Work.Formats, you must use the FMTSEARCH= system option to add the location to the search path so that SAS can locate the format. It can be useful to change the default FMTERR system option to NOFMTERR. Changing the default system option enables SAS to substitute the w. or $w. format and continue processing if SAS does not find a format you reference.

You can permanently associate a format with a variable by modifying the data set using PROC DATASETS.

## Creating Formats from SAS Data Sets
Use the CNTLIN= option to specify a SAS data set that you want to use to create a format. The SAS data set must contain the variables FmtName, Start, and Label. If the values have ranges, there must also be an End variable.

## Creating SAS Data Sets from Formats
Use the CNTLOUT= option to create a SAS data set from a format. This is useful for maintaining formats because you can easily update a SAS data set.

