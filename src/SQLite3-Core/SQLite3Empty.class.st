"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_EMPTY result code is not currently used.
"
Class {
	#name : #SQLite3Empty,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Empty class >> nativeErrorCode [

	^ SQLITE_EMPTY
]
