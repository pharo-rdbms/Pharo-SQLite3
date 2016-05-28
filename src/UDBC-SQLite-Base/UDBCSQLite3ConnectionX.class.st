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

{ #category : #'public API - transactional' }
UDBCSQLite3ConnectionX >> commitTransaction [

	statements valuesDo: [ :s | s ifNotNil: [ s reset ]].
	^ super commitTransaction 
]

{ #category : #initialization }
UDBCSQLite3ConnectionX >> initialize [

	super initialize.
	statements := WeakValueDictionary new
]

{ #category : #'public API - operating' }
UDBCSQLite3ConnectionX >> prepare: anSQLText [
	| s |
	
	s := statements at: anSQLText ifAbsent: [  ].
	s ifNil: [ s := super prepare: anSQLText ].
	s reset.
	^ s
]

{ #category : #'public API - transactional' }
UDBCSQLite3ConnectionX >> rollbackTransaction [

	statements valuesDo: [ :s | s ifNotNil: [ s reset ]].
	^ super rollbackTransaction 
]
