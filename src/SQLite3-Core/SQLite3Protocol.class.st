"
The SQLITE_PROTOCOL result code indicates a problem with the file locking protocol used by SQLite. The SQLITE_PROTOCOL error is currently only returned when using WAL mode and attempting to start a new transaction. There is a race condition that can occur when two separate database connections both try to start a transaction at the same time in WAL mode. The loser of the race backs off and tries again, after a brief delay. If the same connection loses the locking race dozens of times over a span of multiple seconds, it will eventually give up and return SQLITE_PROTOCOL. The SQLITE_PROTOCOL error should appear in practice very, very rarely, and only when there are many separate processes all competing intensely to write to the same database.
"
Class {
	#name : #SQLite3Protocol,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Protocol class >> nativeErrorCode [

	^ SQLITE_PROTOCOL
]
