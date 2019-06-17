"
The SQLITE_IOERR_SHMSIZE error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xShmMap method on the sqlite3_io_methods object while trying to enlarge a ""shm"" file as part of WAL mode transaction processing. This error may indicate that the underlying filesystem volume is out of space.
"
Class {
	#name : #SQLite3IOErrorSharedMemorySize,
	#superclass : #SQLite3IOErrorSharedMemoryError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorSharedMemorySize class >> nativeErrorCode [ 

	^ SQLITE_IOERR_SHMSIZE
]
