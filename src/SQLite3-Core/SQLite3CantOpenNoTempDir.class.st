"
The SQLITE_CANTOPEN_NOTEMPDIR error code is no longer used.
"
Class {
	#name : 'SQLite3CantOpenNoTempDir',
	#superclass : 'SQLite3CantOpen',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3CantOpenNoTempDir class >> nativeErrorCode [

	^ SQLITE_CANTOPEN_NOTEMPDIR
]
