"
The SQLITE_WARNING result code is not returned by any C/C++ interface. However, SQLITE_WARNING (or rather one of its extended error codes) is sometimes used as the first argument in an sqlite3_log() callback to indicate that an unusual and possibly ill-advised operation is taking place.
"
Class {
	#name : #SQLite3LogWarning,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3LogWarning class >> nativeErrorCode [

	^ SQLITE_WARNING
]
