"
Unit tests for SQLiteConnection
"
Class {
	#name : #SQLiteConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'db',
		'res',
		'rs',
		'target'
	],
	#category : #'SQLite3-Core-Tests-Connections'
}

{ #category : #utilities }
SQLiteConnectionTest >> populateRowsInto: tableName of: database [
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
SQLiteConnectionTest >> setUp [ 

	super setUp.
	db := SQLite3Connection on: ':memory:'.
	db open.

]

{ #category : #running }
SQLiteConnectionTest >> tearDown [
	
	[ db close ] on: SQLite3Misuse do: [ ].
	[ target ifNotNil:[target close] ] on: SQLite3Misuse do: [ ].
	super tearDown.
]

{ #category : #tests }
SQLiteConnectionTest >> testBackup [
	| row backup |
	
	target := SQLite3Connection memory.
	target open.
	self populateRowsInto: 'junk' of: db.
	backup := db backupTo: target.
	backup open; step; finish.
	row := (target execute: 'select * from junk where rt = ''1-ZZZ''') onlyRow.
	
	self assert: (row at: 'rk') equals: 1.
	self assert: (row at: 'rt') equals: '1-ZZZ'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 3) equals: '1-ZZZ'.
	

]

{ #category : #tests }
SQLiteConnectionTest >> testChanges [
	| count |
	count := self populateRowsInto: 'stuff' of: db.
	self assert: db changes equals: 1.
	(db basicExecute: 'delete from stuff').
	self assert: db changes equals: count.

]

{ #category : #tests }
SQLiteConnectionTest >> testExactlyOneRow [
	| row |
	
	self populateRowsInto: 'junk' of: db.
	row := (db execute: 'select * from junk where rt = ''1-ZZZ''') onlyRow.
	
	self assert: (row at: 'rk') equals: 1.
	self assert: (row at: 'rt') equals: '1-ZZZ'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 3) equals: '1-ZZZ'.
	

]

{ #category : #tests }
SQLiteConnectionTest >> testExactlyOneRowGotNone [
	| row |
	
	self populateRowsInto: 'junk' of: db.
	row := (db execute: 'select * from junk where rt = ''0-ZZZ''') onlyRow.
	self assert: row isNil.
	

]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteDelete [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	rs := db execute: 'delete from x;'.
	self assert: (rs next isNil).
	rs close.

]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteDrop [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	rs := db execute: 'drop table x;'.
	self assert: (rs next isNil).
	rs close.

]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteNoResult [
	
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
SQLiteConnectionTest >> testExecuteValueInsertArray [
	| rd |
		
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 1 value: 'two'.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.
	
	rd := (db execute: 'select * from x') rows first.
	self assert: (rd at: 'xk') equals: 1.
	self assert: (rd at: 'iv') equals: 1.
	self assert: (rd at: 'tv') equals: 'two'.
	self assert: (rd at: 1) equals: 1.
	self assert: (rd at: 2) equals: 1.
	self assert: (rd at: 3) equals: 'two'.
	self assert: rd first equals: 1.	
	self assert: rd last equals: 'two'
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertBooleanNilThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, bv boolean);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?)' value: nil.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'bv') equals: nil.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: nil.
	self assert: row first equals: 1.
	self assert: row last equals: nil.
	self assert: rs next isNil.
	rs close.

	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertBooleanThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, bv boolean);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?)' value: true.
	self assert: (rs next isNil)..
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'bv') equals: true.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: true.
	self assert: row first equals: 1.
	self assert: row last equals: true.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertChanges [

	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.
	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 1 value: 'two'.
	self assert: rs next isNil.
	rs close.
	res := db commitTransaction.
	self assert: res equals: 0.
	
	self assert: db changes equals: 1.
	self assert: db totalChanges equals: 1.

	res := db beginTransaction.
	self assert: res equals: 0.
	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 2 value: 'too'.
	self assert: (rs next isNil).
	rs close.
	res := db commitTransaction.
	self assert: res equals: 0.
	
	self assert: db changes equals: 1.
	self assert: db totalChanges equals: 2
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 1 value: 'two'.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'iv') equals: 1.
	self assert: (row at: 'tv') equals: 'two'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: 1.
	self assert: (row at: 3) equals: 'two'.
	self assert: row first equals: 1.
	self assert: row last equals: 'two'.
	self assert: rs next isNil.
	rs close	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertThenSelect2 [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 1 value: 'two'.
	self assert: (rs next isNil).
	rs close.

	rs := db execute: 'insert into x values (NULL, ?, ?)' value: 2 value: 'three'.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'iv') equals: 1.
	self assert: (row at: 'tv') equals: 'two'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: 1.
	self assert: (row at: 3) equals: 'two'.
	self assert: row first equals: 1.
	self assert: row last equals: 'two'.
	row := rs next.
	self assert: (row at: 'xk') equals: 2.
	self assert: (row at: 'iv') equals: 2.
	self assert: (row at: 'tv') equals: 'three'.
	self assert: (row at: 1) equals: 2.
	self assert: (row at: 2) equals: 2.
	self assert: (row at: 3) equals: 'three'.
	self assert: row first equals: 2.
	self assert: row last equals: 'three'.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteValueInsertThenSelectDateTime [
	| row data |
	
	res := db basicExecute: 'create table if not exists x (xv datetime);'.
	self assert: res equals: 0.
	
	res := db beginTransaction.
	self assert: res equals: 0.

	data := DateAndTime year: 2015 month: 4 day: 1.
	rs := db execute: 'insert into x values (?)' value: data.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select xv from x'.	
	row := rs next.
	data := row at: 'xv'.
	self assert: data class equals: DateAndTime.
	self assert: data year equals: 2015.
	self assert: data month equals: 4.
	self assert: data dayOfMonth equals: 1.
	data := row at: 1.
	self assert: data class equals: DateAndTime.
	self assert: data year equals: 2015.
	self assert: data month equals: 4.
	self assert: data dayOfMonth equals: 1.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertArray [
	| rd |
		
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil)..
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.
	
	rd := (db execute: 'select * from x') rows first.
	self assert: (rd at: 'xk') equals: 1.
	self assert: (rd at: 'iv') equals: 1.
	self assert: (rd at: 'tv') equals: 'two'.
	self assert: (rd at: 1) equals: 1.
	self assert: (rd at: 2) equals: 1.
	self assert: (rd at: 3) equals: 'two'.
	self assert: rd first equals: 1.	
	self assert: rd last equals: 'two'
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertBooleanNilThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, bv boolean);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?)' with: (Array with: nil).
	self assert: (rs next isNil)..
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'bv') equals: nil.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: nil.
	self assert: row first equals: 1.
	self assert: row last equals: nil.
	self assert: rs next isNil.
	rs close.

	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertBooleanSQLNullThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, bv boolean);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, NULL)'.
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'bv') equals: nil.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: nil.
	self assert: row first equals: 1.
	self assert: row last equals: nil.
	self assert: rs next isNil.
	rs close	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertBooleanThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, bv boolean);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?)' with: (Array with: true).
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'bv') equals: true.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: true.
	self assert: row first equals: 1.
	self assert: row last equals: true.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertChanges [

	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.
	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.
	
	self assert: db changes equals: 1.
	self assert: db totalChanges equals: 1.

	res := db beginTransaction.
	self assert: res equals: 0.
	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(2 'too').
	self assert: (rs next isNil).
	rs close.
	res := db commitTransaction.
	self assert: res equals: 0.
	
	self assert: db changes equals: 1.
	self assert: db totalChanges equals: 2
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertDictionary [
	| rd |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, :first, :two)'
		with: (Dictionary newFromPairs: #(':first' 1 ':two' '2' ':nosuch' 3)).
	self assert: (rs next isNil)..
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.
	
	rd := (db execute: 'select * from x') rows first.
	self assert: (rd at: 'xk') equals: 1.
	self assert: (rd at: 'iv') equals: 1.
	self assert: (rd at: 'tv') equals: '2'.
	self assert: (rd at: 1) equals: 1.
	self assert: (rd at: 2) equals: 1.
	self assert: (rd at: 3) equals: '2'.
	self assert: rd first equals: 1.	
	self assert: rd last equals: '2'
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertMultilingualStringsThenSelect [
	| data s row idx |
	
	data := OrderedCollection with: 'English' with: '中文' with: 'にほんご', 'áěšřčá'.

	res := db basicExecute: 'create table if not exists x (xk integer primary key, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	data do: [ :x |
 		s at: 1 putString: x.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.

	idx := 1.	
	rs := db execute: 'select xk, tv from x order by xk asc'.	
	[ (row := rs next) isNotNil ] whileTrue: [
		self assert: (row at: 'xk') equals: idx.
		self assert: (row at: 'tv') equals: (data at: idx).
		idx := idx + 1 ].
	rs close.
	self assert: idx equals: 4
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertNoDataThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL)' with: #().
	self assert: rs next isNil.
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 1) equals: 1.
	self assert: row first equals: 1.
	self assert: row last equals: 1.
	rs close

	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelect [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'iv') equals: 1.
	self assert: (row at: 'tv') equals: 'two'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: 1.
	self assert: (row at: 3) equals: 'two'.
	self assert: row first equals: 1.
	self assert: row last equals: 'two'.
	self assert: rs next isNil.
	rs close	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelect2 [
	| row |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(1 'two').
	self assert: (rs next isNil).
	rs close.

	rs := db execute: 'insert into x values (NULL, ?, ?)' with: #(2 'three').
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select * from x'.	
	row := rs next.
	self assert: (row at: 'xk') equals: 1.
	self assert: (row at: 'iv') equals: 1.
	self assert: (row at: 'tv') equals: 'two'.
	self assert: (row at: 1) equals: 1.
	self assert: (row at: 2) equals: 1.
	self assert: (row at: 3) equals: 'two'.
	self assert: row first equals: 1.
	self assert: row last equals: 'two'.
	row := rs next.
	self assert: (row at: 'xk') equals: 2.
	self assert: (row at: 'iv') equals: 2.
	self assert: (row at: 'tv') equals: 'three'.
	self assert: (row at: 1) equals: 2.
	self assert: (row at: 2) equals: 2.
	self assert: (row at: 3) equals: 'three'.
	self assert: row first equals: 2.
	self assert: row last equals: 'three'.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelect3 [
	| s row idx |
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?, ?)'.
	1 to: 10 do: [ :x |
		s at: 1 putInteger: x * x.
		s at: 2 putString: x asString, ' * ', x asString.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.

	idx := 1.	
	rs := db execute: 'select * from x where iv < ?' with: #(27).	
	[ (row := rs next) isNotNil ] whileTrue: [
		self assert: (row at: 'xk') equals: idx.
		self assert: (row at: 'iv') equals: (idx * idx).
		self assert: (row at: 'tv') equals: (idx asString, ' * ', idx asString).
		self assert: (row at: 1) equals: idx.
		self assert: (row at: 2) equals: (idx * idx).
		self assert: (row at: 3) equals: (idx asString, ' * ', idx asString).
		self assert: row first equals: idx.
		self assert: row last equals: (idx asString, ' * ', idx asString).
		idx := idx + 1 ].
	rs close.
	self assert: idx equals: 6
	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelectChineseTableName [
	| data s row idx |
	
	data := OrderedCollection with: 'English' with: '中文' with: 'にほんご', 'áěšřčá'.

	res := db basicExecute: 'create table if not exists 表一 (xk integer primary key, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from 表一;'.
	self assert: res equals: 0.	

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into 表一 values (NULL, ?)'.
	data do: [ :x |
 		s at: 1 putString: x.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.

	idx := 1.	
	rs := db execute: 'select xk, tv from 表一 order by xk asc'.	
	[ (row := rs next) isNotNil ] whileTrue: [
		self assert: (row at: 'xk') equals: idx.
		self assert: (row at: 'tv') equals: (data at: idx).
		idx := idx + 1 ].
	rs close.
	self assert: idx equals: 4
	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelectDateTime [
	| row data |
	
	res := db basicExecute: 'create table if not exists x (xv datetime);'.
	self assert: res equals: 0.
	
	res := db beginTransaction.
	self assert: res equals: 0.

	data := DateAndTime year: 2015 month: 4 day: 1.
	rs := db execute: 'insert into x values (?)' with: (Array with: data).
	self assert: (rs next isNil).
	rs close.

	res := db commitTransaction.
	self assert: res equals: 0.

	rs := db execute: 'select xv from x'.	
	row := rs next.
	data := row at: 'xv'.
	self assert: data class equals: DateAndTime.
	self assert: data year equals: 2015.
	self assert: data month equals: 4.
	self assert: data dayOfMonth equals: 1.
	data := row at: 1.
	self assert: data class equals: DateAndTime.
	self assert: data year equals: 2015.
	self assert: data month equals: 4.
	self assert: data dayOfMonth equals: 1.
	self assert: rs next isNil.
	rs close
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithInsertThenSelectJapaneseTableName [
	| data s row idx |
	
	data := OrderedCollection with: 'English' with: '中文' with: 'にほんご', 'áěšřčá'.

	res := db basicExecute: 'create table if not exists テーブル一 (xk integer primary key, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from テーブル一;'.
	self assert: res equals: 0.	

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into テーブル一 values (NULL, ?)'.
	data do: [ :x |
 		s at: 1 putString: x.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.

	idx := 1.	
	rs := db execute: 'select xk, tv from テーブル一 order by xk asc'.	
	[ (row := rs next) isNotNil ] whileTrue: [
		self assert: (row at: 'xk') equals: idx.
		self assert: (row at: 'tv') equals: (data at: idx).
		idx := idx + 1 ].
	rs close.
	self assert: idx equals: 4
	 
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithToFail [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	self should: [ db execute: 'insert into x values (NULL, ?, ?)' with: 42 ]
		raise: SQLite3AbstractError.

	res := db rollbackTransaction.
	self assert: res equals: 0
]

{ #category : #tests }
SQLiteConnectionTest >> testExecuteWithToFail2 [
	
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	self should: [ db execute: 'insert into x values (NULL, ?, ?)' with: '42' ]
		raise: SQLite3AbstractError.

	res := db rollbackTransaction.
	self assert: res equals: 0
]

{ #category : #tests }
SQLiteConnectionTest >> testGetAutocommit [
	
	self assert: db getAutoCommit equals: true.
	db beginTransaction.
	self assert: db getAutoCommit equals: false.
	db rollbackTransaction.
	self assert: db getAutoCommit equals: true.
	

]

{ #category : #'tests - glorp compatibility' }
SQLiteConnectionTest >> testGlorpAutoID [
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
	self assert: (rows first at: 'lid') equals: 2.
	
	rows := (db execute: 'select * from BOOK') rows.
	self assert: rows size equals: 2.
	self assert: (rows first at: 'ID') equals: 1.
	self assert: (rows first at: 'STUFF') equals: 'The Bad Beginning'.
	

]

{ #category : #'tests - glorp compatibility' }
SQLiteConnectionTest >> testGlorpCompositeKey [
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
	
	self assert: rows size equals: 2.
	self assert: (rows first at: 'ID') equals: 1.
	self assert: (rows first at: 'NAME') equals: 'User One'

]

{ #category : #'tests - glorp compatibility' }
SQLiteConnectionTest >> testGlorpDoubleInsertPrimaryKey [
	| schema rows |
	
	schema := 'CREATE TABLE GR_USER (ID integer  NOT NULL ,NAME text  NULL , CONSTRAINT GR_USER_PK PRIMARY KEY  (ID), CONSTRAINT GR_USER_UNIQ UNIQUE  (ID));'.
	
	db basicExecute: schema.
	db beginTransaction.
	db execute: 'insert into GR_USER values (?, ?)' 
		with: #(1 'Fred').
	self should: [ db execute: 'insert into GR_USER values (?, ?)' with: #(1 'Barney') ]
		raise: SQLite3AbstractError.
	db commitTransaction.	
	
	rs := db execute: 'select * from GR_USER'.
	rows := rs rows.
	
	self assert: rows size equals: 1.
	self assert: (rows first at: 'ID') equals: 1.
	self assert: (rows first at: 'NAME') equals: 'Fred'.
	

]

{ #category : #'tests - glorp compatibility' }
SQLiteConnectionTest >> testGlorpUpdate [
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
	
	self assert: rows size equals: 1.
	self assert: (rows first at: 'ID') equals: 1.
	self assert: (rows first at: 'TITLE') equals: 'The Bad Beginning'.
	self assert: (rows first at: 'COPIES_IN_STOCK') equals: 6
]

{ #category : #'tests - glorp compatibility' }
SQLiteConnectionTest >> testGlorpUpdateTwice [
	| schema rows |
	
	schema := 'CREATE TABLE BOOK (ID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,TITLE text  NULL ,DESCRIPTION text  NULL ,COPIES_IN_STOCK int  NULL ,VERSION int  NULL );'.
	
	db basicExecute: schema.
	db beginTransaction.
	db execute: 'insert into BOOK (TITLE,COPIES_IN_STOCK,VERSION) values (?, ?, ?)' 
		with: #('The Bad Beginning' 3 6).
	db execute: 'UPDATE BOOK SET COPIES_IN_STOCK = 7'.
	db execute: 'UPDATE BOOK SET TITLE = ?,COPIES_IN_STOCK = ?,VERSION = ? WHERE ID = ? AND BOOK.VERSION = ?'
		with: #('The Bad Beginning' 6 7 1 6).
	db commitTransaction.	
	
	rs := db execute: 'select * from BOOK'.
	rows := rs rows.
	
	self assert: rows size equals: 1.
	self assert: (rows first at: 'ID') equals: 1.
	self assert: (rows first at: 'TITLE') equals: 'The Bad Beginning'.
	self assert: (rows first at: 'COPIES_IN_STOCK') equals: 6
]

{ #category : #tests }
SQLiteConnectionTest >> testInsertThenSelectInTransaction [
	"From GlorpDatabaseBasicTest>>testNameBinding."
	
	res := db basicExecute: 'create table if not exists x (id integer , tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	db basicExecute: 'insert into x values (10, "abc")'.
	db basicExecute: 'insert into x values (20, "def")'.
	db basicExecute: 'insert into x values (30, "ghi")'.
	
	rs := db execute: 'select * from x where id = ? or id = ?' with: { 10. 30 }.
	self assert: rs rows size equals: 2.

	res := db rollbackTransaction.
	self assert: res equals: 0	
]

{ #category : #tests }
SQLiteConnectionTest >> testRows [
	"SQLite uses 1-based column indexing for database rows."
	| rowCount rows any |
	
	rowCount := self populateRowsInto: 'junk' of: db.
	rs := db execute: 'select * from junk'.
	rs rowClass: SQLite3Row.
	rows := rs rows.
	
	self assert: rows size equals: rowCount.
	self assert: (rows first at: 'rk') equals: 1.
	self assert: (rows first at: 'rt') equals: '1-ZZZ'.
	self assert: (rows first at: 1) equals: 1.
	self assert: (rows first at: 3) equals: '1-ZZZ'.
	
	1 to: 5 do: [ :x |
		any := Random new nextInt: rowCount.
		self assert: ((rows at: any) at: 'rk') equals: any.
		self assert: ((rows at: any) at: 'rt') equals: (any asString, '-ZZZ').
		self assert: (((rows at: any) at: 'rn') \\ any) equals: 0.
		self assert: ((rows at: any) at: 1) equals: any.
		self assert: (((rows at: any) at: 2) \\ any) equals: 0.
		self assert: ((rows at: any) at: 3) equals: (any asString, '-ZZZ') ].
			
	self assert: (rows last at: 'rk') equals: rowCount.
	self assert: (rows last at: 'rt') equals: (rowCount asString, '-ZZZ').
	self assert: (rows last at: 1) equals: rowCount.
	self assert: (rows last at: 3) equals: (rowCount asString, '-ZZZ').
		

]

{ #category : #tests }
SQLiteConnectionTest >> testStatementReadOnly [

	| stmt |
	
	self populateRowsInto: 'junk' of: db.
	stmt := db prepare: 'select * from junk'.
	self assert: stmt isReadOnly equals: true.
	stmt := db prepare: 'delete from junk'.
	self assert: stmt isReadOnly equals: false.
]

{ #category : #tests }
SQLiteConnectionTest >> testValueInsertThenSelectInTransaction [
	"From GlorpDatabaseBasicTest>>testNameBinding."
	
	res := db basicExecute: 'create table if not exists x (id integer , tv text);'.
	self assert: res equals: 0.
	
	res := db basicExecute: 'delete from x;'.
	self assert: res equals: 0.	

	res := db beginTransaction.
	self assert: res equals: 0.

	db basicExecute: 'insert into x values (10, "abc")'.
	db basicExecute: 'insert into x values (20, "def")'.
	db basicExecute: 'insert into x values (30, "ghi")'.
	
	rs := db execute: 'select * from x where id = ? or id = ?' value: 10 value: 30.
	self assert: rs rows size equals: 2.

	res := db rollbackTransaction.
	self assert: res equals: 0	
]

{ #category : #tests }
SQLiteConnectionTest >> untestStatementInProgress [
	"XXX Doesn't work yet."
	| s1 s2 |
		
	res := db basicExecute: 'create table if not exists x (xk integer primary key, iv integer);'.
	self assert: res equals: 0.
	
	
	db beginTransaction.
	s1 := db prepare: 'insert into x values (NULL, ?)'.
	s1 at: 1 putInteger: 1.
	"s1 step."

	db execute: 'delete from x;'.
	"self should: [ db rollbackTransaction ] raise: SQLite3Error."
	db commitTransaction.

	s1 reset.
	s1 finalize

	

  
]
