"
The SQLITE_WARNING_AUTOINDEX result code is passed to the callback of sqlite3_log() whenever automatic indexing is used. This can serve as a warning to application designers that the database might benefit from additional indexes.
"
Class {
	#name : 'SQLite3LogWarningAutoIndex',
	#superclass : 'SQLite3LogWarning',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3LogWarningAutoIndex class >> nativeErrorCode [

	^ SQLITE_WARNING_AUTOINDEX
]
