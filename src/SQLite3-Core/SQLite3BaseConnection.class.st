"
I represent a connection to an SQLite database. I provide a thin wrapper over the SQLite C API.
"
Class {
	#name : #SQLite3BaseConnection,
	#superclass : #Object,
	#instVars : [
		'dbFilename',
		'dbHandle',
		'isOpen',
		'library',
		'statementClass'
	],
	#category : #'SQLite3-Core-Connections'
}

{ #category : #examples }
SQLite3BaseConnection class >> memory [

	^self on: ':memory:'
]

{ #category : #'instance creation' }
SQLite3BaseConnection class >> on: aFilename [

	^(self new) 
		on: aFilename;
		yourself

]

{ #category : #'instance creation' }
SQLite3BaseConnection class >> openOn: aFilename [

	^(self new) 
		on: aFilename; 
		open; 
		yourself

]

{ #category : #'public API - backups' }
SQLite3BaseConnection >> asBackupDestination: backupObject [
	self asBackupDestination: backupObject forDatabase: 'main'
]

{ #category : #'public API - backups' }
SQLite3BaseConnection >> asBackupDestination: backupObject forDatabase: databaseName [
	
	backupObject destinationHandle: dbHandle.
	backupObject destinationDatabaseName: databaseName
	
]

{ #category : #'public API - backups' }
SQLite3BaseConnection >> asBackupSource: backupObject [
	self asBackupSource: backupObject forDatabase: 'main'
]

{ #category : #'public API - backups' }
SQLite3BaseConnection >> asBackupSource: backupObject forDatabase: databaseName [
	
	backupObject sourceHandle: dbHandle.
	backupObject sourceDatabaseName: databaseName
	
]

{ #category : #'public API - operating' }
SQLite3BaseConnection >> basicExecute: anSQLText [ 
	^ (self prepare: anSQLText) step; finalize

"20190302, pierce: This used to invoke sqlite3_exec() which is an SQLite-internal convenience wrapper around prepare/step/finalize. It is now rewritten as seen to handle UTF8-encoded input properly. Rewriting this method breaks the Bobby Tables test which relies on naive SQL string construction to work."
	
]

{ #category : #'public API - transactional' }
SQLite3BaseConnection >> beginTransaction [
	^ self basicExecute: 'begin'	
]

{ #category : #'public API - introspection' }
SQLite3BaseConnection >> changes [
	^ library changes: dbHandle
]

{ #category : #'public API - operating' }
SQLite3BaseConnection >> clearBindings: aStatement [
	library clearBindings: aStatement handle on: dbHandle
	
]

{ #category : #'public API - open/close' }
SQLite3BaseConnection >> close [

	"Let FFIExternalResourceManager take care."
	"dbHandle ifNotNil: [ library close: dbHandle ]."
	dbHandle := nil.
	isOpen := false.
]

{ #category : #'public API - introspection' }
SQLite3BaseConnection >> columnNamesFor: aTableName [
	
	self isOpen
		ifFalse: [ SQLite3NotOpen signal ]
		ifTrue: [ 
			| s tableExists |
			s := self prepare: 'select count(*) from sqlite_master where type = "table" and tbl_name = ?'.
			s at: 1 putString: aTableName.
	  		s basicExecute: [ :row | tableExists := ((row integerAt: 0) = 1) ].
	  		s finalize.
			tableExists ifTrue: [ 
				| columns |
				columns := OrderedCollection new.
				s := self prepare: 'pragma table_info(', aTableName, ')'.
				s basicExecute: [ :row | columns add: (row stringAt: 1) ].
				s finalize.
				^ columns ].
			^ nil ]
		
]

{ #category : #'public API - transactional' }
SQLite3BaseConnection >> commitTransaction [
	^ self basicExecute: 'commit'	
]

{ #category : #'public API - introspection' }
SQLite3BaseConnection >> declaredColumnTypesFor: aTableName [
	
	self isOpen
		ifFalse: [ SQLite3NotOpen signal ]
		ifTrue: [ 
			| s tableExists |
			s := self prepare: 'select count(*) from sqlite_master where type = "table" and tbl_name = ?'.
			s at: 1 putString: aTableName.
	  		s basicExecute: [ :row | tableExists := ((row integerAt: 0) = 1) ].
	  		s finalize.
			tableExists ifTrue: [ 
				| columns |
				columns := OrderedCollection new.
				s := self prepare: 'pragma table_info(', aTableName, ')'.
				s basicExecute: [ :row | columns add: (row stringAt: 2) ].
				s finalize.
				^ columns ].
			^ nil ]
		
]

{ #category : #'public API - extensions' }
SQLite3BaseConnection >> disableExtensions [
	^ library disableLoadExtension: dbHandle 
]

{ #category : #'public API - extensions' }
SQLite3BaseConnection >> enableExtensions [
	^ library enableLoadExtension: dbHandle 
]

{ #category : #'public API - operating' }
SQLite3BaseConnection >> finalize: anSQLText [ 
	"no-op"	
]

{ #category : #initialization }
SQLite3BaseConnection >> initialize [
	
	super initialize.
	isOpen := false.
	library := SQLite3Library current.
	dbHandle := SQLite3DatabaseExternalObject new.
	dbHandle autoRelease.
	statementClass := SQLite3Statement.
]

{ #category : #testing }
SQLite3BaseConnection >> isOpen [
	^ isOpen
]

{ #category : #'public API - extensions' }
SQLite3BaseConnection >> loadExtension: aFilename [
	^ library loadExtension: dbHandle with: aFilename 
]

{ #category : #private }
SQLite3BaseConnection >> on: aFilename [

	dbFilename := aFilename.
	^ self
]

{ #category : #'public API - open/close' }
SQLite3BaseConnection >> open [
	 ((library open: dbFilename via: dbHandle) == 0)
		ifTrue: [ 
			isOpen := true.
			^ self ]
		ifFalse: [
			| err |
			err := library apiErrorMessage: dbHandle.
			library apiClose: dbHandle.
			SQLite3AbstractError signal: err ]
]

{ #category : #'public API - operating' }
SQLite3BaseConnection >> prepare: anSQLText [ 
	| s |
	
	s := self statementClass new.
	s connection: self.
	library prepare: s handle on: dbHandle with: anSQLText.
	^ s
	
]

{ #category : #'public API - cleaning' }
SQLite3BaseConnection >> reset: aStatement [ 
	library reset: aStatement handle on: dbHandle
	
]

{ #category : #'public API - transactional' }
SQLite3BaseConnection >> rollbackTransaction [
	^ self basicExecute: 'rollback'	
]

{ #category : #private }
SQLite3BaseConnection >> signal: exceptionClass with: value [
	library signal: exceptionClass with: value on: dbHandle
]

{ #category : #accessing }
SQLite3BaseConnection >> statementClass [
	^ statementClass
]

{ #category : #'public API - introspection' }
SQLite3BaseConnection >> tableNames [
	| tables s |
	
	self isOpen
		ifFalse: [ SQLite3NotOpen signal ]
		ifTrue: [ 
			tables := OrderedCollection new.
			s := self prepare: 'select tbl_name from sqlite_master where type = "table"'.
	  		s basicExecute: [ :row |
				(row dataValuesAvailable > 0) ifTrue: [ tables add: (row stringAt: 0) ]].
	  		s finalize.
			^ tables ]
]

{ #category : #'public API - introspection' }
SQLite3BaseConnection >> totalChanges [
	^ library totalChanges: dbHandle
]

{ #category : #'public API - tracing' }
SQLite3BaseConnection >> traceUsing: callback with: appdata [
	library trace: dbHandle with: callback with: appdata
	
]
