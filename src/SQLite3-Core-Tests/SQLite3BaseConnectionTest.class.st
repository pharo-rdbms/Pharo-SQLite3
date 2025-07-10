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

{ #category : #private }
SQLite3BaseConnectionTest >> executeInDB: anSQLText [

	| result |

	result := db basicExecute: anSQLText.
	self assert: result equals: 0
]

{ #category : #utilities }
SQLite3BaseConnectionTest >> getTempPath [

	| env |
	env := Smalltalk os environment.
	^ Smalltalk os isWindows
		  ifTrue: [ "See https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-gettemppath2a"
			  (env
				   at: 'TMP'
				   ifAbsent: [ env at: 'TEMP' ifAbsent: [ env at: 'USERPROFILE' ] ])
			  , '\' ]
		  ifFalse: [ "See https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html"
			(env at: 'TMPDIR' ifAbsent: ['/tmp']), '/' ]
]

{ #category : #utilities }
SQLite3BaseConnectionTest >> invalidFileNameOnCurrentOperatingSystem [
	^Smalltalk os isWindows
		ifTrue: [ '/&*no' ]
		ifFalse: [ '/nosuchfile' ]
]

{ #category : #utilities }
SQLite3BaseConnectionTest >> newUniqueFileName [

	^ self getTempPath , UUID new asString
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
	db open
]

{ #category : #running }
SQLite3BaseConnectionTest >> tearDown [

	[ db close ] on: SQLite3Misuse do: [ ].
	super tearDown
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testBadOpen [

	| newConnection |

	newConnection := SQLite3BaseConnection on: self invalidFileNameOnCurrentOperatingSystem.
	self should: [ newConnection open ] raise: SQLite3CantOpen.
	self deny: newConnection isOpen
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testBasicExecuteOk [

	self executeInDB: 'create table x (xk integer, xv integer);'.
	self executeInDB: 'drop table x;'
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testBasicExecuteSyntaxError [

	self should: [ db basicExecute: 'create table,;' ]
		raise: SQLite3AbstractError
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testBooleanColumnTypeMismatch [

	self executeInDB: 'create table x (xk integer primary key, xv notboolean);'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row | self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ] ]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testBooleanObject [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.

	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putObject: true.
		statement step
		].

	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row objectAt: 0.
			self assert: value equals: true
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerOneThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putInteger: 1.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value equals: true
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerTwoThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putInteger: 2.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row | self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ] ]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteIntegerZeroThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putInteger: 0.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value equals: false
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteNilThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putNil: nil.
		statement step
		].
	self executeInDB: 'commit'.


	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value isNil
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteSQLNullThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, NULL)' do: [ :statement | statement step ].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value isNil
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringFalseThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putString: 'false'.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value equals: false
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringTrueThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putString: 'true'.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value equals: true
			]
		]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteStringTwoThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putString: '2'.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row | self should: [ row booleanAt: 0 ] raise: SQLite3AbstractError ] ]
]

{ #category : #'tests - writing' }
SQLite3BaseConnectionTest >> testBooleanWriteThenRead [

	self executeInDB: 'create table x (xk integer primary key, xv boolean);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putBoolean: true.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row booleanAt: 0.
			self assert: value equals: true
			]
		]
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testCloseFile [

	| fileName newConnection |
	fileName := self newUniqueFileName.
	newConnection := SQLite3BaseConnection on: fileName.
	newConnection
		open;
		close.
	newConnection := nil.
	Smalltalk garbageCollect.
	self
		shouldnt: [ File deleteFile: fileName ]
		raise: CannotDeleteFileException
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNames [

	| columns |

	self executeInDB: 'create table x (xk integer, xv integer);'.
	columns := db columnNamesFor: 'x'.
	self assert: columns size equals: 2.
	self assert: columns first equals: 'xk'.
	self assert: columns second equals: 'xv'
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesBobbyStop [

	"In this test, Bobby Tables strikes again, but fails, because #columnNamesFor: uses parameter binding."

	| columns tables |

	self executeInDB: 'create table x (xk integer, xv integer);'.
	self executeInDB: 'create table students (sk integer, sname varchar);'.

	tables := db tableNames.
	self assert: tables size equals: 2.
	self assert: tables first equals: 'x'.
	self assert: tables second equals: 'students'.

	columns := db columnNamesFor: 'x; drop table students; --'.
	self assert: columns isNil.

	tables := db tableNames.
	self assert: tables size equals: 2.
	self assert: tables first equals: 'x'.
	self assert: tables second equals: 'students'
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesForNoSuchTableWithSpaces [

	| columns |

	self executeInDB: 'create table x (xk integer, xv integer);'.
	columns := db columnNamesFor: 'no such table with spaces'.
	self assert: columns isNil
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesForTableWithSpaces [

	| columns |

	self executeInDB: 'create table [table name with spaces] (xk integer, xv integer);'.
	columns := db columnNamesFor: 'table name with spaces'.
	self assert: columns size equals: 2.
	self assert: columns first equals: 'xk'.
	self assert: columns second equals: 'xv'
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testColumnNamesNoSuchTable [

	| columns |

	self executeInDB: 'create table x (xk integer, xv integer);'.
	columns := db columnNamesFor: 'y'.
	self assert: columns isNil
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testConstraintViolation [

	self
		executeInDB: 'create table x (value integer primary key);';
		executeInDB: 'insert into x values(1);'.
	self should: [ db basicExecute: 'insert into x values(1);' ] raise: SQLite3ConstraintViolation
]

{ #category : #'tests - execution' }
SQLite3BaseConnectionTest >> testDataValuesAvailable [

	self executeInDB: 'create table x (xk integer primary key, iv integer, tv text);'.
	self executeInDB: 'insert into x values (NULL, 1, "duh");'.

	self
		withPreparedStatement: 'select * from x'
		do: [ :statement |
		statement basicExecute: [ :row | self assert: row dataValuesAvailable equals: 3 ] ]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testDate [

	| data |

	data := Date year: 2015 month: 4 day: 1.

	self executeInDB: 'create table x (xv date);'.

	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (?)' do: [ :statement |
		statement at: 1 putDateTime: data.
		statement step
		].

	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row dateTimeAt: 0.
			self
				assert: value year equals: 2015;
				assert: value month equals: 4;
				assert: value dayOfMonth equals: 1
			]
		]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testDateAndTime [

	| data |

	data := DateAndTime year: 2015 month: 4 day: 1.

	self executeInDB: 'create table x (xv datetime);'.

	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (?)' do: [ :statement |
		statement at: 1 putDateTime: data.
		statement step
		].

	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row dateTimeAt: 0.
			self
				assert: value year equals: 2015;
				assert: value month equals: 4;
				assert: value dayOfMonth equals: 1;
				assert: value hours equals: 0;
				assert: value minutes equals: 0;
				assert: value seconds equals: 0
			]
		]
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testDeclaredColumnTypes [

	| columns |

	self executeInDB: 'create table x (xk integer, xv blob, xb boolean);'.
	columns := db declaredColumnTypesFor: 'x'.
	self assert: columns size equals: 3.
	self assert: columns first equals: 'INTEGER'.
	self assert: columns second equals: 'BLOB'.
	self assert: columns third equals: 'boolean'
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testDeclaredColumnTypesForNoSuchTable [

	| columns |
	self executeInDB: 'create table x (xk integer, xv integer);'.
	columns := db declaredColumnTypesFor: 'y'.
	self assert: columns isNil
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testDeclaredColumnTypesForNoSuchTableWithSpaces [

	| columns |
	self executeInDB: 'create table x (xk integer, xv integer);'.
	columns := db declaredColumnTypesFor: 'no such table with spaces'.
	self assert: columns isNil
]

{ #category : #'tests - columns' }
SQLite3BaseConnectionTest >> testDeclaredColumnTypesForTableWithSpaces [

	| columns |

	self executeInDB: 'create table [table name with spaces] (xk INTEGER, xv BLOB, xb BOOLEAN);'.
	columns := db declaredColumnTypesFor: 'table name with spaces'.
	self assert: columns size equals: 3.
	self assert: columns first equals: 'INTEGER'.
	self assert: columns second equals: 'BLOB'.
	self assert: columns third equals: 'BOOLEAN'
]

{ #category : #'tests - multilingual' }
SQLite3BaseConnectionTest >> testDefaultMultilingualStrings [

	self executeInDB:
		'create table x (xk integer primary key, xm1 text default ''中文'', xm2 text default ''áěšřčá'');'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x (xk) values (NULL)' do: [ :statement | statement step ].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xm1, xm2 from x order by xk' do: [ :statement |
		statement basicExecute: [ :row |
			self assert: ( row stringAt: 0 ) equals: '中文'.
			self assert: ( row stringAt: 1 ) equals: 'áěšřčá'
			]
		]
]

{ #category : #'tests - connections' }
SQLite3BaseConnectionTest >> testDoubleClose [

	db close.
	[ db close ] on: SQLite3Misuse do: [ ]
	"#tearDown will close the db again, and is similarly guarded."
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testFloat [

	self executeInDB: 'create table x (xk integer primary key, xv real);'.
	self executeInDB: 'insert into x values (NULL, 1.141);'.

	self withPreparedStatement: 'select * from x' do: [ :statement |
		statement basicExecute: [ :row |
			self assert: ( row nameOfColumn: 1 ) equals: 'xv'.
			self assert: ( row floatAt: 1 ) equals: 1.141
			]
		]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testInteger [

	"The large integer comes from Glorp's testInt8."

	self executeInDB: 'create table x (xk integer primary key, xv integer);'.

	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putInteger: 3212321555.
		statement step
		].

	self withPreparedStatement: 'select * from x' do: [ :statement |
		statement basicExecute: [ :row |
			self assert: ( row nameOfColumn: 1 ) equals: 'xv'.
			self assert: ( row integerAt: 1 ) equals: 3212321555
			]
		]
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

	| data index |

	data := OrderedCollection with: 'English' with: '中文' with: 'にほんご' , 'áěšřčá'.
	self executeInDB: 'create table x (xk integer primary key, xv varchar);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		data do: [ :ea |
			statement at: 1 putString: ea.
			statement
				step;
				clearBindings;
				reset
			]
		].
	self executeInDB: 'commit'.

	index := 1.
	self withPreparedStatement: 'select xv from x order by xk asc' do: [ :statement |
		statement basicExecute: [ :row |
			self assert: ( row stringAt: 0 ) equals: ( data at: index ).
			index := index + 1
			]
		]
]

{ #category : #'tests - multilingual' }
SQLite3BaseConnectionTest >> testMultilingualTableName [

	self executeInDB: 'create table 表一 (xk integer primary key, xm1 text default ''中文'');'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into 表一 (xk) values (NULL)' do: [ :statement | statement step ].
	self executeInDB: 'commit'.

	self
		withPreparedStatement: 'select xm1 from 表一 order by xk'
		do: [ :statement |
		statement basicExecute: [ :row | self assert: ( row stringAt: 0 ) equals: '中文' ] ]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testObjectBlob [

	| data |

	data := OrderedCollection with: 1 with: 'two' with: 3.3.

	self
		executeInDB: 'create table x (xk integer primary key, xv blob);';
		executeInDB: 'begin'.

	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putObject: data.
		statement step
		].

	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row objectAt: 0.
			self
				assert: value size equals: 3;
				assert: value first equals: 1;
				assert: value second equals: 'two';
				assert: value third equals: 3.3
			]
		]
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testPrepareStep [

	self executeInDB: 'create table x (xk integer primary key, iv integer, tv text);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?, ?)' do: [ :statement |
		self assert: statement sqlText equals: 'insert into x values (NULL, ?, ?)'.
		1 to: 10 do: [ :x |
			statement at: 1 putInteger: x * x.
			statement at: 2 putString: ( '<1p> * <1p>' expandMacrosWith: x ).
			statement step.
			statement clearBindings.
			statement reset
			]
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select * from x' do: [ :statement |
		| i |

		self assert: statement sqlText equals: 'select * from x'.
		statement basicExecute: [ :row |
			i := row integerAt: 0.
			self assert: ( row integerAt: 1 ) equals: i * i.
			self assert: ( row stringAt: 2 ) equals: ( '<1p> * <1p>' expandMacrosWith: i )
			]
		]
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testPrepareStepSelective [

	| i count |

	self executeInDB: 'create table x (xk integer primary key, iv integer, tv text);'.
	self executeInDB: 'begin'.
	self withPreparedStatement: 'insert into x values (NULL, ?, ?)' do: [ :statement |
		self assert: statement sqlText equals: 'insert into x values (NULL, ?, ?)'.
		1 to: 10 do: [ :x |
			statement
				at: 1 putInteger: x * x;
				at: 2 putString: x asString , ' * ' , x asString;
				step;
				clearBindings;
				reset
			]
		].
	self executeInDB: 'commit'.

	count := 0.
	self withPreparedStatement: 'select * from x where iv < ?' do: [ :statement |
		self assert: statement sqlText equals: 'select * from x where iv < ?'.
		statement at: 1 putInteger: 27.
		statement basicExecute: [ :row |
			count := count + 1.
			i := row integerAt: 0.
			self assert: ( row integerAt: 1 ) equals: i * i.
			self assert: ( row stringAt: 2 ) equals: i asString , ' * ' , i asString
			]
		].
	self assert: count equals: 5
]

{ #category : #tests }
SQLite3BaseConnectionTest >> testResultSetColumnIntrospection [

	self executeInDB: 'create table x (xk integer primary key, iv integer, tv text);'.
	self executeInDB: 'insert into x values (NULL, 1, "duh");'.

	self withPreparedStatement: 'select * from x' do: [ :statement |
		statement basicExecute: [ :row |
			self assert: ( row nameOfColumn: 0 ) equals: 'xk'.
			self assert: ( row valueOfColumn: 0 ) equals: 1.
			self assert: ( row nameOfColumn: 1 ) equals: 'iv'.
			self assert: ( row valueOfColumn: 1 ) equals: 1.
			self assert: ( row nameOfColumn: 2 ) equals: 'tv'.
			self assert: ( row valueOfColumn: 2 ) equals: 'duh'
			]
		]
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testScaledDecimal [

	"This test is a simplified version of GlorpNumericTest>>tesNumeric."

	| number float |

	number := Number readFrom: '12345678s'.
	float := number asFloat.

	self executeInDB: 'create table x (xk integer primary key, xv real);'.

	self withPreparedStatement: 'insert into x values (NULL, ?)' do: [ :statement |
		statement at: 1 putFloat: number.
		statement step
		].

	self withPreparedStatement: 'select * from x' do: [ :statement |
		statement basicExecute: [ :row |
			self
				assert: ( row nameOfColumn: 1 ) equals: 'xv';
				assert: ( row floatAt: 1 ) equals: float
			]
		]
]

{ #category : #'tests - tables' }
SQLite3BaseConnectionTest >> testTableNames [

	| tables |

	self executeInDB: 'create table x (xk integer, xv integer);'.
	tables := db tableNames.
	self assert: tables size equals: 1.
	self assert: tables first equals: 'x'
]

{ #category : #'tests - tables' }
SQLite3BaseConnectionTest >> testTableNamesOfEmptyDatabase [

	| tables |

	tables := db tableNames.
	self assert: tables isEmpty
]

{ #category : #'tests - types' }
SQLite3BaseConnectionTest >> testTime [

	| data |

	data := Time noon.

	self
		executeInDB: 'create table x (xv time);';
		executeInDB: 'begin'.

	self withPreparedStatement: 'insert into x values (?)' do: [ :statement |
		statement at: 1 putTime: data.
		statement step
		].
	self executeInDB: 'commit'.

	self withPreparedStatement: 'select xv from x' do: [ :statement |
		statement basicExecute: [ :row |
			| value |

			value := row timeAt: 0.
			self
				assert: value hour equals: data hour;
				assert: value minute equals: data minute;
				assert: value second equals: data second
			]
		]
]

{ #category : #private }
SQLite3BaseConnectionTest >> withPreparedStatement: anSQLText do: aBlock [

	| statement |

	statement := db prepare: anSQLText.
	[ aBlock value: statement ] ensure: [ statement finalize ]
]
