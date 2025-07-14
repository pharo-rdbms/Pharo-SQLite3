"
The SQLITE_IOERR_SHMLOCK error code is no longer used.
"
Class {
	#name : 'SQLite3IOErrorSharedMemoryLock',
	#superclass : 'SQLite3IOErrorSharedMemoryError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorSharedMemoryLock class >> nativeErrorCode [

	^ SQLITE_IOERR_SHMLOCK
]
