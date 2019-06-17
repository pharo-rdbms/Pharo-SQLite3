"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_FORMAT result code is not currently used.
"
Class {
	#name : #SQLite3Format,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Format class >> nativeErrorCode [

	^ SQLITE_FORMAT
]
