"
The SQLITE_IOERR_GETTEMPPATH error code is an extended error code for SQLITE_IOERR indicating that the VFS is unable to determine a suitable directory in which to place temporary files.
"
Class {
	#name : #SQLite3IOErrorGetTempPath,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorGetTempPath class >> nativeErrorCode [

	^ SQLITE_IOERR_GETTEMPPATH
]
