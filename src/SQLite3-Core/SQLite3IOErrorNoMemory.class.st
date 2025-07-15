"
The SQLITE_IOERR_NOMEM error code is sometimes returned by the VFS layer to indicate that an operation could not be completed due to the inability to allocate sufficient memory. This error code is normally converted into SQLITE_NOMEM by the higher layers of SQLite before being returned to the application.
"
Class {
	#name : 'SQLite3IOErrorNoMemory',
	#superclass : 'SQLite3IOError',
	#category : 'SQLite3-Core-Errors-Extended',
	#package : 'SQLite3-Core',
	#tag : 'Errors-Extended'
}

{ #category : 'private - accessing' }
SQLite3IOErrorNoMemory class >> nativeErrorCode [

	^ SQLITE_IOERR_NOMEM
]
