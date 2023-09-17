"
A test class for `SQLite3Table`
"
Class {
	#name : #SQLite3TableTest,
	#superclass : #TestCase,
	#instVars : [
		'db',
		'table'
	],
	#category : #'SQLite3-Core-Tests-Base'
}

{ #category : #running }
SQLite3TableTest >> setUp [
	super setUp.
	db := SQLite3Database memory.
	db connection open.
	db connection execute: self tableCreationScript.
	table := db tables first
]

{ #category : #accessing }
SQLite3TableTest >> tableCreationScript [

	^'CREATE TABLE "SAMPLE"
(
    [ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [NAME] NVARCHAR(120)
)'
]

{ #category : #running }
SQLite3TableTest >> tearDown [ 
	db connection close.
	db := nil.
	super tearDown 
]

{ #category : #tests }
SQLite3TableTest >> testName [

	| properties instance |
	properties := Dictionary newFromPairs: #( #name 'SimpleTable' ).
	instance := SQLite3Table properties: properties in: nil.
	self assert: instance name equals: 'SimpleTable'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testNumberOfRows [

	self assert: table numberOfRows equals: 0
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testNumberOfRowsIsOne [

	db execute: 'INSERT INTO SAMPLE(NAME) VALUES (''first example'');'.

	self assert: table numberOfRows equals: 1
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testNumberOfRowsIsTwo [

	db execute: 'INSERT INTO SAMPLE(NAME) VALUES (''first example''), (''second example'');'.

	self assert: table numberOfRows equals: 2
]

{ #category : #tests }
SQLite3TableTest >> testPrintString [

	self assert: table printString equals: 'a SQLite3Table("SAMPLE")'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testRows [

	self assert: table rows isEmpty
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testRowsHasOneRow [

	| rows |
	db execute: 'INSERT INTO SAMPLE(NAME) VALUES (''first example'');'.
	rows := table rows.
	self deny: rows isEmpty.
	self assert: rows size equals: 1.
	self assert: (rows first at: 'NAME') equals: 'first example'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testRowsHasTwoRows [

	| rows |
	db execute:
		'INSERT INTO SAMPLE(NAME) VALUES (''first example''), (''second example'');'.
	rows := table rows.
	self deny: rows isEmpty.
	self assert: rows size equals: 2.
	self assert: (rows first at: 'NAME') equals: 'first example'.
	self assert: (rows second at: 'NAME') equals: 'second example'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTable [

	self assert: table name equals: 'SAMPLE'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableColumnNames [

	self assert: table columnNames size equals: 2
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableColumns [

	self assert: table columns size equals: 2
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableProperties [
	|props|
	props := table properties.
	self assert: props size equals: 5.
	
	self assert: (props at: #type) equals: 'table'.
	self assert: (props at: #tbl_name) equals: 'SAMPLE'.
	self assert: (props at: #rootpage) equals: 2.
	self assert: (props at: #name) equals: 'SAMPLE'.
	self assert: (props at: #sql) equals: self tableCreationScript 
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableSchema [

	self assert: table schema equals: self tableCreationScript
]

{ #category : #tests }
SQLite3TableTest >> testUnitializedName [ 

	self assert: SQLite3Table new name equals: ''
		
]
