"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_IOERR result code says that the operation could not finish because the operating system reported an I/O error.

A full disk drive will normally give an SQLITE_FULL error rather than an SQLITE_IOERR error.

There are many different extended result codes for I/O errors that identify the specific I/O operation that failed.
"
Class {
	#name : #SQLite3IOError,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3IOError class >> nativeErrorCode [

	^ SQLITE_IOERR
]
