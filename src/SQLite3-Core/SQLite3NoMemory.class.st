"
The SQLITE_NOMEM result code indicates that SQLite was unable to allocate all the memory it needed to complete the operation. In other words, an internal call to sqlite3_malloc() or sqlite3_realloc() has failed in a case where the memory being allocated was required in order to continue the operation.
"
Class {
	#name : #SQLite3NoMemory,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3NoMemory class >> nativeErrorCode [

	^SQLITE_NOMEM
]
