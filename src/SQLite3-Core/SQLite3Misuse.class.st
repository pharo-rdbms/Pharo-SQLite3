"
The SQLITE_MISUSE return code might be returned if the application uses any SQLite interface in a way that is undefined or unsupported. For example, using a prepared statement after that prepared statement has been finalized might result in an SQLITE_MISUSE error.

SQLite tries to detect misuse and report the misuse using this result code. However, there is no guarantee that the detection of misuse will be successful. Misuse detection is probabilistic. Applications should never depend on an SQLITE_MISUSE return value.

If SQLite ever returns SQLITE_MISUSE from any interface, that means that the application is incorrectly coded and needs to be fixed. Do not ship an application that sometimes returns SQLITE_MISUSE from a standard SQLite interface because that application contains potentially serious bugs.
"
Class {
	#name : #SQLite3Misuse,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Misuse class >> nativeErrorCode [

	^ SQLITE_MISUSE
]
