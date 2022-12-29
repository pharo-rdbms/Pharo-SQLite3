"
Unit tests for SQLiteBaseConnection
"
Class {
	#name : #SQLite3BaseConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'db',
		'res'
	],
	#category : #'SQLite3-Core-Tests-Connections'
}

{ #category : #'tests - DEACTIVATED' }
SQLite3BaseConnectionTest >> deactivatedTestTracing [
	| sql callback expected actual  |
	
	(SystemVersion current major >= 7) ifTrue: [ self skip ].
	"This test invokes a callback from SQLite to Pharo. It works in Pharo 6 and earlier but not in Pharo 7."
	
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
	self assert: res equals: 0.
	
	res := db basicExecute: sql second.
	self assert: res equals: 0.

	res := db basicExecute: sql third.
	self assert: res equals: 0.

	self assert: actual contents equals: expected
]

{ #category : #tests }
SQLite3BaseConnectionTest >> invalidFileNameOnCurrentOperatingSystem [
	^Smalltalk os isWindows
		ifTrue: [ '/&*no' ]
		ifFalse: [ '/nosuchfile' ]
]

{ #category : #tests }
SQLite3BaseConnectionTest >> noTestColumnNamesBobbyGo [

	"In this test, Bobby Tables strikes naive SQL string construction."

	"20190302, pierce: #basicExecute: uses prepare/step/finalize internally and is no longer susceptible to injection attacks. "

	| tables bobby |
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	res := db basicExecute:
		       'create table students (sk integer, sname varchar);'.
	self assert: res equals: 0.

	tables := db tableNames.
	self assert: tables size equals: 2.
	self assert: tables first equals: 'x'.
	self assert: tables second equals: 'students'.

	bobby := 'x); drop table students; --'.
	res := db basicExecute: 'pragma table_info(' , bobby , ')'.
	self assert: res equals: 0.

	tables := db tableNames.
	self assert: tables size equals: 1.
	self assert: tables first equals: 'x'
]

{ #category : #running }
SQLite3BaseConnectionTest >> setUp [ 

	super setUp.
	db := SQLite3BaseConnection on: ':memory:'.
	db open.

]

{ #category : #running }
SQLite3BaseConnectionTest >> tearDown [
	
	[ db close ] on: SQLite3Misuse do: [ ].
	super tearDown

]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testBadOpen [
	| newConnection |
	newConnection := SQLite3BaseConnection
		on: self invalidFileNameOnCurrentOperatingSystem.
	self should: [ newConnection open ] raise: SQLite3CantOpen.
	self deny: newConnection isOpen
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testBasicExecuteOk [

	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	res := db basicExecute: 'drop table x;'.
	self assert: res equals: 0.
	
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testBasicExecuteSyntaxError [

	self should: [ db basicExecute: 'create table,;' ]
		raise: SQLite3AbstractError
	
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testBooleanColumnTypeMismatch [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv notboolean);'.
	self assert: res equals: 0.

	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ].
	s finalize.
	
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testBooleanObject [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putObject: true.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row objectAt: 0.
		self assert: v equals: true ].
	s finalize.
	
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerOneThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putInteger: 1.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: true ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerTwoThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putInteger: 2.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerZeroThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putInteger: 0.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: false ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteNilThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putNil: nil.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: nil ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteSQLNullThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, NULL)'.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: nil ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringFalseThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putString: 'false'.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: false ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringTrueThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putString: 'true'.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: true ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringTwoThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putString: '2'.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ].
	s finalize
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteThenRead [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xv boolean);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putBoolean: true.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row booleanAt: 0.
		self assert: v equals: true ].
	s finalize
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNames [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	columns := db columnNamesFor: 'x'.
	self assert: columns size equals: 2.
	self assert: columns first equals: 'xk'.
	self assert: columns second equals: 'xv'.
	

]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesBobbyStop [
	"In this test, Bobby Tables strikes again, but fails, because #columnNamesFor: uses parameter binding."
	| columns tables |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	res := db basicExecute: 'create table students (sk integer, sname varchar);'.
	self assert: res equals: 0.

	tables := db tableNames.
	self assert: tables size equals: 2.
	self assert: tables first equals: 'x'.	
	self assert: tables second equals: 'students'.	
	
	columns := db columnNamesFor: 'x; drop table students; --'.
	self assert: (columns isNil).

	tables := db tableNames.
	self assert: tables size equals: 2.
	self assert: tables first equals: 'x'.	
	self assert: tables second equals: 'students'
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesNoSuchTable [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	columns := db columnNamesFor: 'y'.
	self assert: (columns isNil).
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testConstraintViolation [
	db
		basicExecute: 'create table x (value integer primary key);';
		basicExecute: 'insert into x values(1);'.
	self should: [ db basicExecute: 'insert into x values(1);' ] raise: SQLite3ConstraintViolation 
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testDataValuesAvailable [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.

	res := db basicExecute: 'insert into x values (NULL, 1, "duh");'.	
	self assert: res equals: 0.
	
	s := db prepare: 'select * from x'.
	s basicExecute: [  :row |
		self assert: row dataValuesAvailable equals: 3 ].
	s finalize
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testDateAndTime [
	| data s | 
	
	data := DateAndTime year: 2015 month: 4 day: 1.
	
	res := db basicExecute: 'create table x (xv datetime);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (?)'.
	s at: 1 putDateTime: data.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row dateTimeAt: 0.
		self assert: v year equals: 2015.
		self assert: v month equals: 4.
		self assert: v dayOfMonth equals: 1 ].
	s finalize
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testDeclaredColumnTypes [
	| columns |
	
	res := db basicExecute: 'create table x (xk integer, xv blob, xb boolean);'.
	self assert: res equals: 0.
	columns := db declaredColumnTypesFor: 'x'.
	self assert: columns size equals: 3.
	self assert: columns first equals: 'integer'.
	self assert: columns second equals: 'blob'.
	self assert: columns third equals: 'boolean'
]

{ #category : #'tests - multilingual' }
SQLite3BaseConnectionTest >> testDefaultMultilingualStrings [
	| s | 
	
	res := db basicExecute: 'create table x (xk integer primary key, xm1 text default ''中文'', xm2 text default ''áěšřčá'');'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	(db prepare: 'insert into x (xk) values (NULL)')
		step;
		finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xm1, xm2 from x order by xk'.
	s basicExecute: [  :row |
		self assert: (row stringAt: 0) equals: '中文' .
		self assert: (row stringAt: 1) equals: 'áěšřčá' ].
	s finalize
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testDoubleClose [
	
	db close.
	[ db close ] on: SQLite3Misuse do: [ ]
	"#tearDown will close the db again, and is similarly guarded."
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testFloat [
	| s |	
	res := db basicExecute: 'create table x (xk integer primary key, xv real);'.
	self assert: res equals: 0.
	res := db basicExecute: 'insert into x values (NULL, 1.141);'.
	self assert: res equals: 0.
	
	s := db prepare: 'select * from x'.
	s basicExecute: [ :row |
		self assert: (row nameOfColumn: 1) equals: 'xv'.
		self assert: (row floatAt: 1) equals: 1.141 ].
	s finalize
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testInteger [
	"The large integer comes from Glorp's testInt8."
	| s |	
		
	res := db basicExecute: 'create table x (xk integer primary key, xv integer);'.
	self assert: res equals: 0.

	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putInteger: 3212321555.
	s step. 		
	s finalize.	
	
	s := db prepare: 'select * from x'.
	s basicExecute: [ :row |
		self assert: (row nameOfColumn: 1) equals: 'xv'.
		self assert: (row integerAt: 1) equals: 3212321555 ].
	s finalize
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testIsAbstract [ 

	self assert: SQLite3BaseConnection isAbstract 
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testIsThreadsafe [

	self assert: (SQLite3BaseConnection isThreadsafe isKindOf: Boolean)
]

{ #category : #'tests - multilingual' }
SQLite3BaseConnectionTest >> testMultilingualStrings [
	| data s idx | 
	
	data := OrderedCollection with: 'English' with: '中文' with: 'にほんご', 'áěšřčá'.
	
	res := db basicExecute: 'create table x (xk integer primary key, xv varchar);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	data do: [ :ea |
		s at: 1 putString: ea.
		s step; clearBindings; reset ].
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	idx := 1.
	s := db prepare: 'select xv from x order by xk asc'.
	s basicExecute: [  :row |
		self assert: (row stringAt: 0) equals: (data at: idx).
		idx := idx + 1 ].
	s finalize
]

{ #category : #'tests - multilingual' }
SQLite3BaseConnectionTest >> testMultilingualTableName [
	| s | 
	
	res := db basicExecute: 'create table 表一 (xk integer primary key, xm1 text default ''中文'');'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	(db prepare: 'insert into 表一 (xk) values (NULL)')
		step;
		finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xm1 from 表一 order by xk'.
	s basicExecute: [  :row |
		self assert: (row stringAt: 0) equals: '中文' ].
	s finalize
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testObjectBlob [
	| data s | 
	
	data := OrderedCollection with: 1 with: 'two' with: 3.3.
	
	res := db basicExecute: 'create table x (xk integer primary key, xv blob);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putObject: data.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row objectAt: 0.
		self assert: v size equals: 3.
		self assert: v first equals: 1.
		self assert: v second equals: 'two'.
		self assert: v third equals: 3.3 ].
	s finalize
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testPrepareStep [
	| s i sql | 
	
	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?, ?)'.
	sql := s sqlText.
	self assert: sql equals: 'insert into x values (NULL, ?, ?)'.
	1 to: 10 do: [ :x |
		s at: 1 putInteger: x * x.
		s at: 2 putString: x asString, ' * ', x asString.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select * from x'.
	sql := s sqlText.
	self assert: sql equals: 'select * from x'.
	s basicExecute: [  :row |
		i := row integerAt: 0.
		self assert: (row integerAt: 1) equals: (i * i).
		self assert: (row stringAt: 2) equals: (i asString, ' * ', i asString) ].
	s finalize
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testPrepareStepSelective [
	| s i sql count | 
	
	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (NULL, ?, ?)'.
	sql := s sqlText.
	self assert: sql equals: 'insert into x values (NULL, ?, ?)'.
	1 to: 10 do: [ :x |
		s at: 1 putInteger: x * x.
		s at: 2 putString: x asString, ' * ', x asString.
		s step. s clearBindings. s reset. ].		
	s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	count := 0.
	s := db prepare: 'select * from x where iv < ?'.
	sql := s sqlText.
	self assert: sql equals: 'select * from x where iv < ?'.
	s at: 1 putInteger: 27.
	s basicExecute: [  :row |
		count := count + 1.
		i := row integerAt: 0.
		self assert: (row integerAt: 1) equals: (i * i).
		self assert: (row stringAt: 2) equals: (i asString, ' * ', i asString) ].
	s finalize.
	self assert: count equals: 5
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testResultSetColumnIntrospection [
	| s | 

	res := db basicExecute: 'create table x (xk integer primary key, iv integer, tv text);'.
	self assert: res equals: 0.

	res := db basicExecute: 'insert into x values (NULL, 1, "duh");'.	
	self assert: res equals: 0.
	
	s := db prepare: 'select * from x'.
	s basicExecute: [  :row |
		self assert: (row nameOfColumn: 0) equals: 'xk'.
		self assert: (row valueOfColumn: 0) equals: 1.
		self assert: (row nameOfColumn: 1) equals: 'iv'.
		self assert: (row valueOfColumn: 1) equals: 1.
		self assert: (row nameOfColumn: 2) equals: 'tv'.
		self assert: (row valueOfColumn: 2) equals: 'duh' ].
	s finalize
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testScaledDecimal [
	"This test is a simplified version of GlorpNumericTest>>tesNumeric."
	| s number float |
	
	number := Number readFrom: '12345678s'.
	float := number asFloat.

	res := db basicExecute: 'create table x (xk integer primary key, xv real);'.
	self assert: res equals: 0.
	
	s := db prepare: 'insert into x values (NULL, ?)'.
	s at: 1 putFloat: number.
	s step. 		
	s finalize.	
	
	s := db prepare: 'select * from x'.
	s basicExecute: [ :row |
		self assert: (row nameOfColumn: 1) equals: 'xv'.
		self assert: (row floatAt: 1) equals: float ].
	s finalize
]

{ #category : #'tests - tables' }
SQLite3BaseConnectionTest >> testTableNames [

	| tables |	
	res := db basicExecute: 'create table x (xk integer, xv integer);'.
	self assert: res equals: 0.
	tables := db tableNames.
	self assert: tables size equals: 1.
	self assert: tables first equals: 'x'
]

{ #category : #'tests - tables' }
SQLite3BaseConnectionTest >> testTableNamesOfEmptyDatabase [

	| tables |	
	tables := db tableNames.
	self assert: tables size equals: 0.
	

]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testTime [
	"SQLite3 converts a given Time instance into a DateAndTime and stores that."
	| data today s | 
	
	data := Time noon.
	today := DateAndTime today.
	
	res := db basicExecute: 'create table x (xv time);'.
	self assert: res equals: 0.

	res := db basicExecute: 'begin'.
	self assert: res equals: 0.
	s := db prepare: 'insert into x values (?)'.
	s at: 1 putDateTime: data.
	s step. s finalize.
	res := db basicExecute: 'commit'.
	self assert: res equals: 0.
	
	s := db prepare: 'select xv from x'.
	s basicExecute: [  :row |
		| v |
		v := row dateTimeAt: 0.
		self assert: v year equals: today year.
		self assert: v month equals: today month.
		self assert: v dayOfMonth equals: today dayOfMonth.
		self assert: v hour equals: data hour. 
		self assert: v minute equals: data minute. 
		self assert: v second equals: data second ].
	s finalize
]
