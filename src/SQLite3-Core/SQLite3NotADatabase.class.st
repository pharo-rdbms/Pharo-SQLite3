"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

When attempting to open a file, the SQLITE_NOTADB error indicates that the file being opened does not appear to be an SQLite database file.
"
Class {
	#name : #SQLite3NotADatabase,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3NotADatabase class >> nativeErrorCode [

	^ SQLITE_NOTADB
]
