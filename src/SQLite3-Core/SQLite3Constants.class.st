"
I provide SQLIte's constants.
"
Class {
	#name : #SQLite3Constants,
	#superclass : #SharedPool,
	#classVars : [
		'SQLITE3_TEXT',
		'SQLITE_ABORT',
		'SQLITE_AUTH',
		'SQLITE_BLOB',
		'SQLITE_BUSY',
		'SQLITE_CANTOPEN',
		'SQLITE_CONSTRAINT',
		'SQLITE_CORRUPT',
		'SQLITE_DONE',
		'SQLITE_EMPTY',
		'SQLITE_ERROR',
		'SQLITE_FLOAT',
		'SQLITE_FORMAT',
		'SQLITE_FULL',
		'SQLITE_INTEGER',
		'SQLITE_INTERNAL',
		'SQLITE_INTERRUPT',
		'SQLITE_IOERR',
		'SQLITE_LOCKED',
		'SQLITE_MISMATCH',
		'SQLITE_MISUSE',
		'SQLITE_NOLFS',
		'SQLITE_NOMEM',
		'SQLITE_NOTADB',
		'SQLITE_NOTFOUND',
		'SQLITE_NOTICE',
		'SQLITE_NULL',
		'SQLITE_OK',
		'SQLITE_PERM',
		'SQLITE_PROTOCOL',
		'SQLITE_RANGE',
		'SQLITE_READONLY',
		'SQLITE_ROW',
		'SQLITE_SCHEMA',
		'SQLITE_TEXT',
		'SQLITE_TOOBIG',
		'SQLITE_WARNING'
	],
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'private - initialization' }
SQLite3Constants class >> initConstants [

	SQLITE_OK := 0.		 			"Successful result"
	SQLITE_ERROR := 1. 			"SQL error or missing database"
	SQLITE_INTERNAL := 2.			"Internal logic error in SQLite"
	SQLITE_PERM := 3.				"Access permission denied"	
	SQLITE_ABORT := 4.				"Callback routine requested an abort"											
	SQLITE_BUSY := 5.  			"The database file is locked" 
	SQLITE_LOCKED := 6. 			"A table in the database is locked"
	SQLITE_NOMEM := 7.				"A malloc() failed"
	SQLITE_READONLY := 8.			"Attempt to write a readonly database"
	SQLITE_INTERRUPT := 9.		"Operation terminated by sqlite3_interrupt()"
	SQLITE_IOERR := 10.			"Some kind of disk I/O error occurred"
	SQLITE_CORRUPT := 11.			"The database disk image is malformed"
	SQLITE_NOTFOUND := 12.		"Unknown opcode in sqlite3_file_control()"							
	SQLITE_FULL := 13.				"Insertion failed because database is full"	
	SQLITE_CANTOPEN := 14.   	"Unable to open the database file"
	SQLITE_PROTOCOL := 15.		"Database lock protocol error"
	SQLITE_EMPTY := 16.			"Database is empty"
	SQLITE_SCHEMA := 17.			"The database schema changed"
	SQLITE_TOOBIG := 18.			"String or BLOB exceeds size limit"			
	SQLITE_CONSTRAINT := 19.		"Abort due to constraint violation"
	SQLITE_MISMATCH := 20.		"Data type mismatch"		
	SQLITE_MISUSE := 21. 			"Library used incorrectly"
	SQLITE_NOLFS := 22.			"Uses OS features not supported on host"	
	SQLITE_AUTH := 23.				"Authorization denied"			
	SQLITE_FORMAT := 24.			"Auxiliary database format error"	
	SQLITE_RANGE := 25.			"2nd parameter to sqlite3_bind out of range"
	SQLITE_NOTADB := 26.			"File opened that is not a database file"
	SQLITE_NOTICE := 27.			"Notifications from sqlite3_log()"
	SQLITE_WARNING := 28.			"Warnings from sqlite3_log()"
																			
	SQLITE_ROW := 100.				"sqlite3_step() has another row ready"
	SQLITE_DONE := 101.			"sqlite3_step() has finished executing"

]

{ #category : #'private - initialization' }
SQLite3Constants class >> initDataTypes [
	"Fundamental Datatypes"
	
	SQLITE_INTEGER := 1.
	SQLITE_FLOAT := 2.
	SQLITE_TEXT := 3.
	SQLITE3_TEXT := 3.
	SQLITE_BLOB := 4.	
	SQLITE_NULL := 5
			
	
]

{ #category : #initialization }
SQLite3Constants class >> initialize [
	self 
		initConstants;
		initDataTypes
			
	
]
