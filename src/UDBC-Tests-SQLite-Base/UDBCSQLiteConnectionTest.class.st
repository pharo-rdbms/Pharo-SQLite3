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
UDBCSQLiteConnectionTest >> testExecuteWithInsertArray [
	| rd |
		
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
	
	rd := (db execute: 'select * from x') rows first.
	self assert: ((rd at: 'xk') = 1).
	self assert: ((rd at: 'iv') = 1).
	self assert: ((rd at: 'tv') = 'two').
	self assert: ((rd at: 1) = 1).
	self assert: ((rd at: 2) = 1).
	self assert: ((rd at: 3) = 'two').
	self assert: (rd first = 1).	
	self assert: (rd last = 'two').
	
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
UDBCSQLiteConnectionTest >> testExecuteWithInsertDictionary [
	| rd |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	rs := db execute: 'insert into x values (NULL, :first, :two)'
		with: (Dictionary newFromPairs: #(':first' 1 ':two' '2' ':nosuch' 3)).
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: (res = 0).
	
	rd := (db execute: 'select * from x') rows first.
	self assert: ((rd at: 'xk') = 1).
	self assert: ((rd at: 'iv') = 1).
	self assert: ((rd at: 'tv') = '2').
	self assert: ((rd at: 1) = 1).
	self assert: ((rd at: 2) = 1).
	self assert: ((rd at: 3) = '2').
	self assert: (rd first = 1).	
	self assert: (rd last = '2').
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
	self assert: ((row at: 1) = 1).
	self assert: (row first = 1).
	self assert: (row last = 1).
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
	self assert: ((row at: 1) = 1).
	self assert: ((row at: 2) = 1).
	self assert: ((row at: 3) = 'two').
	self assert: (row first = 1).
	self assert: (row last = 'two').
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
	self assert: ((row at: 1) = 1).
	self assert: ((row at: 2) = 1).
	self assert: ((row at: 3) = 'two').
	self assert: (row first = 1).
	self assert: (row last = 'two').
	row := rs next.
	self assert: ((row at: 'xk') = 2).
	self assert: ((row at: 'iv') = 2).
	self assert: ((row at: 'tv') = 'three').
	self assert: ((row at: 1) = 2).
	self assert: ((row at: 2) = 2).
	self assert: ((row at: 3) = 'three').
	self assert: (row first = 2).
	self assert: (row last = 'three').
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
	data := row at: 1.
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
UDBCSQLiteConnectionTest >> testGlorpAutoID [
	| schema rows |
	
	schema := 'CREATE TABLE BOOK (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, STUFF TEXT NOT NULL);'.
	
	db basicExecute: schema.
	db beginTransaction.
	db execute: 'insert into BOOK (STUFF) values (?)' 
		with: #('The Bad Beginning').
	db execute: 'insert into BOOK (STUFF) values (?)' 
		with: #('Better Now').
	db commitTransaction.	
	
	rows := (db execute: 'select last_insert_rowid() as lid') rows.
	self assert: (rows first at: 'lid') = 2.
	
	rows := (db execute: 'select * from BOOK') rows.
	self assert: (rows size = 2).
	self assert: (rows first at: 'ID') = 1.
	self assert: (rows first at: 'STUFF') = 'The Bad Beginning'.
	

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testGlorpCompositeKey [
	| schema rows |
	
	"This is the schema generated by Glorp."
	schema := 'CREATE TABLE GR_USER (ID integer  NOT NULL ,NAME text  NULL , CONSTRAINT GR_USER_PK PRIMARY KEY  (ID), CONSTRAINT GR_USER_UNIQ UNIQUE  (ID));'.
	
	db basicExecute: schema.
	db beginTransaction.
	db execute: 'insert into GR_USER values (?, ?)' with: #(1 'User One').
	db execute: 'insert into GR_USER values (?, ?)' with: #(2 'User Two').
	db commitTransaction.	
	
	rs := db execute: 'select ID,NAME from GR_USER'.
	rows := rs rows.
	
	self assert: (rows size = 2).
	self assert: (rows first at: 'ID') = 1.
	self assert: (rows first at: 'NAME') = 'User One'.
	

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testGlorpUpdate [
	| schema rows |
	
	schema := 'CREATE TABLE BOOK (ID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,TITLE text  NULL ,DESCRIPTION text  NULL ,COPIES_IN_STOCK int  NULL ,VERSION int  NULL );'.
	
	db basicExecute: schema.
	db beginTransaction.
	db execute: 'insert into BOOK (TITLE,COPIES_IN_STOCK,VERSION) values (?, ?, ?)' 
		with: #('The Bad Beginning' 3 6).
	db execute: 'UPDATE BOOK SET TITLE = ?,COPIES_IN_STOCK = ?,VERSION = ? WHERE ID = ? AND BOOK.VERSION = ?'
		with: #('The Bad Beginning' 6 7 1 6).
	db commitTransaction.	
	
	rs := db execute: 'select * from BOOK'.
	rows := rs rows.
	
	self assert: (rows size = 1).
	self assert: (rows first at: 'ID') = 1.
	self assert: (rows first at: 'TITLE') = 'The Bad Beginning'.
	

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testInsertThenSelectInTransaction [
	"From GlorpDatabaseBasicTest>>testNameBinding."
	
	res := db basicExecute: 'create table if not exists x (id integer , tv text);'.
	self assert: (res = 0).
	
	res := db basicExecute: 'delete from x;'.
	self assert: (res = 0).	

	res := db beginTransaction.
	self assert: (res = 0).

	db basicExecute: 'insert into x values (10, "abc")'.
	db basicExecute: 'insert into x values (20, "def")'.
	db basicExecute: 'insert into x values (30, "ghi")'.
	
	rs := db execute: 'select * from x where id = ? or id = ?' with: { 10. 30 }.
	self assert: rs rows size = 2.

	res := db rollbackTransaction.
	self assert: (res = 0).
	
]

{ #category : #tests }
UDBCSQLiteConnectionTest >> testRows [
	"SQLite uses 1-based column indexing for database rows."
	| rowCount rows any |
	
	rowCount := self populateRowsInto: 'junk' of: db.
	rs := db execute: 'select * from junk'.
	rs rowClass: UDBCSQLite3Row.
	rows := rs rows.
	
	self assert: (rows size = rowCount).
	self assert: (rows first at: 'rk') = 1.
	self assert: (rows first at: 'rt') = '1-ZZZ'.
	self assert: (rows first at: 1) = 1.
	self assert: (rows first at: 3) = '1-ZZZ'.
	
	1 to: 5 do: [ :x |
		any := Random new nextInt: rowCount.
		self assert: ((rows at: any) at: 'rk') = any.
		self assert: ((rows at: any) at: 'rt') = (any asString, '-ZZZ').
		self assert: (((rows at: any) at: 'rn') \\ any) = 0.
		self assert: ((rows at: any) at: 1) = any.
		self assert: (((rows at: any) at: 2) \\ any) = 0.
		self assert: ((rows at: any) at: 3) = (any asString, '-ZZZ') ].
			
	self assert: (rows last at: 'rk') = rowCount.
	self assert: (rows last at: 'rt') = (rowCount asString, '-ZZZ').
	self assert: (rows last at: 1) = rowCount.
	self assert: (rows last at: 3) = (rowCount asString, '-ZZZ').
		

]

{ #category : #tests }
UDBCSQLiteConnectionTest >> untestStatementInProgress [
	"XXX Doesn't work yet."
	| s1 s2 |
		
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer);'.
	self assert: (res = 0).
	
	
	db beginTransaction.
	s1 := db prepare: 'insert into x values (NULL, ?)'.
	s1 at: 1 putInteger: 1.
	"s1 step."

	db execute: 'delete from x;'.
	"self should: [ db rollbackTransaction ] raise: UDBCSQLite3Error."
	db commitTransaction.

	s1 reset.
	s1 finalize.
	
	

	

  
]
