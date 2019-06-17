"
The SQLITE_IOERR_SHMOPEN error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xShmMap method on the sqlite3_io_methods object while trying to open a new shared memory segment.
"
Class {
	#name : #SQLite3IOErrorSharedMemoryOpen,
	#superclass : #SQLite3IOErrorSharedMemoryError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorSharedMemoryOpen class >> nativeErrorCode [ 

	^ SQLITE_IOERR_SHMOPEN
]
