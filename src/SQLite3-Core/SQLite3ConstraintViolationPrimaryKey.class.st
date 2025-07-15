"
The SQLITE_CONSTRAINT_PRIMARYKEY error code is an extended error code for SQLITE_CONSTRAINT indicating that a PRIMARY KEY constraint failed.
"
Class {
	#name : 'SQLite3ConstraintViolationPrimaryKey',
	#superclass : 'SQLite3ConstraintViolation',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3ConstraintViolationPrimaryKey class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_PRIMARYKEY
]
