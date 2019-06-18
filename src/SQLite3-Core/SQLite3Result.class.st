"
I am an abstract superclass for corresponding classes to result codes created by SQLite3 C library.
"
Class {
	#name : #SQLite3Result,
	#superclass : #Object,
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Results'
}

{ #category : #testing }
SQLite3Result class >> isAbstract [ 

	^self name = #SQLite3Result
]

{ #category : #'private - accessing' }
SQLite3Result class >> nativeResultCode [

	^ self subclassResponsibility
]
