"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_ERROR result code is a generic error code that is used when no other more specific error code is available.
"
Class {
	#name : 'SQLite3Error',
	#superclass : 'SQLite3NativeError',
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'private - accessing' }
SQLite3Error class >> nativeErrorCode [

	^ SQLITE_ERROR
]
