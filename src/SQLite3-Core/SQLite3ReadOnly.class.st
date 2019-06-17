"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_READONLY result code is returned when an attempt is made to alter some data for which the current database connection does not have write permission.
"
Class {
	#name : #SQLite3ReadOnly,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3ReadOnly class >> nativeErrorCode [

	^ SQLITE_READONLY
]
