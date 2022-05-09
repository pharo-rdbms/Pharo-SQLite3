"
An SQLite3 database
"
Class {
	#name : #SQLite3Database,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'SQLite3-Core-Base'
}

{ #category : #'instance creation' }
SQLite3Database class >> forConnection: aConnection [

	^ self new 
		initConnection: aConnection;
		yourself
]

{ #category : #'instance creation' }
SQLite3Database class >> memory [

	^ self forConnection: SQLite3Connection memory
]

{ #category : #'instance creation' }
SQLite3Database class >> on: aFilename [

	^ self forConnection: (SQLite3Connection on: aFilename)
]

{ #category : #accessing }
SQLite3Database class >> tableInfoFor: aFileName [
	
	| db result |
	db := self on: aFileName.
	db connection open.
	 
 	result := db tables collect: [:each | each name -> each numberOfRows ].
	db connection close.
	^result
]

{ #category : #accessing }
SQLite3Database >> connection [

	^ connection
]

{ #category : #executing }
SQLite3Database >> execute: anSQLStatement doing: aBlock [

	^ self connection execute: anSQLStatement with: #(  ) doing: aBlock
]

{ #category : #'private - initialization' }
SQLite3Database >> initConnection: aConnection [

	connection := aConnection 
]

{ #category : #executing }
SQLite3Database >> inspectionSQLite3Tables [
	<inspectorPresentationOrder: 10 title: 'Tables'>
	 
	^ SpTablePresenter new
		items: self tables;
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :assoc | assoc name ]);
		addColumn: (SpStringTableColumn title: 'Number of rows' evaluated: [ :assoc | assoc numberOfRows ]);		
		yourself
]

{ #category : #printing }
SQLite3Database >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self connection filename;
		<< '")'
]

{ #category : #accessing }
SQLite3Database >> tables [

	self connection isOpen ifFalse: [ ^ SQLite3NotOpen signal ].

	^connection
		execute: '
			SELECT *
			FROM sqlite_master
			WHERE
			    type =''table'' AND 
    			name NOT LIKE ''sqlite_%'';'
		with: #(  )
		doing: [ :result | 
			result rows collect: [ :eachRow | 
				| properties |
				properties := (eachRow columnNames collect: [ :eachCName | 
					               eachCName -> (eachRow atName: eachCName) ])
					              asDictionary.

				SQLite3Table properties: properties in: self ] ]
]
