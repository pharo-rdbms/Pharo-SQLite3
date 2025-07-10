"
The SQLITE_IOERR_CONVPATH error code is an extended error code for SQLITE_IOERR used only by Cygwin VFS and indicating that the cygwin_conv_path() system call failed. See also: SQLITE_CANTOPEN_CONVPATH
"
Class {
	#name : #SQLite3IOErrorConvertPath,
	#superclass : #SQLite3IOError,
	#category : #'SQLite3-Core-Errors-Extended'
}

{ #category : #'private - accessing' }
SQLite3IOErrorConvertPath class >> nativeErrorCode [

	^ SQLITE_IOERR_CONVPATH
]
