"
The SQLITE_DONE result code indicates that an operation has completed. The SQLITE_DONE result code is most commonly seen as a return value from sqlite3_step() indicating that the SQL statement has run to completion. But SQLITE_DONE can also be returned by other multi-step interfaces such as sqlite3_backup_step().
"
Class {
	#name : 'SQLite3DoneResult',
	#superclass : 'SQLite3Result',
	#category : 'SQLite3-Core-Results',
	#package : 'SQLite3-Core',
	#tag : 'Results'
}

{ #category : 'private - accessing' }
SQLite3DoneResult class >> nativeResultCode [

	^ SQLITE_DONE
]
