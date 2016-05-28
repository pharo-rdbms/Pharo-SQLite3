"
I represent a set of results returned by the database. I produce UDBCSQLite3Row instances lazily.

"
Class {
	#name : #UDBCSQLite3ResultSet,
	#superclass : #Object,
	#instVars : [
		'db',
		'statement',
		'moreRows'
	],
	#category : #'UDBC-SQLite-Base-Database'
}

{ #category : #API }
UDBCSQLite3ResultSet >> close [

	statement ifNotNil: [ statement finalize ].
	statement := nil
]

{ #category : #private }
UDBCSQLite3ResultSet >> execute: anSQLText with: anObject on: aDb [
	| obj |

	db := aDb.

	obj := anObject isNil ifTrue: [ #() ] ifFalse: [ anObject ].

	(obj isDictionary)
		ifTrue: [ self execute: anSQLText withKeysAndValues: obj ]
		ifFalse: [
			(obj isCollection)
				ifTrue: [ self execute: anSQLText withCollection: obj ]
				ifFalse: [ UDBCSQLite3Error signal: 'Unable to execute SQL on instance of ', obj class asString ]]
	


]

{ #category : #private }
UDBCSQLite3ResultSet >> execute: anSQLText withCollection: aCollection [
	| i |
	self prepareStatement: anSQLText.
	i := 1.
	aCollection do: [ :v | i := self execute: statement withIndex: i withValue: v ].
	moreRows := statement step = 100	" == SQLITE_ROW "
]

{ #category : #private }
UDBCSQLite3ResultSet >> execute: aStatement withIndex: anInteger withValue: anObject [
		
	aStatement perform: (aStatement dataTypeForObject: anObject) with: anInteger with: anObject.
	^ anInteger + 1
		

]

{ #category : #private }
UDBCSQLite3ResultSet >> execute: aStatement withKey: keyObject withValue: valueObject [
	| col |

	col := aStatement bindParameterIndex: keyObject.
	(col = 0) ifFalse: [
		aStatement perform: (aStatement dataTypeForObject: valueObject) with: col with: valueObject ]

		

]

{ #category : #private }
UDBCSQLite3ResultSet >> execute: anSQLText withKeysAndValues: anObject [
	
	self prepareStatement: anSQLText.
	anObject keysAndValuesDo: [ :k :v | 
		self execute: statement withKey: k withValue: v ].
	moreRows := (statement step) = 100. " == SQLITE_ROW "

]

{ #category : #private }
UDBCSQLite3ResultSet >> fillRow: aRow atNameOrIndex: anObject withValue: aValue [
	aRow at: anObject put: aValue

]

{ #category : #initialization }
UDBCSQLite3ResultSet >> initialize [
	"Initializes the receiver"
	
	super initialize.
	moreRows := true

]

{ #category : #API }
UDBCSQLite3ResultSet >> next [
	| nc rr rv |

	statement ifNil: [ UDBCSQLite3Misuse signal: 'This result set does not contain a prepared statement.' ].	
	
	moreRows ifTrue: [	
		nc := statement dataValuesAvailable.
		(nc = 0)
			ifTrue: [ ^ nil ] 
			ifFalse: [ 
				rr := UDBCSQLite3Row new.
				0 to: nc - 1 do: [ :c | 
					rv := statement valueOfColumn: c.
					self fillRow: rr atNameOrIndex: c withValue: rv.
					self fillRow: rr atNameOrIndex: (statement nameOfColumn: c) withValue: rv ].  
				"statement clearBindings." "XXX With this, the Glorp result set fails its test..."
				moreRows := (statement step) = 100. " == SQLITE_ROW "
				^ rr ]].
		
	^ nil

]

{ #category : #private }
UDBCSQLite3ResultSet >> prepareStatement: anSQLText [

	statement isNil
		ifTrue: [ statement := db prepare: anSQLText ]
		ifFalse: [ statement clearBindings; reset ].

]

{ #category : #API }
UDBCSQLite3ResultSet >> rows [
	| rows nc rr rv |

	statement ifNil: [ UDBCSQLite3Misuse signal: 'This result set does not contain a prepared statement.' ].	
	
	rows := OrderedCollection new.
	[ moreRows ] whileTrue: [	
		nc := statement dataValuesAvailable.
		(nc = 0)
			ifFalse: [ 
				rr := UDBCSQLite3Row new.
				0 to: nc - 1 do: [ :c | 
					rv := statement valueOfColumn: c.
					self fillRow: rr atNameOrIndex: c withValue: rv.
					self fillRow: rr atNameOrIndex: (statement nameOfColumn: c) withValue: rv ].  
				rows add: rr ].
		moreRows := (statement step) = 100 " == SQLITE_ROW " ].
	
	^ rows

]

{ #category : #accessing }
UDBCSQLite3ResultSet >> statement [
	^ statement
]

{ #category : #accessing }
UDBCSQLite3ResultSet >> statement: anObject [
	statement := anObject
]
