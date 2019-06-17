"
The SQLITE_IOERR_SEEK error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xRead or xWrite methods on the sqlite3_io_methods object while trying to seek a file descriptor to the beginning point of the file where the read or write is to occur.
"
Class {
	#name : #SQLite3IOErrorSeek,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorSeek class >> nativeErrorCode [ 

	^ SQLITE_IOERR_SEEK
]
