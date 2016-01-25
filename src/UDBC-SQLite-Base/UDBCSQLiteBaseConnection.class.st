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

{ #category : #'public API - open/close' }
UDBCSQLiteBaseConnection >> close [
	dbHandle ifNotNil: [ library close: dbHandle ].
	dbHandle := nil.
	isOpen := false.
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
