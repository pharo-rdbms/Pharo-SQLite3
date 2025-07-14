"
A table within a SQLite3 database
"
Class {
	#name : 'SQLite3Table',
	#superclass : 'Object',
	#instVars : [
		'database',
		'properties'
	],
	#category : 'SQLite3-Core-Base',
	#package : 'SQLite3-Core',
	#tag : 'Base'
}

{ #category : 'instance creation' }
SQLite3Table class >> properties: aDictionary in: aDatabase [
	^ self new
		database: aDatabase;
		properties: aDictionary;
		yourself
]

{ #category : 'accessing' }
SQLite3Table >> columnNames [

	^ self columns collect: [:each | each name ]
]

{ #category : 'accessing' }
SQLite3Table >> columns [

	^ (self database execute: 'pragma table_info([' , self name , ']);')
		  rowClass: SQLite3Column;
		  rows
]

{ #category : 'accessing' }
SQLite3Table >> database [

	^ database
]

{ #category : 'private - accessing' }
SQLite3Table >> database: anObject [

	database := anObject
]

{ #category : 'accessing' }
SQLite3Table >> name [

	^ self properties at: #name ifAbsent: [ '' ]
]

{ #category : 'accessing' }
SQLite3Table >> numberOfRows [

	^ (self database execute: 'SELECT COUNT(*) FROM [' , self name , '];')
		  onlyValue
]

{ #category : 'printing' }
SQLite3Table >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self name;
		<< '")'
]

{ #category : 'accessing' }
SQLite3Table >> properties [

	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : 'private - accessing' }
SQLite3Table >> properties: anObject [

	properties := anObject
]

{ #category : 'accessing' }
SQLite3Table >> rows [

	^ (self database execute: 'SELECT *
			FROM [' , self name , ']
			LIMIT 1000;') rows
]

{ #category : 'accessing' }
SQLite3Table >> schema [

	^ self properties at: #sql ifAbsent: ''
]
