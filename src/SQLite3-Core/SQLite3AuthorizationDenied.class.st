"
This class comment was automatically generated from https://www.sqlite.org/rescode.html

The SQLITE_AUTH error is returned when the authorizer callback indicates that an SQL statement being prepared is not authorized.
"
Class {
	#name : #SQLite3AuthorizationDenied,
	#superclass : #SQLite3NativeError,
	#category : #'SQLite3-Core-Errors'
}

{ #category : #'private - accessing' }
SQLite3AuthorizationDenied class >> nativeErrorCode [

	^ SQLITE_AUTH
]
