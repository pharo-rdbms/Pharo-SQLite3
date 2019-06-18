"
The SQLITE_CONSTRAINT_VTAB error code is not currently used by the SQLite core. However, this error code is available for use by application-defined virtual tables.
"
Class {
	#name : #SQLite3ConstraintViolationVirtualTable,
	#superclass : #SQLite3ConstraintViolation,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ConstraintViolationVirtualTable class >> nativeErrorCode [ 

	^ SQLITE_CONSTRAINT_VTAB
]
