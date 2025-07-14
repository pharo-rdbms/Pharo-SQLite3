"
The SQLITE_BUSY_RECOVERY error code is an extended error code for SQLITE_BUSY that indicates that an operation could not continue because another process is busy recovering a WAL mode database file following a crash. The SQLITE_BUSY_RECOVERY error code only occurs on WAL mode databases.
"
Class {
	#name : 'SQLite3BusyRecovery',
	#superclass : 'SQLite3Busy',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3BusyRecovery class >> nativeErrorCode [

	^ SQLITE_BUSY_RECOVERY
]
