"
An error while using ODBC
"
Class {
	#name : #UDBCODBCError,
	#superclass : #Error,
	#instVars : [
		'details'
	],
	#category : #'UDBC-ODBC-Base-Exceptions'
}

{ #category : #'instance creation' }
UDBCODBCError class >> details: aCollection [
	^ (self new)
		initializeDetails: aCollection;
		yourself
]

{ #category : #'private - initialization' }
UDBCODBCError >> initializeDetails: aCollection [ 
	details := aCollection.
 	self messageText: self asString
]

{ #category : #printing }
UDBCODBCError >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' '.
	details
		do: [ :each | aStream nextPutAll: each asString ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]
