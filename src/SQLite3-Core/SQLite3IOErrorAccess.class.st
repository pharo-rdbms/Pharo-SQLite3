"
The SQLITE_IOERR_ACCESS error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xAccess method on the sqlite3_vfs object.
"
Class {
	#name : #SQLite3IOErrorAccess,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorAccess class >> nativeErrorCode [

	^ SQLITE_IOERR_ACCESS
]
