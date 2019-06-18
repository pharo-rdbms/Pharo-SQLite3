"
The SQLITE_ABORT_ROLLBACK error code is an extended error code for SQLITE_ABORT indicating that an SQL statement aborted because the transaction that was active when the SQL statement first started was rolled back. Pending write operations always fail with this error when a rollback occurs. A ROLLBACK will cause a pending read operation to fail only if the schema was changed within the transaction being rolled back.
"
Class {
	#name : #SQLite3AbortRollback,
	#superclass : #SQLite3Abort,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3AbortRollback class >> nativeErrorCode [

	^ SQLITE_ABORT_ROLLBACK
]
