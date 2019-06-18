"
The SQLITE_OK result code means that the operation was successful and that there were no errors. Most other result codes indicate an error.
"
Class {
	#name : #SQLite3OKResult,
	#superclass : #SQLite3Result,
	#category : #'SQLite3-Core-Results'
}

{ #category : #'private - accessing' }
SQLite3OKResult class >> nativeResultCode [

	^ SQLITE_OK
]
