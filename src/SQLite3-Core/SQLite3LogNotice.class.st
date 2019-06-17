"
The SQLITE_NOTICE result code is not returned by any C/C++ interface. However, SQLITE_NOTICE (or rather one of its extended error codes) is sometimes used as the first argument in an sqlite3_log() callback to indicate that an unusual operation is taking place.
"
Class {
	#name : #SQLite3LogNotice,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3LogNotice class >> nativeErrorCode [

	^ SQLITE_NOTICE
]
