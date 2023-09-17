"
The SQLITE_IOERR_BLOCKED error code is no longer used.
"
Class {
	#name : #SQLite3IOErrorBlocked,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorBlocked class >> nativeErrorCode [

	^ SQLITE_IOERR_BLOCKED
]
