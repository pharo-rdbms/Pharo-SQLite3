"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_CANTOPEN result code indicates that SQLite was unable to open a file. The file in question might be a primary database file or one of several temporary disk files.
"
Class {
	#name : 'SQLite3CantOpen',
	#superclass : 'SQLite3NativeError',
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'private - accessing' }
SQLite3CantOpen class >> nativeErrorCode [

	^ SQLITE_CANTOPEN
]
