"
I provide SQLIte's constants.
"
Class {
	#name : #UDBCSQLiteConstants,
	#superclass : #SharedPool,
	#classVars : [
		'BLOB',
		'BUSY',
		'FLOAT',
		'INTEGER',
		'LOCKED',
		'MISUSE',
		'NULL',
		'OK',
		'TEXT'
	],
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #initialization }
UDBCSQLiteConstants class >> initialize [

	OK := 0.	
	INTEGER := 1.
	FLOAT := 2.
	TEXT := 3.
	BLOB := 4.	
	BUSY := 5.
	NULL := 5.
	LOCKED := 6.	
	MISUSE := 21.
]
