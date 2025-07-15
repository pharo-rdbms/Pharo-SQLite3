"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_ABORT result code indicates that an operation was aborted prior to completion, usually be application request. See also: SQLITE_INTERRUPT.

If the callback function to sqlite3_exec() returns non-zero, then sqlite3_exec() will return SQLITE_ABORT.

If a ROLLBACK operation occurs on the same database connection as a pending read or write, then the pending read or write may fail with an SQLITE_ABORT or SQLITE_ABORT_ROLLBACK error.

In addition to being a result code, the SQLITE_ABORT value is also used as a conflict resolution mode returned from the sqlite3_vtab_on_conflict() interface.
"
Class {
	#name : 'SQLite3Abort',
	#superclass : 'SQLite3NativeError',
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'private - accessing' }
SQLite3Abort class >> nativeErrorCode [

	^ SQLITE_ABORT
]
