"
I represent a connection to an SQLite database. I provide a thin wrapper over the SQLite C API.
"
Class {
	#name : #UDBCSQLiteBaseConnection,
	#superclass : #Object,
	#instVars : [
		'dbFilename',
		'dbHandle',
		'isOpen'
	],
	#category : #'UDBC-SQLite-Base-Connections'
}

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
]

{ #category : #private }
UDBCSQLiteBaseConnection >> on: aFilename [

	dbFilename := aFilename.
	^ self
]
