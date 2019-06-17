"
I provide SQLIte's constants.
"
Class {
	#name : #SQLite3Constants,
	#superclass : #SharedPool,
	#classVars : [
		'SQLITE3_TEXT',
		'SQLITE_BLOB',
		'SQLITE_BUSY',
		'SQLITE_CONSTRAINT',
		'SQLITE_DONE',
		'SQLITE_ERROR',
		'SQLITE_FLOAT',
		'SQLITE_INTEGER',
		'SQLITE_LOCKED',
		'SQLITE_MISUSE',
		'SQLITE_NULL',
		'SQLITE_OK',
		'SQLITE_ROW',
		'SQLITE_TEXT'
	],
	#category : #'SQLite3-Core-UFFI-Support'
}

{ #category : #'private - initialization' }
SQLite3Constants class >> initConstants [

	SQLITE_OK := 0.		 			"Successful result"
	SQLITE_ERROR := 1. 			"SQL error or missing database"
	SQLITE_BUSY := 5.  			"The database file is locked" 
 
	SQLITE_LOCKED := 6. 			"A table in the database is locked"
	SQLITE_CONSTRAINT := 19.		"Abort due to constraint violation"
	SQLITE_MISUSE := 21. 			"Library used incorrectly"
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
