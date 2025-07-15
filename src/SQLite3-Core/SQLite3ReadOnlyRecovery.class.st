"
The SQLITE_READONLY_RECOVERY error code is an extended error code for SQLITE_READONLY. The SQLITE_READONLY_RECOVERY error code indicates that a WAL mode database cannot be opened because the database file needs to be recovered and recovery requires write access but only read access is available.
"
Class {
	#name : 'SQLite3ReadOnlyRecovery',
	#superclass : 'SQLite3ReadOnly',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3ReadOnlyRecovery class >> nativeErrorCode [

	^ SQLITE_READONLY_RECOVERY
]
