"
I represent a connection to an SQLite database. I am a test bed for experimental features.

"
Class {
	#name : #UDBCSQLite3ConnectionX,
	#superclass : #UDBCSQLite3Connection,
	#instVars : [
		'statementsCache'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #'public API - open/close' }
UDBCSQLite3ConnectionX >> close [

	statementsCache valuesDo: [ :s | s finalize ].
	super close
]

{ #category : #'public API - operating' }
UDBCSQLite3ConnectionX >> finalize: anSQLText [

	(statementsCache includesKey: anSQLText) ifTrue: [ 
		statementsCache removeKey: anSQLText ]

]

{ #category : #initialization }
UDBCSQLite3ConnectionX >> initialize [

	super initialize.
	statementsCache := Dictionary new
]

{ #category : #'public API - operating' }
UDBCSQLite3ConnectionX >> prepare: anSQLText [

	(statementsCache includesKey: anSQLText) ifFalse: [ 
			statementsCache at: anSQLText put: (super prepare: anSQLText) ].
	^ statementsCache at: anSQLText

]
