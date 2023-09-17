"
I am an abstract superclass for corresponding classes to result codes created by SQLite3 C library.

Subclasses should not be instantiated directly. Instead use #forNativeResultCode: with a valid result constant.

   SQLite3Result forNativeResultCode: SQLITE_OK
"
Class {
	#name : #SQLite3Result,
	#superclass : #Object,
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Results'
}

{ #category : #accessing }
SQLite3Result class >> forNativeResultCode: anInteger [
	^ (self subclassForNativeResultCode: anInteger) new
]

{ #category : #testing }
SQLite3Result class >> isAbstract [

	^self name = #SQLite3Result
]

{ #category : #'private - accessing' }
SQLite3Result class >> nativeResultCode [

	^ self subclassResponsibility
]

{ #category : #'private - accessing' }
SQLite3Result class >> subclassForNativeResultCode: anInteger [
	^ self subclasses
		detect: [ :subclass | subclass nativeResultCode = anInteger ]
]
