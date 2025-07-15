"
The SQLITE_CORRUPT_VTAB error code is an extended error code for SQLITE_CORRUPT used by virtual tables. A virtual table might return SQLITE_CORRUPT_VTAB to indicate that content in the virtual table is corrupt.
"
Class {
	#name : 'SQLite3CorruptVirtualTable',
	#superclass : 'SQLite3Corrupt',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3CorruptVirtualTable class >> nativeErrorCode [

	^ SQLITE_CORRUPT_VTAB
]
