"
The SQLITE_NOTICE_RECOVER_WAL result code is passed to the callback of sqlite3_log() when a WAL mode database file is recovered.
"
Class {
	#name : #SQLite3LogNoticeRecoverWriteAheadLogging,
	#superclass : #SQLite3LogNotice,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3LogNoticeRecoverWriteAheadLogging class >> nativeErrorCode [

	^ SQLITE_NOTICE_RECOVER_WAL
]
