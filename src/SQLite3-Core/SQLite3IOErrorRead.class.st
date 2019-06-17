"
The SQLITE_IOERR_READ error code is an extended error code for SQLITE_IOERR indicating an I/O error in the VFS layer while trying to read from a file on disk. This error might result from a hardware malfunction or because a filesystem came unmounted while the file was open.
"
Class {
	#name : #SQLite3IOErrorRead,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorRead class >> nativeErrorCode [ 

	^ SQLITE_IOERR_READ
]
