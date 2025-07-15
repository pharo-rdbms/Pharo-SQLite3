"
The SQLITE_IOERR_DIR_CLOSE error code is no longer used.
"
Class {
	#name : 'SQLite3IOErrorDirClose',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorDirClose class >> nativeErrorCode [

	^ SQLITE_IOERR_DIR_CLOSE
]
