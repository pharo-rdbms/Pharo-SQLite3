"
The SQLITE_CONSTRAINT_FOREIGNKEY error code is an extended error code for SQLITE_CONSTRAINT indicating that a foreign key constraint failed.
"
Class {
	#name : 'SQLite3ConstraintViolationForeignKey',
	#superclass : 'SQLite3ConstraintViolation',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3ConstraintViolationForeignKey class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_FOREIGNKEY
]
