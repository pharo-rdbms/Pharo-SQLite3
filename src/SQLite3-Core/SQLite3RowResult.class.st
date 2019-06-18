"
The SQLITE_ROW result code returned by sqlite3_step() indicates that another row of output is available.
"
Class {
	#name : #SQLite3RowResult,
	#superclass : #SQLite3Result,
	#category : #'SQLite3-Core-Results'
}

{ #category : #'private - accessing' }
SQLite3RowResult class >> nativeResultCode [

	^ SQLITE_ROW
]
