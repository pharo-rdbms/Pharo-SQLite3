"
The SQLITE_RANGE error indices that the parameter number argument to one of the sqlite3_bind routines or the column number in one of the sqlite3_column routines is out of range.
"
Class {
	#name : #SQLite3OutOfRange,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3OutOfRange class >> nativeErrorCode [

	^ SQLITE_RANGE
]
