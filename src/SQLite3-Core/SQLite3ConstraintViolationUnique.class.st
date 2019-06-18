"
The SQLITE_CONSTRAINT_UNIQUE error code is an extended error code for SQLITE_CONSTRAINT indicating that a UNIQUE constraint failed.
"
Class {
	#name : #SQLite3ConstraintViolationUnique,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationUnique class >> nativeErrorCode [ 

	^ SQLITE_CONSTRAINT_UNIQUE
]
