"
The SQLITE_CONSTRAINT_COMMITHOOK error code is an extended error code for SQLITE_CONSTRAINT indicating that a commit hook callback returned non-zero that thus caused the SQL statement to be rolled back.
"
Class {
	#name : #SQLite3ConstraintViolationCommitHook,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationCommitHook class >> nativeErrorCode [

	^ SQLITE_CONSTRAINT_COMMITHOOK
]
