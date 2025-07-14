"
The SQLITE_IOERR_CHECKRESERVEDLOCK error code is an extended error code for SQLITE_IOERR indicating an I/O error within the xCheckReservedLock method on the sqlite3_io_methods object.
"
Class {
	#name : 'SQLite3IOErrorCheckReservedLock',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorCheckReservedLock class >> nativeErrorCode [

	^ SQLITE_IOERR_CHECKRESERVEDLOCK
]
