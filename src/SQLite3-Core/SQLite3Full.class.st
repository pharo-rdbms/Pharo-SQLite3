"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_FULL result code indicates that a write could not complete because the disk is full. Note that this error can occur when trying to write information into the main database file, or it can also occur when writing into temporary disk files.

Sometimes applications encounter this error even though there is an abundance of primary disk space because the error occurs when writing into temporary disk files on a system where temporary files are stored on a separate partition with much less space that the primary disk.
"
Class {
	#name : #SQLite3Full,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3Full class >> nativeErrorCode [

	^ SQLITE_FULL
]
