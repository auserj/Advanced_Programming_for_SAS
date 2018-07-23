# Summary

Using the MODIFY Statement
When you use the MODIFY statement to modify a SAS data set, SAS does not create a second copy of the data as it does when you use the SET, MERGE, or UPDATE statements. The descriptor portion of the SAS data set stays the same. Updated observations are written back to the same location as the original observation.
Modifying All Observations in a SAS Data Set
You can use the MODIFY statement with an assignment statement to modify all the observations in a SAS data set.

## Modifying Observations Using a Transaction Data Set
To modify a master data set using a transaction data set, you use the MODIFY statement with a BY statement to specify the matching variable or variables. When you use the MODIFY or BY statements, SAS uses a dynamic WHERE clause to locate observations in the master data set. You can specify how missing values in the transaction data set are handled by using the UPDATEMODE= option in the MODIFY statement.

## Modifying Observations Located by an Index
You can use the MODIFY statement with the KEY= option to name a simple or composite index for the SAS data set that is being modified. The KEY= argument retrieves observations from the master data set based on index values that are supplied by like-named variables in a transaction data set. If you have contiguous duplications in the transaction data set (that is, some that have no match in the master data set), you can use the UNIQUE option to cause a KEY= search to always begin at the top of the index file for each duplicate transaction.

## Controlling the Update Process
When the DATA step contains a MODIFY statement, SAS writes the current observation back to its original place in the SAS data set. This action by default occurs as the last action in the step as if a REPLACE statement were the last statement in the step. However, you can override this default behavior by explicitly adding the OUTPUT, REPLACE, or REMOVE statement.

You can use the automatic variable _IORC_ with the %SYSRC autocall macro to test for specific I/O error conditions that are created when you use the BY statement or the KEY= option in the MODIFY statement. The automatic variable _IORC_ contains a return code for each I/O operation that the MODIFY statement attempts to perform. The best way to test for values of _IORC_ is to use the mnemonic codes that are provided by the SYSRC autocall macro.

## Placing Integrity Constraints on a Data Set
Integrity constraints are rules that you can specify in order to restrict the data values that can be stored for a variable in a SAS data file. SAS enforces integrity constraints when values that are associated with a variable are added, updated, or deleted. You can place integrity constraints on an existing data set using the IC CREATE statement in the DATASETS procedure.

## Documenting and Removing Integrity Constraints
You can view information about the integrity constraints on a data set using the CONTENTS statement in the DATASETS procedure. If you want to remove integrity constraints from a file, you use the IC DELETE statement.

## Initiating and Terminating Audit Trails
An audit trail is an optional SAS file that logs modifications to a SAS table. You initiate an audit trail using the DATASETS procedure with the AUDIT and INITIATE statements. You also suspend, resume, and terminate audit trails using the DATASETS procedure. Once there is data in the audit trail file, you can read it with the TYPE= data set option.

## Controlling Data in the Audit Trail
The audit trail file can contain three types of variables:
- data set variables that store copies of the columns in the audited SAS data file
- audit trail variables that automatically store information about data modifications
- user variables that store user-entered information

You can use the LOG statement to control which types of records are written to an audit trail file.

## Initiating Generation Data Sets
Each generation of a generation data set is stored as part of a generation group. A new generation is created each time the data set is replaced. Each generation in a generation group has the same root member name, but each has a different version number. You initiate generation data sets by using the GENMAX= option to specify the number of generation data sets to keep.

## Processing Generation Data Sets
To select a particular generation to process, you use the GENNUM= data set option. GENNUM= is an input data set option that identifies which generation to open. The GENNUM can be a relative or absolute reference to a generation within a generation group. You can rename or delete generations using the CHANGE and DELETE statements in a PROC DATASETS step.




















