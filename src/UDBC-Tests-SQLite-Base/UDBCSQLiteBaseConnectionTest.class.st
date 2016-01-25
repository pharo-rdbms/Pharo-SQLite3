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
