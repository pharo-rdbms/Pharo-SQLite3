"
The SQLITE_CONSTRAINT_TRIGGER error code is an extended error code for SQLITE_CONSTRAINT indicating that a RAISE function within a trigger fired, causing the SQL statement to abort.
"
Class {
	#name : #SQLite3ConstraintViolationTrigger,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationTrigger class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_TRIGGER
]
