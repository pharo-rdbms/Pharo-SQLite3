"
The SQLITE_CONSTRAINT_NOTNULL error code is an extended error code for SQLITE_CONSTRAINT indicating that a NOT NULL constraint failed.
"
Class {
	#name : #SQLite3ConstraintViolationNotNull,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationNotNull class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_NOTNULL
]
