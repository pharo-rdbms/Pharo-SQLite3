"
I represent a column in a table
"
Class {
	#name : 'SQLite3Column',
	#superclass : 'Object',
	#instVars : [
		'name',
		'index',
		'type',
		'hasNotNullConstraint'
	],
	#category : 'SQLite3-Core-Base',
	#package : 'SQLite3-Core',
	#tag : 'Base'
}

{ #category : 'accessing' }
SQLite3Column >> cid: anObject [
	"The cid column should not be taken to mean more than 'rank within the current result set'."

	index := anObject
]

{ #category : 'accessing' }
SQLite3Column >> hasNotNullConstraint [

	^ hasNotNullConstraint
]

{ #category : 'accessing' }
SQLite3Column >> index [

	^ index
]

{ #category : 'accessing' }
SQLite3Column >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
SQLite3Column >> initialize [

	super initialize.
	hasNotNullConstraint := false
]

{ #category : 'accessing' }
SQLite3Column >> name [

	^ name
]

{ #category : 'accessing' }
SQLite3Column >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
SQLite3Column >> notnull: anInteger [
	"whether or not the column can be NULL"

	hasNotNullConstraint := anInteger = 1
]

{ #category : 'printing' }
SQLite3Column >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self name;
		<< '")'
]

{ #category : 'accessing' }
SQLite3Column >> type [

	^ type
]

{ #category : 'accessing' }
SQLite3Column >> type: anObject [

	type := anObject
]
