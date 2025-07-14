"
The SQLITE_CONSTRAINT_FUNCTION error code is not currently used by the SQLite core. However, this error code is available for use by extension functions.
"
Class {
	#name : 'SQLite3ConstraintViolationFunction',
	#superclass : 'SQLite3ConstraintViolation',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3ConstraintViolationFunction class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_FUNCTION
]
