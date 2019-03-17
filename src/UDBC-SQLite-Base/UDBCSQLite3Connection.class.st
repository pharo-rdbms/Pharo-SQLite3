"
I represent a connection to an SQLite database.

"
Class {
	#name : #UDBCSQLite3Connection,
	#superclass : #UDBCSQLite3BaseConnection,
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText [	
	^ self execute: anSQLText with: #()
]

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText value: anObject [

	^ UDBCSQLite3ResultSet new execute: anSQLText 
		with: (Array with: anObject) 
		on: self	

]

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText value: object1 value: object2 [

	^ UDBCSQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2) 
		on: self	

]

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 [

	^ UDBCSQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3) 
		on: self	

]

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText value: object1 value: object2 value: object3 value: object4 [

	^ UDBCSQLite3ResultSet new execute: anSQLText 
		with: (Array with: object1 with: object2 with: object3 with: object4) 
		on: self	

]

{ #category : #'public API - operating' }
UDBCSQLite3Connection >> execute: anSQLText with: anObject [

	anObject isString
		ifTrue: [ UDBCSQLite3Error signal: 'Unable to execute SQL on instance of String.' ].
			
	^ UDBCSQLite3ResultSet new execute: anSQLText with: anObject on: self	

]

{ #category : #accessing }
UDBCSQLite3Connection >> queryEncoding [
	^ #utf8
]
