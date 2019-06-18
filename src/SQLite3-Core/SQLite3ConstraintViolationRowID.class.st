"
The SQLITE_CONSTRAINT_ROWID error code is an extended error code for SQLITE_CONSTRAINT indicating that a rowid is not unique.
"
Class {
	#name : #SQLite3ConstraintViolationRowID,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationRowID class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_ROWID
]
