"
I represent a connection to an SQLite database.

"
Class {
	#name : #SQLite3Connection,
	#superclass : #SQLite3BaseConnection,
	#category : #'SQLite3-Core-Connections'
}

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText [	
	^ self execute: anSQLText with: #()
]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: anObject [
	^ (self prepare: anSQLText)	execute: (Array with: anObject)

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 [
	^ self execute: anSQLText with: (Array with: object1 with: object2)

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 [
	^ self execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3) 

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 value: object4 [
	^ self execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3 with: object4) 

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText with: aCollection [
	^(self prepare: anSQLText) execute: aCollection

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText with: aCollection doing: aBlock [
	| cursor |
	cursor := self execute: anSQLText with: aCollection.
	[aBlock value: cursor]
		ensure: [ cursor finalizeStatement ]
]
