"
The SQLITE_CANTOPEN_CONVPATH error code is an extended error code for SQLITE_CANTOPEN used only by Cygwin VFS and indicating that the cygwin_conv_path() system call failed while trying to open a file. See also: SQLITE_IOERR_CONVPATH
"
Class {
	#name : #SQLite3CantOpenConvertPath,
	#superclass : #SQLite3CantOpen,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3CantOpenConvertPath class >> nativeErrorCode [

	^ SQLITE_CANTOPEN_CONVPATH
]
