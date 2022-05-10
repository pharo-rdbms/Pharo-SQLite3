Class {
	#name : #SQLite3ColumnTest,
	#superclass : #TestCase,
	#instVars : [
		'column'
	],
	#category : #'SQLite3-Core-Tests-Base'
}

{ #category : #tests }
SQLite3ColumnTest >> testInitialization [

	| instance |
	instance := SQLite3Column new.
	self deny: instance hasNotNullConstraint 
]
