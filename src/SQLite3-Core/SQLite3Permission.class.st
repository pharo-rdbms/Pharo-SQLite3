"
The SQLITE_PERM result code indicates that the requested access mode for a newly created database could not be provided.
"
Class {
	#name : #SQLite3Permission,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Permission class >> nativeErrorCode [

	^ SQLITE_PERM
]
