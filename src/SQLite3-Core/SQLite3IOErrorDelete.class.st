"
The SQLITE_IOERR_DELETE error code is an extended error code for SQLITE_IOERR indicating an I/O error within xDelete method on the sqlite3_vfs object.
"
Class {
	#name : 'SQLite3IOErrorDelete',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorDelete class >> nativeErrorCode [

	^ SQLITE_IOERR_DELETE
]
