"
I provide SQLIte's constants.
"
Class {
	#name : #UDBCSQLite3Constants,
	#superclass : #SharedPool,
	#classVars : [
		'BLOB',
		'BUSY',
		'CONSTRAINT',
		'DONE',
		'ERROR',
		'FLOAT',
		'INTEGER',
		'LOCKED',
		'MISUSE',
		'NULL',
		'OK',
		'ROW',
		'TEXT'
	],
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #initialization }
UDBCSQLite3Constants class >> initialize [

	"C function return codes."
	OK := 0.	
	ERROR := 1.
	BUSY := 5.
	LOCKED := 6.
	CONSTRAINT := 19.	
	MISUSE := 21.
	ROW := 100.
	DONE := 101.
			
	"Types."
	INTEGER := 1.
	FLOAT := 2.
	TEXT := 3.
	BLOB := 4.	
	NULL := 5.

]
