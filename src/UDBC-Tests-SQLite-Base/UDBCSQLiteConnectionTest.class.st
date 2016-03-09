"
Unit tests for UDBCSQLiteConnection
"
Class {
	#name : #UDBCSQLiteConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'db',
		'res',
		'rs'
	],
	#category : #'UDBC-Tests-SQLite-Base-Connections'
}

{ #category : #utilities }
UDBCSQLiteConnectionTest >> populateRowsInto: tableName of: database [
	| rand rows schema insert rn rt |
	 rand := Random new.	
	rows := rand nextInt: 100.

	schema := 'create table ', tableName, ' (rk integer primary key, rn integer, rt text);'.
	insert := 'insert into ', tableName, ' values (?, ?, ?)'.
	
	database basicExecute: 'begin'. 
	database	basicExecute: schema.	
	1 to: rows do: [ :i |
		rn := i * (rand nextInt: 10).
		rt := i asString, '-ZZZ'.
		database execute: insert with: (Array with: i with: rn with: rt) ].	
	database basicExecute: 'commit'.
	
	^ rows
	
	

]

{ #category : #running }
UDBCSQLiteConnectionTest >> setUp [ 

	super setUp.
	db := UDBCSQLite3Connection on: ':memory:'.
	db open.

]

{ #category : #running }
UDBCSQLiteConnectionTest >> tearDown [
	
	[ db close ] on: UDBCSQLite3Misuse do: [ ].
	super tearDown.
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteDelete [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	rs := db execute: 'delete from x;'.
	self assert: (rs next isNil).
	rs close.

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteDrop [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	rs := db execute: 'drop table x;'.
	self assert: (rs next isNil).
	rs close.

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteNoResult [
	
	rs := db execute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (rs next isNil).
	rs close.
	
	rs := db execute: 'delete from x;'.
	self assert: (rs next isNil).
	rs close.
	
	rs := db execute: 'drop table x;'.
	self assert: (rs next isNil).
	rs close.


]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsert [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsert2 [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL, :first, :two)'
		with: (Dictionary newFromPairs: #(':first' 1 ':two' 2 ':nosuch' 3)).
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsertChanges [

	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).
	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.
	res := db commitTransaction.
	self assert: (res = 0).
	
	self assert: (db changes = 1).
	self assert: (db totalChanges = 1).

	res := db beginTransaction.
	self assert: (res = 0).
	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(2 'too').
	self assert: (rs next isNil).
	rs close.
	res := db commitTransaction.
	self assert: (res = 0).
	
	self assert: (db changes = 1).
	self assert: (db totalChanges = 2).

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsertNoDataThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL)' with: #().
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: ((row at: 'xk') = 1).
	rs close.

	 
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsertThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: ((row at: 'xk') = 1).
	self assert: ((row at: 'iv') = 1).
	self assert: ((row at: 'tv') = 'two').
	self assert: (rs next isNil).
	rs close.

	 
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsertThenSelect2 [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(2 'three').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: ((row at: 'xk') = 1).
	self assert: ((row at: 'iv') = 1).
	self assert: ((row at: 'tv') = 'two').
	row := rs next.
	self assert: ((row at: 'xk') = 2).
	self assert: ((row at: 'iv') = 2).
	self assert: ((row at: 'tv') = 'three').
	self assert: (rs next isNil).
	rs close.

	 
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithInsertThenSelectDateTime [
	| row data |
	
	res := db basicExecute: 'create table if not exists x (xv datetime);'.
	self assert: (res = 0).
	
	res := db beginTransaction.
	self assert: (res = 0).

	data := DateAndTime year: 2015 month: 4 day: 1.
	rs := db execute: 'insert into x values (?)' with: (Array with: data).
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).

	rs := db execute: 'select xv from x'.	
	row := rs next.
	data := row at: 'xv'.
	self assert: (data class = DateAndTime).
	self assert: (data year = 2015).
	self assert: (data month = 4).
	self assert: (data dayOfMonth = 1).
	self assert: (rs next isNil).
	rs close.

	 
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithToFail [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	self should: [ db execute: 'insert into x values (NULL, ?, ?)' with: 42 ]
		raise: UDBCSQLite3Error.

	res := db rollbackTransaction.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testExecuteWithToFail2 [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	self should: [ db execute: 'insert into x values (NULL, ?, ?)' with: '42' ]
		raise: UDBCSQLite3Error.

	res := db rollbackTransaction.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testRows [
	| rowCount rows any |
	
	rowCount := self populateRowsInto: 'junk' of: db.
	rows := (db execute: 'select * from junk') rows.
	
	self assert: (rows size = rowCount).
	self assert: (rows first at: 'rk') = 1.
	self assert: (rows first at: 'rt') = '1-ZZZ'.
	
	1 to: 5 do: [ :x |
		any := Random new nextInt: rowCount.
		self assert: ((rows at: any) at: 'rk') = any.
		self assert: ((rows at: any) at: 'rt') = (any asString, '-ZZZ').
		self assert: (((rows at: any) at: 'rn') \\ any) = 0 ].
			
	self assert: (rows last at: 'rk') = rowCount.
	self assert: (rows last at: 'rt') = (rowCount asString, '-ZZZ').
		

]
