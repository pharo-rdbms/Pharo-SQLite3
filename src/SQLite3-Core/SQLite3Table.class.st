"
A table within a SQLite3 database.

- _type_ will be one of the following text strings: 'table', 'index', 'view', or 'trigger' according to the type of object defined. 
- _name_ will hold the name of the object. 
- _tblName_ holds the name of a table or view that the object is associated with.
- _rootpage_ stores the page number of the root b-tree page for tables and indexes.
- _sql_ stores SQL text that describes the object.
"
Class {
	#name : #SQLite3Table,
	#superclass : #Object,
	#instVars : [
		'database',
		'type',
		'name',
		'tblName',
		'rootpage',
		'sql'
	],
	#category : #'SQLite3-Core-Base'
}

{ #category : #accessing }
SQLite3Table >> columnNames [

	^ self columns collect: [:each | each name ]
]

{ #category : #accessing }
SQLite3Table >> columns [

	^ (self database execute: 'pragma table_info([' , self name , ']);')
		  rowClass: SQLite3Column;
		  rows
]

{ #category : #accessing }
SQLite3Table >> database [

	^ database
]

{ #category : #'private - accessing' }
SQLite3Table >> database: anObject [

	database := anObject
]

{ #category : #accessing }
SQLite3Table >> name [

	^ name
]

{ #category : #accessing }
SQLite3Table >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SQLite3Table >> numberOfRows [

	^ (self database execute: 'SELECT COUNT(*) FROM [' , self name , '];')
		  onlyValue
]

{ #category : #printing }
SQLite3Table >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self name;
		<< '")'
]

{ #category : #accessing }
SQLite3Table >> rootpage [

	^ rootpage
]

{ #category : #accessing }
SQLite3Table >> rootpage: anObject [

	rootpage := anObject
]

{ #category : #accessing }
SQLite3Table >> rows [

	^ (self database execute: 'SELECT *
			FROM [' , self name , ']
			LIMIT 1000;') rows
]

{ #category : #accessing }
SQLite3Table >> sql [

	^ sql
]

{ #category : #accessing }
SQLite3Table >> sql: anObject [

	sql := anObject
]

{ #category : #accessing }
SQLite3Table >> tblName [

	^ tblName
]

{ #category : #accessing }
SQLite3Table >> tblName: anObject [

	tblName := anObject
]

{ #category : #accessing }
SQLite3Table >> type [

	^ type
]

{ #category : #accessing }
SQLite3Table >> type: anObject [

	type := anObject
]
