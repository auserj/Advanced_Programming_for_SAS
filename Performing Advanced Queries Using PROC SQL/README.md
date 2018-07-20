# Summary

## Viewing SELECT Statement Syntax
The SELECT statement and its subordinate clauses are the building blocks that you use to construct all PROC SQL queries.

## Displaying All Columns
To display all columns in the order in which they are stored in the table, use an asterisk (*) in the SELECT clause. To write the expanded list of columns to the SAS log, use the FEEDBACK option in the PROC SQL statement.

## Limiting the Number of Rows Displayed
To limit the number of rows that PROC SQL displays as output, use the OUTOBS=n option in the PROC SQL statement.

## Eliminating Duplicate Rows from Output
To eliminate duplicate rows from your query results, use the keyword DISTINCT in the SELECT clause.

## Subsetting Rows By Using Conditional Operators
In a PROC SQL query, use the WHERE clause with any valid SAS expression to subset data. The SAS expression can contain one or more operators, including the following conditional operators:
- the BETWEEN-AND operator selects within an inclusive range of values
- the CONTAINS or ? operator selects a character string
- the IN operator selects from a list of fixed values
- the IS MISSING or IS NULL operator selects missing values
- the LIKE operator selects a pattern
- the sounds-like (=*) operator selects a spelling variation

## Subsetting Rows By Using Calculated Values
It is important to understand how PROC SQL processes calculated columns. When you use a column alias in the WHERE clause to refer to a calculated value, you must use the keyword CALCULATED with the alias.

## Enhancing Query Output
You can enhance PROC SQL query output by using SAS enhancements such as column formats and labels, titles and footnotes, and character constraints.

## Summarizing and Grouping Data
PROC SQL calculates summary functions and outputs results differently, depending on a combination of factors:
- whether the summary function specifies one or more multiple columns as arguments
- whether the query contains a GROUP BY clause
- if the summary function is specified in a SELECT clause, whether there are additional columns listed that are outside the summary function
- whether the WHERE clause, if there is one, contains only columns that are specified in the SELECT clause.
To count nonmissing values, use the COUNT summary function.

To select the groups to be displayed, use a HAVING clause following a GROUP BY clause.

When you use a summary function in a SELECT clause or a HAVING clause, in some situations, PROC SQL must remerge data. When PROC SQL remerges data, it makes two passes through the data, and this requires additional processing time.


## Subsetting Data By Using Subqueries
In the WHERE clause or the HAVING clause of a PROC SQL query, you can use a subquery to subset data. A subquery is a query that is nested in, and is part of, another query. Subqueries can return values from a single row or multiple rows to the outer query but can return values only from a single column.

## Subsetting Data By Using Noncorrelated Subqueries
Noncorrelated subqueries execute independently of the outer query. You can use noncorrelated subqueries that return a single value or multiple values. To further qualify a comparison specified in a WHERE clause or a HAVING clause, you can use the conditional operators ANY and ALL immediately before a noncorrelated (or correlated) subquery.

## Subsetting Data By Using Correlated Subqueries
Correlated subqueries cannot be evaluated independently because their results are dependent on the values returned by the outer query. In the WHERE clause or the HAVING clause of an outer query, you can use the EXISTS and NOT EXISTS conditional operators to test for the existence or non-existence of a set of values returned by the subquery.

## Validating Query Syntax
To check the validity of the query syntax without actually executing the query, use the NOEXEC option or the VALIDATE keyword.

## Additional Features
PROC SQL supports many statements in addition to the SELECT statement.


