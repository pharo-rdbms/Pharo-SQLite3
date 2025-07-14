"
The SQLITE_BUSY_SNAPSHOT error code is an extended error code for SQLITE_BUSY that occurs on WAL mode databases when a database connection tries to promote a read transaction into a write transaction but finds that another database connection has already written to the database and thus invalidated prior reads.

The following scenario illustrates how an SQLITE_BUSY_SNAPSHOT error might arise:

1. Process A starts a read transaction on the database and does one or more SELECT statement. Process A keeps the transaction open.
2. Process B updates the database, changing values previous read by process A.
3. Process A now tries to write to the database. But process A's view of the database content is now obsolete because process B has modified the database file after process A read from it. Hence process A gets an SQLITE_BUSY_SNAPSHOT error.
"
Class {
	#name : 'SQLite3BusySnapshot',
	#superclass : 'SQLite3Busy',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3BusySnapshot class >> nativeErrorCode [

	^ SQLITE_BUSY_SNAPSHOT
]
