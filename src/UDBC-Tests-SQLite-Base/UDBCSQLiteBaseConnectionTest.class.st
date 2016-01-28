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
	| invalidFilename |
	invalidFilename := Smalltalk os isWindows
		ifTrue: [ '/&*no' ]
		ifFalse: [ '/nosuchfile' ].
	db2 := UDBCSQLiteBaseConnection on: invalidFilename.
	self should: [ db2 open ] raise: UDBCSQLiteError.
	self assert: db2 isOpen = false
]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testBasicExecuteOk [

	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	res := db basicExecute: 'drop table x;'.
	self assert: (res = 0).
	
]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testBasicExecuteSyntaxError [

	self should: [ db basicExecute: 'create table,;' ]
		raise: UDBCSQLiteError
	
]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testColumnNames [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	columns := db columnNamesFor: 'x'.
	self assert: (columns size = 2).
	self assert: (columns first = 'xk').
	self assert: (columns second = 'xv').
	

]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testColumnNamesBobbyGo [
	"In this test, Bobby Tables strikes naive SQL string construction."
	| tables bobby |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	res := db basicExecute: 'create table students (sk integer, sname varchar);'.
	self assert: (res = 0).

	tables := db tableNames.
	self assert: (tables size = 2).
	self assert: (tables first = 'x').	
	self assert: (tables second = 'students').	

	bobby := 'x); drop table students; --'.	
	res := db basicExecute: 'pragma table_info(', bobby, ')'.
	self assert: (res = 0).

	tables := db tableNames.
	self assert: (tables size = 1).
	self assert: (tables first = 'x').	


]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testColumnNamesBobbyStop [
	"In this test, Bobby Tables strikes again, but fails, because #columnNamesFor: uses parameter binding."
	| columns tables |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	res := db basicExecute: 'create table students (sk integer, sname varchar);'.
	self assert: (res = 0).

	tables := db tableNames.
	self assert: (tables size = 2).
	self assert: (tables first = 'x').	
	self assert: (tables second = 'students').	
	
	columns := db columnNamesFor: 'x; drop table students; --'.
	self assert: (columns isNil).

	tables := db tableNames.
	self assert: (tables size = 2).
	self assert: (tables first = 'x').	
	self assert: (tables second = 'students').	


]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testColumnNamesNoSuchTable [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	columns := db columnNamesFor: 'y'.
	self assert: (columns isNil).
]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> testDataValuesAvailable [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).

	res := db basicExecute: 'insert into x values (NULL, 1, "duh");'.	
	self assert: (res = 0).
	
	s := db prepare: 'select * from x'.
	s basicExecute: [  :row |
		self assert: (row dataValuesAvailable = 3) ].
	s finalize.
	
]
