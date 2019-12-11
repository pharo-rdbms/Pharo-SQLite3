"
I represent a row of results returned by the database.

"
Class {
	#name : #SQLite3Row,
	#superclass : #Object,
	#instVars : [
		'values',
		'columnNames'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #'instance creation' }
SQLite3Row class >> new: anInteger [
	^(self new) 
		columnNames:(Array new:anInteger);
		values: (Array new: anInteger);
		yourself
]

{ #category : #converting }
SQLite3Row >> asArray [
	^ self values asArray
]

{ #category : #converting }
SQLite3Row >> asCombinedDictionary [
	^self asDictionary addAll: ((self values collectWithIndex:[:v :i | i -> v]) asDictionary); yourself 
]

{ #category : #converting }
SQLite3Row >> asDictionary [
	"Borrowed from the future - Pharo 8"
	| dict |
	dict := Dictionary new.
	self columnNames with: self values do: [ :k :v | dict at: k put: v ].
	^ dict
]

{ #category : #accessing }
SQLite3Row >> at: aKey [ 
	^ self at: aKey ifAbsent: [  ]
]

{ #category : #accessing }
SQLite3Row >> at: aKey ifAbsent: aBlock [
	^ aKey isInteger 
		ifTrue: [ self values at: aKey ifAbsent: aBlock ] 
		ifFalse: [ self values at:(self columnNames indexOf: aKey) ifAbsent: aBlock ]
]

{ #category : #accessing }
SQLite3Row >> at: aKey put: anObject [
	^ aKey isInteger 
		ifTrue: [self atIndex: aKey put: anObject]
		ifFalse: [ self atName: aKey put: anObject ]
]

{ #category : #accessing }
SQLite3Row >> atIndex: anIndex [
	^ values at: anIndex ifAbsent: [  ]
]

{ #category : #accessing }
SQLite3Row >> atIndex: anIndex put: anObject [
	^ self values at: anIndex put: anObject
]

{ #category : #accessing }
SQLite3Row >> atName: aKey [ 
	| idx |
	idx := self columnNames indexOf: aKey.
	^idx = 0 
		ifTrue: [ SQLite3Misuse
				signal: 'Attept to set invalid column name ', aKey, ' in result set'   ] 
		ifFalse: [ values at: idx ]
]

{ #category : #accessing }
SQLite3Row >> atName: aKey put: anObject [
	| idx |
	^ (idx := self columnNames indexOf: aKey) isZero 
		ifTrue: [ 
			columnNames := self columnNames copyWith: aKey.
			values := self values copyWith: anObject ]
		ifFalse: [ values at: idx put: anObject ]
]

{ #category : #accessing }
SQLite3Row >> columnNames [
	^ columnNames ifNil: [ #() ]
]

{ #category : #accessing }
SQLite3Row >> columnNames: anArray [
	columnNames := anArray.
	values := Array new: anArray size
]

{ #category : #accessing }
SQLite3Row >> data [
	"compatibility"
	 ^self asCombinedDictionary
]

{ #category : #accessing }
SQLite3Row >> dataCount [
	^ self columnNames size
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
	^ self values ifEmpty: [] ifNotEmpty: [:v | v first ]

]

{ #category : #accessing }
SQLite3Row >> last [
	^ self values ifEmpty: [ nil ] ifNotEmpty: [:v | v last ]

]

{ #category : #accessing }
SQLite3Row >> size [
	^ self columnNames size
]

{ #category : #accessing }
SQLite3Row >> values [
	 ^values ifNil: [ #() ]
]

{ #category : #accessing }
SQLite3Row >> values: anArray [
	 values := anArray
]
