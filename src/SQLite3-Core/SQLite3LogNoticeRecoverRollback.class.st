"
The SQLITE_NOTICE_RECOVER_ROLLBACK result code is passed to the callback of sqlite3_log() when a hot journal is rolled back.
"
Class {
	#name : #SQLite3LogNoticeRecoverRollback,
	#superclass : #SQLite3LogNotice,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3LogNoticeRecoverRollback class >> nativeErrorCode [

	^ SQLITE_NOTICE_RECOVER_ROLLBACK
]
