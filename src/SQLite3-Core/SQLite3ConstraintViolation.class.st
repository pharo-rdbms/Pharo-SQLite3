"
The SQLITE_CONSTRAINT error code means that an SQL constraint violation occurred while trying to process an SQL statement. Additional information about the failed constraint can be found by consulting the accompanying error message (returned via sqlite3_errmsg() or sqlite3_errmsg16()) or by looking at the extended error code.

The SQLITE_CONSTRAINT code can also be used as the return value from the xBestIndex() method of a virtual table implementation. When xBestIndex() returns SQLITE_CONSTRAINT, that indicates that the particular combination of inputs submitted to xBestIndex() cannot result in a usable query plan and should not be given further consideration.
"
Class {
	#name : #SQLite3ConstraintViolation,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolation class >> nativeErrorCode [
	
	^ SQLITE_CONSTRAINT
]
