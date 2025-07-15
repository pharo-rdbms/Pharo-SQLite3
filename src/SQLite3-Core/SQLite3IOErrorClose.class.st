"
The SQLITE_IOERR_CLOSE error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xClose method on the sqlite3_io_methods object.
"
Class {
	#name : 'SQLite3IOErrorClose',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorClose class >> nativeErrorCode [

	^ SQLITE_IOERR_CLOSE
]
