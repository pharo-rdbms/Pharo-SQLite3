"
I represent a connection to an SQLite database. I am a test bed for experimental features.

"
Class {
	#name : #SQLite3ConnectionX,
	#superclass : #SQLite3Connection,
	#instVars : [
		'statementsCache'
	],
	#category : #'SQLite3-Core-Connections'
}

{ #category : #'public API - open/close' }
SQLite3ConnectionX >> close [

	statementsCache valuesDo: [ :s | s finalize ].
	super close
]

{ #category : #'public API - operating' }
SQLite3ConnectionX >> finalize: anSQLText [

	(statementsCache includesKey: anSQLText) ifTrue: [ 
		statementsCache removeKey: anSQLText ]

]

{ #category : #initialization }
SQLite3ConnectionX >> initialize [

	super initialize.
	statementsCache := Dictionary new
]

{ #category : #'public API - operating' }
SQLite3ConnectionX >> prepare: anSQLText [

	(statementsCache includesKey: anSQLText) ifFalse: [ 
			statementsCache at: anSQLText put: (super prepare: anSQLText) ].
	^ statementsCache at: anSQLText

]
