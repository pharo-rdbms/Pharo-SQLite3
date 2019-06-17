"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_INTERNAL result code indicates an internal malfunction. In a working version of SQLite, an application should never see this result code. If application does encounter this result code, it shows that there is a bug in the database engine.

SQLite does not currently generate this result code. However, application-defined SQL functions or virtual tables, or VFSes, or other extensions might cause this result code to be returned.
"
Class {
	#name : #SQLite3Internal,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Internal class >> nativeErrorCode [
	
	^ SQLITE_INTERNAL
]
