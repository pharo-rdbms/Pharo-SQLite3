"
The SQLITE_CANTOPEN_ISDIR error code is an extended error code for SQLITE_CANTOPEN indicating that a file open operation failed because the file is really a directory.
"
Class {
	#name : 'SQLite3CantOpenIsDir',
	#superclass : 'SQLite3CantOpen',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3CantOpenIsDir class >> nativeErrorCode [

	^ SQLITE_CANTOPEN_ISDIR
]
