"
I provide SQLIte's constants.
"
Class {
	#name : #SQLite3Constants,
	#superclass : #SharedPool,
	#classVars : [
		'BLOB',
		'FLOAT',
		'INTEGER',
		'NULL',
		'SQLITE_BUSY',
		'SQLITE_CONSTRAINT',
		'SQLITE_DONE',
		'SQLITE_ERROR',
		'SQLITE_LOCKED',
		'SQLITE_MISUSE',
		'SQLITE_OK',
		'SQLITE_ROW',
		'TEXT'
	],
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #initialization }
SQLite3Constants class >> initialize [
	SQLITE_OK := 0.		 			"Successful result"
	SQLITE_ERROR := 1. 			"SQL error or missing database"
	SQLITE_BUSY := 5.  			"The database file is locked" 
 
	SQLITE_LOCKED := 6. 			"A table in the database is locked"
	SQLITE_CONSTRAINT := 19.		"Abort due to constraint violation"
	SQLITE_MISUSE := 21. 			"Library used incorrectly"
	SQLITE_ROW := 100.				"sqlite3_step() has another row ready"
	SQLITE_DONE := 101.			"sqlite3_step() has finished executing"
			
	"Types."
	INTEGER := 1.
	FLOAT := 2.
	TEXT := 3.
	BLOB := 4.	
	NULL := 5.

]
