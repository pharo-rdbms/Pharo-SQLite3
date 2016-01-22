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

{ #category : #initialization }
UDBCSQLiteBaseConnection >> initialize [
	
	super initialize.
	isOpen := false.
	library := UDBCSQLiteLibrary current
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
