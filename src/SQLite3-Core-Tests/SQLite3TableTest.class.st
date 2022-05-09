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
SQLite3TableTest >> testSampleTable [

	self assert: table name equals: 'SAMPLE'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableProperties [
	|props|
	props := table properties.
	self assert: props size equals: 5.
	
	self assert: (props at: #type) equals: 'table'.
	self assert: (props at: #tbl_name) equals: 'SAMPLE'.
	self assert: (props at: #rootpage) equals: 2.
	self assert: (props at: #name) equals: 'SAMPLE'
]

{ #category : #'tests - sample' }
SQLite3TableTest >> testSampleTableSchema [

	self assert: table schema equals: self tableCreationScript
]

{ #category : #tests }
SQLite3TableTest >> testUnitializedName [ 

	self assert: SQLite3Table new name equals: ''
		
]
