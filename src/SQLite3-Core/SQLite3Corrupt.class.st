"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_CORRUPT result code indicates that the database file has been corrupted. See the How To Corrupt Your Database Files for further discussion on how corruption can occur.
"
Class {
	#name : 'SQLite3Corrupt',
	#superclass : 'SQLite3NativeError',
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'private - accessing' }
SQLite3Corrupt class >> nativeErrorCode [

	^ SQLITE_CORRUPT
]
