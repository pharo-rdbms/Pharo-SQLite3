"
The SQLITE_NOLFS error can be returned on systems that do not support large files when the database grows to be larger than what the filesystem can handle. ""NOLFS"" stands for ""NO Large File Support"".
"
Class {
	#name : 'SQLite3NoLargeFileSupport',
	#superclass : 'SQLite3NativeError',
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'private - accessing' }
SQLite3NoLargeFileSupport class >> nativeErrorCode [

	^ SQLITE_NOLFS
]
