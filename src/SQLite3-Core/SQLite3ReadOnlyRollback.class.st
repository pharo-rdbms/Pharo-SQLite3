"
The SQLITE_READONLY_ROLLBACK error code is an extended error code for SQLITE_READONLY. The SQLITE_READONLY_ROLLBACK error code indicates that a database cannot be opened because it has a hot journal that needs to be rolled back but cannot because the database is readonly.
"
Class {
	#name : #SQLite3ReadOnlyRollback,
	#superclass : #SQLite3ReadOnly,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ReadOnlyRollback class >> nativeErrorCode [

	^ SQLITE_READONLY_ROLLBACK
]
