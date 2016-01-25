"
I represent a connection to an SQLite database. I provide a thin wrapper over the SQLite C API.
"
Class {
	#name : #UDBCSQLiteBaseConnection,
	#superclass : #Object,
	#instVars : [
		'dbFilename',
		'dbHandle',
		'isOpen',
		'library'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

{ #category : #examples }
UDBCSQLiteBaseConnection class >> memory [

	^self on: ':memory:'
]

{ #category : #'instance creation' }
UDBCSQLiteBaseConnection class >> on: aFilename [

	^(self new) 
		on: aFilename;
		yourself

]

{ #category : #'instance creation' }
UDBCSQLiteBaseConnection class >> openOn: aFilename [

	^(self new) 
		on: aFilename; 
		open; 
		yourself

]

{ #category : #'public API - operating' }
UDBCSQLiteBaseConnection >> basicExecute: anSQLText [ 
	^ library execute: anSQLText on: dbHandle.
	
]

{ #category : #'public API - open/close' }
UDBCSQLiteBaseConnection >> close [
	dbHandle ifNotNil: [ library close: dbHandle ].
	dbHandle := nil.
	isOpen := false.
]

{ #category : #'public API - introspection' }
UDBCSQLiteBaseConnection >> columnNamesFor: aTableName [
	
	self isOpen
		ifFalse: [ UDBCSQLiteNotOpen signal ]
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

{ #category : #initialization }
UDBCSQLiteBaseConnection >> initialize [
	
	super initialize.
	isOpen := false.
	library := UDBCSQLiteLibrary current.
	dbHandle := UDBCSQLiteDatabaseExternalObject new
]

{ #category : #testing }
UDBCSQLiteBaseConnection >> isOpen [
	^ isOpen
]

{ #category : #private }
UDBCSQLiteBaseConnection >> on: aFilename [

	dbFilename := aFilename.
	^ self
]

{ #category : #'public API - open/close' }
UDBCSQLiteBaseConnection >> open [
	 ((library open: dbFilename via: dbHandle) == 0)
		ifTrue: [ 
			isOpen := true.
			^ self ]
]

{ #category : #'public API - operating' }
UDBCSQLiteBaseConnection >> prepare: anSQLText [ 
	| s |
	
	s := UDBCSQLiteStatement new.
	s connection: self.
	library prepare: s handle on: dbHandle with: anSQLText.
	^ s
	
]
