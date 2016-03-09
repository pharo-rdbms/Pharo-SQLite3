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
	db := UDBCSQLite3BaseConnection on: ':memory:'.
	db open.

]

{ #category : #running }
UDBCSQLiteBaseConnectionTest >> tearDown [
	
	[ db close ] on: UDBCSQLite3Misuse do: [ ].
	super tearDown.

]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testBadOpen [
	| invalidFilename |
	invalidFilename := Smalltalk os isWindows
		ifTrue: [ '/&*no' ]
		ifFalse: [ '/nosuchfile' ].
	db2 := UDBCSQLite3BaseConnection on: invalidFilename.
	self should: [ db2 open ] raise: UDBCSQLite3Error.
	self assert: db2 isOpen = false
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testBasicExecuteOk [

	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	res := db basicExecute: 'drop table x;'.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testBasicExecuteSyntaxError [

	self should: [ db basicExecute: 'create table,;' ]
		raise: UDBCSQLite3Error
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testColumnNames [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	columns := db columnNamesFor: 'x'.
	self assert: (columns size = 2).
	self assert: (columns first = 'xk').
	self assert: (columns second = 'xv').
	

]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testColumnNamesNoSuchTable [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	columns := db columnNamesFor: 'y'.
	self assert: (columns isNil).
]

{ #category : #tests }
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

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testDateAndTime [
	| data s | 
	
	data := DateAndTime year: 2015 month: 4 day: 1.
	
	res := db basicExecute: 'create table x (xv datetime);'.
	self assert: (res = 0).

	res := db basicExecute: 'begin'.
	self assert: (res = 0).
	s := db prepare: 'insert into x values (?)'.
	s at: 1 putDateTime: data.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: (res = 0).
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row dateTimeAt: 0.
		self assert: ((v year) = 2015).
		self assert: ((v month) = 4).
		self assert: ((v dayOfMonth) = 1) ].
	s finalize.
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testDoubleClose [
	
	db close.
	[ db close ] on: UDBCSQLite3Misuse do: [ ]
	"#tearDown will close the db again, and is similarly guarded."
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testFloat [
	| s |	
	res := db basicExecute: 'create table x (xk integer primary key, xv real);'.
	self assert: (res = 0).
	res := db basicExecute: 'insert into x values (NULL, 1.141);'.
	self assert: (res = 0).
	
	s := db prepare: 'select * from x'.
	s basicExecute: [ :row |
		self assert: (row nameOfColumn: 1) equals: 'xv'.
		self assert: (row floatAt: 1) equals: 1.141 ].
	s finalize.

]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testObjectBlob [
	| data s | 
	
	data := OrderedCollection with: 1 with: 'two' with: 3.3.
	
	res := db basicExecute: 'create table x (xk integer primary key, xv blob);'.
	self assert: (res = 0).

	res := db basicExecute: 'begin'.
	self assert: (res = 0).
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putObject: data.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: (res = 0).
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row objectAt: 0.
		self assert: v size equals: 3.
		self assert: v first equals: 1.
		self assert: v second equals: 'two'.
		self assert: v third equals: 3.3 ].
	s finalize.
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testPrepareStep [
	| s i | 
	
	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).

	res := db basicExecute: 'begin'.
	self assert: (res = 0).
	s := db prepare: 'insert into x values (NULL, ?, ?)'.
	1 to: 10 do: [ :x |
		s at: 1 putInteger: x * x.
		s at: 2 putString: x asString, ' * ', x asString.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: (res = 0).
	
	s := db prepare: 'select * from x'.
	s basicExecute: [  :row |
		i := row integerAt: 0.
		self assert: (row integerAt: 1) equals: (i * i).
		self assert: (row stringAt: 2) equals: (i asString, ' * ', i asString) ].
	s finalize.
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testResultSetColumnIntrospection [
	| s | 

	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).

	res := db basicExecute: 'insert into x values (NULL, 1, "duh");'.	
	self assert: (res = 0).
	
	s := db prepare: 'select * from x'.
	s basicExecute: [  :row |
		self assert: ((row nameOfColumn: 0) = 'xk').
		self assert: ((row valueOfColumn: 0) = 1).
		self assert: ((row nameOfColumn: 1) = 'iv').
		self assert: ((row valueOfColumn: 1) = 1).
		self assert: ((row nameOfColumn: 2) = 'tv').
		self assert: ((row valueOfColumn: 2) = 'duh') ].
	s finalize.
	
]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testTableNames [
	| tables |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: (res = 0).
	tables := db tableNames.
	self assert: (tables size = 1).
	self assert: (tables first = 'x')
	

]

{ #category : #tests }
UDBCSQLiteBaseConnectionTest >> testTracing [
	| sql callback expected actual  |
	
	sql := #('create table if not exists x (xk integer primary key, iv integer, tv text)'
			'insert into x values (NULL, 1, ''two'')'
			'drop table x').
			
	expected := String streamContents: [ :s |
		s nextPutAll: sql first; cr;
			nextPutAll: sql second; cr;
			nextPutAll: sql third; cr ].
	
	actual := WriteStream on: String new.
	
	callback := FFICallback 	
						signature: #(void (ExternalAddress appData, String sqlText))
						block: [ :appdata :sqltext |
							"We ignore appdata in this test, because we're passing a null pointer in."
							actual nextPutAll: sqltext; cr ].
	
	"The null pointer appears as appdata in the callback."
	db traceUsing: callback with: ExternalAddress new. 
	
	res := db basicExecute: sql first.
	self assert: (res = 0).
	
	res := db basicExecute: sql second.
	self assert: (res = 0).

	res := db basicExecute: sql third.
	self assert: (res = 0).

	self assert: (actual contents = expected)
	

]
