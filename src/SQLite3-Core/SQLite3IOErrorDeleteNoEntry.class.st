"
The SQLITE_IOERR_DELETE_NOENT error code is an extended error code for SQLITE_IOERR indicating that the xDelete method on the sqlite3_vfs object failed because the file being deleted does not exist.
"
Class {
	#name : #SQLite3IOErrorDeleteNoEntry,
	#superclass : #SQLite3IOErrorDelete,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorDeleteNoEntry class >> nativeErrorCode [

	^ SQLITE_IOERR_DELETE_NOENT
]
