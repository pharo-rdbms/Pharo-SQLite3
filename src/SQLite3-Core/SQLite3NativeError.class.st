"
Common subclass for errors corresponding to a native SQLite3 C library error
"
Class {
	#name : #SQLite3NativeError,
	#superclass : #SQLite3AbstractError,
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Errors'
}

{ #category : #testing }
SQLite3NativeError class >> isAbstract [ 

	^self name = #SQLite3NativeError
]

{ #category : #'private - accessing' }
SQLite3NativeError class >> nativeErrorCode [
	"Returns the native error code as defined by SQLite C library."
	
	^ self subclassResponsibility
]

{ #category : #accessing }
SQLite3NativeError class >> subclassForNativeErrorCode: anInteger [
	^ self subclasses detect: [ :subclass |
		subclass nativeErrorCode = anInteger ]
]
