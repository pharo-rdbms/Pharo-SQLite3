"
The SQLITE_CONSTRAINT_CHECK error code is an extended error code for SQLITE_CONSTRAINT indicating that a CHECK constraint failed.
"
Class {
	#name : 'SQLite3ConstraintViolationCheck',
	#superclass : 'SQLite3ConstraintViolation',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3ConstraintViolationCheck class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_CHECK
]
