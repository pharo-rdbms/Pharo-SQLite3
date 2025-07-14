"
The SQLITE_LOCKED_SHAREDCACHE error code is an extended error code for SQLITE_LOCKED indicating that the locking conflict has occurred due to contention with a different database connection that happens to hold a shared cache with the database connection to which the error was returned. For example, if the other database connection is holding an exclusive lock on the database, then the database connection that receives this error will be unable to read or write any part of the database file unless it has the read_uncommitted pragma enabled.

The SQLITE_LOCKED_SHARECACHE error code works very much like the SQLITE_BUSY error code except that SQLITE_LOCKED_SHARECACHE is for separate database connections that share a cache whereas SQLITE_BUSY is for the much more common case of separate database connections that do not share the same cache. Also, the sqlite3_busy_handler() and sqlite3_busy_timeout() interfaces do not help in resolving SQLITE_LOCKED_SHAREDCACHE conflicts.
"
Class {
	#name : 'SQLite3LockedSharedCache',
	#superclass : 'SQLite3Locked',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3LockedSharedCache class >> nativeErrorCode [

	^ SQLITE_LOCKED_SHAREDCACHE
]
