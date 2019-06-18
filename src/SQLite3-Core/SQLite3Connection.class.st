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

	^ SQLite3ResultSet new execute: anSQLText 
		with: (Array with: anObject) 
		on: self	

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 [

	^ SQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2) 
		on: self	

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 [

	^ SQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3) 
		on: self	

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 value: object4 [

	^ SQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3 with: object4) 
		on: self	

]

{ #category : #'public API - operating' }
SQLite3Connection >> execute: anSQLText with: anObject [

	anObject isString
		ifTrue: [ SQLite3AbstractError signal: 'Unable to execute SQL on instance of String.' ].
			
	^ SQLite3ResultSet new execute: anSQLText with: anObject on: self	

]
