"
The SQLITE_IOERR_RDLOCK error code is an extended error code for SQLITE_IOERR indicating an I/O error within xLock method on the sqlite3_io_methods object while trying to obtain a read lock.
"
Class {
	#name : 'SQLite3IOErrorReadLock',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorReadLock class >> nativeErrorCode [

	^ SQLITE_IOERR_RDLOCK
]
