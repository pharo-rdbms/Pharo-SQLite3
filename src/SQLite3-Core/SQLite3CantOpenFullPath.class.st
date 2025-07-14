"
The SQLITE_CANTOPEN_FULLPATH error code is an extended error code for SQLITE_CANTOPEN indicating that a file open operation failed because the operating system was unable to convert the filename into a full pathname.
"
Class {
	#name : 'SQLite3CantOpenFullPath',
	#superclass : 'SQLite3CantOpen',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3CantOpenFullPath class >> nativeErrorCode [

	^ SQLITE_CANTOPEN_FULLPATH
]
