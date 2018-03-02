"
I represent a connection to an SQLite database. I provide a thin wrapper over the SQLite C API.
"
Class {
	#name : #UDBCSQLite3BaseConnection,
	#superclass : #Object,
	#instVars : [
		'dbFilename',
		'dbHandle',
		'isOpen',
		'library',
		'statementClass'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #examples }
UDBCSQLite3BaseConnection class >> memory [

	^self on: ':memory:'
]

{ #category : #'instance creation' }
UDBCSQLite3BaseConnection class >> on: aFilename [

	^(self new) 
		on: aFilename;
		yourself

]

{ #category : #'instance creation' }
UDBCSQLite3BaseConnection class >> openOn: aFilename [

	^(self new) 
		on: aFilename; 
		open; 
		yourself

]

{ #category : #'public API - backups' }
UDBCSQLite3BaseConnection >> asBackupDestination: backupObject [
	self asBackupDestination: backupObject forDatabase: 'main'
]

{ #category : #'public API - backups' }
UDBCSQLite3BaseConnection >> asBackupDestination: backupObject forDatabase: databaseName [
	
	backupObject destinationHandle: dbHandle.
	backupObject destinationDatabaseName: databaseName
	
]

{ #category : #'public API - backups' }
UDBCSQLite3BaseConnection >> asBackupSource: backupObject [
	self asBackupSource: backupObject forDatabase: 'main'
]

{ #category : #'public API - backups' }
UDBCSQLite3BaseConnection >> asBackupSource: backupObject forDatabase: databaseName [
	
	backupObject sourceHandle: dbHandle.
	backupObject sourceDatabaseName: databaseName
	
]

{ #category : #'public API - operating' }
UDBCSQLite3BaseConnection >> basicExecute: anSQLText [ 
	^ library execute: anSQLText on: dbHandle.
	
]

{ #category : #'public API - transactional' }
UDBCSQLite3BaseConnection >> beginTransaction [
	^ self basicExecute: 'begin'	
]

{ #category : #'public API - introspection' }
UDBCSQLite3BaseConnection >> changes [
	^ library changes: dbHandle
]

{ #category : #'public API - operating' }
UDBCSQLite3BaseConnection >> clearBindings: aStatement [
	library clearBindings: aStatement handle on: dbHandle
	
]

{ #category : #'public API - open/close' }
UDBCSQLite3BaseConnection >> close [

	"Let FFIExternalResourceManager take care."
	"dbHandle ifNotNil: [ library close: dbHandle ]."
	dbHandle := nil.
	isOpen := false.
]

{ #category : #'public API - introspection' }
UDBCSQLite3BaseConnection >> columnNamesFor: aTableName [
	
	self isOpen
		ifFalse: [ UDBCSQLite3NotOpen signal ]
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
UDBCSQLite3BaseConnection >> commitTransaction [
	^ self basicExecute: 'commit'	
]

{ #category : #'public API - extensions' }
UDBCSQLite3BaseConnection >> disableExtensions [
	^ library disableLoadExtension: dbHandle 
]

{ #category : #'public API - extensions' }
UDBCSQLite3BaseConnection >> enableExtensions [
	^ library enableLoadExtension: dbHandle 
]

{ #category : #'public API - operating' }
UDBCSQLite3BaseConnection >> finalize: anSQLText [ 
	"no-op"	
]

{ #category : #initialization }
UDBCSQLite3BaseConnection >> initialize [
	
	super initialize.
	isOpen := false.
	library := UDBCSQLite3Library current.
	dbHandle := UDBCSQLite3DatabaseExternalObject new.
	dbHandle autoRelease.
	statementClass := UDBCSQLite3Statement.
]

{ #category : #testing }
UDBCSQLite3BaseConnection >> isOpen [
	^ isOpen
]

{ #category : #'public API - extensions' }
UDBCSQLite3BaseConnection >> loadExtension: aFilename [
	^ library loadExtension: dbHandle with: aFilename 
]

{ #category : #private }
UDBCSQLite3BaseConnection >> on: aFilename [

	dbFilename := aFilename.
	^ self
]

{ #category : #'public API - open/close' }
UDBCSQLite3BaseConnection >> open [
	 ((library open: dbFilename via: dbHandle) == 0)
		ifTrue: [ 
			isOpen := true.
			^ self ]
		ifFalse: [
			| err |
			err := library apiErrorMessage: dbHandle.
			library apiClose: dbHandle.
			UDBCSQLite3Error signal: err ]
]

{ #category : #'public API - operating' }
UDBCSQLite3BaseConnection >> prepare: anSQLText [ 
	| s |
	
	s := self statementClass new.
	s connection: self.
	library prepare: s handle on: dbHandle with: anSQLText.
	^ s
	
]

{ #category : #'public API - cleaning' }
UDBCSQLite3BaseConnection >> reset: aStatement [ 
	library reset: aStatement handle on: dbHandle
	
]

{ #category : #'public API - transactional' }
UDBCSQLite3BaseConnection >> rollbackTransaction [
	^ self basicExecute: 'rollback'	
]

{ #category : #private }
UDBCSQLite3BaseConnection >> signal: exceptionClass with: value [
	library signal: exceptionClass with: value on: dbHandle
]

{ #category : #accessing }
UDBCSQLite3BaseConnection >> statementClass [
	^ statementClass
]

{ #category : #'public API - introspection' }
UDBCSQLite3BaseConnection >> tableNames [
	| tables s |
	
	self isOpen
		ifFalse: [ UDBCSQLite3NotOpen signal ]
		ifTrue: [ 
			tables := OrderedCollection new.
			s := self prepare: 'select tbl_name from sqlite_master where type = "table"'.
	  		s basicExecute: [ :row |
				(row dataValuesAvailable > 0) ifTrue: [ tables add: (row stringAt: 0) ]].
	  		s finalize.
			^ tables ]
]

{ #category : #'public API - introspection' }
UDBCSQLite3BaseConnection >> totalChanges [
	^ library totalChanges: dbHandle
]

{ #category : #'public API - tracing' }
UDBCSQLite3BaseConnection >> traceUsing: callback with: appdata [
	library trace: dbHandle with: callback with: appdata
	
]
