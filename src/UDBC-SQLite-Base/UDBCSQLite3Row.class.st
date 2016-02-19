"
I represent a row of results returned by the database.

"
Class {
	#name : #UDBCSQLite3Row,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #accessing }
UDBCSQLite3Row >> at: aKey [ 
	^ self at: aKey ifAbsent: [  ]
]

{ #category : #accessing }
UDBCSQLite3Row >> at: aKey ifAbsent: aBlock [
	^ data at: aKey ifAbsent: aBlock
]

{ #category : #accessing }
UDBCSQLite3Row >> at: aKey put: anObject [
	^ data at: aKey put: anObject
]

{ #category : #'reflective operations' }
UDBCSQLite3Row >> doesNotUnderstand: aMessage [
	^ self at: aMessage selector asString ifAbsent: [ super doesNotUnderstand: aMessage ]
]

{ #category : #initialization }
UDBCSQLite3Row >> initialize [
	"Initializes the receiver"
	
	super initialize.
	data := Dictionary new
]
