"
I represent a connection to an SQLite database. I am a test bed for experimental features.

"
Class {
	#name : #UDBCSQLite3ConnectionX,
	#superclass : #UDBCSQLite3Connection,
	#instVars : [
		'statements'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #'public API - open/close' }
UDBCSQLite3ConnectionX >> close [

	statements valuesDo: [ :s | s finalize ].
	super close
]

{ #category : #'public API - transactional' }
UDBCSQLite3ConnectionX >> commitTransaction [

	statements valuesDo: [ :s | s reset ].
	^ super commitTransaction 
]

{ #category : #initialization }
UDBCSQLite3ConnectionX >> initialize [

	super initialize.
	statements := Dictionary new
]

{ #category : #'public API - operating' }
UDBCSQLite3ConnectionX >> prepare: anSQLText [
	^ super prepare: anSQLText
]

{ #category : #'public API - transactional' }
UDBCSQLite3ConnectionX >> rollbackTransaction [

	statements valuesDo: [ :s | s reset ].
	^ super rollbackTransaction 
]
