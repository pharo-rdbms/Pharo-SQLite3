"
I represent a row of results returned by the database.

"
Class {
	#name : #UDBCSQLite3Row,
	#superclass : #Object,
	#instVars : [
		'data',
		'dataCount'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #accessing }
UDBCSQLite3Row >> asArray [
	| c |

	c := OrderedCollection new.
	1 to: self dataCount do: [ :i |
		c add: (self atIndex: i) ].
	^ c asArray
]

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

{ #category : #accessing }
UDBCSQLite3Row >> atIndex: anIndex [
	^ self at: anIndex ifAbsent: [  ]
]

{ #category : #accessing }
UDBCSQLite3Row >> atIndex: anIndex put: anObject [
	^ data at: anIndex put: anObject
]

{ #category : #accessing }
UDBCSQLite3Row >> atName: aKey [ 
	^ self at: aKey ifAbsent: [  ]
]

{ #category : #accessing }
UDBCSQLite3Row >> atName: aKey put: anObject [
	^ data at: aKey put: anObject
]

{ #category : #accessing }
UDBCSQLite3Row >> data [

	 ^data
]

{ #category : #accessing }
UDBCSQLite3Row >> dataCount [
	^ dataCount
]

{ #category : #accessing }
UDBCSQLite3Row >> dataCount: anObject [
	dataCount := anObject
]

{ #category : #'reflective operations' }
UDBCSQLite3Row >> doesNotUnderstand: aMessage [

	^ self at: aMessage selector asString 
			ifAbsent: [ 
				"20160514: This bit, for Glorp integration, feels a bit iffy."
				self at: aMessage selector asString asUppercase 
					ifAbsent: [ super doesNotUnderstand: aMessage ]]
]

{ #category : #accessing }
UDBCSQLite3Row >> first [
	^ self atIndex: 1

]

{ #category : #initialization }
UDBCSQLite3Row >> initialize [
	"Initializes the receiver"
	
	super initialize.
	data := Dictionary new
]

{ #category : #accessing }
UDBCSQLite3Row >> last [
	^ self atIndex: self dataCount

]

{ #category : #accessing }
UDBCSQLite3Row >> size [
	^ dataCount
]
