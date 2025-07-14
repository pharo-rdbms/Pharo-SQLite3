"
Common subclass for errors corresponding to a native SQLite3 C library error code.

Typically one uses this class to create and access instances of subclasses: 
 
	(SQLite3NativeError forNativeErrorCode: SQLITE_INTERRUPT  messageText: 'Interrupted') signal
"
Class {
	#name : 'SQLite3NativeError',
	#superclass : 'SQLite3AbstractError',
	#pools : [
		'SQLite3Constants'
	],
	#category : 'SQLite3-Core-Errors',
	#package : 'SQLite3-Core',
	#tag : 'Errors'
}

{ #category : 'examples' }
SQLite3NativeError class >> example [

	(SQLite3NativeError forNativeErrorCode: SQLITE_INTERRUPT  messageText: 'Interrupted') signal
]

{ #category : 'accessing' }
SQLite3NativeError class >> forNativeErrorCode: anInteger messageText: aString [

	^(self subclassForNativeErrorCode: anInteger) new
			messageText: aString;
			yourself
]

{ #category : 'testing' }
SQLite3NativeError class >> isAbstract [

	^self name = #SQLite3NativeError
]

{ #category : 'private - accessing' }
SQLite3NativeError class >> nativeErrorCode [
	"Returns the native error code as defined by SQLite C library."

	^ self subclassResponsibility
]

{ #category : 'private - accessing' }
SQLite3NativeError class >> subclassForNativeErrorCode: anInteger [
	^ self subclasses
		detect: [ :subclass | subclass nativeErrorCode = anInteger ]
]
