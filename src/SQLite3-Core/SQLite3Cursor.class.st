"
I represent a set of results returned by the database. I produce UDBCSQLite3Row instances lazily.

"
Class {
	#name : #SQLite3Cursor,
	#superclass : #Object,
	#instVars : [
		'connection',
		'statement',
		'moreRows',
		'rowClass',
		'rows',
		'mutators'
	],
	#pools : [
		'SQLite3Constants'
	],
	#category : #'SQLite3-Core-Database'
}

{ #category : #'instance creation' }
SQLite3Cursor class >> on: aStatement [ 
	^(self new) statement: aStatement; yourself.
]

{ #category : #accessing }
SQLite3Cursor >> changes [ 
	^statement changes
]

{ #category : #API }
SQLite3Cursor >> close [
	" closing a cursor is not the same as closing the statement - we may reuse a prepared statement"
	statement ifNotNil: [ statement reset ].
	statement := nil.
	mutators := nil.
]

{ #category : #accessing }
SQLite3Cursor >> columnNames [
	^ statement ifNotNil: [ statement columnNames ] ifNil: [ #() ]
]

{ #category : #accessing }
SQLite3Cursor >> connection [ 
	^statement connection
]

{ #category : #API }
SQLite3Cursor >> finalizeStatement [
	statement finalize
]

{ #category : #initialization }
SQLite3Cursor >> initialize [
	"Initializes the receiver"
	
	super initialize.
	moreRows := true.
	rowClass := SQLite3Row

]

{ #category : #accessing }
SQLite3Cursor >> mutators [
	^ mutators
		ifNil: [ mutators := self columnNames
				collect: [ :c | 
					(((c substrings: ' _-()') collect: [ :ea | ea capitalized ])
						joinUsing: '') uncapitalized asSymbol asMutator ] ]
]

{ #category : #API }
SQLite3Cursor >> next [
	^ self nextOfClass: self rowClass

]

{ #category : #API }
SQLite3Cursor >> nextOfClass: aRowClass [
	| rr |
	moreRows ifFalse: [ ^nil ].
	
	statement
		ifNil: [ SQLite3Misuse
				signal: 'This result set does not contain a prepared statement.' ].
	moreRows
		ifTrue: [
			rr := aRowClass new.
			(rr respondsTo: #columnNames:)
				ifTrue: [ "generic row class"
					rr columnNames: self columnNames.
					1 to: statement dataValuesAvailable do: [ :c | rr at: c put: (statement valueOfColumn: c - 1) ].
					 ]
				ifFalse: [ | msgs |
					"custom object"
					msgs := self mutators.
					1 to: msgs count do: [ :c | 
						(rr respondsTo: (msgs at: c))
							ifTrue: [ rr perform: (msgs at: c) with: (statement valueOfColumn: c - 1) ] ] 
						].
			moreRows := statement step = SQLITE_ROW.
			moreRows ifFalse: [ self close ].
			^ rr ].
	^ nil
]

{ #category : #API }
SQLite3Cursor >> onlyRow [
	^ self onlyRow: [ ]

"For the common case where there is exactly one row expected. Returns nil if there is no row."

]

{ #category : #API }
SQLite3Cursor >> onlyRow: ifNoneBlock [
	^self rows
		ifEmpty: [ ifNoneBlock value ]
		ifNotEmpty: [ rows first ].

"For the common case where there is exactly one row expected. Returns the evaluation of ifNoneBlock if there is no row."

]

{ #category : #API }
SQLite3Cursor >> onlyValue [
	^(self onlyRow: SQLite3Row) ifNotNil: [ :r | r first ]
]

{ #category : #accessing }
SQLite3Cursor >> rowClass [
	^ rowClass
]

{ #category : #accessing }
SQLite3Cursor >> rowClass: anObject [
	rowClass := anObject
]

{ #category : #API }
SQLite3Cursor >> rows [
	^ self rowsOfClass: self rowClass

]

{ #category : #API }
SQLite3Cursor >> rowsOfClass: aRowClass [
	
	rows ifNil: [ rows := OrderedCollection new ].
	[ moreRows ] whileTrue: [
			rows add: (self nextOfClass: aRowClass) ].
	^ rows

]

{ #category : #accessing }
SQLite3Cursor >> statement [
	^ statement
]

{ #category : #accessing }
SQLite3Cursor >> statement: anObject [
	statement := anObject.
	moreRows := (statement ifNil:[false ] ifNotNil: [ statement dataValuesAvailable > 0 ])
]
