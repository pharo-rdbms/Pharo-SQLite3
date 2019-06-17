"
I represent a row of results returned by the database.

"
Class {
	#name : #SQLite3Row,
	#superclass : #Object,
	#instVars : [
		'data',
		'dataCount'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #conversion }
SQLite3Row >> asArray [
	^ self data asArray
]

{ #category : #accessing }
SQLite3Row >> at: aKey [ 
	^ self at: aKey ifAbsent: [  ]
]

{ #category : #accessing }
SQLite3Row >> at: aKey ifAbsent: aBlock [
	^ data at: aKey ifAbsent: aBlock
]

{ #category : #accessing }
SQLite3Row >> at: aKey put: anObject [
	^ data at: aKey put: anObject
]

{ #category : #accessing }
SQLite3Row >> atIndex: anIndex [
	^ self at: anIndex ifAbsent: [  ]
]

{ #category : #accessing }
SQLite3Row >> atIndex: anIndex put: anObject [
	^ data at: anIndex put: anObject
]

{ #category : #accessing }
SQLite3Row >> atName: aKey [ 
	^ self at: aKey ifAbsent: [  ]
]

{ #category : #accessing }
SQLite3Row >> atName: aKey put: anObject [
	^ data at: aKey put: anObject
]

{ #category : #accessing }
SQLite3Row >> columnNames [
 
	^ self data keys
]

{ #category : #accessing }
SQLite3Row >> data [

	 ^data
]

{ #category : #accessing }
SQLite3Row >> dataCount [
	^ dataCount
]

{ #category : #accessing }
SQLite3Row >> dataCount: anObject [
	dataCount := anObject
]

{ #category : #'reflective operations' }
SQLite3Row >> doesNotUnderstand: aMessage [

	^ self at: aMessage selector asString 
			ifAbsent: [ 
				"20160514: This bit, for Glorp integration, feels a bit iffy."
				self at: aMessage selector asString asUppercase 
					ifAbsent: [ super doesNotUnderstand: aMessage ]]
]

{ #category : #accessing }
SQLite3Row >> first [
	^ self atIndex: 1

]

{ #category : #initialization }
SQLite3Row >> initialize [
	"Initializes the receiver"
	
	super initialize.
	data := Dictionary new
]

{ #category : #accessing }
SQLite3Row >> last [
	^ self atIndex: self dataCount

]

{ #category : #accessing }
SQLite3Row >> size [
	^ dataCount
]
