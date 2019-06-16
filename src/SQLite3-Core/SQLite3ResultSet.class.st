"
I represent a set of results returned by the database. I produce UDBCSQLite3Row instances lazily.

"
Class {
	#name : #SQLite3ResultSet,
	#superclass : #Object,
	#instVars : [
		'db',
		'statement',
		'moreRows',
		'rowClass'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #API }
SQLite3ResultSet >> close [

	statement ifNotNil: [ statement finalize ].
	statement := nil
]

{ #category : #private }
SQLite3ResultSet >> execute: anSQLText with: anObject on: aDb [
	| obj |

	db := aDb.

	obj := anObject isNil ifTrue: [ #() ] ifFalse: [ anObject ].

	(obj isDictionary)
		ifTrue: [ self execute: anSQLText withKeysAndValues: obj ]
		ifFalse: [
			(obj isCollection)
				ifTrue: [ self execute: anSQLText withCollection: obj ]
				ifFalse: [ SQLite3Error signal: 'Unable to execute SQL on instance of ', obj class asString ]]
	


]

{ #category : #private }
SQLite3ResultSet >> execute: anSQLText withCollection: aCollection [
	| i |
	self prepareStatement: anSQLText.
	i := 1.
	aCollection do: [ :v | i := self execute: statement withIndex: i withValue: v ].
	moreRows := statement step = 100	" == SQLITE_ROW "
]

{ #category : #private }
SQLite3ResultSet >> execute: aStatement withIndex: anInteger withValue: anObject [
		
	aStatement perform: (aStatement dataTypeForObject: anObject) with: anInteger with: anObject.
	^ anInteger + 1
		

]

{ #category : #private }
SQLite3ResultSet >> execute: aStatement withKey: keyObject withValue: valueObject [
	| col |

	col := aStatement bindParameterIndex: keyObject.
	(col = 0) ifFalse: [
		aStatement perform: (aStatement dataTypeForObject: valueObject) with: col with: valueObject ]

		

]

{ #category : #private }
SQLite3ResultSet >> execute: anSQLText withKeysAndValues: anObject [
	
	self prepareStatement: anSQLText.
	anObject keysAndValuesDo: [ :k :v | 
		self execute: statement withKey: k withValue: v ].
	moreRows := (statement step) = 100. " == SQLITE_ROW "

]

{ #category : #initialization }
SQLite3ResultSet >> initialize [
	"Initializes the receiver"
	
	super initialize.
	moreRows := true.
	rowClass := SQLite3Row

]

{ #category : #API }
SQLite3ResultSet >> next [
	^ self nextOfClass: self rowClass

]

{ #category : #API }
SQLite3ResultSet >> nextOfClass: aRowClass [
	| nc rr rv |

	statement ifNil: [ SQLite3Misuse signal: 'This result set does not contain a prepared statement.' ].	
	
	moreRows ifTrue: [	
		nc := statement dataValuesAvailable.
		(nc = 0)
			ifTrue: [ ^ nil ] 
			ifFalse: [ 
				rr := aRowClass new.
				0 to: nc - 1 do: [ :c | 
					rv := statement valueOfColumn: c.
					rr atIndex: c + 1 put: rv.
					rr atName: (statement nameOfColumn: c) put: rv ]. 
				rr dataCount: nc. 
				"statement clearBindings." "XXX With this, the Glorp result set fails its test..."
				moreRows := (statement step) = 100. " == SQLITE_ROW "
				^ rr ]].
		
	^ nil

]

{ #category : #API }
SQLite3ResultSet >> onlyRow [
	^ self onlyRow: [ ]

"For the common case where there is exactly one row expected. Returns nil if there is no row."

]

{ #category : #API }
SQLite3ResultSet >> onlyRow: ifNoneBlock [
	| rows |
	
	rows := self rows.
	^ (rows isEmpty)
		ifTrue: [ ifNoneBlock value ]
		ifFalse: [ rows first ]

"For the common case where there is exactly one row expected. Returns the evaluation of ifNoneBlock if there is no row."

]

{ #category : #private }
SQLite3ResultSet >> prepareStatement: anSQLText [

	statement := db prepare: anSQLText.
	statement clearBindings.
	statement	reset

]

{ #category : #accessing }
SQLite3ResultSet >> rowClass [
	^ rowClass
]

{ #category : #accessing }
SQLite3ResultSet >> rowClass: anObject [
	rowClass := anObject
]

{ #category : #API }
SQLite3ResultSet >> rows [
	^ self rowsOfClass: self rowClass

]

{ #category : #API }
SQLite3ResultSet >> rowsOfClass: aRowClass [
	| rows nc rr rv |

	statement ifNil: [ SQLite3Misuse signal: 'This result set does not contain a prepared statement.' ].	
	
	rows := OrderedCollection new.
	[ moreRows ] whileTrue: [	
		nc := statement dataValuesAvailable.
		(nc = 0)
			ifFalse: [ 
				rr := aRowClass new.
				0 to: nc - 1 do: [ :c | 
					rv := statement valueOfColumn: c.
					rr atIndex: c + 1 put: rv.
					rr atName: (statement nameOfColumn: c) put: rv ].   
				rr dataCount: nc. 
				rows add: rr ].
		moreRows := (statement step) = 100 " == SQLITE_ROW " ].
	
	^ rows

]

{ #category : #accessing }
SQLite3ResultSet >> statement [
	^ statement
]

{ #category : #accessing }
SQLite3ResultSet >> statement: anObject [
	statement := anObject
]
