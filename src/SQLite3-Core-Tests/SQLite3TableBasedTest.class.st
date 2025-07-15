Class {
	#name : 'SQLite3TableBasedTest',
	#superclass : 'TestCase',
	#instVars : [
		'db',
		'table'
	],
	#category : 'SQLite3-Core-Tests-Base',
	#package : 'SQLite3-Core-Tests',
	#tag : 'Base'
}

{ #category : 'testing' }
SQLite3TableBasedTest class >> isAbstract [

	^ self == SQLite3TableBasedTest
]

{ #category : 'running' }
SQLite3TableBasedTest >> setUp [
	super setUp.
	db := SQLite3Database memory.
	db connection open.
	db connection execute: self tableCreationScript.
	table := db tables first
]

{ #category : 'accessing' }
SQLite3TableBasedTest >> tableCreationScript [

	^ self subclassResponsibility
]

{ #category : 'running' }
SQLite3TableBasedTest >> tearDown [
	db connection close.
	db := nil.
	super tearDown
]

{ #category : 'tests - sample' }
SQLite3TableBasedTest >> testSampleTableSchema [

	self assert: table schema equals: self tableCreationScript
]
