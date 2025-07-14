"
An SQLite3 database
"
Class {
	#name : 'SQLite3Database',
	#superclass : 'Object',
	#instVars : [
		'connection'
	],
	#category : 'SQLite3-Core-Base',
	#package : 'SQLite3-Core',
	#tag : 'Base'
}

{ #category : 'instance creation' }
SQLite3Database class >> forConnection: aConnection [

	^ self new
		initConnection: aConnection;
		yourself
]

{ #category : 'instance creation' }
SQLite3Database class >> memory [

	^ self forConnection: SQLite3Connection memory
]

{ #category : 'instance creation' }
SQLite3Database class >> on: aFilename [

	^ self forConnection: (SQLite3Connection on: aFilename)
]

{ #category : 'instance creation' }
SQLite3Database class >> openOn: aFilename [

	^ (self on: aFilename)
			open;
			yourself
]

{ #category : 'accessing' }
SQLite3Database class >> tableInfoFor: aFileName [

	| db |
	db := self on: aFileName.
	db connection open.
	^ db tables
]

{ #category : 'open/close' }
SQLite3Database >> close [

	^ self connection close
]

{ #category : 'accessing' }
SQLite3Database >> connection [

	^ connection
]

{ #category : 'executing' }
SQLite3Database >> execute: anSQLStatement [

	^ self connection execute: anSQLStatement
]

{ #category : 'executing' }
SQLite3Database >> execute: anSQLStatement doing: aBlock [

	^ self connection execute: anSQLStatement with: #(  ) doing: aBlock
]

{ #category : 'private - initialization' }
SQLite3Database >> initConnection: aConnection [

	connection := aConnection
]

{ #category : 'open/close' }
SQLite3Database >> open [

	^ self connection open
]

{ #category : 'printing' }
SQLite3Database >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self connection filename;
		<< '")'
]

{ #category : 'accessing' }
SQLite3Database >> tables [

	self connection isOpen ifFalse: [ ^ SQLite3NotOpen signal ].

	^ (connection execute: '
			SELECT *
			FROM sqlite_master
			WHERE
			    type =''table'' AND
    			name NOT LIKE ''sqlite_%'';') rows collect: [ :eachRow |
		  SQLite3Table properties: eachRow asDictionary in: self ]
]
