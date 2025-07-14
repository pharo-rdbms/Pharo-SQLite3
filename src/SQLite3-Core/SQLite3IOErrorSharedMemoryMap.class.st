"
The SQLITE_IOERR_SHMMAP error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xShmMap method on the sqlite3_io_methods object while trying to map a shared memory segment into the process address space.
"
Class {
	#name : 'SQLite3IOErrorSharedMemoryMap',
	#superclass : 'SQLite3IOErrorSharedMemoryError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorSharedMemoryMap class >> nativeErrorCode [

	^ SQLITE_IOERR_SHMMAP
]
