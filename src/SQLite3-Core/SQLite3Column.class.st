"
I represent a column in a table
"
Class {
	#name : #SQLite3Column,
	#superclass : #Object,
	#instVars : [
		'name',
		'index',
		'type',
		'hasNotNullConstraint'
	],
	#category : #'SQLite3-Core-Base'
}

{ #category : #'instance creation' }
SQLite3Column class >> readFromTableInfoResult: aSQLite3Row [ 
 
	^(self new)
		name: (aSQLite3Row at: 'name');
		index: (aSQLite3Row at: 'cid');
		type: (aSQLite3Row at: 'type');
		hasNotNullConstraint: (aSQLite3Row at: 'notnull') = 1;
		yourself
]

{ #category : #accessing }
SQLite3Column >> hasNotNullConstraint [

	^ hasNotNullConstraint
]

{ #category : #accessing }
SQLite3Column >> hasNotNullConstraint: anObject [

	hasNotNullConstraint := anObject
]

{ #category : #accessing }
SQLite3Column >> index [

	^ index
]

{ #category : #accessing }
SQLite3Column >> index: anObject [

	index := anObject
]

{ #category : #initialization }
SQLite3Column >> initialize [ 

	super initialize.
	hasNotNullConstraint := false
]

{ #category : #accessing }
SQLite3Column >> name [

	^ name
]

{ #category : #accessing }
SQLite3Column >> name: anObject [

	name := anObject
]

{ #category : #printing }
SQLite3Column >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '("';
		<< self name;
		<< '")'
]

{ #category : #accessing }
SQLite3Column >> type [

	^ type
]

{ #category : #accessing }
SQLite3Column >> type: anObject [

	type := anObject
]
