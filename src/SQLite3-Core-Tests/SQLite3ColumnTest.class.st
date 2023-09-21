Class {
	#name : 'SQLite3ColumnTest',
	#superclass : 'TestCase',
	#instVars : [
		'db',
		'table',
		'firstColumn',
		'secondColumn'
	],
	#category : 'SQLite3-Core-Tests-Base',
	#package : 'SQLite3-Core-Tests',
	#tag : 'Base'
}

{ #category : 'running' }
SQLite3ColumnTest >> setUp [
	super setUp.
	db := SQLite3Database memory.
	db connection open.
	db connection execute: self tableCreationScript.
	table := db tables first.
	firstColumn := table columns first.
	secondColumn := table columns second
]

{ #category : 'accessing' }
SQLite3ColumnTest >> tableCreationScript [

	^'CREATE TABLE "SAMPLE"
(
    [ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [NAME] NVARCHAR(120)
)'
]

{ #category : 'running' }
SQLite3ColumnTest >> tearDown [

	db connection close.
	db := nil.
	super tearDown
]

{ #category : 'tests' }
SQLite3ColumnTest >> testHasNotNullConstraint [

	self assert: firstColumn hasNotNullConstraint.
	self deny: secondColumn hasNotNullConstraint
]

{ #category : 'tests' }
SQLite3ColumnTest >> testIndex [

	self assert: firstColumn index equals: 0.
	self assert: secondColumn index equals: 1
]

{ #category : 'tests' }
SQLite3ColumnTest >> testInitialization [

	| instance |
	instance := SQLite3Column new.
	self deny: instance hasNotNullConstraint
]

{ #category : 'tests' }
SQLite3ColumnTest >> testName [

	self assert: firstColumn name equals: 'ID'.
	self assert: secondColumn name equals: 'NAME'
]

{ #category : 'tests' }
SQLite3ColumnTest >> testPrintString [

	self assert: firstColumn printString equals: 'a SQLite3Column("ID")'.
	self assert: secondColumn printString equals: 'a SQLite3Column("NAME")'
]

{ #category : 'tests' }
SQLite3ColumnTest >> testType [

	self assert: firstColumn type equals: 'INTEGER'.
	self assert: secondColumn type equals: 'NVARCHAR(120)'
]
