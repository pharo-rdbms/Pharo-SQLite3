"
The SQLITE_READONLY_DBMOVED error code is an extended error code for SQLITE_READONLY. The SQLITE_READONLY_DBMOVED error code indicates that a database cannot be modified because the database file has been moved since it was opened, and so any attempt to modify the database might result in database corruption if the processes crashes because the rollback journal would not be correctly named.
"
Class {
	#name : #SQLite3ReadOnlyDBMoved,
	#superclass : #SQLite3ReadOnly,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3ReadOnlyDBMoved class >> nativeErrorCode [

	^ SQLITE_READONLY_DBMOVED
]
