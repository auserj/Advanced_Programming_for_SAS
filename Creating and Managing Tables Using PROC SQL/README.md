# Summary

## Understanding Methods of Creating Tables
You can use the CREATE TABLE statement to create a table in three different ways:
- create a table with no rows (an empty table) by defining columns
- create an empty table that is like another table
- create a table that contains rows, based on a query result.

## Creating an Empty Table By Defining Columns
You can create a table with no rows by using a CREATE TABLE statement that contains column specifications. A column specification includes the following elements: column name (required), data type (required), column width (optional), one or more column modifiers (optional), and a column constraint (optional).

## Displaying the Structure of a Table
To display, in the SAS log, a list of a table's columns and their attributes and other information about a table, use the DESCRIBE TABLE statement.

## Creating an Empty Table That Is like Another Table
To create a table with no rows that has the same structure as an existing table, use a CREATE TABLE statement that contains the keyword LIKE. To specify a subset of columns to be copied from the existing table, use the SAS data set options DROP= or KEEP= in your CREATE TABLE statement.

## Creating a Table from a Query Result
To create a new table that contains both columns and rows that are derived from an existing table or set of tables, use a CREATE TABLE statement that includes the keyword AS and the clauses that are used in a query. This method enables you to copy an existing table quickly.

## Inserting Rows of Data into a Table
The INSERT statement can be used in three ways to insert rows of data in existing tables, either empty or populated. You can insert rows by using
- the SET clause to specify column names and values in pairs
- the VALUES clause to specify a list of values
- the clauses that are used in a query to return rows from an existing table.

## Creating a Table That Has Integrity Constraints
Integrity constraints are rules that you can specify in order to restrict the data values that can be stored for a column in a table. To create a table that has integrity constraints, use a CREATE TABLE statement. Integrity constraints can be defined in two different ways in the CREATE TABLE statement:
- by specifying a column constraint in a column specification
- by using a constraint specification.

## Handling Errors in Row Insertions
When you add rows to a table that has integrity constraints, PROC SQL evaluates the new data to ensure that it meets the conditions that are determined by the integrity constraints. When you use the INSERT or UPDATE statement to add or modify data in a table, you can use the UNDO_POLICY= option in the PROC SQL statement to specify whether PROC SQL will make or undo the changes that you submitted up to the point of the error.

## Displaying Integrity Constraints for a Table
To display the integrity constraints for a specified table in the SAS log, use the DESCRIBE TABLE CONSTRAINTS statement.


## Updating Values in Existing Table Rows
To modify data values in some or all of the existing rows in a table, use the UPDATE statement with the following:
- a SET clause and possibly a WHERE clause that specifies a single expression to update rows. To update rows with multiple expressions, use multiple UPDATE statements.
- a CASE expression that specifies multiple expressions to update rows. The CASE expression can be specified without an optional case operand or, if the expression in the SET clause uses an equals (=) comparison operator, with a case operand.
The CASE expression can also be used in the SELECT statement in a new column definition to specify different values for different subsets of rows.

## Deleting Rows in a Table
To delete some or all of the rows in a table, use the DELETE statement.

## Altering Columns in a Table
To alter columns in a table, use the ALTER TABLE statement that contains one or more of the following clauses:
- the ADD clause, to add one or more columns to a table
- the DROP clause, to drop (delete) one or more columns in a table
- the MODIFY clause, to modify the attributes of columns in a table.

## Dropping Tables
To drop (delete) one or more entire tables, use the DROP TABLE statement.
