"
Unit tests for UDBCSQLiteBaseConnection
"
Class {
	#name : #UDBCSQLiteBaseConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'db',
		'db2',
		'res',
		'res2'
	],
	#category : #'UDBC-Tests-SQLite-Base-Connections'
}

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> setUp [ 

	super setUp.
	db := UDBCSQLiteBaseConnection on: ':memory:'.
	db open.

]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> tearDown [
	
	[ db close ] on: UDBCSQLiteMisuse do: [ ].
	super tearDown.

]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testBadOpen [
	|invalidFilename|
	invalidFilename := 
	Smalltalk os isWindows ifTrue: [ '/&*no' ]
		ifFalse: [ '/nosuchfile' ].
	db2 := UDBCSQLiteBaseConnection on: invalidFilename.
	self should: [ db2 open ] raise: UDBCSQLiteError.
	self assert: (db2 isOpen = false)
]
