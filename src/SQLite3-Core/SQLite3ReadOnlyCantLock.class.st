"
The SQLITE_READONLY_CANTLOCK error code is an extended error code for SQLITE_READONLY. The SQLITE_READONLY_CANTLOCK error code indicates that SQLite is unable to obtain a read lock on a WAL mode database because the shared-memory file associated with that database is read-only.
"
Class {
	#name : #SQLite3ReadOnlyCantLock,
	#superclass : #SQLite3ReadOnly,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ReadOnlyCantLock class >> nativeErrorCode [

	^ SQLITE_READONLY_CANTLOCK
]
